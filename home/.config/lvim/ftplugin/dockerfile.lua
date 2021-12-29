-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "hadolint",
        -- args = {},
        filetypes = { "dockerfile" },
    },
}

-- Lsp server override
local opts = {
    root_dir = function(fname)
        return require("lspconfig").util.root_pattern ".git"(fname) or require("lspconfig").util.path.dirname(fname)
    end,
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
}

local servers = require "nvim-lsp-installer.servers"
local server_available, requested_server = servers.get_server "dockerls"
if server_available then
    opts.cmd = requested_server:get_default_options().cmd
end

require("lvim.lsp.manager").setup("dockerls", opts)
