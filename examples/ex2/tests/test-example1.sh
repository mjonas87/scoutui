#/bin/bash
##
# Description
#   Main test script.
##
export SCOUTUI_BIN=../../../bin/scoutui_driver.rb


# Specify the test configuration file
TEST_CFG="../test-configs/test.config.basic.json"

./run-test.sh -b chrome -d ../commands/ex1.yml -t $TEST_CFG -v