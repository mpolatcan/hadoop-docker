ARG JAVA_VERSION=""

FROM mpolatcan/hadoop:base-java${JAVA_VERSION}

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ARG HADOOP_VERSION=""
ARG HADOOP_DOWNLOAD_LINK="http://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

ENV HADOOP_VERSION=$HADOOP_VERSION

RUN wget ${HADOOP_DOWNLOAD_LINK} && \
    tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz -C ${HDUSER_HOME} && \
    mv ${HDUSER_HOME}/hadoop-${HADOOP_VERSION}/* ${HADOOP_HOME} && \
    chown -R hduser:hadoop ${HDUSER_HOME} && \
    rm -r ${HDUSER_HOME}/hadoop-${HADOOP_VERSION} && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

USER hduser
WORKDIR ${HDUSER_HOME}
ENTRYPOINT ["./hadoop_entrypoint.sh", "hadoop"]