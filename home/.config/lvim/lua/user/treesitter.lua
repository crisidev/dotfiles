local M = {}

M.config = function()
	-- Tree sitter
	lvim.builtin.treesitter.highlight.enabled = true
	lvim.builtin.treesitter.context_commentstring.enable = true
	lvim.builtin.treesitter.ensure_installed = "maintained"
	lvim.builtin.treesitter.ignore_install = { "haskell" }
	lvim.builtin.treesitter.incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-n>",
			node_incremental = "<C-n>",
			scope_incremental = "<C-s>",
			node_decremental = "<C-r>",
		},
	}
	lvim.builtin.treesitter.indent = { enable = true }
	lvim.builtin.treesitter.matchup.enable = true
	-- lvim.treesitter.textsubjects.enable = true
	-- lvim.treesitter.playground.enable = true
	lvim.builtin.treesitter.query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	}
	lvim.builtin.treesitter.textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["av"] = "@variable.outer",
				["iv"] = "@variable.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader><M-a>"] = "@parameter.inner",
				["<leader><M-f>"] = "@function.outer",
				["<leader><M-e>"] = "@element",
			},
			swap_previous = {
				["<leader><M-A>"] = "@parameter.inner",
				["<leader><M-F>"] = "@function.outer",
				["<leader><M-E>"] = "@element",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]f"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]F"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	}
end

return M
