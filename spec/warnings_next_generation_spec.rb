# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

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

      describe "aggregation_result" do
        it "add info for entries" do
          aggregation_return("/assets/aggregation.json")
          @my_plugin.aggregation_report

          messages = @dangerfile.status_report[:messages]
          expect(messages.length).to be(8)
        end

        it "uses 'issues' on 0 items" do
          aggregation_return("/assets/aggregation_issues_zero.json")
          @my_plugin.aggregation_report

          messages = @dangerfile.status_report[:messages]
          expect(messages.length).to be(1)
          expect(messages.first).to include("0 issues.")
        end

        it "uses 'issues' on multiple items" do
          aggregation_return("/assets/aggregation_issues_multiple.json")
          @my_plugin.aggregation_report

          messages = @dangerfile.status_report[:messages]
          expect(messages.length).to be(1)
          expect(messages.first).to include("123 issues.")
        end

        it "uses 'issue' on one item" do
          aggregation_return("/assets/aggregation_issues_one.json")
          @my_plugin.aggregation_report

          messages = @dangerfile.status_report[:messages]
          expect(messages.length).to be(1)
          expect(messages.first).to include("1 issue.")
        end

        it "appends 'Awesome' on zero issues" do
          aggregation_return("/assets/aggregation_issues_zero.json")
          @my_plugin.aggregation_report

          messages = @dangerfile.status_report[:messages]
          expect(messages.length).to be(1)
          expect(messages.first).to include("Awesome.")
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
