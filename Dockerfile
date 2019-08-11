FROM ubuntu:18.04

LABEL maintainer "Zhang Jie <me@daydream.site>"

WORKDIR /root

ARG NODE_URL="https://nodejs.org/dist/v10.16.2/node-v10.16.2-linux-x64.tar.xz"

ARG JDK_URL="https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz"

ARG SHARED_DIR=/root/share

ARG DEBIAN_FRONTEND=noninteractive

ARG TZ="Asia/Shanghai"

ENV LANG C.UTF-8
ENV TZ ${TZ}

RUN apt-get update \
    # unminimize, https://github.com/tianon/docker-brew-ubuntu-core/issues/122
    && yes | unminimize \
    # RTFM
    && apt-get install -y man-db \
    # apt-utils
    && apt-get install -y apt-utils \
    # tzdata 
    && apt-get install -y tzdata \
    # downloaders
    && apt-get install -y wget curl axel \
    # common tools
    && apt-get install -y net-tools iputils-ping htop tree zip locate \
    # dev tools
    && apt-get install -y build-essential make cmake git sqlite3 \
    # zsh
    && apt-get install -y zsh \
    # vim
    && apt-get install -y vim \
    # Python, pip
    && apt-get install -y python python-dev python-pip python3 python3-dev python3-pip \
    # clean cache
    && rm -rf /var/lib/apt/lists/*

# copy config files
COPY config/.gitconfig ~
COPY config/.bash_profile ~ 
RUN echo '. ~/.bash_profile' >> ~/.bashrc

# config time zone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended \
    && echo '. ~/.bash_profile' >> ~/.zshrc

# install nodejs manually
RUN ["/bin/bash", "-c", "cd /usr/local \ 
    && set -o pipefail \
    && wget -O - ${NODE_URL} | tar xJf - \
    && find . -maxdepth 1 | grep node | xargs -I {} ln -sf {} node"]

# install java manually
RUN ["/bin/bash", "-c", "cd /usr/local \ 
    && set -o pipefail \
    && wget -O - ${JDK_URL} | tar xzf - \
    && find . -maxdepth 1 | grep jdk | xargs -I {} ln -sf {} jdk"]

# install python modules
RUN pip3 install ipython httpie tldr

# config vim
COPY config/.vimrc ~
# https://superuser.com/questions/873890/can-i-get-vim-to-install-bundles-and-close-in-the-background
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim -E -u NONE -S ~/.vimrc +PlugInstall +qall || true
COPY config/.ycm_extra_conf.py ~/.vim

# # compile YCM manully: https://github.com/ycm-core/YouCompleteMe
# RUN mkdir ~/ycm_build \
#     && cd ~/ycm_build \ 
#     && cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=/path/to/llvm . ~/.vim/plugged/youcompleteme/third_party/ycmd/cpp \
#     && cmake --build . --target ycm_core \ 
#     && rm -rf ~/ycm_build

VOLUME [ "${SHARED_DIR}" ]

ENV TERM=xterm-256color

CMD [ "/usr/bin/zsh" ]