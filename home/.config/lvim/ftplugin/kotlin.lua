-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Additional mappings
local icons = require("user.icons").icons
local which_key = require "which-key"
which_key.register {
    ["f"] = {
        T = {
            name = icons.nuclear .. " Gradle Tools",
            t = { "<Cmd>Telescope gradle tasks<CR>", "Gradle tasks" },
            p = { "<Cmd>Telescope gradle projects<CR>", "Gradle projects" },
            h = { "<Cmd>Telescope gradle history<CR>", "Gradle history" },
        },
    },
}
