local function map(...) vim.api.nvim_set_keymap(...) end

require('telescope').setup{
  defaults = {
    prompt_position = "top",
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

  }
}

local opts = { noremap=true, silent=false }
map('n', 'sf', '<cmd>Telescope find_files<cr>', opts)
map('n', 'sg', '<cmd>Telescope live_grep<cr>', opts)
map('n', 'sb', '<cmd>Telescope buffers<cr>', opts)
map('n', 'sh', '<cmd>Telescope help_tags<cr>', opts)
map('n', 'sc', '<cmd>Telescope commands<cr>', opts)
map('n', 'so', '<cmd>Telescope oldfiles<cr>', opts)
map('n', 'sl', '<cmd>Telescope current_buffer_fuzzy_find<cr>', opts)

-- increase oldfile saved ( default is !,'100,<50,s10,h )
vim.api.nvim_command("set shada=!,'1000,<50,s10,h")
