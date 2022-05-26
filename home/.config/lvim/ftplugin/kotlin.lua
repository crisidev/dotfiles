-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Additional mappings
local icons = require("user.icons").icons
lvim.lsp.buffer_mappings.normal_mode["gT"] = {
    name = icons.debug .. " Gradle Tools",
    t = { "<Cmd>Telescope gradle tasks<CR>", "Gradle tasks" },
    p = { "<Cmd>Telescope gradle projects<CR>", "Gradle projects" },
    h = { "<Cmd>Telescope gradle history<CR>", "Gradle history" },
}
