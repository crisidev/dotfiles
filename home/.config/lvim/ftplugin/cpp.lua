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
local icons = require("user.icons").icons
local which_key = require "which-key"
which_key.register {
    ["f"] = {
        B = {
            name = icons.settings .. "Build helpers",
            h = { "<cmd>ClangdSwitchSourceHeader<cr>", "Run build help" },
        },
    },
}
