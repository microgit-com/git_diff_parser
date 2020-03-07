module GitDiffParser
  # Parsed line
  class Line
    getter :content, :number, :patch_position, :mode

    enum Mode
      Unchanged
      Modified
      Removed
    end

    @content : String
    @number : Int32
    @patch_position : Int32
    @mode : Mode

    def initialize(@content, @number, @patch_position, @mode)
    end

    # @return [Boolean] true if line changed
    def changed?
      true
    end
  end
end
