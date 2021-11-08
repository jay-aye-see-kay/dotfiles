-- helpers {{{

-- usage:
-- augroup('my_group', {
--   { "BufEnter", "*.md", "set filetype=markdown" },
-- })
local function augroup(group_name, definition)
	vim.api.nvim_command("augroup " .. group_name)
	vim.api.nvim_command("autocmd!")
	for _, def in ipairs(definition) do
		local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
		vim.api.nvim_command(command)
	end
	vim.api.nvim_command("augroup END")
end

-- https://stackoverflow.com/a/7470789/7164888
-- TODO use vim.tbl_extend() instead
local function merge(t1, t2)
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(t1[k] or false) == "table") then
			merge(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

local function make_directed_maps(command_desc, command)
	local directions = {
		left = { key = "h", description = "to left", command_prefix = "aboveleft vsplit" },
		right = { key = "l", description = "to right", command_prefix = "belowright vsplit" },
		above = { key = "k", description = "above", command_prefix = "aboveleft split" },
		below = { key = "j", description = "below", command_prefix = "belowright split" },
		in_place = { key = ".", description = "in place", command_prefix = nil },
		tab = { key = ",", description = "in new tab", command_prefix = "tabnew" },
	}

	local maps = {}
	for _, d in pairs(directions) do
		local full_description = command_desc .. " " .. d.description
		local full_command = d.command_prefix -- approximating a ternary
				and "<CMD>" .. d.command_prefix .. " | " .. command .. "<CR>"
			or "<CMD>" .. command .. "<CR>"

		maps[d.key] = { full_command, full_description }
	end
	return maps
end

local function exec(command)
	local file = io.popen(command, "r")
	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end

local function uuid()
	local res = exec([[ python -c "import uuid, sys; sys.stdout.write(str(uuid.uuid4()))" ]])
	return res[1]
end

local function _noremap(mode, from, to)
	vim.api.nvim_set_keymap(mode, from, to, { noremap = true, silent = true })
end

local function noremap(from, to)
	_noremap("", from, to)
end
local function nnoremap(from, to)
	_noremap("n", from, to)
end
local function inoremap(from, to)
	_noremap("i", from, to)
end
local function vnoremap(from, to)
	_noremap("v", from, to)
end

local function source(filename)
	vim.cmd("source" .. vim.fn.stdpath("config") .. "/" .. filename)
end
-- }}}

-- init file setup {{{
source("plugins.lua")

local all_config_files = "*/nvim/init.lua,*/nvim/plugins.lua"
local plugin_file = "*/nvim/plugins.lua"
augroup("init_file_setup", {
	{ "BufNewFile,BufRead", all_config_files, "setlocal foldmethod=marker" },
	{ "BufWritePre", all_config_files, "Neoformat stylua" },
	{ "BufWritePost", all_config_files, "source %" },
	{ "BufWritePost", plugin_file, "PackerCompile" },
})
-- TODO move somewhere?
augroup("natural_movement_in_text_files", {
	{ "FileType", "text,markdown", "nnoremap j gj" },
	{ "FileType", "text,markdown", "nnoremap k gk" },
	{ "FileType", "text,markdown", "setlocal wrap" },
})
-- }}}

-- basic core stuff {{{
vim.g.python_host_prog = "/usr/bin/python3"
vim.g.python3_host_prog = "/usr/bin/python3"

-- faster window movements
nnoremap("<c-h>", "<c-w>h")
nnoremap("<c-j>", "<c-w>j")
nnoremap("<c-k>", "<c-w>k")
nnoremap("<c-l>", "<c-w>l")

-- disable ex mode
nnoremap("Q", "<nop>")
nnoremap("gQ", "<nop>")

inoremap("<c-a>", "<nop>") -- disable insert repeating
nnoremap("Y", "y$") -- make Y behave like C and D

vim.cmd([[ set splitbelow splitright ]]) -- matches i3 behaviour
vim.cmd([[ set linebreak ]]) -- don't break words when wrapping
vim.cmd([[ set list listchars=tab:»·,trail:·,nbsp:· ]]) -- Display extra whitespace
vim.cmd([[ set nojoinspaces ]]) -- Use one space, not two, after punctuation.

vim.cmd([[ set undofile ]])

-- increase oldfile saved ( default is !,'100,<50,s10,h )
vim.cmd([["set shada=!,'1000,<50,s10,h"]])

augroup("only_show_cursorline_on_focued_window", {
	{ "VimEnter,WinEnter,BufWinEnter ", "*", "setlocal cursorline" },
	{ "WinLeave", "*", "setlocal nocursorline" },
})

-- prefer spaces over tabs, vim-sleuth handles files with tabs
vim.cmd([[ set tabstop=2 ]])
vim.cmd([[ set softtabstop=2 ]])
vim.cmd([[ set shiftwidth=2 ]])
vim.cmd([[ set expandtab ]])

augroup("highlight_on_yank", {
	{ "TextYankPost", "*", "silent! lua vim.highlight.on_yank()" },
})

-- modern copy paste keymaps
inoremap("<C-v>", "<C-r>+")
vnoremap("<C-c>", '"+y')

-- stuff from https://github.com/mjlbach/defaults.nvim

--Remap space as leader key
noremap("<Space>", "")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.inccommand = "nosplit" --Incremental live completion
vim.wo.number = true --Make line numbers default
vim.o.hidden = true --Do not save when switching buffers
vim.o.mouse = "a" --Enable mouse mode
vim.o.breakindent = true --Enable break indent
vim.wo.signcolumn = "yes"

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd([[ colorscheme nvcode ]])

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.wrap = false

augroup("fzfDefaultEscapeBehavior", {
	{ "FileType", "fzf", "tnoremap <buffer> <ESC> <ESC>" },
})
-- }}}

-- old vimscript code that hasn't been converted {{{
source("file-tree.vim")
source("terminal.vim")
source("functions.vim")
-- }}}

-- lsp {{{
local lsp_installer = require("nvim-lsp-installer")

local lsp_ensure_installed = {
	"bashls",
	"cssls",
	"dockerls",
	"html",
	"jsonls",
	"pyright",
	"rust_analyzer",
	"solargraph",
	"sumneko_lua",
	"tsserver",
	"vimls",
	"vuels",
	"yamlls",
	"yamlls",
}
for _, name in pairs(lsp_ensure_installed) do
	local ok, server = lsp_installer.get_server(name)
	if ok then
		if not server:is_installed() then
			print("Installing lsp server: " .. name)
			server:install()
		end
	end
end

-- tsserver set up
local tsserver_on_attach = function(client, _bufnr)
	local ts_utils = require("nvim-lsp-ts-utils")
	ts_utils.setup({
		-- filter diagnostics; get more from:
		-- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
		filter_out_diagnostics_by_code = {
			6192, -- "All imports in import declaration are unused."
			6196, -- "'{0}' is declared but never used."
			6198, -- "All destructured elements are unused."
			6133, -- "'{0}' is declared but its value is never read.":
			6138, -- "Property '{0}' is declared but its value is never read."
			80001, -- "File is a CommonJS module; it may be converted to an ES module."
		},
	})
	ts_utils.setup_client(client)
end

lsp_installer.on_server_ready(function(server)
	local opts = {}

	opts.capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

	if server.name == "tsserver" then
		opts.on_attach = tsserver_on_attach

		-- WIP: use global tsserver instead of workspace's
		-- local old_cmd = server._default_options.cmd
		-- table.insert(old_cmd, "--tsserver-path /home/jack/.yarn/bin/tsserver")
		-- opts.cmd = old_cmd
		--
	elseif server.name == "sumneko_lua" then
		opts.settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
				telemetry = { enable = false },
			},
		}
	end

	-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
	server:setup(opts)
	vim.cmd([[ do User LspAttachBuffers ]])
end)

nnoremap("gd", "<CMD>Telescope lsp_definitions<CR>")
nnoremap("gr", "<CMD>Telescope lsp_references<CR>")
nnoremap("gy", "<CMD>Telescope lsp_type_definitions<CR>")
nnoremap("gh", "<CMD>lua vim.lsp.buf.hover()<CR>") -- TODO give border or something
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})

function LspFormat()
	vim.lsp.buf.formatting_sync()
	local tsserver_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
	if vim.tbl_contains(tsserver_filetypes, vim.bo.filetype) then
		vim.cmd([[ TSLspOrganizeSync ]])
	end
end

function QuietLsp()
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = false,
		underline = false,
		virtual_text = false,
	})
end

function LoudenLsp()
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
		underline = true,
		virtual_text = true,
	})
end
-- }}}

-- completions {{{
vim.cmd([[ set completeopt=menu,menuone,noselect ]])

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-f>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- ['<CR>'] = cmp.mapping.confirm({ select = true }),
		-- ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		-- ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "orgmode" },
	}, {
		{ name = "buffer" },
	}),
})
-- }}}

-- notes/wiki {{{
vim.g.markdown_syntax_conceal = 0
vim.g.markdown_fenced_languages = {
	"bash=sh",
	"c",
	"cpp",
	"css",
	"elm",
	"fish",
	"go",
	"html",
	"java",
	"javascript",
	"js=javascript",
	"json",
	"lua",
	"python",
	"ruby",
	"rust",
	"sh",
	"ts=typescript",
	"typescript",
	"yaml",
}

vim.g.bullets_checkbox_markers = " .oOx"
vim.g.wiki_root = "~/notes"
vim.g.markdown_folding = true

nnoremap("glt", "<cmd>ToggleCheckbox<cr>") -- TODO: create or toggle checkbox

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
		-- if no file then... create one with template_str as contents
		"[ -e " .. file_path .. " ] || " .. "echo '" .. template_str .. "' > " .. file_path
	vim.fn.system(template_cmd)
end

local function open_logbook(days_from_today)
	local logbook = get_logbook_info(days_from_today)
	template_if_new(logbook.path, logbook.title)
	vim.cmd("edit " .. logbook.path)
end

function LogbookToday()
	open_logbook()
end
function LogbookYesterday()
	open_logbook(-1)
end
function LogbookTomorrow()
	open_logbook(1)
end

vim.cmd([[command! LogbookToday :call v:lua.LogbookToday()]])
vim.cmd([[command! LogbookYesterday :call v:lua.LogbookYesterday()]])
vim.cmd([[command! LogbookTomorrow :call v:lua.LogbookTomorrow()]])
-- }}}

-- keymaps {{{
nnoremap("<c-s>", "<cmd>w<cr>")

local directed_keymaps = {
	git_status = make_directed_maps("Git Status", "Gedit :"),
	new_terminal = make_directed_maps("New terminal", "terminal"),
	todays_notepad = make_directed_maps("Today's notepad", "LogbookToday"),
	yesterdays_notepad = make_directed_maps("Yesterday's notepad", "LogbookYesterday"),
	tomorrows_notepad = make_directed_maps("Tomorrow's notepad", "LogbookTomorrow"),
	file_explorer = make_directed_maps("File explorer", "Fern . -reveal=%"),
	roaming_file_explorer = make_directed_maps("File explorer (focused on file's directory)", "Fern %:h -reveal=%"),
	vim_config = make_directed_maps("Vim config", "edit $MYVIMRC"),
	vim_plugins = make_directed_maps("Vim plugins", "edit " .. vim.fn.stdpath("config") .. "/plugins.lua"),
}
local grep_notes_cmd = "<Cmd>lua require('fzf-lua').grep({ cwd = '~/notes' })<CR><CR>"

local main_keymap = {
	lsp = {
		name = "+lsp",
		s = { "<cmd>SymbolsOutline<cr>", "SymbolsOutline" },
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "rename symbol" },
		d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "show document diagnostics" },
		D = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "show workspace diagnostics" },
		t = { "<cmd>TroubleToggle<cr>", "show workspace diagnostics" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		j = { "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "Next Diagnostic" },
		k = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
		f = { "<cmd>lua LspFormat()<cr>", "Prev Diagnostic" },

		-- HACK: pop into insert mode after to trigger lsp applying settings
		q = { "<cmd>call v:lua.QuietLsp()<cr>i <bs><esc>", "hide lsp diagnostics" },
		l = { "<cmd>call v:lua.LoudenLsp()<cr>i <bs><esc>", "show lsp diagnostics" },
	},
	finder = {
		name = "+find",
		b = { "<Cmd>FzfLua buffers<CR>", "🔭 buffers" },
		f = { "<Cmd>FzfLua files<CR>", "🔭 files" },
		g = { "<Cmd>FzfLua git_files<CR>", "🔭 git files" },
		h = { "<Cmd>FzfLua help_tags<CR>", "🔭 help tags" },
		c = { "<Cmd>FzfLua commands<CR>", "🔭 commands" },
		q = { "<Cmd>FzfLua quickfix<CR>", "🔭 quickfix" },
		o = { "<Cmd>FzfLua oldfiles<CR>", "🔭 oldfiles" },
		l = { "<Cmd>FzfLua blines<CR>", "🔭 buffer lines" },
		w = { "<Cmd>Telescope spell_suggest<CR>", "🔭 spelling suggestions" },
		s = { "<Cmd>Telescope symbols<CR>", "🔭 unicode and emoji symbols" },
		a = { "<Cmd>FzfLua live_grep<CR>", "FZF full text search" },
		u = { "<Cmd>FzfLua grep_cword<CR>", "FZF word under cursor" },
		U = { "<Cmd>FzfLua grep_cWORD<CR>", "FZF WORD under cursor" },
		n = { grep_notes_cmd, "🔭 personal notes" },
	},
	git = merge(directed_keymaps.git_status, {
		name = "+git",
		g = { "<Cmd>Telescope git_commits<CR>", "🔭 commits" },
		c = { "<Cmd>Telescope git_bcommits<CR>", "🔭 buffer commits" },
		b = { "<Cmd>Telescope git_branches<CR>", "🔭 branches" },
		R = { "<Cmd>Gitsigns reset_hunk<CR>", "reset hunk" },
		p = { "<Cmd>Gitsigns preview_hunk<CR>", "preview hunk" },
	}),
	terminal = merge(directed_keymaps.new_terminal, {
		name = "+terminal",
	}),
	explorer = merge(directed_keymaps.file_explorer, {
		name = "+file explorer",
		["e"] = merge(directed_keymaps.roaming_file_explorer, {
			name = "+in current file' directory",
		}),
	}),
	notes = merge(directed_keymaps.todays_notepad, {
		name = "+notes",
		f = { grep_notes_cmd, "🔭 search all notes" },
		y = merge(directed_keymaps.yesterdays_notepad, {
			name = "+Yesterday' notepad",
		}),
		t = merge(directed_keymaps.tomorrows_notepad, {
			name = "+Tomorrow' notepad",
		}),
	}),
	vim_config = merge(directed_keymaps.vim_config, {
		name = "+vim config",
	}),
	vim_plugins = merge(directed_keymaps.vim_plugins, {
		name = "+vim plugins",
		s = { "<cmd>PackerSync<cr>", "packer sync" },
	}),
}

local which_key = require("which-key")
vim.opt.timeoutlen = 250

which_key.register({
	e = main_keymap.explorer,
	f = main_keymap.finder,
	g = main_keymap.git,
	l = main_keymap.lsp,
	t = main_keymap.terminal,
	n = main_keymap.notes,
	v = main_keymap.vim_config,
	p = main_keymap.vim_plugins,
}, {
	prefix = "<leader>",
})

which_key.register({
	name = "quick keymaps",
	b = main_keymap.finder.b, -- buffers
	g = main_keymap.finder.g, -- git_files
	f = main_keymap.finder.f, -- find_files
	o = main_keymap.finder.o, -- old_files
	a = main_keymap.finder.a, -- Rg
	["."] = main_keymap.explorer["."], -- Fern .
	[">"] = main_keymap.explorer.e["."], -- Fern . (relative to file)
}, {
	prefix = ",",
})
-- }}}

-- snippets {{{

local function snip_map(from, to)
	vim.api.nvim_set_keymap("i", from, to, {})
	vim.api.nvim_set_keymap("s", from, to, {})
end
snip_map("<C-j>", "<Plug>luasnip-expand-snippet")
snip_map("<C-l>", "<Plug>luasnip-jump-next")
snip_map("<C-h>", "<Plug>luasnip-jump-prev")

local ls = require("luasnip")
local l = require("luasnip.extras").lambda
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node
local vsc = ls.parser.parse_snippet

local js_snippets = {
	-- React.useState()
	s("us", {
		t("const ["),
		i(1, "foo"),
		t(", set"),
		l(l._1:gsub("^%l", string.upper), 1),
		t("] = useState("),
		i(2),
		t(")"),
	}),
	-- standard function
	vsc("f", "function ${1}(${2}) {\n\t${3}\n}"),
	-- skeleton function
	vsc("sf", "function ${1}(${2}): ${3:void} {\n\t${0:throw new Error('Not implemented')}\n}"),
	-- throw
	vsc("tn", "throw new Error(${0})"),
	-- comments
	vsc("jsdoc", "/**\n * ${0}\n */"),
	vsc("/", "/* ${0} */"),
	-- template string variable
	vsc({ trig = "v", wordTrig = false }, "\\${${1}}"),
	-- anonymous function
	vsc("af", "(${1}) => $0"),
	-- verbose undefined checks
	vsc("=u", "=== undefined"),
	vsc("!u", "!== undefined"),
}

ls.snippets = {
	all = {
		s("date", { i(1, os.date("%Y-%m-%d")) }),
		s("uuid", { f(uuid, {}) }),
		vsc("filename", "$TM_FILENAME"),
		vsc("filepath", "$TM_FILEPATH"),
		vsc({ trig = "v", wordTrig = false }, "\\${${1}}"),
	},
	markdown = {
		-- task
		vsc("t", "- [ ] ${0}"),
		-- code blocks
		vsc("c", "```\n${1}\n```"),
		vsc("cj", "```json\n${1}\n```"),
		vsc("ct", "```typescript\n${1}\n```"),
		vsc("cp", "```python\n${1}\n```"),
		vsc("cs", "```sh\n${1}\n```"),
	},
	javascript = js_snippets,
	typescript = js_snippets,
	javascriptreact = js_snippets,
	typescriptreact = js_snippets,
}

-- }}}

-- IDEAS:
-- [x] setup notes again
-- [ ] fixup fzf-lua's history command (it's upside down)
-- [ ] get cmp keybinds just right
-- [ ] set exrc? or similar
-- [ ] map gf :edit <cfile><cr>
-- [x] set scrolloff sidescrooloff?
-- [ ] set up sudowrite
-- [x] fzf close with esc
-- [x] map * to :Rg <c-r><c-w> (then <space>fa to live grep)
-- [x] can I query loaded plugins from packer, and compare to plugins to load? then run PackerSync on kj
-- [ ] vim orgmode set up
--
-- [ ] aucommand ColorScheme to make buffers more distingished
-- [ ] some kind of bufferline setup, make sure it has lsp status in it
-- [ ] something to delete buffers (close and remove)
--
-- [ ] auto pairs?
-- [ ] xml auto pairs?
-- [ ] dax to delete xml attr: `Plug 'kana/vim-textobj-user' | Plug 'whatyouhide/vim-textobj-xmlattr'`
