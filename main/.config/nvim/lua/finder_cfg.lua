local telescope = require('telescope')
local vimp = require('vimp')

telescope.setup {
  defaults = {
    prompt_position = "top",
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  },
}

telescope.load_extension('fzy_native')
Telescope_z = require('telescope_z')

vimp.nnoremap('sg', '<cmd>Telescope git_files<cr>')
vimp.nnoremap('sf', '<cmd>Telescope find_files<cr>')
vimp.nnoremap('sa', '<cmd>Telescope live_grep<cr>')
vimp.nnoremap('sb', '<cmd>Telescope buffers sort_lastused=true<cr>')
vimp.nnoremap('sh', '<cmd>Telescope help_tags<cr>')
vimp.nnoremap('sc', '<cmd>Telescope commands<cr>')
vimp.nnoremap('so', '<cmd>Telescope oldfiles<cr>')
vimp.nnoremap('sl', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
vimp.nnoremap('ss', '<cmd>Telescope symbols<cr>')
vimp.nnoremap('sw', '<cmd>Telescope spell_suggest<cr>')
vimp.nnoremap('sp', function()
  require'telescope_z'.list()
end)
vimp.nnoremap('sn', function()
  require"telescope.builtin".grep_string{ cwd = "~/Documents/vimwiki" }
end)

-- increase oldfile saved ( default is !,'100,<50,s10,h )
vim.api.nvim_command("set shada=!,'1000,<50,s10,h")
