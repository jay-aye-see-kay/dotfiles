let g:ale_disable_lsp = 1

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
inoremap <C-a> <nop>
nnoremap Y y$
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
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'christianchiarulli/nvcode-color-schemes.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'dense-analysis/ale'

Plug 'sirver/UltiSnips'
call plug#end()
" }}}


" {{{ color scheme
let g:nvcode_termcolors=256
colorscheme nvcode " Or whatever colorscheme you make
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif
" }}}


" {{{ specific config bits
lua require('helpers')
lua require('lsp')
lua require('finder')
" }}}


" {{{ treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- Modules and its options go here
  highlight = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  playground = { enable = true },
}
EOF
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
augroup completionsInEveryBuffer
  autocmd!
  autocmd BufEnter * lua require'completion'.on_attach()
augroup end

let g:UltiSnipsExpandTrigger="<c-j>"
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_enable_auto_paren = 1
let g:completion_auto_change_source = 1

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c
" }}}

" {{{ ale
" TODO put this in a file somewhere, but I need linting now
let g:ale_linters = {
\   'javascript': [],
\   'javascriptreact': [],
\   'typescript': [],
\   'typescriptreact': [],
\}
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
\}
let g:ale_fix_on_save = 1
" }}}
