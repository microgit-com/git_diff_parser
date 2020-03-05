require "./spec_helper"

module GitDiffParser
  describe Patches do
    describe "#parse" do
      file0 = "lib/saddler/reporter/github.rb"
      body0 = File.read("spec/support/fixtures/file0.diff")
      file1 = "lib/saddler/reporter/github/commit_comment.rb"
      body1 = File.read("spec/support/fixtures/file1.diff")
      file2 = "lib/saddler/reporter/github/helper.rb"
      body2 = File.read("spec/support/fixtures/file2.diff")
      file3 = "lib/saddler/reporter/github/support.rb"
      body3 = File.read("spec/support/fixtures/file3.diff")

      sjis_file = "spec/support/fixtures/sjis.csv"
      sjis_diff = sjis_file.gsub(/\.csv\z/, ".diff")
      sjis_body = File.read(sjis_diff)

      whitespace_file = "spec/support/fixtures/sjis.csv"
      whitespace_filename_diff = "spec/support/fixtures/whitespacefilename.diff"
      whitespace_filename_body = File.read(whitespace_filename_diff)

      it "returns parsed patches" do
        diff_body = File.read("spec/support/fixtures/d1bd180-c27866c.diff")
        patches = Patches.parse(diff_body)

        patches.size.should eq(4)
        patches.not_nil![0].not_nil!.file.should eq(file0)
        patches.not_nil![0].not_nil!.body.should eq(body0)
        patches.not_nil![1].not_nil!.file.should eq(file1)
        patches.not_nil![1].not_nil!.body.should eq(body1)
        patches.not_nil![2].not_nil!.file.should eq(file2)
        patches.not_nil![2].not_nil!.body.should eq(body2)
        patches.not_nil![3].not_nil!.file.should eq(file3)
        patches.not_nil![3].not_nil!.body.should eq(body3)
      end

      it "handles non UTF-8 encoding characters" do
        patches = nil
        patches = Patches.parse(sjis_body)
        patches.not_nil![0].file.should eq(sjis_file)
      end

      it "correctly strips trailing whitespace from filenames" do
        patches = Patches.parse(whitespace_filename_body)
        patches.not_nil![0].file.should eq(whitespace_file)
      end
    end
  end
end
