#!/usr/bin/env bash

#!/bin/bash


VIEWPORT="--viewport 800x600"

while getopts ":a:b:c:d:eh:l:m:p:r:st:u:A:P:O:S:T:V:v" opt; do
  case $opt in
    a)
      echo "-a was triggered, Parameter: $OPTARG" >&2
      ;;
    b)
       BROWSER="--browser $OPTARG"

       if [[ $BROWSER=="chrome" ]];
       then
          rc=`/usr/local/bin/which chromedriver`
          if [ $? -ne 0 ]
          then
            echo "-- Error: unable to find chromedriver. --"
            exit 2
          fi

       fi
       ;;
    c)
       CAPS="--capabilities $OPTARG"
       ;;
    d)
       DUT="--dut $OPTARG"
          ;;
    e)
      EYES="--eyes"
          ;;
    h)
      HOST="--host \"$OPTARG\""
      ;;
    l)
      LEVEL="--loglevel $OPTARG"
        ;;
    m)
      MATCH_LEVEL="--match $OPTARG"
      ;;
    p)
        PASSWORD="--password $OPTARG"
        ;;
    r)
        ROLE="--role $OPTARG"
        ;;
    s)
       SAUCE="--sauce"
       ;;
    S)
       SAUCE_NAME="--sauce_name $OPTARG"
       ;;
    t)
       TEST_CFG="$OPTARG"
       ;;
    u)
       USERID="--user $OPTARG"
       ;;
    v)
      VERBOSE="--debug"
      ;;
    A)
       APP="--app $OPTARG"
       ;;
    O)
       DIFF_DIR="--diffs $OPTARG"
       ;;
    P)
       PAGE_MODEL="--pages $OPTARG"
       ;;
    T)
       TITLE="--title $OPTARG"
       ;;
    V)
       VIEWPORT="--viewport $OPTARG"
       ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "BROWSER: ${BROWSER}"
echo "EYES : ${EYES}"
echo "HOST : ${HOST}"
echo "VERBOSE: ${VERBOSE}"
echo "MATCH: ${MATCH_LEVEL}"
echo "SAUCE: ${SAUCE}"
echo "CAPS: ${CAPS}"
echo "DUT: ${DUT}"
echo "TITLE: ${TITLE}"
echo "APP: ${APP}"
echo "VIEWPORT: ${VIEWPORT}"


# --dut ../commands/login.fail.yml
#TITLE="--title DEMO-XYZ"
#APP="--app LOC.ALL-HANDS"
#PAGE_MODEL="--pages ../appmodels/page_model.cge.json,../appmodels/page_model.traveler.json,../appmodels/page_model.common_bar.json"

if [[ -f $TEST_CFG ]]; then

  CMD="$SCOUTUI_BIN --config ${TEST_CFG} ${DIFF_DIR}  ${LEVEL} ${USERID} ${PASSWORD} ${DUT} ${VIEWPORT} ${ROLE} ${EYES} ${SAUCE} ${SAUCE_NAME} $TITLE ${APP} ${CAPS} ${MATCH_LEVEL} ${BROWSER} ${HOST}  ${PAGE_MODEL} ${VERBOSE}"

  echo $CMD
  eval $CMD
else
  echo "Error: unable to access ${TEST_CFG}."
  exit 1
fi