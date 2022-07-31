local M = {}

M.config = function()
	require("grammar-guard").init()

	local opts = {
		cmd = { "ltex-ls" },
		root_dir = function(fname)
			return require("lspconfig").util.find_git_ancestor(fname) or vim.fn.getcwd()
		end,
		settings = {
			ltex = {
				checkFrequency = "edit",
				enabled = { "latex", "tex", "bib", "markdown", "rst", "text" },
				language = "en",
				diagnosticSeverity = "information",
				sentenceCacheSize = 2000,
				additionalRules = {
					enablePickyRules = true,
					motherTongue = "en",
				},
				trace = { server = "warning" },
			},
		},
		on_attach = require("lvim.lsp").common_on_attach,
		on_init = require("lvim.lsp").common_on_init,
		capabilities = require("lvim.lsp").common_capabilities(),
	}
	-- Use your attach function here
	local status_ok, lsp = pcall(require, "lspconfig")
	if not status_ok then
		return
	end

	local status_ok, result = pcall(lsp.grammar_guard.setup, opts)
	if not status_ok then
		return
	end

	require("lvim.lsp.manager").setup("prosemd_lsp", {})
end

return M
