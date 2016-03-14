#/bin/bash
##
# Description
#   Main test script.
##
export SCOUTUI_BIN=../../../bin/scoutui_driver.rb


# Specify the test configuration file
TEST_CFG="../test-configs/test.config.basic.json"

./run-test.sh -b chrome -d ../commands/commands.basic.yml -t $TEST_CFG -v