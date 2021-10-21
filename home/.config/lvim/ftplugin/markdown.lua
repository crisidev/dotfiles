-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettier",
        -- args = {},
        filetypes = { "markdown" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "vale",
        -- args = {},
        filetypes = { "markdown" },
    },
}
