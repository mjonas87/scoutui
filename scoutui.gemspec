# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scoutui/version'

Gem::Specification.new do |spec|
  spec.name          = "scoutui"
  spec.version       = Scoutui::VERSION
  spec.authors       = ["Peter Kim"]
  spec.email         = ["h20dragon@outlook.com"]

  spec.summary       = %q{Simple yet powerful navigation and browser snapshot framework.}
  spec.description   = %q{Leverage a navigation framework integrated with Applitool's Eyes for page/image capture capabilities - welcome to the world of Visual Testing!}
  spec.homepage      = "https://github.com/h20dragon"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "eyes_selenium"
  spec.add_development_dependency "selenium-webdriver", ">= 2.47"
  spec.add_development_dependency "httparty"
  spec.add_development_dependency "json"
end
