-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "shfmt",
        args = { "-i", "4", "-ci" },
        filetypes = { "bash", "sh", "zsh" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "shellcheck",
        -- args = {},
        filetypes = { "bash", "sh", "zsh" },
    },
}
