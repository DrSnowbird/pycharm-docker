FROM openkbs/jdk-mvn-py3-x11

MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

ARG INSTALL_DIR=${INSTALL_DIR:-/opt}

ARG PRODUCT_VER=${PRODUCT_VER:-2019.2}

ARG PRODUCT_NAME=pycharm-community
ARG PRODUCT_EXE_NAME=pycharm.sh
ARG PRODUCT_URL_ROOT=https://download.jetbrains.com/python
##
ARG PRODUCT_TGZ=${PRODUCT_TGZ:-${PRODUCT_NAME}-${PRODUCT_VER}.tar.gz}
ARG PRODUCT_URL=${PRODUCT_URL:-${PRODUCT_URL_ROOT}/${PRODUCT_TGZ}}
ARG PRODUCT_HOME=${PRODUCT_HOME:-${INSTALL_DIR}/${PRODUCT_NAME}-${PRODUCT_VER}}
ARG PRODUCT_HOME_LINK=${PRODUCT_LINK:-${INSTALL_DIR}/${PRODUCT_NAME}}
ARG PRODUCT_EXE=${PRODUCT_HOME}/bin/${PRODUCT_EXE_NAME}

############################# 
#### ---- Install Target ----
############################# 
WORKDIR ${INSTALL_DIR}

RUN sudo wget -cq ${PRODUCT_URL} && \
    sudo tar xvf ${PRODUCT_TGZ} && \
    sudo rm ${PRODUCT_TGZ}

RUN sudo ln -s ${PRODUCT_EXE} /usr/bin/$(basename ${PRODUCT_EXE}) && \
    ls -al ${PRODUCT_HOME} && \
    sudo mkdir -p /workspace

## -- PyCharm related files ---
# drwxr-xr-x 4 root root 4096 Feb  1 18:00 .PyCharmCE2019.2
# drwxr-xr-x 4 root root 4096 Feb  1 18:00 .java
# -rw-r--r-- 1 root root  148 Aug 17  2015 .profile
# drwxr-xr-x 3 root root 4096 Feb  1 18:00 PycharmProjects

## ---- user: developer ----
ENV USER_NAME=developer
ENV HOME=/home/${USER_NAME}

## ---- update pip3 ----
RUN sudo chown -R ${USER_NAME}:${USER_NAME} $HOME && \
    sudo -H pip3 install --upgrade pip && \
    sudo -H pip3 install geopy

VOLUME "${HOME}/data"
VOLUME "${HOME}/workspace"

WORKDIR ${HOME}/workspace
USER "${USER_NAME}"
ENV PRODUCT_EXE=${PRODUCT_EXE}
ENTRYPOINT "${PRODUCT_EXE}"

#CMD ["/bin/bash"]
