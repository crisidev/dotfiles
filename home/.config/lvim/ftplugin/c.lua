-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "clang_format",
        -- args = {},
        filetypes = { "c" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Additional mappings
lvim.lsp.buffer_mappings.normal_mode["gH"] = {
    "<cmd>ClangdSwitchSourceHeader<cr>",
    "Run build help",
}
