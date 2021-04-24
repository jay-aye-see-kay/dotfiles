local vimp = require('vimp')

vim.g.python_host_prog  = '/usr/bin/python2'
vim.g.python3_host_prog  = '/usr/bin/python3'

-- faster window movements
vimp.nnoremap('<c-h>', '<c-w>h')
vimp.nnoremap('<c-j>', '<c-w>j')
vimp.nnoremap('<c-k>', '<c-w>k')
vimp.nnoremap('<c-l>', '<c-w>l')

-- disable insert repeating
vimp.inoremap('<c-a>', '<nop>')

-- disable ex mode
vimp.inoremap('Q', '<nop>')
vimp.inoremap('gQ', '<nop>')

-- make Y behave like C and D
vimp.nnoremap('Y', 'y$')

vim.api.nvim_command[[
  set splitbelow splitright " matches i3 behaviour
  set linebreak " don't break words when wrapping
  set list listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
  set nojoinspaces " Use one space, not two, after punctuation.
]]

-- tabs vs spaces
vim.api.nvim_command[[
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab
"  augroup tabwidths
"    autocmd!
"    autocmd FileType elm,python set tabstop=4
"    autocmd FileType elm,python set softtabstop=4
"    autocmd FileType elm,python set shiftwidth=4
"  augroup END
]]

-- Highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- Use hop for movements
vimp.nnoremap('s', '<cmd>HopChar1<cr>')

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
