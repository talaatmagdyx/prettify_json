require_relative 'prettify_json/version'

require 'json'
require 'optparse'
require 'rainbow'

# Main module for the PrettifyJson gem
module PrettifyJson
  # Class responsible for prettifying and colorizing JSON strings
  class JsonPrettifier
    attr_reader :json_string

    # Initializes the JsonPrettifier with a JSON string
    #
    # @param json_string [String] the JSON string to be prettified and colorized
    def initialize(json_string)
      @json_string = json_string
    end

    # Colorizes a JSON string by adding colors to different types of JSON elements
    #
    # @param json_string [String] the JSON string to be colorized
    # @return [String] the colorized JSON string
    def colorize_json(json_string)
      regex = /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(?:\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+-]?\d+)?)/

      json_string.gsub(regex) { |match| colorize_match(match) }
    end

    # Helper method to colorize individual JSON elements
    #
    # @param match [String] the matched JSON element
    # @return [String] the colorized JSON element
    def colorize_match(match)
      case match
      when /^"/
        match.include?(':') ? Rainbow(match).yellow : Rainbow(match).green # Keys and Strings
      when 'true', 'false'
        Rainbow(match).blue # Booleans
      when 'null'
        Rainbow(match).magenta # Null
      else
        Rainbow(match).red # Numbers
      end
    end

    # Parses and prettifies the JSON string, then applies colorization
    #
    # @return [String] the prettified and colorized JSON string, or an error message if parsing fails
    def pretty_print
      parsed_json = JSON.parse(json_string)
      pretty_json = JSON.pretty_generate(parsed_json)
      colorize_json(pretty_json)
    rescue JSON::ParserError => e
      "Invalid JSON: #{e.message}"
    end
  end

  # Command Line Interface (CLI) class for handling command line inputs and options
  class CLI
    # Parses command line options and returns a hash of options
    #
    # @return [Hash] a hash containing the parsed options
    def self.parse_options
      options = {}
      opts = option_parser(options)
      opts.parse!
      options
    end

    # OptionParser configuration
    #
    # @param options [Hash] the hash to store parsed options
    # @return [OptionParser] the configured OptionParser object
    def self.option_parser(options)
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($PROGRAM_NAME)} [options]"
        add_file_option(opts, options)
        add_string_option(opts, options)
        add_help_option(opts)
      end
    end

    # Add file option to OptionParser
    #
    # @param opts [OptionParser] the OptionParser object
    # @param options [Hash] the hash to store parsed options
    def self.add_file_option(opts, options)
      opts.on('-f', '--file FILE', 'Input JSON file') do |file|
        options[:file] = file
      end
    end

    # Add string option to OptionParser
    #
    # @param opts [OptionParser] the OptionParser object
    # @param options [Hash] the hash to store parsed options
    def self.add_string_option(opts, options)
      opts.on('-s', '--string JSON', 'Input JSON string') do |json_string|
        options[:string] = json_string
      end
    end

    # Add help option to OptionParser
    #
    # @param opts [OptionParser] the OptionParser object
    def self.add_help_option(opts)
      opts.on('-h', '--help', 'Show this help message') do
        puts opts
        exit
      end
    end

    # Runs the CLI, processing the input JSON and printing the prettified output
    def self.run
      options = parse_options

      if options.key?(:file)
        json_string = File.read(options[:file])
      elsif options.key?(:string)
        json_string = options[:string]
      else
        puts 'Error: No JSON input provided. Use -f or -s option.'
        return
      end

      puts JsonPrettifier.new(json_string).pretty_print
    end
  end
end

# Executes the CLI run method if this file is run as a script
PrettifyJson::CLI.run if __FILE__ == $PROGRAM_NAME
