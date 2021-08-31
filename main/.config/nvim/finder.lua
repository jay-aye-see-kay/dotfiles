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
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
}

telescope.load_extension('fzf')

-- fzf setup
vim.api.nvim_exec([[
  augroup fzfDefaultEscapeBehavior
    autocmd!
    autocmd FileType fzf tnoremap <buffer> <ESC> <ESC>
  augroup END
]], false)
