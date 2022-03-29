-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "clang_format",
        -- args = {},
        filetypes = { "c", "cpp" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Additional mappings
lvim.lsp.buffer_mappings.normal_mode["gB"] = {
    name = " Build helpers",
    h = { "<cmd>ClangdSwitchSourceHeader<cr>", "Run build help" },
}
