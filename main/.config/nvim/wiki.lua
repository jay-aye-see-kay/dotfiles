local nnoremap = require('helpers').nnoremap

vim.g.markdown_syntax_conceal = 0
vim.g.markdown_fenced_languages = {
  'bash=sh',
  'c',
  'cpp',
  'css',
  'elm',
  'fish',
  'go',
  'html',
  'java',
  'javascript',
  'js=javascript',
  'json',
  'lua',
  'python',
  'ruby',
  'rust',
  'sh',
  'ts=typescript',
  'typescript',
  'yaml',
}

vim.g.bullets_checkbox_markers = ' .oOx'

vim.g.wiki_root = '~/notes'

-- TODO: create or toggle checkbox
nnoremap('glt', '<cmd>ToggleCheckbox<cr>')

vim.api.nvim_exec([[
augroup naturalMovementInTextFiles
  autocmd!
  autocmd FileType text,markdown nnoremap j gj
  autocmd FileType text,markdown nnoremap k gk
  autocmd FileType text,markdown setlocal wrap
augroup END
]], false)


local function get_logbook_info(days_from_today)
  local date_cmd = "date"
  if days_from_today then
    date_cmd = date_cmd .. " -d '" .. days_from_today .. " day'"
  end

  local path_fmt = "%Y/%m/%d-%A.md"
  local title_fmt = "# %A %d %b %Y"
  local path_cmd = date_cmd .. " +'" .. path_fmt .. "'"
  local title_cmd = date_cmd .. " +'" .. title_fmt .. "'"

  local logbook_base_path = "~/notes/logbook/"
  return {
    path = logbook_base_path .. vim.fn.systemlist(path_cmd)[1],
    title = vim.fn.systemlist(title_cmd)[1],
  }
end

local function template_if_new(file_path, template_str)
  local template_cmd =
    -- if no file then...
    "[ -e " .. file_path .. " ] || "
    -- create one with template_str as contents
    .. "echo '" .. template_str .. "' > " .. file_path
  vim.fn.system(template_cmd)
end

local function open_logbook(days_from_today)
  local logbook = get_logbook_info(days_from_today)
  template_if_new(logbook.path, logbook.title)
  vim.cmd("edit " .. logbook.path)
end

function LogbookToday()     open_logbook()   end
function LogbookYesterday() open_logbook(-1) end
function LogbookTomorrow()  open_logbook(1)  end

vim.cmd[[command LogbookToday :call v:lua.LogbookToday()]]
vim.cmd[[command LogbookYesterday :call v:lua.LogbookYesterday()]]
vim.cmd[[command LogbookTomorrow :call v:lua.LogbookTomorrow()]]
