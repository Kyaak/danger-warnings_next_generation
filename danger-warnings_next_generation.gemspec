# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'warnings_next_generation/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name = 'danger-warnings_next_generation'
  spec.version = WarningsNextGeneration::VERSION
  spec.authors = ['Martin Schwamberger']
  spec.email = ['kyaak.dev@gmail.com']
  spec.description = %q{Danger plugin to for Jenkins-Warnings-Next-Generation plugin.}
  spec.summary = %q{Read Jenkins warnings-ng reports and comment pull request with found issues.}
  spec.homepage = 'https://github.com/Kyaak/danger-warnings_next_generation'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) {|f| File.basename(f)}
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>=2.3.0'

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'

  # General ruby development
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'

  # Testing support
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'mocha', '~> 1.8'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'simplecov-console', '~> 0.4'

  # Linting code and docs
  spec.add_development_dependency "rubocop", '~> 0.68'
  spec.add_development_dependency "rubocop-performance", '~> 1.2'
  spec.add_development_dependency "yard", '~> 0.9'
end
