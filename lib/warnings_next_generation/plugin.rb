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
  # @see  Martin Schwamberger/danger-warnings_next_generation
  # @tags monday, weekends, time, rattata
  #
  class DangerWarningsNextGeneration < Plugin
    require "json"
    require "open-uri"

    def aggregation_report
      json = aggregation_result
      tools = json["tools"]
      tools.each do |tool|
        name = tool["name"]
        threshold = tool["threshold"]

        message = "#{name} has #{threshold} #{issue_by_count(threshold)}."
        if zero_issues?(threshold)
          message += " Awesome."
        end

        message(message)
      end
    end

    private

    def issue_by_count(threshold)
      result = "issue"
      unless single_issue?(threshold)
        result += "s"
      end
      result
    end

    def single_issue?(threshold)
      threshold.to_i == 1
    end

    def zero_issues?(threshold)
      threshold.to_i.zero?
    end

    def aggregation_result
      content = open("#{build_url}/warnings-ng/api/json").read
      JSON.parse(content)
    end

    def build_url
      ENV["BUILD_URL"]
    end
  end
end
