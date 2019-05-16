# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)
MARKDOWN_FIRST_TABLE_INDEX = 4

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
        it "all zero displays star, zero, zero" do
          aggregation_return("/assets/aggregation_single.json")
          overview_return("/assets/java_zero.json")
          @my_plugin.overview_report(include: ["java"])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 1)
          expect(rows[MARKDOWN_FIRST_TABLE_INDEX]).to include("|:star:|0|0|")
        end

        it "new issues zero displays zero" do
          aggregation_return("/assets/aggregation_single.json")
          overview_return("/assets/java_zero_new.json")
          @my_plugin.overview_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 1)
          expect(rows[MARKDOWN_FIRST_TABLE_INDEX]).to include("|8|0|4|")
        end

        it "displays correct issue sizes" do
          aggregation_return("/assets/aggregation_single.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 1)
          expect(rows[MARKDOWN_FIRST_TABLE_INDEX]).to include("|3|2|1|")
        end

        it "list all entries" do
          aggregation_return("/assets/aggregation.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 8)
        end

        it "no configuration list all entries" do
          aggregation_return("/assets/aggregation.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 8)
        end

        it "single include adds target entry" do
          aggregation_return("/assets/aggregation.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report(include: ["java"])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 1)
          expect(rows[MARKDOWN_FIRST_TABLE_INDEX]).to include("Java Warnings")
        end

        it "multiple include adds valid entries" do
          aggregation_return("/assets/aggregation.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report(include: %w(java pmd))

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 2)
          expect(rows[MARKDOWN_FIRST_TABLE_INDEX]).to include("Java Warnings")
          expect(rows[MARKDOWN_FIRST_TABLE_INDEX + 1]).to include("PMD Warnings")
        end

        it "empty includes add no overview" do
          aggregation_return("/assets/aggregation.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report(include: [])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)
        end

        it "wrong includes add no overview" do
          aggregation_return("/assets/aggregation.json")
          overview_return("/assets/java.json")
          @my_plugin.overview_report(include: ["not_existing"])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)
        end
      end

      describe "tools_report" do
        it "list all entries" do
          aggregation_return("/assets/aggregation_single.json")
          details_return("/assets/java_all.json")
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 8)
        end

        it "no configuration list all warnings reports" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_all.json")
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(8)
        end

        it "single include adds table" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_all.json")
          @my_plugin.tools_report(include: ["java"])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).to include("Java Warnings")
        end

        it "multiple include adds table for each" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_all.json")
          @my_plugin.tools_report(include: %w(java pmd))

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(2)

          expect(markdowns[0].message).to include("Java Warnings")
          expect(markdowns[1].message).to include("PMD Warnings")
        end

        it "empty includes add no overview" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_all.json")
          @my_plugin.tools_report(include: [])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)
        end

        it "wrong includes add no overview" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_all.json")
          @my_plugin.tools_report(include: ["not_existing"])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)
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
