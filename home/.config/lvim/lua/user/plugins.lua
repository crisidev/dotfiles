local M = {}

M.themes = function()
	return {
		{
			-- "folke/tokyonight.nvim",
			"abzcoding/tokyonight.nvim",
			branch = "feat/local",
			config = function()
				require("user.theme").tokyonight()
				vim.cmd([[colorscheme tokyonight]])
			end,
		},
		{ "folke/lsp-colors.nvim" },
		-- Colorizer
		{
			"norcalli/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		},
	}
end

M.git = function()
	return {
		-- Git blame
		{
			"f-person/git-blame.nvim",
			config = function()
				vim.cmd("highlight default link gitblame Question")
				vim.g.gitblame_enabled = 0
				vim.g.gitblame_message_template = "<date> • <author> • <summary>"
				vim.g.gitblame_date_format = "%r"
			end,
		},
		-- Github management
		{
			"pwntester/octo.nvim",
			config = function()
				require("octo").setup()
			end,
			event = "BufRead",
		},
		-- Git linker
		{
			"ruifm/gitlinker.nvim",
			event = "BufRead",
			config = function()
				require("gitlinker").setup({
					opts = {
						-- adds current line nr in the url for normal mode
						add_current_line_on_normal_mode = true,
						-- callback for what to do with the url
						action_callback = require("gitlinker.actions").copy_to_clipboard,
						-- print the url after performing the action
						print_url = false,
						-- mapping to call url generation
						mappings = "gy",
					},
					callbacks = {
						["code.crisidev.org"] = require("gitlinker.hosts").get_gitea_type_url,
						["git.amazon.com"] = require("user.amzn").get_amazon_type_url,
					},
				})
			end,
			requires = "nvim-lua/plenary.nvim",
		},
	}
end

M.telescope = function()
	return {
		-- Telescope zoxide
		{
			"jvgrootveld/telescope-zoxide",
			requires = { "nvim-telescope/telescope.nvim" },
		},
		-- Telescope repo
		{
			"cljoly/telescope-repo.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		},
		-- Telescope UI select
		{ "nvim-telescope/telescope-ui-select.nvim" },
		-- Telescope file browser
		{ "nvim-telescope/telescope-file-browser.nvim" },
		-- Telescope live grep
		{ "nvim-telescope/telescope-live-grep-raw.nvim" },
	}
end

M.lsp = function()
	return {
		-- Lsp signature
		{
			"ray-x/lsp_signature.nvim",
			config = function()
				require("user/lsp_signature").config()
			end,
			event = { "BufRead", "BufNew" },
		},
		-- Lsp progress lualine
		{
			"arkav/lualine-lsp-progress",
			disable = lvim.builtin.fidget.active,
		},
		-- Lsp progreess in fidget
		{
			"j-hui/fidget.nvim",
			config = function()
				require("user.fidget").config()
			end,
			disable = not lvim.builtin.fidget.active,
		},
		-- Lsp goto preview
		{
			"rmagatti/goto-preview",
			config = function()
				require("goto-preview").setup({
					default_mappings = false,
				})
			end,
		},
		-- Lsp Rust
		{
			"simrat39/rust-tools.nvim",
			ft = { "rust", "rs" },
		},
		-- Lsp Typescript
		{
			"jose-elias-alvarez/nvim-lsp-ts-utils",
			ft = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			opt = true,
			event = "BufReadPre",
			before = "williamboman/nvim-lsp-installer",
		},
		-- Lsp Cland Extensions
		{
			"p00f/clangd_extensions.nvim",
			ft = { "c", "cpp", "objc", "objcpp" },
		},
		-- Lightbulb
		{
			"kosayoda/nvim-lightbulb",
			config = function()
				vim.fn.sign_define(
					"LightBulbSign",
					{ text = require("user.lsp").icons.code_action, texthl = "DiagnosticInfo" }
				)
			end,
			event = "BufRead",
			ft = { "rust", "go", "c", "cpp", "typescript", "typescriptreact" },
		},
		-- Scala metals
		{
			"scalameta/nvim-metals",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("user.metals").config()
			end,
			ft = { "scala", "sbt" },
		},
		-- Renamer
		{
			-- "filipdutescu/renamer.nvim",
			"abzcoding/renamer.nvim",
			branch = "develop",
			config = function()
				require("user.renamer").config()
			end,
		},
		-- Symbol outline
		{
			"simrat39/symbols-outline.nvim",
			config = function()
				require("user.symbols_outline").config()
			end,
			event = "BufReadPost",
			disable = lvim.builtin.tag_provider ~= "symbols-outline",
		},
		-- Vista
		{
			"liuchengxu/vista.vim",
			setup = function()
				require("user.vista").config()
			end,
			event = "BufReadPost",
			disable = lvim.builtin.tag_provider ~= "vista",
		},
	}
end

M.markdown = function()
	return {
		{
			"iamcco/markdown-preview.nvim",
			run = "cd app && npm install",
			ft = { "markdown" },
			config = function()
				vim.g.mkdp_auto_start = 1
				vim.g.mkdp_browser = "/usr/bin/firefox"
			end,
		},
		-- Glow markdown preview
		{
			"ellisonleao/glow.nvim",
			ft = { "markdown" },
		},
		-- Better diff view
		{
			"sindrets/diffview.nvim",
			cmd = { "DiffviewOpen", "DiffviewFileHistory" },
			module = "diffview",
			keys = "<leader>gd",
			setup = function()
				-- require("which-key").register { ["Gd"] = "diffview: diff HEAD" }
			end,
			config = function()
				require("diffview").setup({
					enhanced_diff_hl = true,
					key_bindings = {
						file_panel = { q = "<Cmd>DiffviewClose<CR>" },
						view = { q = "<Cmd>DiffviewClose<CR>" },
					},
				})
			end,
		},
		-- Crates cmp
		{
			"Saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("user.crates").config()
			end,
		},
		-- Markdown TOC
		{
			"mzlogin/vim-markdown-toc",
			ft = "markdown",
		},
	}
end

M.copilot = function()
	return {
		-- Copilot
		{
			"github/copilot.vim",
			config = function()
				vim.g.copilot_no_tab_map = true
				vim.g.copilot_assume_mapped = true
				vim.g.copilot_tab_fallback = ""
				vim.g.copilot_filetypes = {
					["*"] = false,
					python = true,
					lua = true,
					go = true,
					rust = true,
					html = true,
					c = true,
					cpp = true,
					javascript = true,
					typescript = true,
				}
			end,
			disable = not lvim.builtin.copilot.active,
		},
		-- Tabout
		{
			"abecodes/tabout.nvim",
			wants = { "nvim-treesitter" },
			after = { "nvim-cmp" },
			config = function()
				require("user.tabout").config()
			end,
			disable = not lvim.builtin.copilot.active,
		},
	}
end

M.filetype = function()
	return {
		-- i3 syntax
		{ "mboughaba/i3config.vim" },
		-- Smithy
		{ "jasdel/vim-smithy" },
		-- Editor config
		{
			"editorconfig/editorconfig-vim",
			event = "BufRead",
			disable = not lvim.builtin.editorconfig.active,
		},
		-- Faster filetype
		{
			"abzcoding/filetype.nvim",
			branch = "fix/qf-syntax",
			config = function()
				require("user.filetype").config()
			end,
		},
	}
end

M.grammar = function()
	return {
		-- Spelling
		{
			"lewis6991/spellsitter.nvim",
			config = function()
				require("spellsitter").setup({
					hl = "SpellBad",
					captures = { "comment" },
				})
			end,
		},
		-- Grammarous
		{
			"rhysd/vim-grammarous",
			cmd = "GrammarousCheck",
		},
		-- Grammar guard
		{
			"brymer-meneses/grammar-guard.nvim",
			filetype = { "latex", "tex", "bib", "markdown", "rst", "text" },
			requires = {
				"neovim/nvim-lspconfig",
				"williamboman/nvim-lsp-installer",
			},
		},
		-- Dictionary cmp
		{
			"uga-rosa/cmp-dictionary",
			config = function()
				require("cmp_dictionary").setup({
					dic = {
						["markdown"] = { "/usr/share/dict/words", "/usr/share/dict/british-english" },
						["rst"] = { "/usr/share/dict/words", "/usr/share/dict/british-english" },
						["*"] = {},
					},
				})
			end,
			rocks = { "mpack" },
		},
	}
end

M.config = function()
	lvim.plugins = {
		-- Pick up where you left
		{
			"ethanholz/nvim-lastplace",
			event = "BufRead",
			config = function()
				require("nvim-lastplace").setup({
					lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
					lastplace_ignore_filetype = {
						"gitcommit",
						"gitrebase",
						"svn",
						"hgcommit",
					},
					lastplace_open_folds = true,
				})
			end,
		},
		-- Session manager
		{
			"Shatur/neovim-session-manager",
			config = function()
				local Path = require("plenary.path")
				require("session_manager").setup({
					sessions_dir = Path:new(vim.fn.stdpath("config"), "/sessions/"),
					path_replacer = "__",
					colon_replacer = "++",
					autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
					autosave_last_session = true,
					autosave_ignore_not_normal = true,
					autosave_only_in_session = false,
				})
			end,
			requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		},
		-- Hlslens
		{
			"kevinhwang91/nvim-hlslens",
			config = function()
				require("user.hlslens").config()
			end,
			event = "BufReadPost",
			disable = not lvim.builtin.hlslens.active,
		},
		-- Neogen
		{
			"danymat/neogen",
			config = function()
				require("neogen").setup({
					enabled = true,
				})
			end,
			event = "InsertEnter",
			requires = "nvim-treesitter/nvim-treesitter",
		},
		-- Diagnostics
		{
			"folke/trouble.nvim",
			config = function()
				require("trouble").setup({
					auto_open = true,
					auto_close = true,
					padding = false,
					height = 10,
					use_diagnostic_signs = true,
				})
			end,
			cmd = "Trouble",
		},
		-- Python coverage highlight
		{ "mgedmin/coverage-highlight.vim" },
		-- Goyo
		{ "junegunn/goyo.vim" },
		{ "junegunn/limelight.vim" },
		-- Screenshots
		{
			"JMcKiern/vim-shoot",
			run = "./install.py geckodriver",
			config = function()
				vim.api.nvim_set_var("shoot_zoom_factor", 1)
			end,
		},
		-- Debugging UI
		{
			"rcarriga/nvim-dap-ui",
			config = function()
				require("dapui").setup()
			end,
			ft = { "python", "rust", "rs", "go", "c" },
			requires = { "mfussenegger/nvim-dap" },
			disable = not lvim.builtin.dap.active,
		},
		-- TODO comments
		{
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("user.todo_comments").config()
			end,
		},
		-- Spectre
		{
			"windwp/nvim-spectre",
			event = "BufRead",
			config = function()
				require("user.spectre").config()
			end,
		},
		-- Qbf
		{
			"kevinhwang91/nvim-bqf",
			config = function()
				require("user.bqf").config()
			end,
			event = "BufRead",
		},
		-- Sidebar
		{
			"sidebar-nvim/sidebar.nvim",
			config = function()
				require("user.sidebar").config()
			end,
			-- event = "BufRead",
			disable = not lvim.builtin.sidebar.active,
		},
		-- Zoxide
		{ "nanotee/zoxide.vim" },
		-- Stable window open
		{
			"luukvbaal/stabilize.nvim",
			config = function()
				require("stabilize").setup({
					forcemark = "f",
					nested = "QuickFixCmdPost,User LspDiagnosticsChanged",
				})
			end,
		},
		-- Smart quit
		{
			"marklcrns/vim-smartq",
			config = function()
				vim.g.smartq_default_mappings = 0
			end,
		},
		-- Web API
		{ "mattn/webapi-vim" },
	}
	table.insert(lvim.plugins, M.themes())
	table.insert(lvim.plugins, M.git())
	table.insert(lvim.plugins, M.telescope())
	table.insert(lvim.plugins, M.lsp())
	table.insert(lvim.plugins, M.markdown())
	table.insert(lvim.plugins, M.copilot())
	table.insert(lvim.plugins, M.filetype())
	table.insert(lvim.plugins, M.grammar())
end

return M
