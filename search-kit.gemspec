# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'search_kit/version'

Gem::Specification.new do |spec|
  spec.name          = "search-kit"
  spec.version       = SearchKit.version_string
  spec.authors       = ["Joseph McCormick"]
  spec.email         = ["esmevane@gmail.com"]

  spec.summary       = %q{Client gem for search kit}
  spec.description   = %q{Build simple and powerful search quickly}
  spec.homepage      = "https://github.com/qbox-io/search-kit"
  spec.license       = "MIT"

  spec.files         = %w[search-kit.gemspec]
  spec.files        += Dir['*.md', 'bin/*', 'lib/**/*.rb', 'config/**/*.yml']
  spec.test_files    = Dir['spec/**/*.rb']
  spec.require_paths = ["lib"]

  spec.executables   << 'search-kit'

  spec.add_dependency "ansi", "~> 1.5"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "highline", "~> 1.7"
  spec.add_dependency "i18n", "~> 0.7"
  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "user_config", "~> 0.0"
  spec.add_dependency "virtus", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "simplecov", "~> 0.10"
  spec.add_development_dependency "ruby-prof", "~> 0.15"
end
