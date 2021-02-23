local nvim_lsp = require('lspconfig')
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
local saga = require 'lspsaga'

saga.init_lsp_saga()

map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
map('n', 'gh', '<cmd>Lspsaga hover_doc<cr>')
map('n', 'gr', '<cmd>Lspsaga lsp_finder<cr>')
map('n', '<leader>rn', '<cmd>Lspsaga rename<cr>')
map('n', '[g', '<cmd>Lspsaga diagnostic_jump_prev<cr>')
map('n', ']g', '<cmd>Lspsaga diagnostic_jump_next<cr>')
map('n', '<leader>la', '<cmd>Lspsaga code_action<cr>')

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local servers = {
  "bashls", -- `yarn global add bash-language-server`
  "clangd", -- should be installed
  "cssls", -- `yarn global add vscode-css-languageserver-bin`
  "dockerls", -- `yarn global add dockerfile-language-server-nodejs`
  "pyls", -- `pacman -S python-language-server`
  "rust_analyzer", -- `pacman -S rust-analyzer`
  "tsserver", -- `yarn global add typescript typescript-language-server`
  "vimls", -- `yarn global add vim-language-server`
  "yamlls", -- `yarn global add yaml-language-server`
  -- TODO lua lsp
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
