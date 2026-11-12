#!/bin/bash
while getopts t:d:b:u: flag;
do
    case "${flag}" in
        t) DATE="${OPTARG}";;
        d) DRIVER="${OPTARG}";;
        b) BUILD="${OPTARG}";;
        u) DOCKER_USERNAME="${OPTARG}";;
        *) echo "Invalid option";;
    esac
done

echo "Testing daily build image"

sed -i "\#<artifactId>liberty-maven-plugin</artifactId>#a<configuration><install><runtimeUrl>https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER</runtimeUrl></install></configuration>" pom.xml
cat pom.xml

if [[ "$DOCKER_USERNAME" != "" ]]; then
    sed -i "s;FROM icr.io/appcafe/open-liberty:kernel-slim-java25-openj9-ubi-minimal;FROM $DOCKER_USERNAME/olguides:$BUILD;g" Dockerfile
    sed -i "s;RUN features.sh;#RUN features.sh;g" Dockerfile
    cat Dockerfile
fi

../scripts/testApp.sh
