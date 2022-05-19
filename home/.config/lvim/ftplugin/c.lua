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
local icons = require("user.lsp").icons
lvim.lsp.buffer_mappings.normal_mode["gB"] = {
    name = icons.settings .. "Build helpers",
    h = { "<cmd>ClangdSwitchSourceHeader<cr>", "Run build help" },
}
