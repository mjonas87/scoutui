require_relative '../lib/scoutui'

require 'logger'

##
# --file <Yaml>
# --host <String>
# --lang <String>
# --title <Applitools Title>
# --browser <chrome|firefox|ie>




puts 'Start'

nav = Scoutui::Navigator.new(Scoutui::Utils::TestUtils.instance.parseCommandLine())


runner = Scoutui::Base::TestRunner.new(nav)

if runner.hasSettings?
  runner.dumpSettings

  runner.run()
end



