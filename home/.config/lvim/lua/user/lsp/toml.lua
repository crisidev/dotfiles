local M = {}

M.config = function()
	local home = os.getenv("HOME")
	local opts = {
		cmd = { home .. "/.local/share/nvim/lsp_servers/taplo/taplo-lsp", "run" },
		on_attach = require("lvim.lsp").common_on_attach,
		on_init = require("lvim.lsp").common_on_init,
		capabilities = require("lvim.lsp").common_capabilities(),
	}

	require("lvim.lsp.manager").setup("taplo", opts)
end

return M
