ARG JAVA_VERSION=""

FROM azul/zulu-openjdk:${JAVA_VERSION}

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ENV HDUSER_HOME "/home/hduser"
ENV HADOOP_HOME="${HDUSER_HOME}/hadoop"
ENV HADOOP_CONF_DIR="${HADOOP_HOME}/etc/hadoop" \
    YARN_CONF_DIR="${HADOOP_HOME}/etc/hadoop" \
    PATH=$PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin \
    HADOOP_CLASSPATH=$HADOOP_CLASSPATH:${HADOOP_HOME}/share/hadoop/tools/lib/* \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${HADOOP_HOME}/lib/native/ \
    HADOOP_TMP_DIR="${HDUSER_HOME}/app/hadoop/tmp" \
    HADOOP_HDFS_HOME="${HADOOP_HOME}" \
    HADOOP_MAPRED_HOME="${HADOOP_HOME}" \
    HADOOP_COMMON_HOME="${HADOOP_HOME}" \
    HADOOP_YARN_HOME="${HADOOP_HOME}"

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
                                             net-tools \
                                             python && \
    rm -rf /var/lib/apt/lists/* && \
    addgroup hadoop && adduser --disabled-password --gecos "" --ingroup hadoop hduser && \
    mkdir -p ${HADOOP_HOME} ${HADOOP_TMP_DIR} && \
    chown -R hduser:hadoop ${HDUSER_HOME}