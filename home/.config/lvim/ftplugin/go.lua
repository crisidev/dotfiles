-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "goimports",
        -- args = {},
        filetypes = { "go" },
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
            name = icons.nuclear .. " Go Tools",
            i = { "<cmd>GoInstallDeps<cr>", "Install dependencies" },
            t = { "<cmd>GoMod tidy<cr>", "Tidy" },
            a = { "<cmd>GoTestAdd<cr>", "Add test" },
            A = { "<cmd>GoTestsAll<cr>", "Add all tests" },
            e = { "<cmd>GoTestsExp<cr>", "Add exported tests" },
            g = { "<cmd>GoGenerate<cr>", "Generate" },
            c = { "<cmd>GoCmt<cr>", "Comment" },
            d = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug test" },
        },
    },
}
