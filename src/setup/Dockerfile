ARG JAVA_VERSION=""

FROM mpolatcan/hadoop:base-java${JAVA_VERSION}

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ARG HADOOP_VERSION="3.3.0"
ARG HADOOP_ZIP_FOLDER_NAME="hadoop-${HADOOP_VERSION}"
ARG HADOOP_DOWNLOAD_LINK="http://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/${HADOOP_ZIP_FOLDER_NAME}.tar.gz"
ARG TEZ_VERSION="0.9.2"
ARG TEZ_ZIP_FOLDER_NAME="tez-${TEZ_VERSION}-hadoop-${HADOOP_VERSION}"
ARG TEZ_DOWNLOAD_LINK="https://github.com/mpolatcan/apache-tez-dist/releases/download/tez-${TEZ_VERSION}-hadoop-${HADOOP_VERSION}/${TEZ_ZIP_FOLDER_NAME}.tar.gz"
ARG AWS_SDK_JAVA_VERSION="1.11.881"
ARG AWS_SDK_JAVA_DOWNLOAD_LINK="https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_JAVA_VERSION}/aws-java-sdk-bundle-${AWS_SDK_JAVA_VERSION}.jar"

ENV HADOOP_VERSION=$HADOOP_VERSION

ADD config_loader.sh ${HDUSER_HOME}/hadoop_config_loader.sh

RUN wget ${HADOOP_DOWNLOAD_LINK} ${TEZ_DOWNLOAD_LINK} ${AWS_SDK_JAVA_DOWNLOAD_LINK} && \
    tar -xvzf ${HADOOP_ZIP_FOLDER_NAME}.tar.gz -C ${HDUSER_HOME} && \
    tar -xvzf ${TEZ_ZIP_FOLDER_NAME}.tar.gz -C ${HDUSER_HOME}/${TEZ_HOME} && \
    mv ${HDUSER_HOME}/${HADOOP_ZIP_FOLDER_NAME}/* ${HADOOP_HOME} && \
    rm ${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-*.jar && \
    mv aws-java-sdk-bundle-${AWS_SDK_JAVA_VERSION}.jar ${HADOOP_HOME}/share/hadoop/tools/lib && \
    chmod +x ${HDUSER_HOME}/hadoop_config_loader.sh && \
    chown -R hduser:hadoop ${HDUSER_HOME} && \
    rm -r ${HDUSER_HOME}/${HADOOP_ZIP_FOLDER_NAME} \
          ${HDUSER_HOME}/${TEZ_ZIP_FOLDER_NAME} \
          ${TEZ_ZIP_FOLDER_NAME}.tar.gz \
          ${HADOOP_ZIP_FOLDER_NAME}.tar.gz

USER hduser
WORKDIR ${HDUSER_HOME}
ENTRYPOINT ["./hadoop_entrypoint.sh", "hadoop"]