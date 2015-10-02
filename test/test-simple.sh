#/bin/bash

BUT=firefox
TITLE=Graceland
APP=Elvis
KEY=../test/peter.eyes.json

TEST_CFG="../spec/fixtures/static_test_settings.elvis.json"

##
# content
# strict
# exact
# layyout
# layout2
##
MATCH_TYPE="content"

./test_script.rb --config $TEST_CFG  --browser $BUT --eyes true --app $APP --title $TITLE --key $KEY   --match content