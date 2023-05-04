#!/bin/bash
mvn clean install -Dnative  \
-DskipTests=true -Dquarkus.native.container-runtime=podman \
-Dquarkus.native.remote-container-build=true