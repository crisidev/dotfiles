-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "shfmt",
        args = { "-i", "2", "-ci" },
        filetypes = { "sh" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "shellcheck",
        -- args = {},
        filetypes = { "sh" },
    },
}
