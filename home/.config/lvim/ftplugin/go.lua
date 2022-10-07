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
        T = {
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
        B = {
            name = icons.settings .. "Build helpers",
            b = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go build .;read',count=2,direction='horizontal'})<cr>",
                "Run go build",
            },
            v = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go vet .;read',count=2,direction='horizontal'})<cr>",
                "Run go vet",
            },
            t = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go test .;read',count=2,direction='horizontal'})<cr>",
                "Run go test",
            },
            r = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go run .;read',count=2,direction='horizontal'})<cr>",
                "Run go run",
            },
        },
    },
}
