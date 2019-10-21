#!/bin/bash

HADOOP_VERSIONS=(
    "3.2.1"
    "3.1.3"
    "2.9.2"
    "2.8.5"
    "2.7.7"
)

JAVA_VERSIONS=(
    "8"
)


function build_base_image() {
    sudo docker build -q -t mpolatcan/hadoop:base-java$1 --build-arg JAVA_VERSION=$1 ./src/v2/base/
    sudo docker push mpolatcan/hadoop:base-java$1
    sudo docker rmi mpolatcan/hadoop:base-java$1
}

function build_image() {
    sudo docker build -q -t mpolatcan/hadoop:$1-java$2 --build-arg HADOOP_VERSION=$1 --build-arg JAVA_VERSION=$2 ./src/v2/setup/
	  sudo docker push mpolatcan/hadoop:$1-java$2
	  sudo docker rmi mpolatcan/hadoop:$1-java$2
}

# Build Hadoop base image for each Java version
for JAVA_VERSION in ${JAVA_VERSIONS[@]}; do
    build_base_image $JAVA_VERSION
done

# Build Hadoop images for each Hadoop and Java versions
for HADOOP_VERSION in ${HADOOP_VERSIONS[@]}; do
  for JAVA_VERSION in ${JAVA_VERSIONS[@]}; do
      build_image $HADOOP_VERSION $JAVA_VERSION
  done
done