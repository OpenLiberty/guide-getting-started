#!/bin/bash
while getopts t:d:v: flag;
do
    case "${flag}" in
        t) DATE="${OPTARG}";;
        d) DRIVER="${OPTARG}";;
        v) OL_LEVEL="${OPTARG}";;
        *) echo "Invalid option";;
    esac
done

echo "Testing daily Docker image"

sed -i "\#<artifactId>liberty-maven-plugin</artifactId>#a<configuration><install><runtimeUrl>https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER</runtimeUrl></install></configuration>" pom.xml
cat pom.xml

if [[ "$OL_LEVEL" != "" ]]; then
  sed -i "s;FROM icr.io/appcafe/open-liberty:kernel-slim-java25-openj9-ubi-minimal;FROM cp.stg.icr.io/cp/olc/open-liberty-vnext:$OL_LEVEL-full-java25-openj9-ubi-minimal;g" Dockerfile
else
  sed -i "s;FROM icr.io/appcafe/open-liberty:kernel-slim-java25-openj9-ubi-minimal;FROM cp.stg.icr.io/cp/olc/open-liberty-daily:full-java25-openj9-ubi-minimal;g" Dockerfile
fi
sed -i "s;RUN features.sh;#RUN features.sh;g" Dockerfile
cat Dockerfile

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin cp.stg.icr.io
docker pull "cp.stg.icr.io/cp/olc/open-liberty-daily:full-java25-openj9-ubi-minimal"
echo "build level:"
docker inspect --format "{{ index .Config.Labels \"org.opencontainers.image.revision\"}}" cp.stg.icr.io/cp/olc/open-liberty-daily:full-java25-openj9-ubi-minimal

../scripts/testApp.sh
