#/bin/bash
##
# Description
#   This test script overrides the provided title and appname (if provided in the test config. file)
#
# Set the APPLITOOLS_API_KEY environment variable with your key.
#
#          export APPLITOOLS_API_KEY="__YOUR_KEY_HERE__"
##
SCOUTUI_BIN=../../bin/scoutui_driver.rb
# Specify browser under test  (chrome, firefox, ie, safari)
BUT=chrome

# Specify the title and appName needed by Applitools
## NOTE:  If the test configuration file specifies the title and app, it is superseded by the
##        command line options.
TITLE=DEMO-CarMax
APP=Oct2015

# Specify the test configuration file
TEST_CFG="./test.config.json"

##
# content
# strict
# exact
# layyout
##
MATCH_TYPE="layout"

EYES=--eyes


# The following command line parameters will override provided title and appName (if provided in test config file)
$SCOUTUI_BIN  --config $TEST_CFG  --browser $BUT $EYES --app $APP --title $TITLE  --match $MATCH_TYPE --pagemodel ./page_model.json

# The following
# $SCOUTUI_BIN --config $TEST_CFG  --eyes  --match $MATCH_TYPE  --browser $BUT
