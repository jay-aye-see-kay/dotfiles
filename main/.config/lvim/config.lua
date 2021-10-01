local which_key = require("which-key")

-- Helpers {{{
-- https://stackoverflow.com/a/7470789/7164888
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
		-- leftmost =  { key = 'H' , description = 'to left edge'   , command_prefix = 'topleft vsplit' }    ,
		-- rightmost = { key = 'L' , description = 'to right edge'  , command_prefix = 'botright vsplit' }   ,
		-- top =       { key = 'K' , description = 'to top edge'    , command_prefix = 'topleft split' }     ,
		-- bottom =    { key = 'J' , description = 'to bottom edge' , command_prefix = 'botright split' }    ,
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
-- }}}

-- General {{{
lvim.leader = "space"
lvim.format_on_save = false
lvim.lint_on_save = true
lvim.colorscheme = "nvcode"

lvim.builtin.dashboard.active = true
lvim.builtin.nvimtree.active = false
lvim.builtin.bufferline.active = false
vim.opt.showtabline = 1
lvim.builtin.which_key.setup.layout = { align = "center", spacing = 6 }
lvim.builtin.which_key.setup.window.padding = { 1, 1, 1, 1 }

vim.opt.clipboard = "" -- use vim's clipboard normally
vim.cmd([[ set list listchars=tab:»·,trail:·,nbsp:· ]]) -- Display extra whitespace
vim.cmd([["set shada=!,'1000,<50,s10,h"]]) -- increase oldfile saved ( default is !,'100,<50,s10,h )

lvim.keys.normal_mode["Q"] = "" -- disable ex mode
lvim.keys.normal_mode["gQ"] = "" -- disable ex mode
lvim.keys.normal_mode["Y"] = "y$" -- make Y behave like C and D

vim.opt.linebreak = true

vim.g.python_host_prog = "/usr/bin/python3"
vim.g.python3_host_prog = "/usr/bin/python3"

vim.g.mundo_preview_bottom = 1
vim.g.mundo_width = 40
vim.g.mundo_preview_height = 20

vim.cmd([[source $LUNARVIM_CONFIG_DIR/file-tree.vim]])
vim.cmd([[source $LUNARVIM_CONFIG_DIR/terminal.vim]])
-- }}}

-- Dashboard {{{
lvim.builtin.dashboard = {
	active = true,
	custom_header = {
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⣾⠿⠿⠟⠛⠛⠛⠛⠿⠿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⡿⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠒⠂⠉⠉⠉⠉⢩⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⢰⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠠⡀⠀⠀⢀⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⢀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡧⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠈⠁⠒⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠉⠢⠤⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠈⠑⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"               ⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠒⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡇⠀⠀⢀⣣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		"               ⠸⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠒⠢⠤⠄⣀⣀⠀⠀⠀⢠⣿⡟⠀⠀⠀⣺⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	},
	custom_section = {
		a = {
			description = { "  Recent Projects    " },
			command = "Telescope projects",
		},
		b = {
			description = { "  Find File          " },
			command = "Telescope find_files",
		},
		c = {
			description = { "  Configuration      " },
			command = ":e $LUNARVIM_CONFIG_DIR/config.lua",
		},
		d = {
			description = { "  Recently Used Files" },
			command = "Telescope oldfiles",
		},
		e = {
			description = { "  Find Word          " },
			command = "Telescope live_grep",
		},
	},
}
-- }}}

-- Lsp etc. {{{
lvim.lsp.on_attach_callback = function(_, bufnr)
	-- using defer_fn to call this code after LunarVim sets default keybinds
	vim.defer_fn(function()
		local keys = {
			["gh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
			["gd"] = { "<cmd>Telescope lsp_definitions<CR>", "Goto Definition" },
			["gr"] = { "<cmd>Telescope lsp_references<CR>", "Goto references" },
			["gI"] = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
		}
		which_key.register(keys, { mode = "n", buffer = bufnr })
	end, 0)
end

-- disable LunarVim's default up and down in pum keys, <C-n> and <C-p> are fine
lvim.keys.insert_mode["<C-j>"] = nil
lvim.keys.insert_mode["<C-k>"] = nil

vim.g.symbols_outline = {
	auto_preview = false,
	keymaps = {
		close = nil,
		goto_location = "<cr>",
		focus_location = "o",
		hover_symbol = "gh",
		toggle_preview = "p",
		rename_symbol = "r",
		code_actions = "a",
	},
}
--- }}}

-- Linting & formatting {{{
-- lvim.lang.javascript.linters = { { exe = "eslint_d" } }
-- lvim.lang.typescript.linters = { { exe = "eslint_d" } }
-- lvim.lang.javascriptreact.linters = { { exe = "eslint_d" } }
-- lvim.lang.typescriptreact.linters = { { exe = "eslint_d" } }
-- }}}

-- Treesitter {{{
-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
-- }}}

-- Debugging {{{
-- TODO
-- lvim.builtin.dap.active = true
-- }}}

-- Telescope {{{
lvim.builtin.telescope.defaults = {
	layout_config = { prompt_position = "top" },
	sorting_strategy = "ascending",
	layout_strategy = "flex",
}
-- }}}

-- Plugins {{{
lvim.plugins = {
	{
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			require("hop").setup()
			vim.api.nvim_set_keymap("n", "s", ":HopChar1<cr>", { silent = true })
			vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
		end,
	},
	{ "christianchiarulli/nvcode-color-schemes.vim" },
	{ "sbdchd/neoformat" },
	{
		"tpope/vim-fugitive",
		cmd = {
			"G",
			"Git",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gedit",
		},
		ft = { "fugitive" },
	},
	{
		"folke/lua-dev.nvim",
		config = function()
			local luadev = require("lua-dev").setup({
				lspconfig = lvim.lang.lua.lsp.setup,
			})
			lvim.lang.lua.lsp.setup = luadev
		end,
	},
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
	},
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufRead",
	},
	{ "norcalli/nvim-colorizer.lua" },
	{ "tpope/vim-repeat" },
	{
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
	},
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
				lastplace_open_folds = true,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
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
	},
	{ "simnalamburt/vim-mundo" },
	{ "lambdalisue/fern.vim" },
	{ "lambdalisue/fern-git-status.vim" },
	{ "lambdalisue/fern-hijack.vim" },
	{ "lambdalisue/fern-renderer-nerdfont.vim" },
	{ "lambdalisue/nerdfont.vim" },

	{ "tpope/vim-markdown" },
	{ "lervag/wiki.vim" },
	{ "dkarter/bullets.vim" },
	{ "godlygeek/tabular" },

	{ "junegunn/fzf.vim" },
	{ "junegunn/fzf" },

	{ "sedm0784/vim-resize-mode" },

	{ "tpope/vim-abolish" },
	{ "tpope/vim-unimpaired" },
	{ "tpope/vim-surround" },

	{ "kevinoid/vim-jsonc" },
	{ "GutenYe/json5.vim" },
	{ "blankname/vim-fish" },
	{ "rafcamlet/nvim-luapad", cmd = { "Luapad", "LuaRun" } },
}
-- }}}

-- Autocommands (https://neovim.io/doc/user/autocmd.html) {{{
lvim.autocommands.custom_groups = {
	-- lvim config
	{ "BufNewFile,BufRead", "*/lvim/config.lua", "setlocal foldmethod=marker" },
	{ "BufWritePre", "*/lvim/config.lua", "Neoformat stylua | source %" },

	-- naturalMovementInTextFiles
	{ "FileType", "text,markdown", "nnoremap j gj" },
	{ "FileType", "text,markdown", "nnoremap k gk" },
	{ "FileType", "text,markdown", "setlocal wrap" },
}
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

-- TODO: create or toggle checkbox
lvim.keys.normal_mode["glt"] = "<cmd>ToggleCheckbox<cr>"

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
		-- if no file then...		create one with template_str as contents
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

-- keymaps {{{
-- modern copy paste keymaps
lvim.keys.insert_mode["<C-v>"] = "<C-r>+"
lvim.keys.visual_mode["<C-c>"] = '"+y'

lvim.keys.insert_mode["<c-a>"] = "<home>"
lvim.keys.insert_mode["<c-e>"] = "<end>"

lvim.keys.normal_mode["<C-s>"] = "<cmd>w<cr>"
lvim.keys.normal_mode["<leader>u"] = "<cmd>MundoToggle<cr>"

local directed_keymaps = {
	git_status = make_directed_maps("Git Status", "Gedit :"),
	new_terminal = make_directed_maps("New terminal", "terminal"),
	file_explorer = make_directed_maps("File explorer", "Fern . -reveal=%"),
	roaming_file_explorer = make_directed_maps("File explorer (focused on file's directory)", "Fern %:h -reveal=%"),
	todays_notepad = make_directed_maps("Today's notepad", "LogbookToday"),
	yesterdays_notepad = make_directed_maps("Yesterday's notepad", "LogbookYesterday"),
	tomorrows_notepad = make_directed_maps("Tomorrow's notepad", "LogbookTomorrow"),
}

local grep_notes_cmd = "<Cmd>lua require('telescope.builtin').grep_string({ cwd = '~/notes' })<CR>"
-- "<Cmd>lua require('telescope.builtin').grep_string({ cwd = '~/notes', file_ignore_patterns = {'./.obsidian/*'} })<CR>"

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
		b = { "<Cmd>Telescope buffers<CR>", "🔭 buffers" },
		f = { "<Cmd>Telescope find_files<CR>", "🔭 files" },
		g = { "<Cmd>Telescope git_files<CR>", "🔭 git files" },
		h = { "<Cmd>Telescope help_tags<CR>", "🔭 help tags" },
		c = { "<Cmd>Telescope commands<CR>", "🔭 commands" },
		q = { "<Cmd>Telescope quickfix<CR>", "🔭 quickfix" },
		o = { "<Cmd>Telescope oldfiles<CR>", "🔭 oldfiles" },
		l = { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "🔭 buffer lines" },
		w = { "<Cmd>Telescope spell_suggest<CR>", "🔭 spelling suggestions" },
		s = { "<Cmd>Telescope symbols<CR>", "🔭 unicode and emoji symbols" },
		a = { "<Cmd>Rg<CR>", "FZF full text search" },
		p = { '<Cmd>lua require("telescope_z").list()<CR>', "🔭 jump to project with z" },
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

lvim.builtin.which_key.mappings.f = main_keymap.finder
lvim.builtin.which_key.mappings.n = main_keymap.notes
lvim.builtin.which_key.mappings.g = main_keymap.git
lvim.builtin.which_key.mappings.t = main_keymap.terminal
lvim.builtin.which_key.mappings.e = main_keymap.explorer
lvim.builtin.which_key.mappings.l = main_keymap.lsp

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
