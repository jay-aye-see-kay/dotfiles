# Path to your oh-my-zsh installation.
export ZSH="/home/jack/.oh-my-zsh"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()
source $ZSH/oh-my-zsh.sh

# dotfiles/config management
alias config='/usr/bin/git --git-dir=/home/jack/.cfg/ --work-tree=/home/jack'
export PATH=$PATH:~/bin:~/.local/bin

# useful image resize/optimise function
smartresize() {
   mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

# connect clipboard to shell
# alias pbc='xclip -i -sel clipboard'
# alias pbp='xclip -o -sel clipboard'
alias pbc='wl-copy'
alias pbp='wl-paste'

# vim
export EDITOR=/usr/bin/nvim
alias v="nvim"
alias vimwiki="nvim ~/vimwiki/index.md"
alias zshrc="nvim ~/.zshrc"
alias vimrc="nvim ~/.vim/vimrc"
alias swayrc="nvim ~/.config/sway/config"

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PATH="$PATH:$HOME/.poetry/bin"

# javascript
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:~/.npm_global/bin

# golang
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# command line basics
alias trash='gio trash'
precmd() { print "" }

# fzf and z
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # init
. ~/bin/z.sh # init
unalias z 2> /dev/null # z with no args goes to fzf mode
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

alias sai="sudo apt install"
alias acs="apt search"
alias sizes="du -csh * | sort -h"

# auto start sway after login on tty1
if [ "$(tty)" = "/dev/tty1" ]; then
  export XDG_SESSION_TYPE=wayland
  export MOZ_ENABLE_WAYLAND=1
  export QT_QPA_PLATFORMTHEME="qt5ct"
  exec sway
fi

# rust
export PATH="$HOME/.cargo/bin:$PATH"

