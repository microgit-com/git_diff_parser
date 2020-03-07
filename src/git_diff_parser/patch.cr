module GitDiffParser
  # Parsed patch
  class Patch
    RANGE_ADD_INFORMATION_LINE = /^@@ .+\+(?<line_number>\d+)/
    RANGE_DEL_INFORMATION_LINE = /^@@ \-(?<line_number>\d+)/
    MODIFIED_LINE              = /^\+(?!\+|\+)/
    REMOVED_LINE               = /^[-]/
    NOT_REMOVED_LINE           = /^[^-]/
    NOT_MOD_REM_LINE           = /^[^-+]/

    property :file, :body, :secure_hash

    # @!attribute [rw] file
    #   @return [String, nil] file path or nil
    # @!attribute [rw] body
    #   @return [String, nil] patch section in `git diff` or nil
    #   @see #initialize
    # @!attribute [rw] secure_hash
    #   @return [String, nil] target sha1 hash or nil

    # @param body [String] patch section in `git diff`.
    #   GitHub's pull request file's patch.
    #   GitHub's commit file's patch.
    #
    #    <<-BODY
    #    @@ -11,7 +11,7 @@ def valid?
    #
    #       def run
    #         api.create_pending_status(*api_params, 'Hound is working...')
    #    -    @style_guide.check(pull_request_additions)
    #    +    @style_guide.check(api.pull_request_files(@pull_request))
    #         build = repo.builds.create!(violations: @style_guide.violations)
    #         update_api_status(build)
    #       end
    #    @@ -19,6 +19,7 @@ def run
    #       private
    #
    #       def update_api_status(build = nil)
    #    +    # might not need this after using Rubocop and fetching individual files.
    #         sleep 1
    #         if @style_guide.violations.any?
    #           api.create_failure_status(*api_params, 'Hound does not approve', build_url(build))
    #    BODY
    #
    # @param options [Hash] options
    # @option options [String] :file file path
    # @option options [String] 'file' file path
    # @option options [String] :secure_hash target sha1 hash
    # @option options [String] 'secure_hash' target sha1 hash
    #
    # @see https://developer.github.com/v3/repos/commits/#get-a-single-commit
    # @see https://developer.github.com/v3/pulls/#list-pull-requests-files

    @file : String | Int32
    @body : String
    @secure_hash : String | Int32
    @all_lines : Array(Line) | Nil

    def initialize(body, options = {} of String => String | Int32)
      @body = body || ""
      @file = options[:file]? || options["file"]? || ""
      @secure_hash = options[:secure_hash]? || options["secure_hash"]? || ""
    end

    def all_lines
      return @all_lines.not_nil! unless @all_lines.nil?
      remove_number = 0
      add_number = 0
      unchanged_number = 0
      @all_lines = @body.lines.map_with_index do |content, index|
        case content
        when RANGE_ADD_INFORMATION_LINE
          line_nr = RANGE_ADD_INFORMATION_LINE.match(content).not_nil!
          remove_number = line_nr["line_number"].to_i
          add_number = line_nr["line_number"].to_i
          unchanged_number = line_nr["line_number"].to_i
        when MODIFIED_LINE
          line = Line.new(
            content,
            add_number,
            index,
            Line::Mode::Modified
          )
          add_number += 1
        when REMOVED_LINE
          line = Line.new(
            content,
            remove_number,
            index,
            Line::Mode::Removed
          )
          remove_number += 1
        when NOT_REMOVED_LINE
          add_number += 1
        when NOT_MOD_REM_LINE
          line = Line.new(
            content,
            unchanged_number,
            index,
            Line::Mode::Unchanged
          )
          unchanged_number += 1
        end
        line
      end.compact
    end

    # @return [Array<Line>] changed lines
    def changed_lines
      all_lines.select { |l| l.mode == Line::Mode::Modified }
    end

    # @return [Array<Line>] removed lines
    def removed_lines
      all_lines.select { |l| l.mode == Line::Mode::Removed }
    end

    # @return [Array<Integer>] changed line numbers
    def changed_line_numbers
      changed_lines.map(&.number)
    end

    # @return [Array<Integer>] removed line numbers
    def removed_line_numbers
      removed_lines.map(&.number)
    end

    # @param line_number [Integer] line number
    #
    # @return [Integer, nil] patch position
    def find_line_by_line_number(line_number)
      changed_lines.find { |line| line.number == line_number }
    end

    # @param line_number [Integer] line number
    #
    # @return [Integer, nil] patch position
    def find_removed_line_by_line_number(line_number)
      removed_lines.find { |line| line.number == line_number }
    end
  end
end
