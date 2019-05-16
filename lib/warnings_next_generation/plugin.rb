# frozen_string_literal: true

module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  Kyaak/danger-warnings_next_generation
  # @tags monday, weekends, time, rattata
  #
  class DangerWarningsNextGeneration < Plugin
    require "json"
    require "open-uri"
    require_relative "markdown_table"

    EMOJI_BEETLE = ":beetle:"
    EMOJI_X = ":x:"
    EMOJI_CHECK_MARK = ":white_check_mark:"
    EMOJI_STAR = ":star:"
    TABLE_HEADER_TOOL = "**Tool**"
    TABLE_HEADER_FILE = "**File**"
    TABLE_HEADER_SEVERITY = "**Severity**"
    TABLE_HEADER_DESCRIPTION = "**Description**"
    WNG_OVERVIEW_TITLE = "### Warnings Next Generation Overview"

    def report(*args)
      options = args.first
      overview_report(options)
      tools_report(options)
    end

    def overview_report(*args)
      overview_table = WarningsNextGeneration::MarkdownTable.new
      overview_table.overview_header(TABLE_HEADER_TOOL, EMOJI_BEETLE, EMOJI_X, EMOJI_CHECK_MARK)
      options = args.first
      tool_ids = include(options)
      entry_count = 0

      tools = tool_entries
      tools.each do |tool|
        name = tool["name"]
        url = tool["latestUrl"]
        id = tool["id"]

        if use_include_option?(options)
          next unless tool_ids.include?(id)
        end
        overview = overview_result(url)
        entry_count += 1
        overview_entry(overview_table, name, overview)
      end

      if use_include_option?(options)
        return if entry_count.zero?
      end
      markdown("#{WNG_OVERVIEW_TITLE}\n\n#{overview_table.to_markdown}")
    end

    def tools_report(*args)
      options = args.first
      tool_ids = include(options)

      tools = tool_entries
      tools.each do |tool|
        name = tool["name"]
        url = tool["latestUrl"]
        id = tool["id"]

        if use_include_option?(options)
          next unless tool_ids.include?(id)
        end
        if inline?(options) && check_baseline(options)
          inline_report(url, baseline(options))
        else
          tool_table(name, url)
        end
      end
    end

    private

    def include(options)
      options && !options[:include].nil? ? options[:include] : []
    end

    def inline?(options)
      options && !options[:inline].nil? ? options[:inline] : false
    end

    def baseline(options)
      base = options && !options[:baseline].nil? ? options[:baseline] : nil
      if base && !base.chars.last.eql?("/")
        base << "/"
      end
      base
    end

    def check_baseline(options)
      raise "Please set 'baseline' for correct inline comments." unless baseline(options)

      true
    end

    def use_include_option?(options)
      !options.nil? && !options[:include].nil?
    end

    def tool_table(name, url)
      details = details_result(url)
      issues = details["issues"]

      table = WarningsNextGeneration::MarkdownTable.new
      table.detail_header(TABLE_HEADER_SEVERITY, TABLE_HEADER_FILE, TABLE_HEADER_DESCRIPTION)
      issues.each do |issue|
        severity = issue["severity"]
        file = File.basename(issue["fileName"])
        line = issue["lineStart"]
        message = issue["message"]
        category = issue["category"]
        table.line(severity, "#{file}:#{line}", "[#{category}] #{message}")
      end
      content = +"### #{name}\n\n"
      content << table.to_markdown
      markdown(content)
    end

    def inline_report(url, baseline)
      details = details_result(url)
      issues = details["issues"]

      issues.each do |issue|
        severity = issue["severity"]
        file = issue["fileName"].gsub(baseline, "")
        line = issue["lineStart"]
        message = issue["message"]
        category = issue["category"]

        inline_message = "#{severity}\n[#{category}]\n#{message}"
        message(inline_message, file: file, line: line)
      end
    end

    def tool_entries
      json = aggregation_result
      json["tools"]
    end

    def overview_entry(table, name, overview)
      fixed = overview["fixedSize"]
      new = overview["newSize"]
      total = overview["totalSize"]
      table.line(name, num_star(total), new, fixed)
    end

    def num_star(number)
      number.to_i.zero? ? EMOJI_STAR : number
    end

    def details_result(url)
      content = OpenURI.open("#{url}/all/api/json").read
      JSON.parse(content)
    end

    def overview_result(url)
      content = OpenURI.open("#{url}/api/json").read
      JSON.parse(content)
    end

    def aggregation_result
      content = OpenURI.open("#{ENV['BUILD_URL']}/warnings-ng/api/json").read
      JSON.parse(content)
    end
  end
end
