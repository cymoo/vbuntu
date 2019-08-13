FROM ubuntu:18.04

LABEL maintainer "Zhang Jie <me@daydream.site>"

WORKDIR /root

ARG NODE_URL="https://nodejs.org/dist/v10.16.2/node-v10.16.2-linux-x64.tar.xz"

# better and beautiful bat(1)
ARG BAT_URL="https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb"

ARG PYPI_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

ARG SHARED_DIR=/root/work

ARG TZ="Asia/Shanghai"

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG C.UTF-8
ENV TZ ${TZ}

VOLUME [ "${SHARED_DIR}" ]

# replace default sources.list
# COPY config/sources.list /etc/apt/

# Do not exclude man pages & other documentation
RUN rm /etc/dpkg/dpkg.cfg.d/excludes

# Reinstall all currently installed packages in order to get the man pages back
RUN apt-get update \
    && dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall \
    && rm -r /var/lib/apt/lists/*

RUN apt-get update \
    # unminimize, https://github.com/tianon/docker-brew-ubuntu-core/issues/122
    # && yes | unminimize \
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
    && apt-get install -y build-essential make cmake git \
    # zsh
    && apt-get install -y zsh \
    # vim
    && apt-get install -y vim \
    # Python, pip
    && apt-get install -y python python-dev python-pip python3 python3-dev python3-pip \
    # clean cache
    && rm -rf /var/lib/apt/lists/*

# config time zone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

# install bat
RUN wget ${BAT_URL} -O bat.deb \
    && dpkg -i bat.deb \
    && rm bat.deb

# install nodejs
RUN [ "/bin/bash", "-c", "cd /usr/local \ 
    && set -o pipefail \
    && wget -O - ${NODE_URL} | tar xJf - \
    && find . -maxdepth 1 | grep node | xargs -I {} ln -sf {} node" ]

# install oh-my-zsh
COPY config/.bash_profile /root/
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended \
    && echo '. ~/.bash_profile' >> ~/.zshrc \
    && echo '. ~/.bash_profile' >> /root/.bashrc

# install common python modules
RUN pip3 install -i ${PYPI_URL} ipython httpie tldr --no-cache-dir

# config vim
COPY config/.vimrc /root/
# https://superuser.com/questions/873890/can-i-get-vim-to-install-bundles-and-close-in-the-background
RUN ln -sf /usr/local/node/bin/npm /usr/bin/npm \
    && ln -sf /usr/local/node/bin/node /usr/bin/node \
    && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim -E -u NONE -S ~/.vimrc +PlugInstall +qall || true
COPY config/.ycm_extra_conf.py /root/

# # or compile YCM manully: https://github.com/ycm-core/YouCompleteMe
# RUN mkdir ~/ycm_build \
#     && cd ~/ycm_build \ 
#     && cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=/path/to/llvm . ~/.vim/plugged/youcompleteme/third_party/ycmd/cpp \
#     && cmake --build . --target ycm_core \ 
#     && rm -rf ~/ycm_build

# miscs
COPY config/.gitconfig /root/

# create index db for locate(1)
RUN updatedb

ENV TERM=xterm-256color
CMD [ "/usr/bin/zsh"]