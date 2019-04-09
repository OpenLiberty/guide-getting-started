#!/bin/bash
set -euxo pipefail

##############################################################################
##
##  Travis CI test script
##
##############################################################################

# TEST 1:  Running the application in a Docker container
mvn -q clean package -P docker-image

docker run -d --name gettingstarted-app -p 9080:9080 openliberty-getting-started:1.0-SNAPSHOT

sleep 60

status="$(curl --write-out "%{http_code}\n" --silent --output /dev/null "http://localhost:9080/system/properties")"; if [ "$status" == "200" ]; then echo ENDPOINT OK; else echo "$status"; echo ENDPOINT NOT OK; exit 1; fi;

docker stop gettingstarted-app && docker rm gettingstarted-app

# TEST 2: Building and running the application
mvn -q clean install

serverName=$(target/liberty/wlp/bin/server list | cut -d '.' -f2| tr -d '\n');

build=$(grep "Open Liberty" target/liberty/wlp/usr/servers/"$serverName"/logs/console.log | cut -d' ' -f5 | cut -d')' -f1 ); release=$( echo "$build" | cut -d'/' -f1); number=$(echo "$build" | cut -d'/' -f2); ol_jv=$(grep -i "on java" target/liberty/wlp/usr/servers/"$serverName"/logs/console.log); jv=$(printf '%s\n' "${ol_jv//$' on '/$'\n'}" | sed '2q;d'); echo -e "\n"; echo -e  "\033[1;34mOpen Liberty release:\033[0m \033[1;36m$release\033[0m"; echo -e "\033[1;34mOpen Liberty build number:\033[0m \033[1;36m$number\033[0m"; echo -e "\033[1;34mJava version:\033[0m\033[1;36m$jv\033[0m";

cd target/liberty/wlp/usr/servers/"$serverName"/logs/; repo_name=$(echo "$TRAVIS_REPO_SLUG" | sed -e "s/\//-/g"); if [ "$TRAVIS_TEST_RESULT" -eq 0 ]; then result="passed"; else result="failed"; fi; serverlogsarchive="$repo_name-$TRAVIS_BUILD_NUMBER-$result.zip";zip -r "$serverlogsarchive" .; curl -H "$JFROG_TOKEN" -T "$serverlogsarchive" "https://na.artifactory.swg-devops.com/artifactory/hyc-openliberty-guides-files-generic-local/";
