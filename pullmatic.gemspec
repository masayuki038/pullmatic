# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pullmatic/version'

Gem::Specification.new do |spec|
  spec.name          = "pullmatic"
  spec.version       = Pullmatic::VERSION
  spec.authors       = ['Masayuki Takahashi']
  spec.email         = ['masayuki038@gmail.com']

  spec.summary       = %q{A tool for collecting server states and printing as JSON string.}
  spec.description   = %q{A tool for collecting server states and printing as JSON string via SSH.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
  
  spec.add_dependency "specinfra", "~> 2.40"
  spec.add_dependency "oj"
  spec.add_dependency "ox"
  spec.add_dependency "thor"
end
