# {{{ core
# Path to your oh-my-zsh installation.
export ZSH="/home/jack/.oh-my-zsh"
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
DISABLE_AUTO_UPDATE="true"
ZSH_THEME="robbyrussell"
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  fzf
  z
)
source $ZSH/oh-my-zsh.sh

# dotfiles/config management
alias config='/usr/bin/git --git-dir=/home/jack/.cfg/ --work-tree=/home/jack'
export PATH=$PATH:~/bin:~/.local/bin

# connect clipboard to shell
# alias pbc='xclip -i -sel clipboard'
# alias pbp='xclip -o -sel clipboard'
alias pbc='wl-copy'
alias pbp='wl-paste'

# command line basics
precmd() { print "" }
alias trash='gio trash'
alias sizes="du -csh * | sort -h"

# fzf and z
function fzf-z {
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  zle accept-line
}
zle -N fzf-z
bindkey '^G' fzf-z

# vim
export EDITOR=/usr/bin/nvim
alias v="nvim"
alias vimwiki="nvim ~/vimwiki/index.md"
alias zshrc="nvim ~/.zshrc"
alias vimrc="nvim ~/.vim/vimrc"
alias swayrc="nvim ~/.config/sway/config"
# }}} core

# {{{ languages
# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PATH="$PATH:$HOME/.poetry/bin"

# javascript
export PATH=$PATH:~/.npm_global/bin:~/.yarn/bin
export NVM_DIR="$HOME/.nvm"
# stop nvm slowing shell launch by 500ms https://github.com/nvm-sh/nvm/issues/1277#issuecomment-470459658
nvm() {
    echo "Lazy loading nvm..."
    unfunction "$0" # Remove nvm function
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" # Load nvm
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion" # Load bash_completion
    $0 "$@" # Call nvm
}

# golang
GOPATH=$HOME/go/bin
GOROOT=/usr/lib/go
export PATH=$GOPATH:$GOROOT/bin:$PATH

# rust
export PATH="$HOME/.cargo/bin:$PATH"
# }}} languages

# allows ctrl+shift+t to open new tab same dir, from termite readme
if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

# arch stuff from the zsh plugin
function paclist() {
  # Source: https://bbs.archlinux.org/viewtopic.php?id=93683
  LC_ALL=C pacman -Qei $(pacman -Qu | cut -d " " -f 1) | \
    awk 'BEGIN {FS=":"} /^Name/{printf("\033[1;36m%s\033[1;37m", $2)} /^Description/{print $2}'
}
if (( $+commands[xdg-open] )); then
  function pacweb() {
    pkg="$1"
    infos="$(pacman -Si "$pkg")"
    if [[ -z "$infos" ]]; then
      return
    fi
    repo="$(grep '^Repo' <<< "$infos" | grep -oP '[^ ]+$')"
    arch="$(grep '^Arch' <<< "$infos" | grep -oP '[^ ]+$')"
    xdg-open "https://www.archlinux.org/packages/$repo/$arch/$pkg/" &>/dev/null
  }
fi

# useful image resize/optimise function
smartresize() {
   mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}


# auto start sway after login on tty1
if [ "$(tty)" = "/dev/tty1" ]; then
  export XDG_SESSION_TYPE=wayland
  export _JAVA_AWT_WM_NONREPARENTING=1
  # export MOZ_ENABLE_WAYLAND=1
  export QT_QPA_PLATFORMTHEME="qt5ct"
  exec sway
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
