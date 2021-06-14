vim.api.nvim_exec([[
  augroup commitMessageSettings
    autocmd!
    autocmd FileType gitcommit setlocal spell
  augroup end
]], false)

require('gitsigns').setup({
  keymaps = {
    -- Most keymaps moved to keymap_cfg.lua
    noremap = true,
    buffer = true,
    ['n ]h'] = { expr = true, "&diff ? ']h' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
    ['n [h'] = { expr = true, "&diff ? '[h' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
    ['o ah'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
    ['x ah'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
  }
})
