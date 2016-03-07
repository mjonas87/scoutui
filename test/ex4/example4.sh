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
MATCH_LEVEL="layout2"

HOST=http://rqa3-cb.concurtech.net

# $SCOUTUI --config $TEST_CFG  --eyes  --match $MATCH_LEVEL  --browser $BUT --host $HOST
$SCOUTUI --config $TEST_CFG  --eyes  --browser $BUT --host $HOST --debug --viewport 800x600
