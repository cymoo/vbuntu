# Vbuntu

## Intro

Vbuntu is a docker image based on Ubuntu. It contains the necessary utilities and reasonable configurations.

Out of the box, it has:

* Vim:

  * tuned configurations

  * plugins: youcompleteme, nerdtree, gitgutter, onedark theme ...

* Zsh with oh-my-zsh

* Git and .gitconfig

* Python, pip, iPython

* NodeJs (10.x)

* Linux man page

* Build tools: gcc, make, cmake ...

* Common tools: ifconfig, htop, locate, wget, curl ...

## Usage

```bash
docker run -it vbuntu:0.1
```

## FixMe

Vim YCM completion engine won't be triggered unless ycmd server is restarted using :YcmRestartServer command
