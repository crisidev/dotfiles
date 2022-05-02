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

-- Lsp config
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "dockerls" })

local opts = {
    root_dir = function(fname)
        return require("lspconfig").util.root_pattern ".git"(fname) or require("lspconfig").util.path.dirname(fname)
    end,
}

require("lvim.lsp.manager").setup("dockerls", opts)
