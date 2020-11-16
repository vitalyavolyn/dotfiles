ZSH=/usr/share/oh-my-zsh

if [ ! -d "$ZSH" ]; then
  # oh-my-zsh is installed locally on Ubuntu
  ZSH=$HOME/.oh-my-zsh
fi

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
  httpie
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
alias x='xclip -sel clip'
alias vi='vim'
alias mnt="sudo mount -o uid=1000,gid=1000"

if [ $TERM = 'xterm-kitty' ]; then
  alias icat="kitty +kitten icat"
fi

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

if ! type "pacman" > /dev/null; then
  # Ubuntu
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # zsh-autosuggestions are not available for armv7l. cool.
  if [ -d /usr/share/zsh-autosuggestions ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  else
    source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi
else
  # Arch
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/doc/pkgfile/command-not-found.zsh
fi

function swap()
{
  local TMPFILE=tmp.$$
  mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE $2
}

bindkey '^H' backward-kill-word
