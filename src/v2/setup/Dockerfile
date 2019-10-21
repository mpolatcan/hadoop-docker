ARG JAVA_VERSION=8

FROM mpolatcan/hadoop:base-java${JAVA_VERSION}

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ARG HADOOP_VERSION=3.2.1
ARG HADOOP_DOWNLOAD_LINK="http://www-eu.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

RUN wget ${HADOOP_DOWNLOAD_LINK} && \
    tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz -C ${HDUSER_HOME} && \
    mv ${HDUSER_HOME}/hadoop-${HADOOP_VERSION}/* ${HADOOP_HOME} && \
    chown -R hduser:hadoop ${HDUSER_HOME} ${HADOOP_HOME} ${HADOOP_TMP_DIR} && \
    rm -r ${HDUSER_HOME}/hadoop-${HADOOP_VERSION} && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

USER hduser
WORKDIR ${HDUSER_HOME}
ENTRYPOINT ["./hadoop_entrypoint.sh", "hadoop"]