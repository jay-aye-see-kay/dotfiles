vim.cmd('source ./plugins.vim')

vim.cmd('source ./file-tree.vim')
vim.cmd('source ./functions.vim')
vim.cmd('source ./search.vim')
vim.cmd('source ./terminal.vim')
vim.cmd('source ./vcs.vim')
vim.cmd('source ./wiki.vim')

require('lua/core_cfg')
require('lua/telescope_z')
require('lua/treesitter_cfg')
require('lua/lsp_cfg')
require('lua/finder_cfg')
