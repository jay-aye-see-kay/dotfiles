local telescope = require('telescope')

telescope.setup {
  defaults = {
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        }
      }
    },
  },
}

telescope.load_extension('fzy_native')

-- increase oldfile saved ( default is !,'100,<50,s10,h )
vim.api.nvim_command("set shada=!,'1000,<50,s10,h")

-- fzf setup
vim.api.nvim_exec([[
  augroup fzfDefaultEscapeBehavior
    autocmd!
    autocmd FileType fzf tnoremap <buffer> <ESC> <ESC>
  augroup END
]], false)
