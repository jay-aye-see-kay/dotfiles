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

# useful image resize/optimise function
smartresize() {
   mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

# connect clipboard to shell
alias pbc='xclip -i -sel clipboard'
alias pbp='xclip -o -sel clipboard'

# vim
export EDITOR=/usr/bin/vim
alias vi="vim"
alias vimwiki="vim ~/vimwiki/index.md"
alias vimzsh="vim ~/.zshrc"
alias vimrc="vim ~/.vim/vimrc"

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# javascript
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:~/.npm_global/bin

# golang
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# command line basics
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias trash='gio trash'
precmd() { print "" }
