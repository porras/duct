# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'duct/version'

Gem::Specification.new do |spec|
  spec.name          = "duct"
  spec.version       = Duct::VERSION
  spec.authors       = ["Sergio Gil"]
  spec.email         = ["sgilperez@gmail.com"]
  spec.description   = %q{Embeds a Gemfile in a script}
  spec.summary       = %q{Embeds a Gemfile in a script}
  spec.homepage      = "https://github.com/porras/duct"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
