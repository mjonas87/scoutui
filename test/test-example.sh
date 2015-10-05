#/bin/bash

BUT=firefox
TITLE=Graceland
APP=Elvis
# export APPLITOOLS_API_KEY="__YOUR_KEY_HERE__"

TEST_CFG="../spec/fixtures/static_test_settings.elvis.json"

##
# content
# strict
# exact
# layyout
# layout2
##
MATCH_TYPE="content"

./test_script.rb --config $TEST_CFG  --browser $BUT --eyes --app $APP --title $TITLE  --match $MATCH_TYPE