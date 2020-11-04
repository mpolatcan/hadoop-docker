#!/bin/bash

# $1: message
function __log__() {
    echo "[$(date '+%d/%m/%Y %H:%M:%S')] -> $1"
}

function configure_tez() {
    __log__ "Configuring Tez..."
    hdfs dfs -mkdir -p /tez
    hdfs dfs -copyFromLocal ${TEZ_HOME}/tez.tar.gz /tez
}

function main() {
    # Load Hadoop configurations and run daemons
    ./hadoop_entrypoint.sh $1

    # Load Tez configurations
    ./tez_config_loader.sh

    # After HDFS started, if Tez enabled, configure it!
    if [[ "${TEZ_ENABLED:=false}" == "true" ]]; then
        __log__ "Awaiting HDFS is ready..."
        sleep 3
        __log__ "HDFS is ready!"
        configure_tez
    fi

    if [[ "$1" == "tez" ]]; then
        tail -f /dev/null
    fi
}

main $1
