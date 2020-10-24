ARG JAVA_VERSION=""

FROM azul/zulu-openjdk:${JAVA_VERSION}

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ENV HDUSER_HOME "/home/hduser"
ENV HADOOP_HOME "${HDUSER_HOME}/hadoop"
ENV HADOOP_CONF_DIR="${HADOOP_HOME}/etc/hadoop" \
    YARN_CONF_DIR="${HADOOP_HOME}/etc/hadoop" \
    HADOOP_TMP_DIR="${HDUSER_HOME}/app/hadoop/tmp" \
    PATH=$PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${HADOOP_HOME}/lib/native/ \
    HADOOP_DAEMONS="NULL" \
    HADOOP_DFS_NAMESERVICES="" \
    HADOOP_WEBAPPS_HOSTNAME="0.0.0.0" \
    HADOOP_HEALTHCHECK_INTERVAL_IN_SECS="2"

ADD entrypoint.sh ${HDUSER_HOME}/hadoop_entrypoint.sh
ADD config_loader.sh ${HDUSER_HOME}/hadoop_config_loader.sh

RUN apt-get update && \
    apt-get -y install --no-install-recommends procps \
                                             nano \
                                             wget \
                                             rsync \
                                             gcc \
                                             g++ \
                                             unzip \
                                             iputils-ping \
                                             telnet \
                                             dnsutils \
                                             netcat \
                                             openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup hadoop && adduser --disabled-password --gecos "" --ingroup hadoop hduser && \
    mkdir -p ${HADOOP_HOME} ${HADOOP_TMP_DIR} && \
    chown -R hduser:hadoop ${HDUSER_HOME} && \
    chmod +x ${HDUSER_HOME}/hadoop_entrypoint.sh ${HDUSER_HOME}/hadoop_config_loader.sh && \
    ssh-keygen -b 2048 -t rsa -f ${HDUSER_HOME}/.ssh/id_rsa -q -N ""