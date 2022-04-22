lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/sonarcloud_metric_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-sonarcloud_metric_kit'
  spec.version       = Fastlane::SonarcloudMetricKit::VERSION
  spec.author        = 'alteral'

  spec.summary       = 'With this fastlane plugin, you can access most of the metrics collected by SonarCloud'
  spec.homepage      = 'https://github.com/GetStream/fastlane-plugin-sonarcloud_metric_kit'

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('fasterer', '0.9.0')
  spec.add_development_dependency('fastlane', '>= 2.204.3')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rubocop', '1.28.0')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-rake', '0.6.0')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('rubocop-rspec', '2.4.0')
  spec.add_development_dependency('simplecov')
  spec.metadata['rubygems_mfa_required'] = 'true'
end
