-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettierd",
        -- args = {},
        filetypes = { "json" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}
