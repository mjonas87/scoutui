#/bin/bash
##
# Description
#   Main test script.
##
export SCOUTUI_BIN=../../../bin/scoutui_driver.rb


# Specify the test configuration file
TEST_CFG="../test-configs/test.config.basic.json"
APP_MODEL="../appmodel/page_model.json"


./run-test.sh -b chrome -d ../commands/commands.basic.appmodel.yml -P $APP_MODEL  -t $TEST_CFG -v