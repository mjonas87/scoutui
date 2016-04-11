#!/usr/bin/env ruby
require_relative '../lib/scoutui'

require 'dotenv'
require 'logger'
require 'pry'

##
# --file <Yaml>
# --host <String>
# --lang <String>
# --title <Applitools Title>
# --browser <chrome|firefox|ie>

Dotenv.load()
binding.pry

nav = Scoutui::Navigator.new(Scoutui::Utils::TestUtils.instance.parseCommandLine())
runner = Scoutui::Base::TestScout.new(nav)
runner.start
runner.report


