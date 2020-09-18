FROM dorowu/ubuntu-desktop-lxde-vnc:bionic-lxqt

ARG VERSION=1.14.2

MAINTAINER Truong Nghiem <truong.nghiem@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# OpenModelica packages
RUN apt-get update && apt-get upgrade -qy && apt-get dist-upgrade -qy\
    && apt-get install -qy gnupg wget ca-certificates apt-transport-https \
    && echo "deb https://build.openmodelica.org/omc/builds/linux/releases/$VERSION/ `cat /etc/lsb-release | grep CODENAME | cut -d= -f2` release" > /etc/apt/sources.list.d/openmodelica.list \
    && wget https://build.openmodelica.org/apt/openmodelica.asc -O- | apt-key add - \
    && apt-get update && apt-get upgrade && apt-get dist-upgrade \
    && apt-get install --no-install-recommends -qy omc openmodelica \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY image /

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/startup.sh"]
