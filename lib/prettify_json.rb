# frozen_string_literal: true

require_relative "prettify_json/version"

require 'json'
require 'optparse'
require 'rainbow'

module PrettifyJson
  class JsonPrettifier
    attr_reader :json_string

    def initialize(json_string)
      @json_string = json_string
    end

    def colorize_json(json_string)
      json_string.gsub(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(?:\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+-]?\d+)?)/) do |match|
        case match
        when /^"/
          if match.include?(':')
            Rainbow(match).yellow # Keys
          else
            Rainbow(match).green  # Strings
          end
        when 'true', 'false'
          Rainbow(match).blue     # Booleans
        when 'null'
          Rainbow(match).magenta  # Null
        else
          Rainbow(match).red      # Numbers
        end
      end
    end

    def pretty_print
      begin
        parsed_json = JSON.parse(json_string)
        pretty_json = JSON.pretty_generate(parsed_json)
        colorize_json(pretty_json)
      rescue JSON::ParserError => e
        "Invalid JSON: #{e.message}"
      end
    end
  end

  class CLI
    def self.parse_options
      options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($PROGRAM_NAME)} [options]"

        opts.on("-f", "--file FILE", "Input JSON file") do |file|
          options[:file] = file
        end

        opts.on("-s", "--string JSON", "Input JSON string") do |json_string|
          options[:string] = json_string
        end
      end.parse!

      options
    end

    def self.run
      options = parse_options

      if options.key?(:file)
        json_string = File.read(options[:file])
      elsif options.key?(:string)
        json_string = options[:string]
      else
        puts "Error: No JSON input provided. Use -f or -s option."
        return
      end

      puts JsonPrettifier.new(json_string).pretty_print
    end
  end
end

PrettifyJson::CLI.run if __FILE__ == $0
