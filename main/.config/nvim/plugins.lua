local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = nil
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

local packer_config = {
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
	},
}

return require("packer").startup({
	function(use)
		use({ "wbthomason/packer.nvim" })
		use({ "christianchiarulli/nvcode-color-schemes.vim" })
		use({ "sbdchd/neoformat" })

		use({
			-- file tree
			"lambdalisue/fern-git-status.vim",
			"lambdalisue/fern-hijack.vim",
			"lambdalisue/fern-renderer-nerdfont.vim",
			"lambdalisue/fern.vim",
			"lambdalisue/nerdfont.vim",
		})

		use({
			-- notes / wiki
			"lervag/wiki.vim",
			"dkarter/bullets.vim",
			"godlygeek/tabular",
		})
		use({
			"kristijanhusak/orgmode.nvim",
			config = function()
				require("orgmode").setup({
					org_agenda_files = { "~/Documents/org/*" },
					org_default_notes_file = "~/Documents/org/refile.org",
					org_todo_keywords = { "TODO(t)", "IN_PROGRESS(p)", "|", "DONE(d)" },
					org_todo_keyword_faces = {
						DONE = ":foreground blue :weight bold",
						IN_PROGRESS = ":foreground yellow",
						TODO = ":foreground red",
					},
				})
			end,
		})
		use({
			"akinsho/org-bullets.nvim",
			config = function()
				require("org-bullets").setup({
					symbols = { "◉", "○", "✸", "✿" },
				})
			end,
		})

		use({ "JoosepAlviste/nvim-ts-context-commentstring" })
		use({ "aymericbeaumet/vim-symlink" })
		use({ "itchyny/lightline.vim" })
		use({ "kyazdani42/nvim-web-devicons" })
		use({ "moll/vim-bbye" })
		use({ "nvim-lua/plenary.nvim" })
		use({ "nvim-lua/popup.nvim" })
		use({ "rafamadriz/friendly-snippets" })
		use({ "rafcamlet/nvim-luapad", cmd = { "Luapad", "LuaRun" } })
		use({ "rhysd/git-messenger.vim" })
		use({ "sedm0784/vim-resize-mode" })

		use({ "sindrets/diffview.nvim", event = "BufRead" })
		use({ "folke/trouble.nvim", cmd = "TroubleToggle" })
		use({ "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline" })

		use({
			-- tim pope / core
			"tpope/vim-abolish",
			"tpope/vim-commentary",
			"tpope/vim-fugitive",
			"tpope/vim-markdown",
			"tpope/vim-repeat",
			"tpope/vim-rhubarb",
			"tpope/vim-sleuth",
			"tpope/vim-surround",
			"tpope/vim-unimpaired",
		})

		use({
			-- custom lang setup
			"kevinoid/vim-jsonc",
			"blankname/vim-fish",
			"GutenYe/json5.vim",
		})

		use({
			-- finders
			{
				"nvim-telescope/telescope.nvim",
				config = function()
					require("telescope").setup({
						defaults = {
							layout_config = { prompt_position = "top" },
							sorting_strategy = "ascending",
							layout_strategy = "flex",
						},
					})
				end,
			},
			{ "junegunn/fzf" },
			{ "junegunn/fzf.vim" },
			{
				"ibhagwan/fzf-lua",
				requires = {
					"vijaymarupudi/nvim-fzf",
					"kyazdani42/nvim-web-devicons",
				},
				config = function()
					require("fzf-lua").setup({
						winopts = {
							preview = {
								layout = "flex",
								flip_columns = 150,
							},
						},
					})
				end,
			},
		})

		use({ "norcalli/nvim-colorizer.lua" })

		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup()
			end,
		})

		use({
			"phaazon/hop.nvim",
			as = "hop",
			config = function()
				require("hop").setup()
				vim.api.nvim_set_keymap("n", "s", ":HopChar1<cr>", { silent = true })
				vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
			end,
		})

		use({
			"simnalamburt/vim-mundo",
			config = function()
				vim.api.nvim_set_keymap("n", "<leader>u", "<cmd>MundoToggle<cr>", { silent = true })
				vim.g.mundo_preview_bottom = 1
				vim.g.mundo_width = 40
				vim.g.mundo_preview_height = 20
			end,
		})

		use({
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
				dial.augends["custom#Boolean"] = dial.common.enum_cyclic({
					name = "Boolean",
					strlist = { "True", "False" },
				})
				table.insert(dial.config.searchlist.normal, "custom#boolean")
				table.insert(dial.config.searchlist.normal, "custom#Boolean")
			end,
		})

		use({
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

		use({
			"windwp/nvim-ts-autotag",
			event = "InsertEnter",
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		})

		use({
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

		-- lsp
		use({
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/nvim-lsp-installer" },
			{ "jose-elias-alvarez/nvim-lsp-ts-utils" },
		})

		-- completions
		use({
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip" },
		})

		use({
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({
					plugins = {
						spelling = { enabled = true },
					},
					window = {
						winblend = 15,
					},
					layout = {
						spacing = 4,
						align = "center",
					},
				})
			end,
		})

		use({ "L3MON4D3/LuaSnip" })

		use({
			{ "nvim-treesitter/playground" },
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{
				"nvim-treesitter/nvim-treesitter",
				run = ":TSUpdate",
				config = function()
					local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
					parser_config.org = {
						install_info = {
							url = "https://github.com/milisims/tree-sitter-org",
							revision = "main",
							files = { "src/parser.c", "src/scanner.cc" },
						},
						filetype = "org",
					}

					require("nvim-treesitter.configs").setup({
						ensure_installed = "maintained",
						disable = { "haskell" },
						-- Modules and its options go here
						highlight = {
							enable = true,
							-- disable = { "org" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
							additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
						},
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

		use({ "folke/lua-dev.nvim" })

		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = packer_config,
})