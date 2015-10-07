#/bin/bash

BUT=chrome
TITLE=Gat
APP=Test
# export APPLITOOLS_API_KEY="__YOUR_KEY_HERE__"

TEST_CFG="./config.json"

##
# content
# strict
# exact
# layyout
# layout2
##
MATCH_TYPE="layout"

# $SCOUTUI --config $TEST_CFG  --browser $BUT --eyes --app $APP --title $TITLE  --match $MATCH_TYPE
$SCOUTUI_BIN --config $TEST_CFG  --eyes  --match $MATCH_TYPE  --browser $BUT
