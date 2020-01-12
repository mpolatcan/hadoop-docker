#!/bin/bash

HADOOP_K8S_FILES=(
  # ---------------------------- CONFIGURATIONS ----------------------------
  "configuration/common/hadoop_init.yml"
  "configuration/master-slave-cluster/hadoop_master.yml"
  "configuration/master-slave-cluster/hadoop_slave.yml"
  # ------------------------------------------------------------------------

  # ------------------------------ SERVICES --------------------------------
  "service/common/hadoop.yml"
  "service/master-slave-cluster/hadoop_master_webapps.yml"
  "service/master-slave-cluster/hadoop_slave_webapps.yml"
  "service/master-slave-cluster/hadoop_other_webapps.yml"
  # ------------------------------------------------------------------------

  # ----------------------------- DEPLOYMENTS ------------------------------
  "deployment/master-slave-cluster/hadoop_master.yml"
  "deployment/master-slave-cluster/hadoop_slave.yml"
  # ------------------------------------------------------------------------
)

for HADOOP_K8S_FILE in ${HADOOP_K8S_FILES[@]}; do
  kubectl $1 -f $HADOOP_K8S_FILE
done