export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

if [ -e /usr/local/node ]; then
    export PATH=/usr/local/node/bin:$PATH
fi

if [ -e /usr/local/jdk ]; then
    export PATH=/usr/local/jdk/bin:$PATH
fi

### ALIASES ###

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -lh'
alias l.='ls -d .*'
alias h='history'
alias grep='grep --color=auto'
alias py='python3'
alias py2='python2'
alias https='http --default-scheme=https'
alias psg='ps -ef | grep'

### VARIABLES && ENVIRON  ###

HISTCONTROL=ignoredups
HISTSIZE=32768
HISTFILESIZE=2000000

### FUNCTIONS ###

function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)        tar xjf $1                ;;
            *.tar.gz)         tar xzf $1                ;;
            *.tar.xz)         tar xJf $1                ;;
            *.bz2)            bunzip2 $1                ;;
            *.rar)            rar x $1                  ;;
            *.gz)             gunzip $1                 ;;
            *.tar)            tar xf $1                 ;;
            *.tbz2)           tar xjf $1                ;;
            *.tgz)            tar xzf $1                ;;
            *.zip)            unzip $1                  ;;
            *.Z)              uncompress $1             ;;
            *.7z)             7z x $1                   ;;
            *)                echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


### BASH ###

if [[ -n "${BASH_VERSION}" ]]; then
    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize
    shopt -s histappend

    # Enable programmable completion features
    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi

    export PS1="\u \w >> "
fi

### ZSH ###

if [[ -n "${ZSH_VERSION}" ]]; then
    HIST_STAMPS="yyyy-mm-dd"
    export LANG=zh_CN.UTF-8
fi
