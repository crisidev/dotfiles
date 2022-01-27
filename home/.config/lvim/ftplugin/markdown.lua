-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Enable markdown fencing
vim.g.markdown_fenced_languages = { "python", "rust", "ruby", "sh" }

-- Lsp config
require("lspconfig").grammar_guard.setup {
    cmd = { "/home/matbigoi/.local/share/nvim/lsp_servers/ltex/ltex-ls/bin/ltex-ls" }, -- add this if
    settings = {
        ltex = {
            enabled = { "latex", "tex", "bib", "markdown", "rst", "text" },
            language = "en",
            diagnosticSeverity = "information",
            setenceCacheSize = 2000,
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "en",
            },
            trace = { server = "info" },
        },
    },
}

-- require("user.lsp").config_prosemd()
