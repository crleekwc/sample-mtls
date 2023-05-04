#!/bin/sh
RUN_JAVA_VERSION=1.3.8
container=$(buildah from scratch)
t=$(buildah mount $newcontainer)
container=$(buildah from registry.access.redhat.com/ubi8-micro:latest)
microcontainer=$(buildah mount $container)
backendimage=quay.io/voravitl/backend:micro
yum clean all --installroot $microcontainer 
buildah config --env JAVA_PACKAGE="java-17-openjdk-headless" --env LANG="en_US.UTF-8" \
        --env RUN_JAVA_VERSION="1.3.8" --env LANGUAGE="en_US:en" \
        --env JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager" \
        $microcontainer
buildah run $microcontainer mkdir /deployments
buildah copy $microcontainer target/quarkus-app/lib/ /deployments
buildah copy $microcontainer target/quarkus-app/*.jar /deployments
buildah copy $microcontainer target/quarkus-app/app/ /deployments
buildah copy $microcontainer target/quarkus-app/quarkus/ /deployments
curl https://repo1.maven.org/maven2/io/fabric8/run-java-sh/${RUN_JAVA_VERSION}/run-java-sh-${RUN_JAVA_VERSION}-sh.sh -o ./run-java.sh
buildah copy $microcontainer ./run-java.sh /deployments
rm -f ./run-java.sh
buildah run $microcontainer echo "securerandom.source=file:/dev/urandom" >> /etc/alternatives/jre/conf/security/java.security
buildah run $microcontainer chown -R 1001 /deployments

buildah run $microcontainer chmod 540 /deployments/run-java.sh
buildah config --port 8080 $microcontainer
buildah config --entrypoint "java -Djava.util.logging.manager=org.jboss.logmanager.LogManager -jar /deployments/quarkus-run.jar" $microcontainer
buildah config --user 1001 $microcontainer
buildah umount $microcontainer
buildah commit $microcontainer $backendimage
