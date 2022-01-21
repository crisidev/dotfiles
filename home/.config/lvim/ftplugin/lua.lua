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
        -- args = {},
        filetypes = { "lua" },
    },
}

-- Lsp config
require("user.lsp").config_sumneko()
