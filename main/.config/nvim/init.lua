-- Helpers {{{

-- usage:
-- augroup('MyGroup', {
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
augroup("initFileSetup", {
	{ "BufNewFile,BufRead", "*/nvim/init.lua", "setlocal foldmethod=marker" },
	{ "BufWritePre", "*/nvim/init.lua", "Neoformat stylua" },
	{ "BufWritePost", "*/nvim/init.lua", "source %" },
})
-- TODO move somewhere?
augroup("naturalMovementInTextFiles", {
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

-- disable insert repeating
inoremap("<c-a>", "<nop>")

-- disable ex mode
nnoremap("Q", "<nop>")
nnoremap("gQ", "<nop>")

-- make Y behave like C and D
nnoremap("Y", "y$")

vim.cmd([[ set splitbelow splitright ]]) -- matches i3 behaviour
vim.cmd([[ set linebreak ]]) -- don't break words when wrapping
vim.cmd([[ set list listchars=tab:»·,trail:·,nbsp:· ]]) -- Display extra whitespace
vim.cmd([[ set nojoinspaces ]]) -- Use one space, not two, after punctuation.

-- increase oldfile saved ( default is !,'100,<50,s10,h )
vim.cmd([["set shada=!,'1000,<50,s10,h"]])

-- Only show cursorline on focued window
vim.api.nvim_exec(
	[[
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
]],
	false
)

-- tabs vs spaces
vim.api.nvim_exec(
	[[
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab
  augroup tabwidths
    autocmd!
    autocmd FileType elm,python set tabstop=4
    autocmd FileType elm,python set softtabstop=4
    autocmd FileType elm,python set shiftwidth=4
  augroup END
]],
	false
)

-- Highlight on yank
vim.api.nvim_exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	false
)

-- modern copy paste keymaps
inoremap("<C-v>", "<C-r>+")
vnoremap("<C-c>", '"+y')

-- stuff from https://github.com/mjlbach/defaults.nvim

--Remap space as leader key
noremap("<Space>", "")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Incremental live completion
vim.o.inccommand = "nosplit"

--Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = "yes"

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd([[colorscheme nvcode]])
-- }}}

-- old vimscript code that hasn't been converted {{{
vim.cmd([[source file-tree.vim]])
vim.cmd([[source terminal.vim]])
-- }}}

-- packer and basic plugins {{{
local packer = require("packer")
packer.reset()
packer.init()

packer.use({ "wbthomason/packer.nvim" })
packer.use({ "christianchiarulli/nvcode-color-schemes.vim" })
packer.use({ "sbdchd/neoformat" })

packer.use({ "lambdalisue/fern-git-status.vim" })
packer.use({ "lambdalisue/fern-hijack.vim" })
packer.use({ "lambdalisue/fern-renderer-nerdfont.vim" })
packer.use({ "lambdalisue/fern.vim" })
packer.use({ "lambdalisue/nerdfont.vim" })

packer.use({ "JoosepAlviste/nvim-ts-context-commentstring" })
packer.use({ "aymericbeaumet/vim-symlink" })
packer.use({ "dkarter/bullets.vim" })
packer.use({ "godlygeek/tabular" })
packer.use({ "itchyny/lightline.vim" })
packer.use({ "junegunn/fzf" })
packer.use({ "junegunn/fzf.vim" })
packer.use({ "kyazdani42/nvim-web-devicons" })
packer.use({ "lervag/wiki.vim" })
packer.use({ "moll/vim-bbye" })
packer.use({ "nvim-lua/plenary.nvim" })
packer.use({ "nvim-lua/popup.nvim" })
packer.use({ "nvim-telescope/telescope.nvim" })
packer.use({ "rafamadriz/friendly-snippets" })
packer.use({ "rafcamlet/nvim-luapad", cmd = { "Luapad", "LuaRun" } })
packer.use({ "rhysd/git-messenger.vim" })
packer.use({ "sedm0784/vim-resize-mode" })

packer.use({ "sindrets/diffview.nvim", event = "BufRead" })
packer.use({ "folke/trouble.nvim", cmd = "TroubleToggle" })
packer.use({ "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline" })

packer.use({ "tpope/vim-abolish" })
packer.use({ "tpope/vim-commentary" })
packer.use({ "tpope/vim-fugitive" })
packer.use({ "tpope/vim-markdown" })
packer.use({ "tpope/vim-repeat" })
packer.use({ "tpope/vim-rhubarb" })
packer.use({ "tpope/vim-sleuth" })
packer.use({ "tpope/vim-surround" })
packer.use({ "tpope/vim-unimpaired" })

packer.use({ "kevinoid/vim-jsonc" })
packer.use({ "blankname/vim-fish" })
packer.use({ "GutenYe/json5.vim" })

packer.use({ "L3MON4D3/LuaSnip" })

packer.use({ "norcalli/nvim-colorizer.lua" })

packer.use({
	"ibhagwan/fzf-lua",
	requires = { "vijaymarupudi/nvim-fzf" },
})

packer.use({
	"lewis6991/gitsigns.nvim",
	requires = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("gitsigns").setup()
	end,
})

packer.use({
	"phaazon/hop.nvim",
	config = function()
		require("hop").setup()
		vim.api.nvim_set_keymap("n", "s", ":HopChar1<cr>", { silent = true })
		vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
	end,
})

packer.use({
	"simnalamburt/vim-mundo",
	config = function()
		vim.api.nvim_set_keymap("n", "<leader>u", "<cmd>MundoToggle<cr>", { silent = true })
		vim.g.mundo_preview_bottom = 1
		vim.g.mundo_width = 40
		vim.g.mundo_preview_height = 20
	end,
})

packer.use({
	"monaqa/dial.nvim",
	event = "BufRead",
	config = function()
		local dial = require("dial")
		vim.cmd([[
				nmap <C-a> <Plug>(dial-increment)
				nmap <C-x> <Plug>(dial-decrement)
				vmap <C-a> <Plug>(dial-increment)
				vmap <C-x> <Plug>(dial-decrement)
				vmap g<C-a> <Plug>(dial-increment-additional)
				vmap g<C-x> <Plug>(dial-decrement-additional)
			]])

		dial.augends["custom#boolean"] = dial.common.enum_cyclic({
			name = "boolean",
			strlist = { "true", "false" },
		})
		table.insert(dial.config.searchlist.normal, "custom#boolean")

		-- For Languages which prefer True/False, e.g. python.
		dial.augends["custom#Boolean"] = dial.common.enum_cyclic({
			name = "Boolean",
			strlist = { "True", "False" },
		})
		table.insert(dial.config.searchlist.normal, "custom#Boolean")
	end,
})

packer.use({
	"ethanholz/nvim-lastplace",
	event = "BufRead",
	config = function()
		require("nvim-lastplace").setup({
			lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
			lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
			lastplace_open_folds = true,
		})
	end,
})

packer.use({
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	config = function()
		require("nvim-ts-autotag").setup()
	end,
})

packer.use({
	"ruifm/gitlinker.nvim",
	event = "BufRead",
	config = function()
		require("gitlinker").setup({
			opts = {
				action_callback = require("gitlinker.actions").open_in_browser,
			},
		})
	end,
	requires = "nvim-lua/plenary.nvim",
})

-- }}}

-- tree sitter {{{
packer.use({
	{ "nvim-treesitter/playground" },
	{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "0.5-compat" },
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		branch = "0.5-compat",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "maintained",
				disable = { "haskell" },
				-- Modules and its options go here
				highlight = { enable = true },
				incremental_selection = { enable = true },
				playground = { enable = true },
				context_commentstring = { enable = true },
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["a/"] = "@comment.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>pl"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>ph"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
})
-- }}}c

-- lsp {{{
packer.use({
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/nvim-lsp-installer" },
	{ "jose-elias-alvarez/nvim-lsp-ts-utils" },
})
local lsp_installer = require("nvim-lsp-installer")

local lsp_ensure_installed = {
	"bashls",
	"cssls",
	"dockerls",
	"graphql",
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
		-- filter diagnostics
		filter_out_diagnostics_by_severity = {},
		filter_out_diagnostics_by_code = {},
	})
	ts_utils.setup_client(client)
end

-- TODO setup nvim-lsp-ts-utils
lsp_installer.on_server_ready(function(server)
	local opts = {}

	-- (optional) Customize the options passed to the server
	if server.name == "tsserver" then
		opts.on_attach = tsserver_on_attach
	end

	-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
	server:setup(opts)
	vim.cmd([[ do User LspAttachBuffers ]])
end)

nnoremap("gd", "<CMD>Telescope lsp_definitions<CR>")
nnoremap("gr", "<CMD>Telescope lsp_references<CR>")
nnoremap("gy", "<CMD>Telescope lsp_type_definitions<CR>")
nnoremap("gh", "<CMD>lua vim.lsp.buf.hover()<CR>") -- TODO give border or something

-- TODO project specific settings?? Can I make some mindset specific settings for TS?
-- }}}

-- keymaps {{{
packer.use({
	"folke/which-key.nvim",
	config = function()
		require("which-key").setup()
	end,
})

local directed_keymaps = {
	git_status = make_directed_maps("Git Status", "Gedit :"),
	new_terminal = make_directed_maps("New terminal", "terminal"),
	todays_notepad = make_directed_maps("Today's notepad", "LogbookToday"),
	yesterdays_notepad = make_directed_maps("Yesterday's notepad", "LogbookYesterday"),
	tomorrows_notepad = make_directed_maps("Tomorrow's notepad", "LogbookTomorrow"),
	file_explorer = make_directed_maps("File explorer", "Fern . -reveal=%"),
	roaming_file_explorer = make_directed_maps("File explorer (focused on file's directory)", "Fern %:h -reveal=%"),
}
local grep_notes_cmd = "<Cmd>lua require('telescope.builtin').grep_string({ cwd = '~/notes' })<CR>"
local main_keymap = {
	lsp = {
		name = "+Lsp",
		s = { "<cmd>SymbolsOutline<cr>", "SymbolsOutline" },
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "rename symbol" },
		d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "show document diagnostics" },
		D = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "show workspace diagnostics" },
		t = { "<cmd>TroubleToggle<cr>", "show workspace diagnostics" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		j = {
			"<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = lvim.lsp.popup_border}})<cr>",
			"Next Diagnostic",
		},
		k = {
			"<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = lvim.lsp.popup_border}})<cr>",
			"Prev Diagnostic",
		},

		-- HACK: pop into insert mode after to trigger lsp applying settings
		q = { "<cmd>call v:lua.Quiet_lsp()<cr>i <bs><esc>", "hide lsp diagnostics" },
		l = { "<cmd>call v:lua.Louden_lsp()<cr>i <bs><esc>", "show lsp diagnostics" },
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
		a = { "<Cmd>Rg<CR>", "FZF full text search" },
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
}

local which_key = require("which-key")

which_key.register({
	e = main_keymap.explorer,
	f = main_keymap.finder,
	g = main_keymap.git,
	l = main_keymap.lsp,
	t = main_keymap.terminal,
	-- n = main_keymap.notes, -- TODO not setup yet
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
