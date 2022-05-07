-- Formatting
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({})

-- Linting
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({})

-- Lsp config
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "smithy-language-server" })

local configs = require("lspconfig.configs")

-- Check if the config is already defined (useful when reloading this file)
if not configs.smithy_language_server then
	configs.smithy_language_server = {
		default_config = {
			cmd = { "smithy-language-server" },
			filetypes = { "smithy" },
			root_dir = function(fname)
				return require("lspconfig").util.find_git_ancestor(fname) or vim.fn.getcwd()
			end,
			settings = {},
		},
	}
end


local status_ok, lsp = pcall(require, "lspconfig")
if not status_ok then
	return
end

lsp.smithy_language_server.setup({
	on_attach = require("lvim.lsp").common_on_attach,
	on_init = require("lvim.lsp").common_on_init,
	capabilities = require("lvim.lsp").common_capabilities(),
})
