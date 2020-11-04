ARG JAVA_VERSION=""
ARG HADOOP_VERSION=""
FROM mpolatcan/hadoop:${HADOOP_VERSION}-java${JAVA_VERSION}

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ARG HADOOP_VERSION=""
ARG TEZ_VERSION="0.9.2"
ARG TEZ_ZIP_FOLDER_NAME="tez-${TEZ_VERSION}-hadoop-${HADOOP_VERSION}"
ARG TEZ_DOWNLOAD_LINK="https://github.com/mpolatcan/apache-tez-dist/releases/download/tez-${TEZ_VERSION}-hadoop-${HADOOP_VERSION}/${TEZ_ZIP_FOLDER_NAME}.tar.gz"

ENV TEZ_HOME="${HDUSER_HOME}/tez"
ENV TEZ_CONF_DIR="${TEZ_HOME}/conf"
ENV HADOOP_CLASSPATH=$HADOOP_CLASSPATH:${TEZ_CONF_DIR}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*

USER root

ADD config_loader.sh ./tez_config_loader.sh
ADD entrypoint.sh ./tez_entrypoint.sh

RUN mkdir -p ${TEZ_CONF_DIR} && \
    wget ${TEZ_DOWNLOAD_LINK} && \
    tar -xvzf ${TEZ_ZIP_FOLDER_NAME}.tar.gz -C ${TEZ_HOME} && \
    cd ${TEZ_HOME} && tar -czvf tez.tar.gz * && cd .. && \
    chown -R hduser:hadoop ${HDUSER_HOME} && \
    chmod +x tez_entrypoint.sh tez_config_loader.sh && \
    rm -r ${TEZ_ZIP_FOLDER_NAME}.tar.gz

USER hduser
ENTRYPOINT ["./tez_entrypoint.sh", "tez"]