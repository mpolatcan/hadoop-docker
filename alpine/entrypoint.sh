#!/usr/bin/env bash
function execCmd() { su - hduser -s /bin/bash -c "$1"; }

function startNamenode() {
    # Formatting HDFS
    [[ ! -d "${HADOOP_TMP_DIR}/dfs" ]] && execCmd "${HADOOP_HOME}/bin/hadoop namenode -format"

    # Start Hadoop Namenode
    execCmd "${HADOOP_HOME}/sbin/hadoop-daemon.sh start namenode"

    # Start Hadoop Secondary namenode
    execCmd "${HADOOP_HOME}/sbin/hadoop-daemon.sh start secondarynamenode"

    # Start Hadoop Datanode
    execCmd "${HADOOP_HOME}/sbin/hadoop-daemon.sh start datanode"

    # Start YARN Resourcemanager
    execCmd "${HADOOP_HOME}/sbin/yarn-daemon.sh start resourcemanager"

    # Start YARN Nodemanager
    execCmd "${HADOOP_HOME}/sbin/yarn-daemon.sh start nodemanager"

    # Start JobHistory server
    execCmd "${HADOOP_HOME}/sbin/mr-jobhistory-daemon.sh start historyserver"
}

function startDatanode() {
    # Start Datanode
    execCmd "${HADOOP_HOME}/sbin/hadoop-daemon.sh start datanode"

    # Start YARN Nodemanager
    execCmd "${HADOOP_HOME}/sbin/yarn-daemon.sh start nodemanager"
}

# Load Hadoop configs
hadoop_config_loader.sh

[[ "${HADOOP_NODE_TYPE}" == "namenode" ]] && startNamenode

[[ "${HADOOP_NODE_TYPE}" == "datanode" ]] && startDatanode

tail -f /dev/null