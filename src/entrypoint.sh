#!/usr/bin/env bash
function startNamenode() {
    # Formatting HDFS
    [[ ! -d "${HADOOP_TMP_DIR}/dfs" ]] && hdfs namenode -format

    # Start Hadoop Namenode
    hdfs --daemon start namenode

    # Start Hadoop Secondary namenode
    hdfs --daemon start secondarynamenode

    # Start Hadoop Datanode
    hdfs --daemon start datanode

    # Start YARN Resourcemanager
    yarn --daemon start resourcemanager

    # Start YARN Nodemanager
    yarn --daemon start nodemanager

    # Start JobHistory server
    mapred --daemon start historyserver
}

function startDatanode() {
    # Start Datanode
    hdfs --daemon start datanode

    # Start YARN Nodemanager
    yarn --daemon start nodemanager
}

# Load Hadoop configs
./hadoop_config_loader.sh

[[ "${HADOOP_NODE_TYPE}" == "namenode" ]] && startNamenode

[[ "${HADOOP_NODE_TYPE}" == "datanode" ]] && startDatanode

if [[ "$1" == "hadoop" ]]; then
    tail -f /dev/null
fi