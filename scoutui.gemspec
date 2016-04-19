# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scoutui/version'

Gem::Specification.new do |spec|
  spec.name          = 'scoutui'
  spec.version       = Scoutui::VERSION
  spec.authors       = ['Peter Kim', 'Joshua Peeling']
  spec.email         = ['h20dragon@outlook.com']

  spec.summary       = %q{Simple yet powerful application model based automation framework.}
  spec.description   = %q{Leverage a fully functional e2e framework that's integrated with Applitool's Eyes and Sauce Labs!}
  spec.homepage      = 'https://github.com/h20dragon'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'awesome_print'
  spec.add_dependency 'colorize'
  spec.add_dependency 'eyes_selenium', '>= 2.28'
  spec.add_dependency 'httparty', '>=0.13.7'
  spec.add_dependency 'json', '>= 1.8.3'
  spec.add_dependency 'logging'
  spec.add_dependency 'sauce_whisk'
  spec.add_dependency 'selenium-webdriver', '>= 2.47'
  spec.add_dependency 'testmgr', '0.3.1.pre'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-byebug'
end
