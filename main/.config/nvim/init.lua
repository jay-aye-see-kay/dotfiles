local function sourceVimL(filename)
    vim.cmd('source' .. vim.fn.stdpath('config') .. '/' .. filename)
end

sourceVimL('plugins.vim')
sourceVimL('file-tree.vim')
sourceVimL('functions.vim')
sourceVimL('search.vim')
sourceVimL('snippets.vim')
sourceVimL('terminal.vim')
sourceVimL('wiki.vim')

require('core_cfg')
require('telescope_z')
require('treesitter_cfg')
require('lsp_cfg')
require('finder_cfg')
require('keymap_cfg')
require('vcs_cfg')
