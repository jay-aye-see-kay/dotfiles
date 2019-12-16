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
export FZF_DEFAULT_OPTS="--height 40% --reverse --tac"
function fzf-z {
  cd "$(_z -l 2>&1 | fzf --nth 2.. +s | sed 's/^[0-9,.]* *//')"
  zle accept-line
}
zle -N fzf-z
bindkey '^G' fzf-z

# vim
export EDITOR=/usr/bin/nvim
alias v="nvim"
alias r="ranger"
alias g="git"
alias vimwiki="nvim ~/vimwiki/index.md"
alias zshrc="nvim ~/.zshrc"
alias vimrc="nvim ~/.vim/vimrc"
alias swayrc="nvim ~/.config/sway/config"
alias kittyrc="nvim ~/.config/kitty/kitty.conf"
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
# usage: inputfile size outputdir
smartresize() {
   mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}


# auto start sway after login on tty1
if [ "$(tty)" = "/dev/tty1" ]; then
  # what a display manager normally sets
  export XDG_SESSION_TYPE=wayland

  export _JAVA_AWT_WM_NONREPARENTING=1
  export MOZ_ENABLE_WAYLAND=1

  exec sway
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# fco - checkout git branch/tag
fco() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

fman() {
  man -k . | fzf --height 100% --preview-window wrap --preview "echo {} | awk '{print $1}' | xargs -r man" | awk '{print $1}' | xargs -r man
}

# make fzf history search unique by overriding this function and changing line 4
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 | sort -r -k 2 | uniq -f 1 | sort -n |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}

