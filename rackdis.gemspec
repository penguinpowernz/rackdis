# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rackdis/version'

Gem::Specification.new do |spec|
  spec.name          = "rackdis"
  spec.version       = Rackdis::VERSION
  spec.authors       = ["Robert McLeod"]
  spec.email         = ["robert@penguinpower.co.nz"]
  spec.summary       = %q{Ruby clone of Webdis Redis web API}
  spec.description   = %q{A Ruby clone of the awesome Webdis Redis web API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_dependency "hiredis"
  spec.add_dependency "redis"
  spec.add_dependency "grape"
  spec.add_dependency "rack-stream"
  spec.add_dependency "em-synchrony"
  spec.add_dependency "thin"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
