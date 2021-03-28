let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog  = '/usr/bin/python3'

" {{{ core set up
let mapleader= " "
set title
set mouse=a
set splitbelow splitright " matches i3 behaviour
set number relativenumber
set showmatch hlsearch
set linebreak " don't break words when wrapping
set hidden " leave buffers without abandoning
set list listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set nojoinspaces " Use one space, not two, after punctuation.
set updatetime=100
set signcolumn=yes
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" disable repeat last insert from insert mode
inoremap <C-a> <nop>
nnoremap Y y$
" disable ex-mode
nnoremap Q <nop>
nnoremap gQ <nop>
" }}}

" tabs vs spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
augroup tabwidths
  autocmd!
  autocmd FileType elm,python set tabstop=4
  autocmd FileType elm,python set softtabstop=4
  autocmd FileType elm,python set shiftwidth=4
augroup END

" {{{ plugins
" install plug.vim on new on new machines
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
source $HOME/.vim/file-tree.vim
source $HOME/.vim/functions.vim
source $HOME/.vim/search.vim
source $HOME/.vim/status-line.vim
source $HOME/.vim/terminal.vim
source $HOME/.vim/vcs.vim
source $HOME/.vim/wiki.vim

" tpope/core stuff
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'christianchiarulli/nvcode-color-schemes.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'
Plug 'sedm0784/vim-resize-mode'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'glepnir/lspsaga.nvim'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css'] }

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'GutenYe/json5.vim'

Plug 'phaazon/hop.nvim'
call plug#end()
" }}}

noremap <leader>h <cmd>HopWord<cr>


" {{{ color scheme
let g:nvcode_termcolors=256
colorscheme nvcode
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif
" }}}


" {{{ meta (config config)
" unload my lua config so it gets sourced
lua package.loaded['init_cfg'] = nill
" load lua config
lua require('init_cfg')

" maps
nnoremap <leader>vr :source $MYVIMRC<cr>
nnoremap <leader>vc :edit $HOME/dotfiles/main/.config/nvim/new-init.vim<cr>
" }}}


" {{{ git
augroup commitMessageSettings
  autocmd!
  autocmd FileType gitcommit setlocal spell
augroup end

let g:gitgutter_map_keys = 0
nnoremap [h :GitGutterPrevHunk<CR>
nnoremap ]h :GitGutterNextHunk<CR>
nnoremap <leader>gz :GitGutterFold<CR>
nnoremap <leader>gp :GitGutterPreviewHunk<CR>

nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap <leader>gs :Gstatus<CR><C-w>T
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gl :Gclog<CR>
nnoremap <leader>gb :Gblame<CR>
" }}}


" {{{ undotree
" TODO add a plugin
if has("persistent_undo")
  set undodir=$HOME/.cache/vim/persistent_undo
  set undofile
endif
" }}}

augroup highlightOnYank
  autocmd!
  autocmd TextYankPost * lua vim.highlight.on_yank{}
augroup end

" {{{ completions
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

inoremap <silent><expr> <CR> compe#confirm('<CR>')

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:vsnip_snippet_dir = "$HOME/.config/nvim/vsnip"

" Avoid showing message extra message when using completion
set shortmess+=c
" }}}

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
" let g:prettier#autoformat_config_present = 1
let g:prettier#quickfix_enabled = 0
