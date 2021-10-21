-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettier",
        -- args = {},
        filetypes = { "html" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}
