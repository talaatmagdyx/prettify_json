require 'json'
require 'stringio'
require 'fileutils'
require 'rainbow'
require_relative '../lib/prettify_json'

RSpec.describe PrettifyJson::CLI do
  let(:valid_json) { '{"key": "value"}' }
  let(:json_file) { 'spec/test.json' }

  before do
    FileUtils.mkdir_p('spec')
    File.open(json_file, 'w') { |file| file.write(valid_json) }
  end

  after do
    File.delete(json_file) if File.exist?(json_file)
    FileUtils.rmdir('spec') if Dir.exist?('spec') && Dir.empty?('spec')
  end

  describe '.parse_options' do
    it 'parses file option' do
      options = PrettifyJson::CLI.parse_options(['-f', json_file])
      expect(options[:file]).to eq(json_file)
    end

    it 'parses string option' do
      options = PrettifyJson::CLI.parse_options(['-s', valid_json])
      expect(options[:string]).to eq(valid_json)
    end
  end

end
