require 'json'
require 'optparse'
require 'rainbow'
require_relative 'prettify_json/version'

module PrettifyJson
  class JsonPrettifier
    attr_reader :json_string

    def initialize(json_string)
      @json_string = json_string
    end

    def colorize_json(json_string)
      regex = /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(?:\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+-]?\d+)?)/

      json_string.gsub(regex) { |match| colorize_match(match) }
    end

    def colorize_match(match)
      case match
      when /^"/
        match.include?(':') ? Rainbow(match).yellow : Rainbow(match).green
      when 'true', 'false'
        Rainbow(match).blue
      when 'null'
        Rainbow(match).magenta
      else
        Rainbow(match).red
      end
    end

    def pretty_print
      parsed_json = JSON.parse(json_string)
      pretty_json = JSON.pretty_generate(parsed_json)
      colorize_json(pretty_json)
    rescue JSON::ParserError => e
      "Invalid JSON: #{e.message}"
    end
  end

  class CLI
    def self.parse_options(argv = ARGV)
      options = {}
      opts = option_parser(options)
      opts.parse!(argv)
      options
    end

    def self.option_parser(options)
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($PROGRAM_NAME)} [options]"
        add_file_option(opts, options)
        add_string_option(opts, options)
        add_help_option(opts)
      end
    end

    def self.add_file_option(opts, options)
      opts.on('-f', '--file FILE', 'Input JSON file') do |file|
        options[:file] = file
      end
    end

    def self.add_string_option(opts, options)
      opts.on('-s', '--string JSON', 'Input JSON string') do |json_string|
        options[:string] = json_string
      end
    end

    def self.add_help_option(opts)
      opts.on('-h', '--help', 'Show this help message') do
        puts opts
        exit
      end
    end

    def self.read_input(options)
      if options[:file]
        File.read(options[:file])
      elsif options[:string]
        options[:string]
      elsif ARGV.include?('-')
        $stdin.read
      else
        display_help
      end
    end

    def self.pretty_print_json(input)
      puts PrettifyJson::JsonPrettifier.new(input).pretty_print
    rescue JSON::ParserError => e
      puts "Invalid JSON: #{e.message}"
    end

    def self.display_help
      puts help_message
      exit 0
    end

    def self.help_message
      <<~HELP
        Usage:
          prettify_json [options]

        [Options]
          -f, --file FILE          Input JSON file
          -s, --string JSON        Input JSON string
          -                        Read multiple lines from standard input (no single quotes needed)

        You may specify a file path or a JSON string to be parsed and formatted.
        IMPORTANT: make sure to surround your JSON string with single quotes to prevent the shell from splitting it by its own.
      HELP
    end

    def self.main(argv = ARGV)
      options = parse_options(argv)

      display_help if options.empty? && argv.empty?

      input = read_input(options)
      pretty_print_json(input)
    end

    public_class_method :main
  end
end

if __FILE__ == $PROGRAM_NAME
  PrettifyJson::CLI.main
end
