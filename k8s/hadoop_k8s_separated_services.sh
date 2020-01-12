#!/bin/bash

HADOOP_K8S_FILES=(
  # ---------------------------- CONFIGURATIONS ----------------------------
  "configuration/common/hadoop_init.yml"
  "configuration/separated-services-cluster/hadoop_namenode.yml"
  "configuration/separated-services-cluster/hadoop_secondarynamenode.yml"
  "configuration/separated-services-cluster/hadoop_resourcemanager.yml"
  "configuration/separated-services-cluster/hadoop_datanode.yml"
  "configuration/separated-services-cluster/hadoop_nodemanager.yml"
  # ------------------------------------------------------------------------

  # ------------------------------ SERVICES --------------------------------
  "service/common/hadoop.yml"
  "service/separated-services-cluster/hadoop_namenode_webapps.yml"
  "service/separated-services-cluster/hadoop_secondarynamenode_webapps.yml"
  "service/separated-services-cluster/hadoop_resourcemanager_webapps.yml"
  "service/separated-services-cluster/hadoop_datanode_webapps.yml"
  "service/separated-services-cluster/hadoop_nodemanager_webapps.yml"
  # ------------------------------------------------------------------------

  # ----------------------------- DEPLOYMENTS ------------------------------
  "deployment/separated-services-cluster/hadoop_namenode.yml"
  "deployment/separated-services-cluster/hadoop_secondarynamenode.yml"
  "deployment/separated-services-cluster/hadoop_resourcemanager.yml"
  "deployment/separated-services-cluster/hadoop_datanode.yml"
  "deployment/separated-services-cluster/hadoop_nodemanager.yml"
  # ------------------------------------------------------------------------
)

for HADOOP_K8S_FILE in ${HADOOP_K8S_FILES[@]}; do
  kubectl $1 -f $HADOOP_K8S_FILE
done