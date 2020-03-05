module GitDiffParser
  # Parse entire `git diff` into Patches and Patch
  class DiffParser
    # Parse entire `git diff` into Patches and Patch
    def self.parse(contents)
      Patches.parse(contents)
    end
  end
end
