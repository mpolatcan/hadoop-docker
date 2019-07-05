#!/bin/bash

HADOOP_VERSIONS=(
    "3.2.0"
    "3.1.2"
    "3.1.1"
    "3.0.3"
    "3.0.2"
    "2.9.1"
    "2.9.0"
    "2.8.4"
    "2.7.6"
    "2.6.5"
)

DISTS=(
    "alpine"
    "ubuntu"
)

# $1: DIST
# $2: HADOOP_VERSION
function build_image() {
    sudo docker build -q -t mpolatcan/hadoop:$1-$2 --build-arg HADOOP_VERSION=$2 ./$1/
	sudo docker push mpolatcan/hadoop:$1-$2
	sudo docker rmi mpolatcan/hadoop:$1-$2
}

for HADOOP_VERSION in ${HADOOP_VERSIONS[@]}; do
    for DIST in ${DISTS[@]}; do
        build_image $DIST $HADOOP_VERSION
    done
done