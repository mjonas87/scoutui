#/bin/bash
SCOUTUI=././../test_script.rb

BUT=chrome
TITLE=LOC-LOGIN-TEST
APP=Login
# export APPLITOOLS_API_KEY="__YOUR_KEY_HERE__"

TEST_CFG="./config.ja.json"

##
# content
# strict
# exact
# layyout
# layout2
##
MATCH_TYPE="layout"

HOST=http://rqa3-cb.concurtech.net

$SCOUTUI --config $TEST_CFG  --eyes  --match $MATCH_TYPE  --browser $BUT --host $HOST
