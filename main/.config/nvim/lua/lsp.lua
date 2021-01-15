local nvim_lsp = require('lspconfig')
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }

map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>')
map('n', 'gr', '<cmd>Telescope lsp_references()<cr>')
map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
map('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')
map('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
map('n', '<leader>la', '<cmd>Telescope lsp_code_actions<cr>')

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local servers = {
  "bashls", -- `yarn global add bash-language-server`
  "clangd", -- should be installed
  "cssls", -- `yarn global add vscode-css-languageserver-bin`
  "dockerls", -- `yarn global add dockerfile-language-server-nodejs`
  "rust_analyzer", -- `pacman -S rust-analyzer`
  "tsserver", -- `yarn global add typescript typescript-language-server`
  "vimls", -- `yarn global add vim-language-server`
  "yamlls", -- `yarn global add yaml-language-server`
  -- TODO lua lsp
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
