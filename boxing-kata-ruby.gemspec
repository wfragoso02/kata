# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boxing/kata/version'

Gem::Specification.new do |spec|
  spec.name          = "boxing-kata-ruby"
  spec.version       = Boxing::Kata::VERSION
  spec.authors       = ["J"]
  spec.email         = ["j"]

  spec.summary       = "The Boxing Kata"
  spec.description   = "A kata in Ruby for determining how to box and ship dental perks."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "activesupport", "~> 5.0.0"
  spec.add_development_dependency "csv", "~> 3.1.1"
  spec.add_development_dependency "byebug", "~> 11.0"
  spec.add_development_dependency 'american_date', '~> 1.1'
end
