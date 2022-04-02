local M = {}

M.config = function()
	-- NORMAL
	lvim.keys.normal_mode = {
		-- Toggle tree
		["<F3>"] = "<cmd>NvimTreeToggle<cr>",
		["<S-F3>"] = "<cmd>NvimTreeRefresh<cr>",
		-- Toggle mouse
		["<F4>"] = "<cmd>SidebarNvimToggle<cr>",
		-- Toggle sidebar
		["<F5>"] = "<cmd>MouseToggle<cr>",
		-- Yank current path
		["<F6>"] = '<cmd>let @+ = expand("%:p")<cr>',
		-- Windows navigation
		["<A-Up>"] = "<cmd>wincmd k<cr>",
		["<A-Down>"] = "<cmd>wincmd j<cr>",
		["<A-Left>"] = "<cmd>wincmd h<cr>",
		["<A-Right>"] = "<cmd>wincmd l<cr>",
		-- Toggle numbers
		["<F11>"] = "<cmd>NoNuMode<cr>",
		["<F12>"] = "<cmd>NuModeToggle<cr>",
		-- Align text
		["<"] = "<<",
		[">"] = ">>",
		-- Yank to the end of line
		["Y"] = "y$",
		-- Open horizontal terminal
		["<C-]>"] = "<cmd>ToggleTerm size=12 direction=horizontal<cr>",
	}

	if lvim.builtin.tag_provider == "symbols-outline" then
		lvim.keys.normal_mode["<F10>"] = "<cmd>SymbolsOutline<cr>"
		lvim.keys.insert_mode["<F10>"] = "<cmd>SymbolsOutline<cr>"
	elseif lvim.builtin.tag_provider == "vista" then
		lvim.keys.normal_mode["<F10>"] = "<cmd>Vista!!<cr>"
		lvim.keys.insert_mode["<F10>"] = "<cmd>Vista!!<cr>"
	end
	-- INSERT
	lvim.keys.insert_mode = {
		-- Toggle tree
		["<F3>"] = "<cmd>NvimTreeToggle<cr>",
		["<S-F3>"] = "<cmd>NvimTreeRefresh<cr>",
		-- Toggle sidebar
		["<F4>"] = "<cmd>SidebarNvimToggle<cr>",
		-- Toggle mouse
		["<F5>"] = "<cmd>MouseToggle<cr>",
		-- Yank current path
		["<F6>"] = '<cmd>let @+ = expand("%:p")<cr>',
		-- Windows navigation
		["<A-Up>"] = "<cmd>wincmd k<cr>",
		["<A-Down>"] = "<cmd>wincmd j<cr>",
		["<A-Left>"] = "<cmd>wincmd h<cr>",
		["<A-Right>"] = "<cmd>wincmd l<cr>",
		-- Paste with Ctrl-v
		["<C-v>"] = "<C-r><C-o>+",
		-- Snippets
		["<C-s>"] = "<cmd>lua require('telescope').extensions.luasnip.luasnip(require('telescope.themes').get_cursor({}))<cr>",
		-- Open horizontal terminal
		["<C-]>"] = "<cmd>ToggleTerm size=12 direction=horizontal<cr>",
	}
	-- VISUAL
	lvim.keys.visual_mode = {
		-- Yank with Ctrl-c
		["<C-c>"] = '"+yi',
		-- Cut with Ctrl-x
		["<C-x>"] = '"+c',
		-- Paste with Ctrl-v
		["<C-v>"] = 'c<Esc>"+p',
	}

	-- Buffer navigation
	lvim.keys.normal_mode["<F1>"] = "<cmd>BufferLineCyclePrev<cr>"
	lvim.keys.normal_mode["<F2>"] = "<cmd>BufferLineCycleNext<cr>"
	lvim.keys.insert_mode["<F1>"] = "<cmd>BufferLineCyclePrev<cr>"
	lvim.keys.insert_mode["<F2>"] = "<cmd>BufferLineCycleNext<cr>"
	-- Move buffers
	lvim.keys.normal_mode["<A-S-Left>"] = "<cmd>BufferLineMovePrev<cr>"
	lvim.keys.normal_mode["<A-S-Right>"] = "<cmd>BufferLineMoveNext<cr>"
	lvim.keys.insert_mode["<A-S-Left>"] = "<cmd>BufferLineMovePrev<cr>"
	lvim.keys.insert_mode["<A-S-Right>"] = "<cmd>BufferLineMoveNext<cr>"
end

M.set_hlslens_keymaps = function()
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap(
		"n",
		"n",
		"<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
		opts
	)
	vim.api.nvim_set_keymap(
		"n",
		"N",
		"<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
		opts
	)
	vim.api.nvim_set_keymap("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", opts)
	vim.api.nvim_set_keymap("n", "#", "#<Cmd>lua require('hlslens').start()<CR>", opts)
	vim.api.nvim_set_keymap("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", opts)
	vim.api.nvim_set_keymap("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", opts)
end

M.set_terminal_keymaps = function()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

return M
