require 'json'
require 'rainbow'
require_relative '../lib/prettify_json'

RSpec.describe PrettifyJson::JsonPrettifier do
  let(:valid_json) { '{"key": "value", "boolean": true, "null_value": null, "number": 123}' }
  let(:invalid_json) { 'invalid json' }
  let(:prettifier) { PrettifyJson::JsonPrettifier.new(valid_json) }

  describe '#initialize' do
    it 'initializes with a JSON string' do
      expect(prettifier.json_string).to eq(valid_json)
    end
  end

  describe '#colorize_json' do
    it 'colorizes a JSON string' do
      colorized = prettifier.colorize_json(valid_json)
      expect(colorized).to include(Rainbow('"key":').yellow.to_s)
      expect(colorized).to include(Rainbow('"value"').green.to_s)
      expect(colorized).to include(Rainbow('true').blue.to_s)
      expect(colorized).to include(Rainbow('null').magenta.to_s)
      expect(colorized).to include(Rainbow('123').red.to_s)
    end
  end

  describe '#pretty_print' do
    context 'with valid JSON' do
      it 'returns prettified and colorized JSON' do
        pretty = prettifier.pretty_print
        expect(pretty).to include(Rainbow('"key":').yellow.to_s)
        expect(pretty).to include(Rainbow('"value"').green.to_s)
        expect(pretty).to include(Rainbow('true').blue.to_s)
        expect(pretty).to include(Rainbow('null').magenta.to_s)
        expect(pretty).to include(Rainbow('123').red.to_s)
      end
    end

    context 'with invalid JSON' do
      it 'returns an error message' do
        prettifier = PrettifyJson::JsonPrettifier.new(invalid_json)
        expect(prettifier.pretty_print).to match(/Invalid JSON: unexpected token at 'invalid json'/)
      end
    end
  end
end
