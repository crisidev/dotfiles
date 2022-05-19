-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

require("nvim-lsp-installer._generated.filetype_map")["smithy"] = { "smithy_language_server" }
