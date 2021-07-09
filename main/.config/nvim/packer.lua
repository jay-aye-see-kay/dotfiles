local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

require'packer'.startup(function(use)
  use 'famiu/nvim-reload'

  use 'folke/which-key.nvim'

  use 'lambdalisue/fern.vim'
  use 'lambdalisue/fern-git-status.vim'
  use 'lambdalisue/fern-hijack.vim'
  use 'lambdalisue/fern-renderer-nerdfont.vim'
  use 'lambdalisue/nerdfont.vim'

  use 'junegunn/fzf.vim'
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }

  use 'itchyny/lightline.vim'


  use 'vimwiki/vimwiki'

  use 'tpope/vim-abolish'
  use 'tpope/vim-commentary'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-sleuth'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-symbols.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  use 'christianchiarulli/nvcode-color-schemes.vim'

  use 'tpope/vim-fugitive'
  use 'rhysd/git-messenger.vim'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use 'sedm0784/vim-resize-mode'

  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'
  use 'hrsh7th/nvim-compe'
  use 'glepnir/lspsaga.nvim'

  use 'rafcamlet/nvim-luapad'
  use 'godlygeek/tabular'

  use 'sbdchd/neoformat'

  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'rafamadriz/friendly-snippets'

  use 'GutenYe/json5.vim'
  use 'blankname/vim-fish'
  use 'norcalli/nvim-colorizer.lua'

  use 'moll/vim-bbye'
  use 'aymericbeaumet/vim-symlink'
  use 'simnalamburt/vim-mundo'

  use 'phaazon/hop.nvim'
end)
