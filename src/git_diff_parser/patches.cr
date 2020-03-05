require "logger"

module GitDiffParser
  # The array of patch
  class Patches
    include Enumerable(Patch)

    @patches : Array(Patch)

    # @return [Patches<Patch>]
    def self.[](*ary)
      new(ary)
    end

    # @param contents [String] `git diff` result
    #
    # @return [Patches<Patch>] parsed object
    def self.parse(contents)
      body = false
      file_name = ""
      patch = [] of Patch | String
      lines = contents.lines
      line_count = lines.size
      parsed = [] of Patch
      lines.each_with_index do |line, size|
        case line
        when /^diff/
          unless patch.empty?
            parsed << Patch.new(patch.join("\n") + "\n", {file: file_name})
            patch.clear
            file_name = ""
          end
          body = false
        when /^\-\-\- a\/(?<file_name>.*)/
          matches_minus = /^\-\-\- a\/(?<file_name>.*)/.match(line)
          if !matches_minus.nil?
            file_name = matches_minus.not_nil!["file_name"].rstrip
            body = true
          end
        when /^\+\+\+ (b|a|)\/(?<file_name>.*)/
          matches = /^\+\+\+ b\/(?<file_name>.*)/.match(line)
          if !matches.nil? && file_name.empty?
            file_name = matches.not_nil!["file_name"].rstrip
            body = true
          end
        when /^(?<body>[\ @\+\-\\].*)/
          patch << line if file_name != line.rstrip
          if !patch.empty? && body && line_count == size + 1
            parsed << Patch.new(patch.join("\n") + "\n", {file: file_name})
            patch.clear
            file_name = ""
          end
        end
      end
      parsed
    end

    # @return [String]
    def self.scrub_string(line)
      line.encode("UTF-8", invalid: :skip)
    end

    # @return [Patches<Patch>]
    def initialize(patches)
      @patches = patches
    end

    # @return [Array<String>] file path
    def files
      map(&.file)
    end

    # @return [Array<String>] target sha1 hash
    def secure_hashes
      map(&.secure_hash)
    end

    def each
      @patches.each do |p|
        yield p
      end
    end

    def to_s
      @patches.to_s
    end

    # @param file [String] file path
    #
    # @return [Patch, nil]
    def find_patch_by_file(file)
      find { |patch| patch.file == file }
    end

    # @param secure_hash [String] target sha1 hash
    #
    # @return [Patch, nil]
    def find_patch_by_secure_hash(secure_hash)
      find { |patch| patch.secure_hash == secure_hash }
    end
  end
end
