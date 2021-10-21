-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettier",
        -- args = {},
        filetypes = { "javascript" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "eslint_d",
        -- args = {},
        filetypes = { "javascript" },
    },
}
