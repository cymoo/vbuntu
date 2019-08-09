FROM ubuntu:18.04

LABEL maintainer "Zhang Jie <me@daydream.site>"

WORKDIR /root

ARG DEBIAN_FRONTEND=noninteractive

ARG TZ="Asia/Shanghai"
ENV TZ ${TZ}

RUN apt-get update \
    # manual, https://github.com/tianon/docker-brew-ubuntu-core/issues/122
    && echo 'install manual...' \ 
    && yes | unminimize \
    && apt-get install -y man-db \
    # apt-utils
    && echo 'install apt-utils...' \ 
    && apt-get install -y apt-utils \
    # config time zone
    && echo 'config time zone...' \
    && apt-get install -y tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    # downloaders
    && echo 'install downloaders: wget, curl, axel...' \ 
    && apt-get install -y wget curl axel \
    # common tools
    && echo 'install common tools: net-tools, ping, htop, tree, zip, locate...' \
    && apt-get install -y net-tools iputils-ping htop tree zip locate \
    # dev tools
    && echo 'install dev tools: make, cmake, git, sqlite3...' \
    && apt-get install -y make cmake git sqlite3 \
    # zsh
    && echo 'install zsh and oh-my-zsh...' \
    && apt-get install -y zsh \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended \
    # vim
    && apt-get install -y vim \
    # Python
    && echo 'install python3, python3-dev, pip...' \
    && apt-get install -y python3 python3-dev python3-pip \
    # Node.js
    && echo 'install nodejs...' \
    # Java
    # clean cache
    && echo 'clean cache...' \
    && rm -rf /var/lib/apt/lists/*

# common python modules
# RUN pip3 install ipython httpie tldr

# youCompleteMe 
# RUN ...

COPY rc/.gitconfig /root

COPY rc/.vimrc /root

COPY rc/.bash_profile /root
RUN echo '. ~/.bash_profile' >> /root/.bashrc

VOLUME [ "/root/data" ]

CMD [ "/usr/bin/zsh" ]