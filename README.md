# Vbuntu

## Intro

Vbuntu is a docker image based on Ubuntu. It contains the necessary utilities and reasonable configurations.

Out of the box, it has:

* Vim:

  * tuned configurations

  * plugins: youcompleteme, nerdtree, gitgutter, onedark theme ...

* Zsh with oh-my-zsh

* Git

* Python(2.7 and 3.6), pip, iPython

* NodeJs (10.x)

* Linux man pages

* Build tools: gcc, make, cmake ...

* Common tools: ifconfig, htop, locate, wget, curl, bat...

## Usage

```bash
docker run -it vbuntu
```

## Freq

### Why vim completion does not work

This may happen rarely and can be fixed easily by using command: YcmRestartServer
