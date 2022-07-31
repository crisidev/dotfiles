local M = {}

-- Function to replace local autocmds with global ones.

M.config = function()
	-- Autocommands
	vim.api.nvim_create_augroup("_lvim_user", {})

	-- Codelense viewer
	vim.api.nvim_create_autocmd("CursorHold", {
		group = "_lvim_user",
		pattern = { "*.rs", "*.c", "*.cpp", "*.go", "*.ts", "*.tsx", "*.kt", "*.py", "*.pyi", "*.java" },
		command = "lua require('user.codelens').show_line_sign()",
	})

	-- Terminal
	vim.api.nvim_create_autocmd("TermOpen", {
		group = "_lvim_user",
		pattern = "term://*",
		command = "lua require('user.keys').set_terminal_keymaps()",
	})

	-- Smithy filetype
	vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
		group = "_lvim_user",
		pattern = "*.smithy",
		command = "setfiletype smithy",
	})

	-- Disable Copilot globally
	vim.api.nvim_create_autocmd("BufRead", {
		group = "_lvim_user",
		pattern = "*",
		command = "lua require('user.copilot').disable()",
	})

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = "_lvim_user",
		pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
		callback = function()
			vim.opt_local.undofile = false
		end,
	})

	vim.api.nvim_create_autocmd("BufWritePost,BufEnter", {
		group = "_lvim_user",
		pattern = "*",
		command = "set nofoldenable foldmethod=manual foldlevelstart=99",
	})
end

return M
