module GitDiffParser
  # Parsed line
  class Line
    getter :content, :number, :patch_position

    @content : String
    @number : Int32
    @patch_position : Int32

    def initialize(@content, @number, @patch_position)
    end

    # @return [Boolean] true if line changed
    def changed?
      true
    end
  end
end
