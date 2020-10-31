#!/bin/bash

echo "ENV = {hosts:{timeline:\"http://${YARN_TIMELINE_SERVER_HOSTNAME}:${YARN_TIMELINE_SERVER_PORT:=8188}\",rm:\"http://${YARN_RESOURCEMANAGER_HOSTNAME}:${YARN_RESOURCEMANAGER_PORT:=8088}\"}};" > webapps/tez/config/configs.env
catalina.sh run