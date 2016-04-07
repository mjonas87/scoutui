#!/usr/bin/env ruby
require_relative '../lib/scoutui'

require 'logger'

##
# --file <Yaml>
# --host <String>
# --lang <String>
# --title <Applitools Title>
# --browser <chrome|firefox|ie>


nav = Scoutui::Navigator.new(Scoutui::Utils::TestUtils.instance.parseCommandLine())


runner = Scoutui::Base::TestScout.new(nav)

runner.start()
runner.report()


