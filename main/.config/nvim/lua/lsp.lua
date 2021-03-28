local nvim_lsp = require('lspconfig')
local saga = require('lspsaga')
local lspconfig = require('lspconfig')

saga.init_lsp_saga {
  code_action_prompt = { enable = false }
}

vim.o.completeopt = 'menuone,noselect'

require'compe'.setup({
  enabled = true,
  source = {
    path = true,
    buffer = true,
    nvim_lua = true,
    nvim_lsp = true,
    spell = true,
  },
})

map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
map('n', 'gh', '<cmd>Lspsaga hover_doc<cr>')
map('n', 'gr', '<cmd>Lspsaga lsp_finder<cr>')
map('n', '<leader>rn', '<cmd>Lspsaga rename<cr>')
map('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')
map('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
map('n', '<leader>la', '<cmd>Lspsaga code_action<cr>')

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", { noremap=true })
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", { noremap=true })
  end
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

-- Linting and formatting/fixing on command via efm
local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  formatCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT} --fix-to-stdout",
  formatStdin = true,
}

local languages = {
  typescript = {eslint},
  javascript = {eslint},
  typescriptreact = {eslint},
  javascriptreact = {eslint},
}

-- depends on efm-langserver `pacman -S efm-langserver`
lspconfig.efm.setup {
  root_dir = lspconfig.util.root_pattern("yarn.lock", "lerna.json", ".git"),
  filetypes = vim.tbl_keys(languages),
  init_options = {
    documentFormatting = true,
    codeAction = true
  },
  settings = {
    languages = languages
  },
  on_attach = on_attach
}


function quiet_lsp ()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = false,
      underline = false,
      virtual_text = false,
    }
  )
end

function louden_lsp ()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = true,
      underline = true,
      virtual_text = true,
    }
  )
end

-- HACK: pop into insert mode after to trigger lsp applying settings
map('n', '<leader>lq', '<cmd>call v:lua.quiet_lsp()<cr>i <bs><esc>')
map('n', '<leader>ll', '<cmd>call v:lua.louden_lsp()<cr>i <bs><esc>')
