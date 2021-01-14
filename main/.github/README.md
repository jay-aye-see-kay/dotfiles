# My dotfiles/config files

## Usage

`config` is an aliased git command, use it just like `git` eg:
```
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```

## Setting up a new machine

Clone the repo and add the config command to current shell
```
git clone --bare git@github.com:jay-aye-see-kay/dotfiles.git $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Checkout branch, if there are any conflicts (i.e. a .zshrc already exists) the existing files will need to be removed
```
config checkout
```

Turn off show untracked so setup is nicer to use
```
config config --local status.showUntrackedFiles no
```

## Source
This setup is based on: https://www.atlassian.com/git/tutorials/dotfiles
