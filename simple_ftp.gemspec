# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_ftp/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_ftp"
  spec.version       = SimpleFtp::VERSION
  spec.authors       = ["david hodgetts"]
  spec.email         = ["david.demainlalune@gmail.com"]
  spec.description   = %q{wrap NET::Ftp to provide rmdir! and put_dir methods}
  spec.summary       = %q{rmdir! is too be used as rmdir exept it will delete full dir, put_dir will move whole tree to server}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "rake"
end
