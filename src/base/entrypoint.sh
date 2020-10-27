#!/bin/bash
declare -A hadoop_daemons
declare -A hadoop_daemons_backport
declare -A healthchecks
declare -A healthcheck_hosts
declare -A healthcheck_ports

# ------------------------- DAEMONS -----------------------
# ------- YARN Daemons ---------
hadoop_daemons[nodemanager]=yarn
hadoop_daemons_backport[nodemanager]=yarn-daemon.sh
hadoop_daemons[proxyserver]=yarn
hadoop_daemons_backport[proxyserver]=yarn-daemon.sh
hadoop_daemons[registrydns]=yarn
hadoop_daemons_backport[registrydns]=yarn-daemon.sh
hadoop_daemons[resourcemanager]=yarn
hadoop_daemons_backport[resourcemanager]=yarn-daemon.sh
hadoop_daemons[router]=yarn
hadoop_daemons_backport[router]=yarn-daemon.sh
hadoop_daemons[sharedcachemanager]=yarn
hadoop_daemons_backport[sharedcachemanager]=yarn-daemon.sh
# ------------------------------

# -------- HDFS Daemons --------
hadoop_daemons[balancer]=hdfs
hadoop_daemons_backport[balancer]=hadoop-daemon.sh
hadoop_daemons[datanode]=hdfs
hadoop_daemons_backport[datanode]=hadoop-daemon.sh
hadoop_daemons[dfsrouter]=hdfs
hadoop_daemons_backport[dfsrouter]=hadoop-daemon.sh
hadoop_daemons[diskbalancer]=hdfs
hadoop_daemons_backport[diskbalancer]=hadoop-daemon.sh
hadoop_daemons[journalnode]=hdfs
hadoop_daemons_backport[journalnode]=hadoop-daemon.sh
hadoop_daemons[mover]=hdfs
hadoop_daemons_backport[mover]=hadoop-daemon.sh
hadoop_daemons[namenode]=hdfs
hadoop_daemons_backport[namenode]=hadoop-daemon.sh
hadoop_daemons[nfs3]=hdfs
hadoop_daemons_backport[nfs3]=hadoop-daemon.sh
hadoop_daemons[portmap]=hdfs
hadoop_daemons_backport[portmap]=hadoop-daemon.sh
hadoop_daemons[secondarynamenode]=hdfs
hadoop_daemons_backport[secondarynamenode]=hadoop-daemon.sh
hadoop_daemons[sps]=hdfs
hadoop_daemons_backport[sps]=hadoop-daemon.sh
hadoop_daemons[zkfc]=hdfs
hadoop_daemons_backport[zkfc]=hadoop-daemon.sh
# ------------------------------

# ------ MapReduce Daemons ------
hadoop_daemons[historyserver]=mapred
hadoop_daemons_backport[historyserver]=mr-jobhistory-daemon.sh
# -------------------------------------------------------------

# $1: message
function __log__() {
    echo "[$(date '+%d/%m/%Y %H:%M:%S')] -> $1"
}

function configure_hdfs() {
    # Formatting HDFS
    if [[ ! -d "${HADOOP_TMP_DIR}/dfs" ]]; then
        if [[ "${HADOOP_FORMAT_NAMENODE:=true}" == "true" ]]; then
            __log__ "Formatting HDFS on namenode..."
            hdfs namenode -format
        fi
    else
        __log__ "HDFS already formatted!"
    fi

    if [[ "${HADOOP_BOOTSTRAP_STANDBY_NAMENODE:=false}" == "true" ]]; then
        hdfs namenode -bootstrapStandby
    fi
}

function configure_zkfc() {
    if [[ "${HADDOP_INITIALIZE_HA_STATE_IN_ZK:=false}" == "true" ]]; then
        hdfs zkfc -formatZK
    fi
}

function start_daemons() {
    IFS='.' read -r -a HADOOP_VERSION_TOKENS <<< "$HADOOP_VERSION"

    __log__ "Hadoop CLI Version ${HADOOP_VERSION_TOKENS[0]}!"

    for daemon in ${HADOOP_DAEMONS[@]}; do
        if [[ "$daemon" == "namenode" ]]; then
            configure_hdfs
        elif [[ "$daemon" == "zkfc" ]]; then
            configure_zkfc
        fi

        # Start current daemon
        __log__ "Starting Hadoop $daemon..."
        if [[ "${HADOOP_VERSION_TOKENS[0]}" == "2" ]]; then
            ${hadoop_daemons_backport[$daemon]} start $daemon
        else
            ${hadoop_daemons[$daemon]} --daemon start $daemon
        fi
    done
}

function main() {
    # Load Hadoop configs
    ./hadoop_config_loader.sh

    if [[ "${HADOOP_DAEMONS}" != "NULL" ]]; then
      # Start Hadoop Daemons
        start_daemons
    else
        __log__ "HADOOP_DAEMONS environment variable is not defined so that container will be run in \"client\" mode"
    fi

    if [[ "$1" == "hadoop" ]]; then
        tail -f /dev/null
    fi
}

main $1