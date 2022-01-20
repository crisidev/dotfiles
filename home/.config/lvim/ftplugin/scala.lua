-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "scalafmt",
        filetypes = { "scala", "sbt" },
    },
}

-- Start metals
require("user.metals").config()
