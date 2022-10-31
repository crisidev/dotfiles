local M = {}

M.config = function()
    local util = require "lspconfig.util"
    local opts = {
        cmd = { "taplo", "lsp", "stdio" },
        on_attach = require("lvim.lsp").common_on_attach,
        on_init = require("lvim.lsp").common_on_init,
        capabilities = require("lvim.lsp").common_capabilities(),
        root_dir = function(fname)
            return util.root_pattern "*.toml" (fname) or util.find_git_ancestor(fname)
        end,
        single_file_support = true,
    }

    require("lvim.lsp.manager").setup("taplo", opts)
end

return M
