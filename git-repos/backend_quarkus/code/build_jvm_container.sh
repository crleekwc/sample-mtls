#!/bin/sh
CONTAINER_NAME=quay.io/voravitl/backend
PLATFORM=linux/amd64
if [ $# -lt 1 ];
then
   echo "Usage: build_jvm_container.sh <TAG>"
   echo "Use default tag micrometer"
   TAG=micrometer
else
   TAG=$1
fi
if [ $# -gt 1 ];
then
   DOCKERFILE=$2
else
   DOCKERFILE=jvm
fi

echo "Build with Dockerfile.$DOCKERFILE tag $TAG"
mvn clean package -DskipTests=true
CONTAINER_RUNTIME=podman
podman --version 1>/dev/null 2>&1
if [ $? -ne 0 ];
then
   CONTAINER_RUNTIME=docker 
fi
$CONTAINER_RUNTIME build --platform $PLATFORM --layers=false  -f src/main/docker/Dockerfile.$DOCKERFILE \
-t ${CONTAINER_NAME}:${TAG} .
jq --help > /dev/null
if [ $? -eq 0 ];
then
   ARCH=$($CONTAINER_RUNTIME inspect ${CONTAINER_NAME}:${TAG} | jq '.[0].Architecture' | sed 's/\"//g')
   printf "${CONTAINER_NAME}:${TAG} architecture is $ARCH"
fi
