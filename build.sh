#!/bin/bash

HADOOP_VERSIONS=(
    "3.2.1"
    "3.1.2"
    "2.9.2"
    "2.8.5"
    "2.7.7"
)

JAVA_VERSIONS=(
    "8"
    "9"
    "10"
    "11"
)

# $1: HADOOP_VERSION
# $2: JAVA_VERSION
function build_image() {
    sudo docker build -q -t mpolatcan/hadoop:$1-java$2 --build-arg HADOOP_VERSION=$1 --build-arg JAVA_VERSION=$2 ./src/
	  sudo docker push mpolatcan/hadoop:$1-java$2
	  sudo docker rmi mpolatcan/hadoop:$1-java$2
}

for HADOOP_VERSION in ${HADOOP_VERSIONS[@]}; do
  for JAVA_VERSION in ${JAVA_VERSIONS[@]}; do
      build_image $HADOOP_VERSION $JAVA_VERSION
  done
done