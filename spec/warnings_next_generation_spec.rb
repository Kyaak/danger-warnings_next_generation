# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)
MARKDOWN_FIRST_TABLE_INDEX = 4
JAVA_ALL_BASELINE = "/var/lib/jenkins/workspace/projectname/b2b-app-android-analyze/repository/"

module Danger
  describe Danger::DangerWarningsNextGeneration do
    it "should be a plugin" do
      expect(Danger::DangerWarningsNextGeneration.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.warnings_next_generation
        target_files_return_java_all
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
          details_return("/assets/java_detail_all.json")
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)

          rows = markdowns.first.message.split("\n")
          expect(rows.length).to be(MARKDOWN_FIRST_TABLE_INDEX + 8)
        end

        it "no configuration list all warnings reports" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_detail_all.json")
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(8)
        end

        it "single include adds table" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_detail_all.json")
          @my_plugin.tools_report(include: ["java"])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).to include("Java Warnings")
        end

        it "multiple include adds table for each" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_detail_all.json")
          @my_plugin.tools_report(include: %w(java pmd))

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(2)

          expect(markdowns[0].message).to include("Java Warnings")
          expect(markdowns[1].message).to include("PMD Warnings")
        end

        it "empty includes add no overview" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_detail_all.json")
          @my_plugin.tools_report(include: [])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)
        end

        it "wrong includes add no overview" do
          aggregation_return("/assets/aggregation.json")
          details_return("/assets/java_detail_all.json")
          @my_plugin.tools_report(include: ["not_existing"])

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)
        end

        it "inline missing baseline raises error" do
          aggregation_return("/assets/aggregation_single.json")
          details_return("/assets/java_detail_all.json")
          expect { @my_plugin.tools_report(inline: true) }.to raise_error(/set 'baseline'/)
        end

        it "creates inline comments" do
          aggregation_return("/assets/aggregation_single.json")
          details_return("/assets/java_detail_all.json")
          @my_plugin.tools_report(inline: true, baseline: JAVA_ALL_BASELINE)

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)

          messages = @dangerfile.status_report[:messages]
          expect(messages.length).to be(8)
        end

        it "baseline frozen string is modifiable" do
          aggregation_return("/assets/aggregation_single.json")
          details_return("/assets/java_detail_all.json")
          baseline = JAVA_ALL_BASELINE.chomp("/").freeze
          expect(baseline.chars.last).not_to be("/")
          expect(baseline.frozen?).to be_truthy

          @my_plugin.tools_report(inline: true, baseline: baseline)

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)

          messages = @dangerfile.status_report[:messages]
          expect(messages.length).to be(8)
        end

        it "inline comments remove baseline" do
          aggregation_return("/assets/aggregation_single.json")
          details_return("/assets/java_detail_all.json")
          @my_plugin.tools_report(inline: true, baseline: JAVA_ALL_BASELINE)

          message = @dangerfile.violation_report[:messages].first
          expect(message.file).not_to include(JAVA_ALL_BASELINE)
          expect(message.file.chars.first).not_to eql("/")
        end

        it "message will not contain new lines" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          expect(issue["message"]).to include("\n")
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message.split("|").last).not_to include("\n")
        end

        it "category and type both added" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          issue["category"] = "TEST_CATEGORY"
          issue["type"] = "TEST_TYPE"
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).to include("[TEST_CATEGORY - TEST_TYPE]")
        end

        it "type empty not added" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          issue["category"] = "TEST_CATEGORY"
          issue["type"] = ""
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).to include("[TEST_CATEGORY]")
        end

        it "type is dash not added" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          issue["category"] = "TEST_CATEGORY"
          issue["type"] = "-"
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).to include("[TEST_CATEGORY]")
        end

        it "type nil not added" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          issue["category"] = "TEST_CATEGORY"
          issue["type"] = nil
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).to include("[TEST_CATEGORY]")
        end

        it "category empty not added" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          issue["category"] = ""
          issue["type"] = "TEST_TYPE"
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).to include("[TEST_TYPE]")
        end

        it "category nil not added" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          issue["category"] = nil
          issue["type"] = "TEST_TYPE"
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).to include("[TEST_TYPE]")
        end

        it "category and type empty not added" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          issue["category"] = ""
          issue["type"] = ""
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).not_to include("[")
          expect(markdowns.first.message).not_to include("]")
        end

        it "category and type nil not added" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues
          issue = issues["issues"].first
          issue["category"] = nil
          issue["type"] = nil
          details_return_issue(issues)
          target_files_return_manifest
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(1)
          expect(markdowns.first.message).not_to include("[")
          expect(markdowns.first.message).not_to include("]")
        end

        it "no changed files match does not add report" do
          aggregation_return("/assets/aggregation_single.json")
          details_return("/assets/java_detail_one.json")
          target_files_return(["Unmatched.java"])
          @my_plugin.tools_report

          markdowns = @dangerfile.status_report[:markdowns]
          expect(markdowns.length).to be(0)
        end

        it "creates inline comments if issues lower than threshold" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues(14)
          expect(issues["issues"].size).to be(14)
          details_return_issue(issues)
          mock_file_in_changeset(true)
          @my_plugin.tools_report(inline: true, baseline: "mylibrary/src/main", inline_threshold: 15)

          markdowns = @dangerfile.status_report[:markdowns]
          messages = @dangerfile.status_report[:messages]
          expect(markdowns.length).to be(0)
          expect(messages.length).to be(14)
        end

        it "creates table comment if issues equal than threshold" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues(15)
          expect(issues["issues"].size).to be(15)
          details_return_issue(issues)
          mock_file_in_changeset(true)
          mock_basename_in_changeset(true)
          @my_plugin.tools_report(inline: true, baseline: "mylibrary/src/main", inline_threshold: 15)

          markdowns = @dangerfile.status_report[:markdowns]
          messages = @dangerfile.status_report[:messages]
          expect(markdowns.length).to be(1)
          expect(messages.length).to be(0)
        end

        it "creates table comment if issues greater than threshold" do
          aggregation_return("/assets/aggregation_single.json")
          issues = android_lint_issues(16)
          expect(issues["issues"].size).to be(16)
          details_return_issue(issues)
          mock_file_in_changeset(true)
          mock_basename_in_changeset(true)
          @my_plugin.tools_report(inline: true, baseline: "mylibrary/src/main", inline_threshold: 15)

          markdowns = @dangerfile.status_report[:markdowns]
          messages = @dangerfile.status_report[:messages]
          expect(markdowns.length).to be(1)
          expect(messages.length).to be(0)
        end

        it "creates table comment if issues of multiple reports greater than threshold" do
          aggregation_return("/assets/aggregation.json")
          issues = android_lint_issues(9)
          expect(issues["issues"].size).to be(9)
          details_return_issue(issues)
          mock_file_in_changeset(true)
          mock_basename_in_changeset(true)
          @my_plugin.tools_report(inline: true, baseline: "mylibrary/src/main", inline_threshold: 15)

          markdowns = @dangerfile.status_report[:markdowns]
          messages = @dangerfile.status_report[:messages]
          expect(markdowns.length).to be(8)
          expect(messages.length).to be(0)
        end

        it "creates inline comment if issues of multiple reports lower threshold" do
          aggregation_return("/assets/aggregation.json")
          issues = android_lint_issues(10)
          expect(issues["issues"].size).to be(10)
          details_return_issue(issues)
          mock_file_in_changeset(true)
          mock_basename_in_changeset(true)
          @my_plugin.tools_report(inline: true, baseline: "mylibrary/src/main", inline_threshold: 100)

          markdowns = @dangerfile.status_report[:markdowns]
          messages = @dangerfile.status_report[:messages]
          expect(markdowns.length).to be(0)
          expect(messages.length).to be(80)
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

def details_return_issue(issue)
  @my_plugin.stubs(:details_result).returns(issue)
end

def android_lint_issues(count = 1)
  json = {
    "issues": [],
  }

  items = 0
  while items < count
    json[:issues] << {
      "baseName": "AndroidManifest.xml",
      "category": "Internationalization:Bidirectional Text",
      "columnEnd": 0,
      "columnStart": 0,
      "description": "",
      "fileName": "/var/lib/jekins/workspace/Jenkins/Examples/android/MR6--danger/repository/mylibrary/src/main/AndroidManifest.xml",
      "fingerprint": "4F7305CA47CE9CFC2A8E9BE4287E79F8",
      "lineEnd": 0,
      "lineStart": 0,
      "message": "Using RTL attributes without enabling RTL support\nThe project references RTL attributes, but does not explicitly enable or disable RTL support with `android:supportsRtl` in the manifest\nTo enable right-to-left support, when running on API 17 and higher, you must set the `android:supportsRtl` attribute in the manifest `<application>` element.&#xA;&#xA;If you have started adding RTL attributes, but have not yet finished the migration, you can set the attribute to false to satisfy this lint check.",
      "moduleName": "",
      "origin": "android-lint",
      "packageName": "-",
      "reference": "3",
      "severity": "NORMAL",
      "type": "RtlEnabled",
    }
    items += 1
  end
  serialized = JSON.generate(json)
  JSON.parse(serialized)
end

def target_files_return_java_all
  target_files_return(["app/src/main/java/com/projectname/b2bshop/fragment/gallery/ImageGalleryFragment.kt",
                       "app/src/main/java/com/projectname/b2bshop/webservice/requestqueue/RequestQueue.java",
                       "app/src/main/java/com/projectname/b2bshop/webservice/requestqueue/RequestQueueImpl.java",
                       "app/src/main/java/com/projectname/b2bshop/fragment/ProductDetailPageFragment.kt"])
end

def target_files_return_manifest
  target_files_return(["AndroidManifest.xml"])
end

def target_files_return(list)
  @my_plugin.stubs(:target_files).returns(list)
end

def mock_file_in_changeset(value)
  @my_plugin.stubs(:file_in_changeset?).returns(value)
end

def mock_basename_in_changeset(value)
  @my_plugin.stubs(:basename_in_changeset?).returns(value)
end
