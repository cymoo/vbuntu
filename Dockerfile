FROM ubuntu:18.04

LABEL maintainer "Zhang Jie <me@daydream.site>"

WORKDIR /root

ARG NODE_VERSION="v10.16.2"
ARG JDK_VERSION="12.0.2"
ARG JDK_URL="https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz"

ARG SHARED_DIR=/root/share

ARG DEBIAN_FRONTEND=noninteractive

ARG TZ="Asia/Shanghai"
ENV TZ ${TZ}

RUN apt-get update \
    # unminimize, https://github.com/tianon/docker-brew-ubuntu-core/issues/122
    && yes | unminimize \
    && apt-get install -y man-db \
    # apt-utils
    && apt-get install -y apt-utils \
    # config time zone
    && apt-get install -y tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    # downloaders
    && apt-get install -y wget curl axel \
    # common tools
    && apt-get install -y net-tools iputils-ping htop tree zip locate \
    # dev tools
    && apt-get install -y make cmake git sqlite3 \
    # zsh, oh-my-zsh
    && apt-get install -y zsh \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended \
    # vim
    && apt-get install -y vim \
    # Python, pip
    && apt-get install -y python3 python3-dev python3-pip \
    # clean cache
    && rm -rf /var/lib/apt/lists/*

# install nodejs manually
RUN cd /usr/local \
    && wget -O - https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz | tar xJf - \
    && ln -sf node-${NODE_VERSION}-linux-x64 node

# install java manually
RUN cd /usr/local \
    && wget -O - ${JDK_URL} | tar xzf - \
    && ln -sf jdk-${JDK_VERSION} jdk

# common python modules
RUN pip3 install ipython httpie tldr

# config vim
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


COPY rc/.gitconfig /root

COPY rc/.vimrc /root

COPY rc/.bash_profile /root
RUN echo '. ~/.bash_profile' >> /root/.bashrc
RUN echo '. ~/.bash_profile' >> /root/.zshrc

VOLUME [ "${SHARED_DIR}" ]

CMD [ "/usr/bin/zsh" ]