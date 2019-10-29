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
mvn liberty:start
mvn failsafe:integration-test liberty:stop
mvn failsafe:verify
