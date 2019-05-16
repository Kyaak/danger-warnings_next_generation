# frozen_string_literal: true

module WarningsNextGeneration
  class MarkdownTable
    COLUMN_SEPARATOR = "|"
    HEADER_SEPARATOR = "-"

    def initialize
      @header = COLUMN_SEPARATOR.dup
      @header_separator = COLUMN_SEPARATOR.dup
      @lines = []
    end

    def overview_header(*args)
      args.each_with_index do |item, index|
        @header << "#{item}#{COLUMN_SEPARATOR}"
        @header_separator << if index.zero?
                               ":#{HEADER_SEPARATOR}#{COLUMN_SEPARATOR}"
                             else
                               ":#{HEADER_SEPARATOR}:#{COLUMN_SEPARATOR}"
                             end
      end
    end

    def detail_header(*args)
      args.each do |item|
        @header << "#{item}#{COLUMN_SEPARATOR}"
        @header_separator << "#{HEADER_SEPARATOR}#{COLUMN_SEPARATOR}"
      end
    end

    def line(*args)
      line = COLUMN_SEPARATOR.dup
      args.each do |item|
        line << "#{item}#{COLUMN_SEPARATOR}"
      end
      @lines << line
    end

    def to_markdown
      result = +"#{@header}\n#{@header_separator}\n"
      result << @lines.join("\n")
    end
  end
end
