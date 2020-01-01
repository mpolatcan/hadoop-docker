#!/bin/bash

HADOOP_K8S_FILES=(
  # ------------------------- CONFIGURATIONS -------------------------
  "configuration/hadoop_init.yml"
  "configuration/hadoop_namenode.yml"
  "configuration/hadoop_secondarynamenode.yml"
  "configuration/hadoop_datanode.yml"
  "configuration/hadoop_resourcemanager.yml"
  "configuration/hadoop_nodemanager.yml"
  # ------------------------------------------------------------------

  # ----------------------------- SERVICES ---------------------------
  "service/hadoop.yml"
  "service/hadoop_namenode_webapps.yml"
  "service/hadoop_secondarynamenode_webapps.yml"
  "service/hadoop_datanode_webapps.yml"
  "service/hadoop_resourcemanager_webapps.yml"
  "service/hadoop_nodemanager_webapps.yml"
  # ------------------------------------------------------------------

  # --------------------------- STORAGE CLASSES ----------------------
  "storage-class/gce_pd_hdd.yml"
  "storage-class/gce_pd_ssd.yml"
  # ------------------------------------------------------------------

  # ---------------------------- DEPLOYMENTS -------------------------
  "deployment/hadoop_namenode.yml"
  #"deployment/hadoop_secondarynamenode.yml"
  #"deployment/hadoop_datanode.yml"
  #"deployment/hadoop_resourcemanager.yml"
  #"deployment/hadoop_nodemanager.yml"
  # ------------------------------------------------------------------
)

for HADOOP_K8S_FILE in ${HADOOP_K8S_FILES[@]}; do
  kubectl $1 -f $HADOOP_K8S_FILE
done
