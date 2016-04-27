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
user_vars = Scoutui::Base::UserVars.inspect
user_vars.dump

puts '-' * 72
puts "accounts => " + user_vars.getVar(:accounts).to_s
puts "eyes.viewport => " + user_vars.getVar('eyes.viewport').to_s
puts "eyes.viewport => " + user_vars.getViewPort().to_s
