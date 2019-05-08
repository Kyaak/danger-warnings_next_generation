# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)
OVERVIEW_INDEX_FIRST_ENTRY = 4

module Danger
  describe Danger::DangerWarningsNextGeneration do
    it "should be a plugin" do
      expect(Danger::DangerWarningsNextGeneration.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.warnings_next_generation
      end

      describe "overview_report" do
        it "all zero displays stars" do
          aggregation_return("/assets/aggregation_single.json")
          overview_return("/assets/java_zero.json")
          @my_plugin.overview_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(OVERVIEW_INDEX_FIRST_ENTRY + 1)
          expect(rows[OVERVIEW_INDEX_FIRST_ENTRY]).to include("|:star:|:star:|:star:|")
        end

        it "new zero displays star" do
          aggregation_return("/assets/aggregation_single.json")
          overview_return("/assets/java_zero_new.json")
          @my_plugin.overview_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(OVERVIEW_INDEX_FIRST_ENTRY + 1)
          expect(rows[OVERVIEW_INDEX_FIRST_ENTRY]).to include("|8|:star:|4|")
        end

        it "displays correct issue sizes" do
          aggregation_return("/assets/aggregation_single.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(OVERVIEW_INDEX_FIRST_ENTRY + 1)
          expect(rows[OVERVIEW_INDEX_FIRST_ENTRY]).to include("|3|2|1|")
        end

        it "list all entries" do
          aggregation_return("/assets/aggregation.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(OVERVIEW_INDEX_FIRST_ENTRY + 8)
        end
      end
    end
  end
end

def aggregation_return(file)
  content = File.read(File.dirname(__FILE__) + file)
  json = JSON.parse(content)
  @my_plugin.stubs(:aggregation_result).returns(json)
end

def overview_return(file)
  content = File.read(File.dirname(__FILE__) + file)
  json = JSON.parse(content)
  @my_plugin.stubs(:overview_result).returns(json)
end

def details_return(file)
  content = File.read(File.dirname(__FILE__) + file)
  json = JSON.parse(content)
  @my_plugin.stubs(:details_result).returns(json)
end
