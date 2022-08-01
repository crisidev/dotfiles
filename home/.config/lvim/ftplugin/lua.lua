-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "stylua",
        -- args = {},
        filetypes = { "lua" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "luacheck",
        args = { "--globals vim lvim" },
        filetypes = { "lua" },
    },
}
