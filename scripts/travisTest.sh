#!/bin/bash
#set -euxo pipefail

##############################################################################
##
##  Travis CI test script
##
##############################################################################

# TEST 1:  Running the application in a Docker container
mvn -q clean package

docker build -t openliberty-getting-started:1.0-SNAPSHOT .

docker run -d --name gettingstarted-app -p 9080:9080 openliberty-getting-started:1.0-SNAPSHOT

sleep 60

status="$(curl --write-out "%{http_code}\n" --silent --output /dev/null "http://localhost:9080/system/properties")" 
if [ "$status" == "200" ]
then 
  echo ENDPOINT OK
else 
  echo "$status" 
  echo ENDPOINT NOT OK
  exit 1
fi

docker stop gettingstarted-app && docker rm gettingstarted-app

# TEST 2: Building and running the application
mvn -q clean package liberty:create liberty:install-feature liberty:deploy liberty:package 
mvn liberty:start > start.log
mvn failsafe:integration-test liberty:stop > out.log
ERROR=`grep ERROR out.log | wc -l | awk '{$1=$1};1'`
if [ $ERROR -ne 0 ]; then
    mvn liberty:stop
    cat start.log
    cat target/liberty/wlp/usr/servers/defaultServer/logs/messages.log 
    cat out.log
    echo "Test Failed!"
    exit 1
fi
