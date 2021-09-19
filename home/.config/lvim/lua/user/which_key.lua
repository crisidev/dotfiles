local M = {}

M.config = function()
	lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<cr>", "Projects" }
	lvim.builtin.which_key.mappings["B"] = { "<cmd>lua require('user.telescope').buffers()<cr>", "Buffers" }

	lvim.builtin.which_key.mappings["lj"] = {
		"<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
		"Next Diagnostic",
	}
	lvim.builtin.which_key.mappings["lk"] = {
		"<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
		"Prev Diagnostic",
	}
	-- Trouble
	lvim.builtin.which_key.mappings["t"] = {
		name = "Diagnostics",
		t = { "<cmd>TroubleToggle<cr>", "Trouble" },
		w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "Lsp workspace" },
		d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Lsp document" },
		q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
		l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
		r = { "<cmd>TroubleToggle lsp_references<cr>", "Lsp references" },
		j = {
			"<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
			"Next diagnostics",
		},
		k = {
			"<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
			"Prev Diagnostic",
		},
	}
	-- Rust tools
	lvim.builtin.which_key.mappings["R"] = {
		name = "Rust Tools",
		i = { "<cmd>RustToggleInlayHints<cr>", "Toggle inlay hints" },
		r = { "<cmd>RustRunnables<cr>", "Run targes" },
		D = { "<cmd>RustDebuggables<cr>", "Debug targes" },
		e = { "<cmd>RustExpandMacro<cr>", "Expand macro" },
		m = { "<cmd>RustExpandMacro<cr>", "Parent module" },
		u = { "<cmd>RustMoveItemUp<cr>", "Move item up" },
		d = { "<cmd>RustMoveItemDown<cr>", "Move item down" },
		h = { "<cmd>RustHoverActions<cr>", "Hover actions" },
		H = { "<cmd>RustHoverRange<cr>", "Hover range" },
		c = { "<cmd>RustOpenCargo<cr>", "Open Cargo.toml" },
	}
	-- Close buffer with Leader-q
	lvim.builtin.which_key.mappings["q"] = { "<cmd>BufferClose<cr>", "Close buffer" }
	lvim.builtin.which_key.mappings["c"] = { "<cmd>set operatorfunc=CommentOperator<CR>g@l", "Comment out" }
	lvim.builtin.which_key.mappings["Q"] = { "<cmd>quit<cr>", "Quit" }
	-- Goyo
	lvim.builtin.which_key.mappings["G"] = { "<cmd>Goyo 90%x90%<cr>", "Start Goyo" }
	-- Session management
	lvim.builtin.which_key.mappings["h"] = {
		name = "+Persistence",
		s = { "<cmd>lua require('persistence').load()<cr>", "Restore for current dir" },
		l = { "<cmd>lua require('persistence').load({ last = true})<cr>", "Restore last session" },
		d = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
	}
	-- Git blame
	lvim.builtin.which_key.mappings["g"]["l"] = { "<cmd>GitBlameToggle<cr>", "Toggle inline git blame" }
	lvim.builtin.which_key.mappings["g"]["L"] = { "<cmd>Git blame<cr>", "Open git blame" }
	-- Standard keys
	lvim.builtin.which_key.on_config_done = function(wk)
		local keys = {
			["gk"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover action" },
			["gp"] = {
				name = "+Goto preview",
				d = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Preview definition" },
				r = { "<cmd>lua require('goto-preview').goto_preview_references()<cr>", "Preview references" },
				i = { "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", "Preview implementation" },
				q = { "<cmd>lua require('goto-preview').close_all_win()<cr>", "Close all preview windows" },
			},
			-- Code actions popup
			["ga"] = { "<cmd>lua require('user.telescope').code_actions()<cr>", "Code action" },
			-- Rename symbol
			["gr"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol" },
			-- Go to
			["gd"] = {
				name = "+Goto",
				g = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
				d = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto declaration" },
				i = { "<cmd>lua require('user.telescope').lsp_implementations()<cr>", "Goto Implementation" },
				r = { "<cmd>lua require('user.telescope').lsp_references()<cr>", "Goto References" },
			},
			["gg"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
			-- Diagnostics
			["ge"] = { "<cmd>lua require('user.telescope').lsp_document_diagnostics()<cr>", "Document diagnostics" },
			-- Format
			["gf"] = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format file" },
			-- Files
			["gS"] = { "<cmd>lua require('user.telescope').find_string()<cr>", "Find string in file" },
			["gF"] = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" },
			["gR"] = { "<cmd>lua require('user.telescope').recent_files()<cr>", "Recent files" },
			["gb"] = { "<cmd>lua require('user.telescope').file_browser()<cr>", "File browser" },
			-- Buffers
			["gq"] = { "<cmd>BufferClose<cr>", "Close buffer" },
			["gQ"] = { "<cmd>BufferClose!<cr>", "Force close buffer" },
			["gB"] = { "<cmd>lua require('user.telescope').buffers()<cr>", "Buffers" },
		}
		wk.register(keys, { mode = "n" })
	end
end

return M
