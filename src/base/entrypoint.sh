#!/bin/bash
declare -A daemons
declare -A healthchecks
declare -A healthcheck_hosts
declare -A healthcheck_ports

# ------------------------- DAEMONS -----------------------
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
# -------------------------------------------------------------

# ------------------------ HEALTHCHECKS -----------------------
healthchecks[nodemanager]=resourcemanager
healthchecks[datanode]=namenode

healthcheck_hosts[resourcemanager]=$YARN_RESOURCEMANAGER_HOSTNAME
healthcheck_hosts[namenode]=$DFS_NAMENODE_HOSTNAME

healthcheck_ports[resourcemanager]=$YARN_RESOURCEMANAGER_WEBAPP_PORT
healthcheck_ports[namenode]=$DFS_NAMENODE_HTTP_PORT
# -------------------------------------------------------------

function health_checker() {
  host=${healthcheck_hosts[$2]}

  if [[ "${healthcheck_hosts[$2]}" == "NULL" ]]; then
    host=$HOSTNAME
  fi

  port=${healthcheck_ports[$2]}

  echo "Hadoop $2 healthcheck started (for: \"$1\", host: \"$host\", port: \"$port\")"

  nc $host $port
  result=$?

  until [[ $result -eq 0 ]]; do
    echo "Waiting Hadoop $2 is ready (for: \"$1\", host: \"$host\", port: \"$port\")"
    sleep 2

    nc $host $port
    result=$?
  done

  echo "Hadoop $2 is ready (for: \"$1\", host: \"$host\", port: \"$port\") ✔"
}

function start_daemons() {
  for daemon in ${HADOOP_DAEMONS[@]}; do
      if [[ "$daemon" == "namenode" ]]; then
          # Formatting HDFS
          if [[ ! -d "${HADOOP_TMP_DIR}/dfs" ]]; then
              echo "Formatting HDFS on namenode..."
              hdfs namenode -format
          else
              echo "HDFS already formatted!"
          fi
      fi

      if [[ "${healthchecks[$daemon]}" != "" ]]; then
        health_checker $daemon ${healthchecks[$daemon]}
      fi

      # Start current daemon
      echo "Starting Hadoop  $daemon..."
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