#!/bin/bash
set -euxo pipefail

./mvnw -version

# TEST 1:  Running the application in a Docker container
./mvnw -ntp -q clean package

docker pull -q icr.io/appcafe/open-liberty:kernel-slim-java11-openj9-ubi

docker build -t openliberty-getting-started:1.0-SNAPSHOT .

docker run -d --name gettingstarted-app -p 9080:9080 openliberty-getting-started:1.0-SNAPSHOT

sleep 60

docker exec gettingstarted-app cat /logs/messages.log | grep product
docker exec gettingstarted-app cat /logs/messages.log | grep java

status="$(curl --write-out "%{http_code}\n" --silent --output /dev/null "http://localhost:9080/dev/system/properties")" 
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
./mvnw -ntp -Dhttp.keepAlive=false \
    -Dmaven.wagon.http.pool=false \
    -Dmaven.wagon.httpconnectionManager.ttlSeconds=120 \
    -q clean package liberty:create liberty:install-feature liberty:deploy
./mvnw -ntp liberty:start
./mvnw -ntp -Dhttp.keepAlive=false \
    -Dmaven.wagon.http.pool=false \
    -Dmaven.wagon.httpconnectionManager.ttlSeconds=120 \
    -Dcontext.root=/dev/ failsafe:integration-test liberty:stop
./mvnw -ntp failsafe:verify

# TEST 3: packaging and running the application jar
./mvnw -ntp liberty:package -Dinclude=runnable
if [ ! -f "target/guide-getting-started.jar" ]; then
    echo "target/guide-getting-started.jar was not generated!"
    exit 1
fi
java -jar target/guide-getting-started.jar &
GGS_PID=$!
echo "GGS_PID=$GGS_PID"
sleep 60
status="$(curl --write-out "%{http_code}\n" --silent --output /dev/null "http://localhost:9080/dev/system/properties")"
kill $GGS_PID
if [ "$status" == "200" ]
then
  echo ENDPOINT OK
else
  echo "$status"
  echo ENDPOINT NOT OK
  exit 1
fi
