#!/bin/bash

declare -A daemons

# ------- YARN Daemons ---------
daemons[nodemanager]=yarn
daemons[proxyserver]=yarn
daemons[registrydns]=yarn
daemons[resourcemanager]=yarn
daemons[router]=yarn
daemons[sharedcachemanager]=yarn
# ------------------------------

# -------- HDFS Daemons --------
daemons[balancer]=hdfs
daemons[datanode]=hdfs
daemons[dfsrouter]=hdfs
daemons[diskbalancer]=hdfs
daemons[journalnode]=hdfs
daemons[mover]=hdfs
daemons[namenode]=hdfs
daemons[nfs3]=hdfs
daemons[portmap]=hdfs
daemons[secondarynamenode]=hdfs
daemons[sps]=hdfs
daemons[zkfc]=hdfs
# ------------------------------

# ------ MapReduce Daemons ------
daemons[historyserver]=mapred
# -------------------------------

function start_daemon() {
    ${daemons[$1]} --daemon start $1
}

function start_namenode() {
    # Formatting HDFS
    [[ ! -d "${HADOOP_TMP_DIR}/dfs" ]] && hdfs namenode -format

    # Start Hadoop Namenode
    start_daemon namenode

    # Start Hadoop Secondary namenode
    start_daemon secondarynamenode

    # Start Hadoop Datanode
    start_daemon datanode

    # Start YARN Resourcemanager
    start_daemon resourcemanager

    # Start YARN Nodemanager
    start_daemon nodemanager

    # Start JobHistory server
    start_daemon historyserver
}

function start_datanode() {
    # Start Datanode
    start_daemon datanode

    # Start YARN Nodemanager
    start_daemon nodemanager
}

function run_additional_daemons() {
  HADOOP_ADDITIONAL_DAEMONS=(${HADOOP_ADDITIONAL_DAEMONS//,/ })

  for daemon in ${HADOOP_ADDITIONAL_DAEMONS[@]}; do
    start_daemon $daemon
  done
}

# Load Hadoop configs
./hadoop_config_loader.sh

[[ "${HADOOP_NODE_TYPE}" == "namenode" ]] && start_namenode

[[ "${HADOOP_NODE_TYPE}" == "datanode" ]] && start_datanode

[[ "${HADOOP_ADDITIONAL_DAEMONS}" != "NULL" ]] && run_additional_daemons

if [[ "$1" == "hadoop" ]]; then
    tail -f /dev/null
fi