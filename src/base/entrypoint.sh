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

function start_daemons() {
  for daemon in ${HADOOP_DAEMONS[@]}; do
      if [[ "$daemon" == "namenode" ]]; then
          # Formatting HDFS
          hdfs namenode -format
      fi

      # Start current daemon
      ${daemons[$daemon]} --daemon start $daemon
  done
}

# Load Hadoop configs
./hadoop_config_loader.sh

# Start Hadoop Daemons
[[ "${HADOOP_DAEMONS}" != "NULL" ]] && start_daemons

if [[ "$1" == "hadoop" ]]; then
    tail -f /dev/null
fi