require_relative 'lib/prettify_json/version'

Gem::Specification.new do |spec|
  spec.name          = 'prettify_json'
  spec.version       = PrettifyJson::VERSION
  spec.authors       = ['talaatmagdyx']
  spec.email         = ['talaatmagdy75@gmail.com']

  spec.summary       = 'A CLI tool to pretty-print JSON with colors.'
  spec.description   = 'A simple command line tool to pretty-print JSON with colors using Ruby.'
  spec.homepage      = 'https://github.com/talaatmagdyx/prettify_json'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/talaatmagdyx/prettify_json/main'
  spec.metadata['changelog_uri'] = 'https://github.com/talaatmagdyx/prettify_json/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/talaatmagdyx/prettify_json/issues'
  spec.metadata['wiki_uri'] = 'https://github.com/talaatmagdyx/prettify_json/wiki'

  spec.post_install_message = "Thanks for installing! #{spec.name} is #{spec.description}"
  spec.platform = Gem::Platform::RUBY

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir['lib/**/*.rb'] + %w[
    bin/prettify_json
    README.md
    LICENSE.txt
  ]

  spec.bindir = 'bin'
  spec.executables = ['prettify_json']
  spec.require_paths = ['lib']

  # Dependencies
  spec.add_runtime_dependency 'rainbow', '~> 3.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
