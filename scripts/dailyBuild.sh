#!/bin/bash
while getopts t:d:b:u: flag;
do
    case "${flag}" in
        t) DATE="${OPTARG}";;
        d) DRIVER="${OPTARG}";;
        b) BUILD="${OPTARG}";;
        u) DOCKER_USERNAME="${OPTARG}"
    esac
done

sed -i "\#<artifactId>liberty-maven-plugin</artifactId>#a<configuration><install><runtimeUrl>https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/"$DATE"/"$DRIVER"</runtimeUrl></install></configuration>" pom.xml
cat pom.xml

sed -i "s;FROM openliberty/open-liberty:kernel-java8-openj9-ubi;FROM "$DOCKER_USERNAME"/olguides:"$BUILD Dockerfile
cat Dockerfile

set -euxo pipefail

##############################################################################
##
##  Travis CI test script
##
##############################################################################

# TEST 1:  Running the application in a Docker container
mvn -q clean package

docker pull openliberty/open-liberty:kernel-java8-openj9-ubi

docker build -t openliberty-getting-started:1.0-SNAPSHOT .

docker run -d --name gettingstarted-app -p 9080:9080 openliberty-getting-started:1.0-SNAPSHOT

sleep 60

docker exec gettingstarted-app cat /logs/messages.log | grep product
docker exec gettingstarted-app cat /logs/messages.log | grep java

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
mvn -q clean package liberty:create liberty:install-feature liberty:deploy
mvn liberty:start
mvn failsafe:integration-test liberty:stop
mvn failsafe:verify
mvn liberty:package -Dinclude=runnable
if [ ! -f "target/guide-getting-started.jar" ]; then
    echo "target/guide-getting-started.jar was not generated!"
    exit 1
fi
