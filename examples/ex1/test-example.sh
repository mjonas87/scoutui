#/bin/bash
##
# Description
#   This test script overrides the provided title and appname (if provided in the test config. file)
#
# Set the APPLITOOLS_API_KEY environment variable with your key.
#
#          export APPLITOOLS_API_KEY="__YOUR_KEY_HERE__"
##

# Specify browser under test  (chrome, firefox, ie, safari)
BUT=chrome

# Specify the title and appName needed by Applitools
TITLE=DEMO-1012-MOUSE
APP=Elvis

# Specify the test configuration file
TEST_CFG="./test.config.json"

##
# content
# strict
# exact
# layyout
##
MATCH_TYPE="layout"

# The following command line parameters will override provided title and appName (if provided in test config file)
$SCOUTUI_BIN   --config $TEST_CFG  --browser $BUT --eyes --app $APP --title $TITLE  --match $MATCH_TYPE

# The following
# $SCOUTUI_BIN --config $TEST_CFG  --eyes  --match $MATCH_TYPE  --browser $BUT
