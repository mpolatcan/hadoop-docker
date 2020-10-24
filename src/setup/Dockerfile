ARG JAVA_VERSION=""

FROM mpolatcan/hadoop:base-java${JAVA_VERSION}

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ARG HADOOP_VERSION=""
ARG HADOOP_DOWNLOAD_LINK="http://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"
ARG AWS_SDK_JAVA_VERSION="1.11.881"
ARG AWS_SDK_JAVA_DOWNLOAD_LINK="https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_JAVA_VERSION}/aws-java-sdk-bundle-${AWS_SDK_JAVA_VERSION}.jar"

ENV HADOOP_VERSION=$HADOOP_VERSION

RUN wget ${HADOOP_DOWNLOAD_LINK} && \
    tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz -C ${HDUSER_HOME} && \
    mv ${HDUSER_HOME}/hadoop-${HADOOP_VERSION}/* ${HADOOP_HOME} && \
    chown -R hduser:hadoop ${HDUSER_HOME} && \
    rm -r ${HDUSER_HOME}/hadoop-${HADOOP_VERSION} && \
    rm hadoop-${HADOOP_VERSION}.tar.gz && \
    rm ${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-*.jar && \
    wget ${AWS_SDK_JAVA_DOWNLOAD_LINK} && \
    mv aws-java-sdk-bundle-${AWS_SDK_JAVA_VERSION}.jar ${HADOOP_HOME}/share/hadoop/tools/lib

# Run sshd in background
CMD sshd -D ${HDUSER_HOME}/sshd_config

USER hduser
WORKDIR ${HDUSER_HOME}
ENTRYPOINT ["./hadoop_entrypoint.sh", "hadoop"]