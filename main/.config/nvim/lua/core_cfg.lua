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
vim.o.updatetime = 250
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
