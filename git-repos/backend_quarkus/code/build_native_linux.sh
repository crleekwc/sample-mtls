#!/bin/bash
# Image quay.io/quarkus/ubi-quarkus-mandrel-builder-image:22.3-java17
java -version
BUILDER_IMAGE=quay.io/quarkus/ubi-quarkus-mandrel-builder-image:22.3.0.1-Final-java17-amd64
mvn clean install -Dnative  \
#-Dquarkus.native.builder-image=$BUILDER_IMAGE \
-DskipTests=true \
-Dquarkus.native.container-runtime=podman \
-Dquarkus.native.remote-container-build=true