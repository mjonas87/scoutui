#/bin/bash
##
# Description
#   This test script overrides the provided title and appname (if provided in the test config. file)
#
# Set the APPLITOOLS_API_KEY environment variable with your key.
#
#          export APPLITOOLS_API_KEY="__YOUR_KEY_HERE__"
##
SCOUTUI_BIN=../../../bin/scoutui_driver.rb
# Specify browser under test  (chrome, firefox, ie, safari)
BUT=firefox

# Specify the title and appName needed by Applitools
## NOTE:  If the test configuration file specifies the title and app, it is superseded by the
##        command line options.
TITLE=DEMO-CarMax
APP=Oct2015

# Specify the test configuration file
TEST_CFG="../test-configs/test.config.json"

##
# content
# strict
# exact
# layyout
##
MATCH_TYPE="layout"

EYES=--eyes
EYES=


# The following command line parameters will override provided title and appName (if provided in test config file)
#$SCOUTUI_BIN  --config $TEST_CFG  --browser $BUT $EYES --app $APP --title $TITLE  --match $MATCH_TYPE --pagemodel ../appmodel/page_model.json  --debug

# The following
# $SCOUTUI_BIN --config $TEST_CFG  --eyes  --match $MATCH_TYPE  --browser $BUT

PM="../appmodel/page_model.json,../appmodel/common.json"

./run-test.sh -b chrome -i -d ../commands/ex2.yml -P "${PM}" -t ../test-configs/test.config.json -v