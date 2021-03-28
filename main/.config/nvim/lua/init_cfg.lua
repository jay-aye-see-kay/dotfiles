config_files = {
  'helpers_cfg',
  'finder_cfg',
  'lsp_cfg',
  'treesitter_cfg'
}

for _, v in pairs(config_files) do
  package.loaded[v] = nil
  require(v)
end
