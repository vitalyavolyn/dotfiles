ZSH=/usr/share/oh-my-zsh
ZSH_THEME="fishy"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
REPORTTIME=10 # shows command execution time after N seconds

plugins=(
  git
  httpie
  archlinux
  dirhistory
  sudo
  dotenv
  yarn
)

source $ZSH/oh-my-zsh.sh
setopt HIST_IGNORE_DUPS

export EDITOR=`which vim`
export WINEDEBUG=-all
export GOPATH=$HOME/go
export GPG_TTY=`tty`
export CHROME_EXECUTABLE=`which google-chrome-stable` # for flutter

export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/flutter/bin
export PATH=$PATH:$HOME/.pub-cache/bin
export PATH=$PATH:$HOME/.yarn/bin

alias l='ls'
alias la='ls -A'
alias ls='ls --color=auto'
alias x='xclip -sel clip'
alias vi='vim'
alias sudo='sudo '
alias mnt="sudo mount -o uid=1000,gid=1000"

if [ $TERM = 'xterm-kitty' ]; then
  alias icat="kitty +kitten icat"
fi

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/doc/pkgfile/command-not-found.zsh

function swap()
{
  local TMPFILE=tmp.$$
  mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE $2
}

bindkey '^H' backward-kill-word
