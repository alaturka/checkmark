# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'checkmark/version'

Gem::Specification.new do |s|
  s.name        = 'checkmark'
  s.author      = 'Recai Oktaş'
  s.email       = 'roktas@gmail.com'
  s.license     = 'GPL-3.0-or-later'
  s.version     = Checkmark::VERSION.dup
  s.summary     = 'Loerm ipsum'
  s.description = 'Lorem ipsum'

  s.homepage      = 'https://alaturka.github.io/checkmark'
  s.files         = Dir['CHANGELOG.md', 'LICENSE.md', 'README.md', 'BENİOKU.md', 'checkmark.gemspec', 'lib/**/*']
  s.executables   = %w[checkmark]
  s.require_paths = %w[lib]

  s.metadata['changelog_uri']     = 'https://github.com/alaturka/checkmark/blob/master/CHANGELOG.md'
  s.metadata['source_code_uri']   = 'https://github.com/alaturka/checkmark'
  s.metadata['bug_tracker_uri']   = 'https://github.com/alaturka/checkmark/issues'

  s.required_ruby_version = '>= 3.0.2'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest-focus', '>= 1.2.1'
  s.add_development_dependency 'minitest-reporters', '>= 1.4.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-minitest'
  s.add_development_dependency 'rubocop-performance'
  s.add_development_dependency 'rubocop-rake'
  s.add_development_dependency 'rubygems-tasks'
  s.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
