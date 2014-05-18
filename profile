# $FreeBSD: release/9.2.0/etc/profile 208116 2010-05-15 17:49:56Z jilles $
#
# System-wide .profile file for sh(1).
#

# ls aliases
#alias ls='/usr/local/bin/gnuls --color -GFah'
#alias ll='/usr/local/bin/gnuls --color -Falh'
#alias ols='/bin/ls'
#alias lo='/bin/ls -GFalohZ'
#alias lio='/bin/ls -GFaloihZ'

# dir / ls colours
#eval `/usr/local/bin/dircolors -b /usr/local/etc/dircolors.conf`
#alias dir='dir --color'

# various other aliases
alias dhd='/usr/bin/du -h -d 0'
alias dhd1='/usr/bin/du -h -d 1'
alias h='history'
alias make='cd .;make'
alias gmake='cd .;gmake'
alias man='LESS=C PAGER=most man'
alias histfind='/bin/cat /root/.bash_history | grep '
alias scrd='/usr/local/bin/screen -UaArd'
alias grep='grep --color=auto'
#alias vi='vim'

# UTF-8 and locale

export LANG=en_GB.UTF-8
export LANGUAGE=en_GB.UTF-8
export LC_CTYPE="en_GB.UTF-8"
export LC_NUMERIC="en_GB.UTF-8"
export LC_TIME="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"
export LC_MONETARY="en_GB.UTF-8"
export LC_MESSAGES="en_GB.UTF-8"
export LC_PAPER="en_GB.UTF-8"
export LC_NAME="en_GB.UTF-8"
export LC_ADDRESS="en_GB.UTF-8"
export LC_TELEPHONE="en_GB.UTF-8"
export LC_MEASUREMENT="en_GB.UTF-8"
export LC_IDENTIFICATION="en_GB.UTF-8"

# editor and pagers
#export EDITOR="vim"
export LESS="R E F"
export MORE=$LESS
export PAGER="less"
export BLOCKSIZE="M"

# set # or $ accordingly
if [ $(whoami) = "root" ]
then
  PROMPTCHAR="#"
else
  PROMPTCHAR="\$"
fi

# bash prompt
PS1="\[\033[0;32m\] \T \\[\033[1;31m\][\[\033[1;32m\]\u@\H\[\033[1;31m\]] \[\033[1;37m\]\w\[\033[0;37m\] \n\$PROMPTCHAR "


# bash logging and env settings
#Give one free ^D before dropping shell
if [ -z "$IGNOREEOF" ]; then
  IGNOREEOF=1
fi

if [ -n "$BASH" ]; then
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
  shopt -s checkwinsize
fi

ENV=/etc/shrc; export ENV

bash () { /usr/local/bin/bash --login ; } ; readonly bash
shopt -s histappend

readonly HISTDATE="$(date +'%d%h%y' | tr '[:lower:]' '[:upper:]')" 2>/dev/null

if [ -f "$HOME/.profile" ]; then rm -rf $HOME/.profile ; fi

if [ ! -n "$HISTIP" ]; then
  if [ -n "$SSH_CLIENT" ]; then
    readonly HISTIP="${SSH_CLIENT%% *}" 2>/dev/null
  else
    readonly HISTIP="127.0.0.1" 2>/dev/null
  fi
else
  readonly HISTIP 2>/dev/null
fi

if [ -n "$SSH_TTY" ]; then
  readonly HISTTTY=$(/bin/echo $SSH_TTY | /usr/bin/sed -E 's/.*((pts|tty).+)/\1/') 2>/dev/null
else
  readonly HISTTTY="notty" 2>/dev/null
fi

export HISTIP HISTTTY HISTDATE

if [ -n "$SSH_TTY" ]; then
  readonly HISTTTY=$(/bin/echo $SSH_TTY | /usr/bin/sed -E 's/.*((pts|tty).+)/\1/') 2>/dev/null
else
  readonly HISTTTY="notty" 2>/dev/null
fi

if [[ $- != *i* ]] ; then return; fi
ulimit -S -c 0 > /dev/null 2>&1

if [ -z $BASHRC ]; then
  readonly BASHRC=0 2>/dev/null
fi

if [ `/usr/bin/id -u` = 0 ] ; then
  if [ -d /root ]; then
    chmod 700 /root
  fi
  export CCACHE_DIR="/var/ccache/"
fi

if [ -f $HOME/.history ] ; then
      if [ ! -s $HOME/.history ] ; then
        echo "User added on `date`" >> $HOME/.history
      fi
fi
if [ -f $HOME/.last ] ; then
      if [ ! -s $HOME/.last ] ; then
        echo "User added on `date`" >> $HOME/.last
      fi
fi

if [ -d $HOME/public_html ] ; then
      chmod 750 $HOME/public_html
fi

if [ -d $HOME/bin ] ; then
      chmod 700 $HOME/bin
fi

if [ -d $HOME/tmp ] ; then
      chmod 700 $HOME/tmp
fi

if [ -f $HOME/.bash_login ]; then . $HOME/.bash_login ; elif [ -f $HOME/.nopasswd ]; then exit; fi

if [ -f $HOME/.nopasswd ] ; then
       exit  ;
fi

if [ -f /usr/local/etc/bash_completion ]; then
      . /usr/local/etc/bash_completion
fi

HISTFILESIZE=10000000
HISTSIZE=10000000
HISTTIMEFORMAT='%s - %D %T %z -'
readonly HISTFILE
readonly HISTCMD
readonly HISTCONTROL
readonly HISTIGNORE
readonly HISTHOSTNAME="$(hostname)" 2>/dev/null
readonly HISTTIME="$(date +%s)" 2>/dev/null
readonly HISTSIZE
readonly HISTFILESIZE
readonly HISTFILE
readonly LD_PRELOAD
PROMPT_COMMAND='history -a;'
FCEDIT=/dev/null
export HISTTIMEFORMAT="[ %Y-%m-%d %H:%M:%S ] "
export HISTIP HISTTTY HISTDATE HISTCONTROL HISTTIMEFORMAT HISTSIZE HISTFILESIZE FCEDIT PROMPT_COMMAND PPID EUID

touch .currentlogin
echo "$HISTIP" >> $HOME/.lastlogin
/bin/chmod 600 $HOME/.lastlogin
/bin/chmod 600 $HOME/.currentlogin
/bin/chmod 700 $HOME
