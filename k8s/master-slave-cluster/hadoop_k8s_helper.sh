#!/bin/bash

HADOOP_K8S_FILES=(
  # ------------------------- CONFIGURATIONS -------------------------
  "configuration/hadoop_init.yml"
  "configuration/hadoop_master.yml"
  "configuration/hadoop_slave.yml"
  # ------------------------------------------------------------------

  # ----------------------------- SERVICES ---------------------------
  "service/hadoop.yml"
  "service/hadoop_master_webapps.yml"
  "service/hadoop_other_webapps.yml"
  "service/hadoop_slave_webapps.yml"
  # ------------------------------------------------------------------

  # --------------------------- STORAGE CLASSES ----------------------
  "storage-class/gce_pd_hdd.yml"
  "storage-class/gce_pd_ssd.yml"
  # ------------------------------------------------------------------

  # ---------------------------- DEPLOYMENTS -------------------------
  "deployment/hadoop_master.yml"
  "deployment/hadoop_slave.yml"
  # ------------------------------------------------------------------
)

for HADOOP_K8S_FILE in ${HADOOP_K8S_FILES[@]}; do
  kubectl $1 -f $HADOOP_K8S_FILE
done
