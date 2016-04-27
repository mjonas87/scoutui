#!/usr/bin/env ruby
require_relative '../lib/scoutui'

require 'dotenv'
require 'logger'
require 'pry'
require 'awesome_print'
require 'colorize'
require 'active_support/inflector'
require 'active_support/core_ext/hash'

Dotenv.load

##
# --file <Yaml>
# --host <String>
# --lang <String>
# --title <Applitools Title>
# --browser <chrome|firefox|ie>

begin
  nav = Scoutui::Navigator.new(Scoutui::Utils::TestUtils.instance.parseCommandLine)
  runner = Scoutui::Base::TestScout.new(nav)
  runner.start
  runner.report
rescue Exception => ex
  Scoutui::Logger::LogMgr.instance.debug ex.inspect.red
  Scoutui::Logger::LogMgr.instance.debug ex.backtrace.join("\n")
end
