local lspconfig = require('lspconfig')
local saga = require('lspsaga')

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
    vsnip = true,
  },
})

require'which-key'.register({
  [']g'] =  {'<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', 'next lsp diagnostic'},
  ['[g'] =  {'<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', 'next lsp diagnostic'},
  g = {
    d = {'<cmd>Telescope lsp_definitions<cr>', 'lsp jump to defintion'},
    y = {'<cmd>lua vim.lsp.buf.type_definition()<cr>', 'lsp jump to type def'},
    h = {'<cmd>Lspsaga hover_doc<cr>', 'lsp hover info'},
    r = {'<cmd>Telescope lsp_references<cr>', 'lsp jump to reference(s)'},
  },
})

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
}
for _, lsp in ipairs(servers) do
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
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


function Quiet_lsp ()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = false,
      virtual_text = false,
    }
  )
end

function Louden_lsp ()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = true,
      underline = true,
      virtual_text = true,
    }
  )
end

-- {{{ lua lang server set up
-- `yay lua-language-server`
local sumneko_root_path = '/usr/bin'
local sumneko_binary = sumneko_root_path..'/lua-language-server'
require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
-- }}}
