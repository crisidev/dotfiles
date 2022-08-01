-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "black",
        args = { "--fast", "--line-length=120" },
        filetypes = { "python" },
    },
    {
        exe = "isort",
        args = { "--profile", "black", "-l", "120", "-m", "3", "-tc" },
        filetypes = { "python" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "flake8",
        args = { "--max-line-length=120" },
        filetypes = { "python" },
    },
}
