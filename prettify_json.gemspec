# frozen_string_literal: true

require_relative "lib/prettify_json/version"

Gem::Specification.new do |spec|
  spec.name          = "prettify_json"
  spec.version       = PrettifyJson::VERSION
  spec.authors       = ["talaatmagdyx"]
  spec.email         = ["talaatmagdy75@gmail.com"]

  spec.summary       = "A CLI tool to pretty-print JSON with colors."
  spec.description   = "A simple command line tool to pretty-print JSON with colors using Ruby."
  spec.homepage      = "https://github.com/talaatmagdyx/prettify_json"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/talaatmagdyx/prettify_json"
  spec.metadata["changelog_uri"] = "https://github.com/talaatmagdyx/prettify_json/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/talaatmagdyx/prettify_json/issues"
  spec.metadata["wiki_uri"] = "https://github.com/talaatmagdyx/prettify_json/wiki"

  spec.post_install_message = "Thanks for installing! #{spec.name} is #{spec.description}"
  spec.platform = Gem::Platform::RUBY

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.files += ['bin/prettify_json', 'README.md', 'LICENSE.txt']

  spec.bindir = "bin"
  spec.executables = ['prettify_json']
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
