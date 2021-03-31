local telescope = require('telescope')

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
telescope.load_extension('z')

map('n', 'sg', '<cmd>Telescope git_files<cr>')
map('n', 'sf', '<cmd>Telescope find_files<cr>')
map('n', 'sa', '<cmd>Telescope live_grep<cr>')
map('n', 'sb', '<cmd>Telescope buffers sort_lastused=true<cr>')
map('n', 'sh', '<cmd>Telescope help_tags<cr>')
map('n', 'sc', '<cmd>Telescope commands<cr>')
map('n', 'so', '<cmd>Telescope oldfiles<cr>')
map('n', 'sl', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
map('n', 'ss', '<cmd>Telescope symbols<cr>')
map('n', 'sw', '<cmd>Telescope spell_suggest<cr>')
map('n', 'sp', [[<cmd>lua require'telescope'.extensions.z.list{ cmd = { vim.o.shell, '-c', 'zoxide query -sl' } }<cr>]])

-- increase oldfile saved ( default is !,'100,<50,s10,h )
vim.api.nvim_command("set shada=!,'1000,<50,s10,h")
