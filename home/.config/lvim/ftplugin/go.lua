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
