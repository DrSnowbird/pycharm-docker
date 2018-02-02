FROM openkbs/jdk-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

ARG INSTALL_DIR=${INSTALL_DIR:-/opt}

ARG TARGET_VER=${TARGET_VER:-2017.3.3}

ARG TARGET_TGZ=${TARGET_TGZ:-pycharm-community-${TARGET_VER}.tar.gz}
ARG TARGET_URL=${TARGET_URL:-https://download.jetbrains.com/python/${TARGET_TGZ}}

ARG TARGET_HOME=${TARGET_HOME:-${INSTALL_DIR}/pycharm-community-${TARGET_VER}}

ARG TARGET_EXE=${TARGET_HOME}/bin/pycharm.sh

############################# 
#### ---- Install Target ----
############################# 
WORKDIR ${INSTALL_DIR}

RUN wget -c ${TARGET_URL} && \
    tar xvf ${TARGET_TGZ} && \
    rm ${TARGET_TGZ}
    
RUN ln -s ${TARGET_EXE} /usr/bin/$(basename ${TARGET_EXE}) && \
    ls -al ${TARGET_HOME} && \
    mkdir -p /workspace

# drwxr-xr-x 4 root root 4096 Feb  1 18:00 .PyCharmCE2017.3
# drwxr-xr-x 4 root root 4096 Feb  1 18:00 .java
# -rw-r--r-- 1 root root  148 Aug 17  2015 .profile
# drwxr-xr-x 3 root root 4096 Feb  1 18:00 PycharmProjects

VOLUME "/data"
VOLUME "/workspace"

WORKDIR /workspace

USER "developer"

ENV TARGET_EXE=${TARGET_HOME}/bin/pycharm.sh

ENTRYPOINT "${TARGET_EXE}"

#CMD ["/usr/bin/firefox"]
