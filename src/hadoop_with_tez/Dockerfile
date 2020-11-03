ARG JAVA_VERSION=""
ARG HADOOP_VERSION=""
FROM mpolatcan/hadoop:${HADOOP_VERSION}-java${JAVA_VERSION}

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ARG HADOOP_VERSION=""
ARG TEZ_VERSION="0.9.2"
ARG TEZ_ZIP_FOLDER_NAME="tez-${TEZ_VERSION}-hadoop-${HADOOP_VERSION}"
ARG TEZ_DOWNLOAD_LINK="https://github.com/mpolatcan/apache-tez-dist/releases/download/tez-${TEZ_VERSION}-hadoop-${HADOOP_VERSION}/${TEZ_ZIP_FOLDER_NAME}.tar.gz"

USER root
RUN wget ${TEZ_DOWNLOAD_LINK} && \
    tar -xvzf ${TEZ_ZIP_FOLDER_NAME}.tar.gz -C ${TEZ_HOME} && \
    cd ${TEZ_HOME} && tar -czvf tez.tar.gz * && cd .. && \
    chown -R hduser:hadoop ${HDUSER_HOME} && \
    rm -r ${TEZ_ZIP_FOLDER_NAME}.tar.gz

USER hduser
ENTRYPOINT ["./hadoop_entrypoint.sh", "hadoop"]