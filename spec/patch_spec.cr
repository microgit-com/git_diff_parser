require "./spec_helper"

module GitDiffParser
  describe Patch do
    describe "#changed_lines" do
      it "returns lines that were modified" do
        patch_body = File.read("spec/support/fixtures/patch.diff")
        patch = Patch.new(patch_body)

        patch.changed_lines.size.should eq(3)
        patch.changed_line_numbers.should eq([14, 22, 53])
        patch.changed_lines.map(&.patch_position).should eq([5, 13, 37])
      end

      context "when body is nil" do
        it "returns no lines" do
          patch = Patch.new(nil)

          patch.changed_lines.size.should eq(0)
        end
      end
    end

    describe "#removed_lines" do
      it "returns lines that were modified" do
        patch_body = File.read("spec/support/fixtures/patch.diff")
        patch = Patch.new(patch_body)

        patch.removed_lines.size.should eq(7)
        patch.removed_line_numbers.should eq([11, 36, 37, 38, 39, 40, 48])
        patch.removed_lines.map(&.patch_position).should eq([4, 21, 22, 23, 24, 25, 36])
      end

      context "when body is nil" do
        it "returns no lines" do
          patch = Patch.new(nil)

          patch.removed_lines.size.should eq(0)
        end
      end
    end

    describe "#changed_line_numbers" do
      it "returns line numbers that were modified" do
        patch_body = File.read("spec/support/fixtures/patch.diff")
        patch = Patch.new(patch_body)

        patch.changed_line_numbers.size.should eq(3)
        patch.changed_line_numbers.should eq([14, 22, 53])
      end

      context "when body is nil" do
        it "returns no line numbers" do
          patch = Patch.new(nil)

          patch.changed_line_numbers.size.should eq(0)
        end
      end
    end

    describe "#find_patch_position_by_line_number" do
      it "returns patch position that were included" do
        patch_body = File.read("spec/support/fixtures/patch.diff")
        patch = Patch.new(patch_body)
        position = 5

        patch.find_line_by_line_number(12).should be_nil
        patch.find_line_by_line_number(14).not_nil!.patch_position.should eq(position)
      end

      context "when body is nil" do
        it "returns no patch position" do
          patch = Patch.new(nil)

          patch.find_line_by_line_number(14).should be_nil
        end
      end
    end
  end
end
