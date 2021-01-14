" {{{ core set up
let mapleader= " "
set title
set mouse=a
set splitbelow splitright " matches i3 behaviour
set number relativenumber
set updatetime=100
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
inoremap <C-a> <nop>
nnoremap Y y$
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif
" }}}

" {{{ plugins
" install plug.vim on new on new machines
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
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

let g:UltiSnipsExpandTrigger="<c-l>"
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
