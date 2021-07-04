local nnoremap = require('helpers').nnoremap
local inoremap = require('helpers').inoremap
local source = require('helpers').source

source('file-tree.vim')
source('functions.vim')
source('plugins.vim')
source('search.vim')
source('snippets.vim')
source('terminal.vim')
source('wiki.vim')
source('de-nest.vim')

source('finder.lua')
source('keymap.lua')
source('lsp.lua')
source('treesitter.lua')
source('vcs.lua')

vim.g.python_host_prog  = '/usr/bin/python3'
vim.g.python3_host_prog  = '/usr/bin/python3'

-- faster window movements
nnoremap('<c-h>', '<c-w>h')
nnoremap('<c-j>', '<c-w>j')
nnoremap('<c-k>', '<c-w>k')
nnoremap('<c-l>', '<c-w>l')

-- disable insert repeating
inoremap('<c-a>', '<nop>')

-- disable ex mode
nnoremap('Q', '<nop>')
nnoremap('gQ', '<nop>')

-- make Y behave like C and D
nnoremap('Y', 'y$')

vim.cmd[[ set splitbelow splitright ]]                -- matches i3 behaviour
vim.cmd[[ set linebreak ]]                            -- don't break words when wrapping
vim.cmd[[ set list listchars=tab:»·,trail:·,nbsp:· ]] -- Display extra whitespace
vim.cmd[[ set nojoinspaces ]]                         -- Use one space, not two, after punctuation.

-- Only show cursorline on focued window
vim.api.nvim_exec([[
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
]], false)

-- tabs vs spaces
vim.api.nvim_exec([[
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
]], false)

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Use hop for movements
nnoremap('s', '<cmd>HopChar1<cr>')

-- stuff from https://github.com/mjlbach/defaults.nvim

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Incremental live completion
vim.o.inccommand = "nosplit"

--Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.cmd[[set undofile]]
nnoremap('<leader>u', '<cmd>MundoToggle<cr>')
vim.g.mundo_preview_bottom = 1
vim.g.mundo_width = 40
vim.g.mundo_preview_height = 20

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 100
vim.wo.signcolumn="yes"

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd[[colorscheme nvcode]]

--Set statusbar
vim.g.lightline = {
  colorscheme = 'one';
  active = {
    left = {
      { 'mode', 'paste' },
      { 'cocstatus', 'readonly', 'gitbranch', 'relativepath', 'modified' },
    }
  };
  inactive = {
    left = { { 'relativepath' } }
  };
  component_function = {
    cocstatus = 'coc#status',
    gitbranch = 'FugitiveHead',
  };
}

-- Format on save
vim.api.nvim_exec([[
augroup fmt
  autocmd!
  autocmd BufWritePre * Neoformat
augroup END
]], false)

