require_relative '../lib/scoutui'

require 'logger'

##
# --file <Yaml>
# --host <String>
# --lang <String>
# --title <Applitools Title>
# --browser <chrome|firefox|ie>

# ruby test_script.rb  --file ../spec/fixtures/static_test_settings.json --host rqa3 --lang en-us  --title "abc 123"  --user peter --password Hello --browser chrome  --eyes false --debug false


puts 'Start'

nav = Scoutui::Navigator.new(Scoutui::Utils::TestUtils.instance.parseCommandLine())

puts "User => " + Scoutui::Base::Utils::TestUtils.instance.gets(:user)