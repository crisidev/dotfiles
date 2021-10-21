-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "clang_format",
        -- args = {},
        filetypes = { "cpp" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}
