# Jbuntu

## Intro

Jbuntu is a docker image based on Ubuntu. It contains the necessary utilities and reasonable configurations.

Out of the box, it has:

* Vim:

  * tuned configurations

  * plugins: youcompleteme, nerdtree, gitgutter, onedark theme ...

* Zsh with oh-my-zsh

* Git and .gitconfig

* Python, pip, iPython

* NodeJs (10.x)

* Java (12.x)

* Linux man page

* Build tools: gcc, make, cmake ...

* Common tools: ifconfig, htop, locate, wget, curl ...

## Usage

```bash
docker run -it jbuntu:0.1
```
