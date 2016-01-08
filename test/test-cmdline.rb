#!/usr/bin/ruby
require_relative '../lib/scoutui'

require 'logger'

##
# --file <Yaml>
# --host <String>
# --lang <String>
# --title <Applitools Title>
# --browser <chrome|firefox|ie>


nav = Scoutui::Navigator.new(Scoutui::Utils::TestUtils.instance.parseCommandLine())

test_settings=Scoutui::Utils::TestUtils.instance.getTestSettings()

puts test_settings

puts "accounts => #{test_settings[:accounts]}"

puts '-' * 72
Scoutui::Base::UserVars.instance.dump()

puts '-' * 72
puts "accounts => " + Scoutui::Base::UserVars.instance.getVar(:accounts).to_s
puts "eyes.viewport => " + Scoutui::Base::UserVars.instance.getVar('eyes.viewport').to_s
puts "eyes.viewport => " + Scoutui::Base::UserVars.instance.getViewPort().to_s