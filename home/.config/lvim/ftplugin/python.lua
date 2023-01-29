-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "flake8",
        args = { "--max-line-length=120" },
        filetypes = { "python" },
    },
}
