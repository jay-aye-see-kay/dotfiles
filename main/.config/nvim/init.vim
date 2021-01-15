if has('nvim-0.5')
  source $HOME/.config/nvim/new-init.vim
else
  " fallback to old vimrc
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vim/vimrc
endif
