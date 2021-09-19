local M = {}

M.config = function()
	-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
	lvim.builtin.dashboard.active = true
	lvim.builtin.terminal.active = true
	lvim.builtin.nvimtree.side = "left"
	lvim.builtin.nvimtree.show_icons.git = 0

	-- if you don't want all the parsers change this to a table of the ones you want
	lvim.builtin.treesitter.ensure_installed = "maintained"
	lvim.builtin.treesitter.highlight.enabled = true
	lvim.builtin.treesitter.ignore_install = { "haskell", "kotlin" }

	-- Telescope
	lvim.builtin.telescope.defaults.path_display = { shorten = 10 }
	lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
	lvim.builtin.telescope.defaults.layout_config = require("user.telescope").layout_config()

	-- Debugging
	lvim.builtin.dap.active = true

	-- Dashboard
	lvim.builtin.dashboard.active = true
	lvim.builtin.dashboard.custom_section = {
		a = {
			description = { "  Recent Projects    " },
			command = "Telescope projects",
		},
		b = {
			description = { "  Recently Used Files" },
			command = "lua require('user.telescope').recent_files()",
		},
		c = {
			description = { "  Find File          " },
			command = "lua require('user.telescope').find_files()",
		},
		d = {
			description = { "  Find Word          " },
			command = "lua require('user.telescope').live_grep()",
		},
		e = {
			description = { "  Configuration      " },
			command = ":e ~/.config/lvim/config.lua",
		},
	}

	-- terminal
	lvim.builtin.terminal.open_mapping = [[<c-\>]]

	-- Comp
	lvim.builtin.cmp.formatting = {
		format = function(entry, vim_item)
			local cmp_kind = require("user.lsp").cmp_kind
			vim_item.kind = cmp_kind(vim_item.kind)
			vim_item.menu = ({
				buffer = "(Buffer)",
				nvim_lsp = "(LSP)",
				luasnip = "(Snip)",
				treesitter = " ",
				nvim_lua = "(NvLua)",
				spell = " 暈",
				emoji = "  ",
				path = "  ",
				calc = "  ",
				cmp_tabnine = "  ",
			})[entry.source.name]
			vim_item.dup = ({
				buffer = 1,
				path = 1,
				nvim_lsp = 0,
			})[entry.source.name] or 0
			return vim_item
		end,
	}

	-- Discover GUIs
	local f = io.open("/proc/self/cmdline", "rb")
	local cmdline = f:read("*all")
	f:close()
	if string.find(cmdline, 'let g:guifont="FiraCode Nerd Font Mono:h10"') then
		lvim.builtin.neovide = true
	else
		lvim.builtin.neovide = false
	end

	if vim.g.glrnvim_gui then
		lvim.builtin.glrnvim = true
	else
		lvim.builtin.glrnvim = false
	end
end

return M
