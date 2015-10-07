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

puts "browser => #{test_settings[:browser]}"

puts '-' * 72
Scoutui::Base::UserVars.instance.dump()

puts '-' * 72
puts ":browser => " + Scoutui::Base::UserVars.instance.getVar(:browser).to_s
puts Scoutui::Base::UserVars.instance.getBrowserType()

puts "--key => " + Scoutui::Utils::TestUtils.instance.getLicenseFile().empty?.to_s