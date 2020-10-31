FROM tomcat

MAINTAINER Mutlu Polatcan <mutlupolatcan@gmail.com>

ARG TEZ_UI_VERSION="0.9.2"
ARG TEZ_UI_DOWNLOAD_LINK="https://repository.apache.org/content/repositories/releases/org/apache/tez/tez-ui/${TEZ_UI_VERSION}/tez-ui-${TEZ_UI_VERSION}.war"

ADD entrypoint.sh .

RUN wget ${TEZ_UI_DOWNLOAD_LINK} && \
    unzip tez-ui-${TEZ_UI_VERSION}.war -d webapps/tez && \
    chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]