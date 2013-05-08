# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firebolt/version'

Gem::Specification.new do |spec|
  spec.name          = "firebolt"
  spec.version       = Firebolt::VERSION
  spec.authors       = ["Adam Hutchison","BJ Neilsen"]
  spec.email         = ["dev@moneydesktop.com"]
  spec.description   = %q{Simple little cache sweeper/warmer.}
  spec.summary       = %q{Firebolt is a simple cache sweeper & warmer. It sweeps the cache based on a given key and warms the cache using a specially defined class.}
  spec.homepage      = "https://git.moneydesktop.com/dev/firebolt"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  ##
  # Dependencies
  #
  spec.add_dependency "rufus-scheduler"
  spec.add_dependency "sucker_punch"

  ##
  # Development Dependencies
  #
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "better_receive"
  spec.add_development_dependency "special_delivery"
end
