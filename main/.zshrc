command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# {{{ core
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true"
HISTSIZE=10000000
SAVEHIST=10000000
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  asdf
  fzf
  # requires: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
  zsh-autosuggestions
  # requires: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

export PATH=$PATH:~/bin:~/.local/bin

# connect clipboard to shell
command_exists xclip && {
  alias pbc='xclip -i -sel clipboard'
  alias pbp='xclip -o -sel clipboard'
}
command_exists wl-copy && {
  alias pbc='wl-copy'
  alias pbp='wl-paste'
}
command_exists pbcopy && {
  alias pbc='pbcopy'
  alias pbp='pbpaste'
}

# command line basics
command_exists open || command_exists xdg-open && {
    alias open='xdg-open'
}
command_exists trash || {
  alias trash='gio trash'
}
alias sizes="du -csh * | sort -h"
alias whoslistening="ss -lntu"

# fzf and z
export FZF_DEFAULT_OPTS="--height 40% --reverse --tac"
eval "$(zoxide init zsh)"
function fzf-z {
  _ZO_FZF_OPTS='--height 40% --layout=reverse' zi
  zle accept-line
}
zle -N fzf-z
bindkey '^G' fzf-z

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vim
alias v="$EDITOR"
alias r="ranger"
alias g="git"
alias vw="$EDITOR -c VimwikiIndex"
alias vwt="$EDITOR -c VimwikiMakeDiaryNote"
alias vwy="$EDITOR -c VimwikiMakeYesterdayDiaryNote"
alias zshrc="$EDITOR ~/.zshrc"
alias vimrc="$EDITOR ~/.vim/vimrc"
alias swayrc="$EDITOR ~/.config/sway/config"
alias i3rc="$EDITOR ~/.config/i3/config"
alias kittyrc="$EDITOR ~/.config/kitty/kitty.conf"
# }}} core

# {{{ languages
# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command_exists && {
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
}
export PATH="$PATH:$HOME/.poetry/bin"

# ruby
PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"

# javascript
export PATH=$PATH:~/.npm_global/bin:~/.yarn/bin
export PATH="$HOME/.nodenv/bin:$PATH"
command_exists nodenv && {
  eval "$(nodenv init -)"
}

# golang
GOPATH=$HOME/go/bin
GOROOT=/usr/lib/go
export PATH=$GOPATH:$GOROOT/bin:$PATH

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# android dev stuff
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# }}} languages

# useful image resize/optimise function
# usage: inputfile size outputdir
smartresize() {
   mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

fbook() {
  local LIBRARY="$HOME/Calibre Library"
  zathura "$(find $LIBRARY -type f | fzf)"
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

# ripgrep config
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"

# make shopping list
alias shopping_list='$EDITOR $HOME/Documents/shopping-lists/$(date --iso-8601).md'

# inflate zlib compressed stream from stdin, part of the building git book
alias inflate='ruby -r zlib -e "STDOUT.write Zlib::Inflate.inflate(STDIN.read)"'

command_exists nvim && {
  export MANPAGER='nvim +Man!'
  export MANWIDTH=999
}

command_exists broot && {
  source $HOME/.config/broot/launcher/bash/br
}

# auto start sway after login on tty1
[ "$TTY" = "/dev/tty1" ] && {
  # what a display manager normally sets
  export XDG_SESSION_TYPE=wayland
  export _JAVA_AWT_WM_NONREPARENTING=1
  export MOZ_ENABLE_WAYLAND=1
  exec sway
}

eval "$(starship init zsh)"
