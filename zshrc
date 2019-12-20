ZSH=/usr/share/oh-my-zsh/
ZSH_THEME="fishy"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
REPORTTIME=10

plugins=(
  git
  httpie
  archlinux
  dirhistory
  sudo
  dotenv
)
source $ZSH/oh-my-zsh.sh
setopt HIST_IGNORE_DUPS

#micro_path=`which micro`
#if [ -x "$micro_path" ] ; then
#  EDITOR="$micro_path"
#else
#  EDITOR=`which vim`
#fi
EDITOR=`which vim`

export EDITOR
export WINEDEBUG=-all
export GOPATH=$HOME/go
export GPG_TTY=`tty`
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$ANDROID_HOME/tools 
export PATH=$PATH:$ANDROID_HOME/platform-tools 
export PATH=$PATH:$HOME/flutter/bin
export PATH=$PATH:$HOME/.pub-cache/bin

alias l='ls'
alias la='ls -A'
alias ls='ls --color=auto'
alias x='xclip -sel clip'
alias vi='vim'
alias sudo='sudo '
# alias nano='micro'
alias serve='(port=$(( 8000+( $(od -An -N2 -i /dev/random) )%(1023+1) )); (xdg-open http://localhost:${port}; python -m http.server ${port}))'
alias да='yes'
alias ъеъ='yay'

if [ $TERM = 'xterm-kitty' ]
then
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

function localhost.run()
{
  local PORT="${1:-8080}"
  ssh -R 80:localhost:$PORT ssh.localhost.run
}
