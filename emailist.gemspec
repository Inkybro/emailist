# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emailist/version'

Gem::Specification.new do |spec|
  spec.name          = "emailist"
  spec.version       = Emailist::VERSION
  spec.authors       = ["Ethan Barron"]
  spec.email         = ["inkybro@gmail.com"]
  spec.summary       = %q{Wrapper around Ruby's Array class for managing lists of email addresses.}
  spec.description   = %q{
                          Provides a Ruby array wrapper that helps in managing a list of 
                          email addresses. Automagically uniquifies the list, as well as
                          attempting to clean invalid emails.
                        }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "shoulda-matchers"

  spec.add_runtime_dependency "possible_email"
end
