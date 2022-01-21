-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Enable markdown fencing
vim.g.markdown_fenced_languages = { "python", "rust", "ruby", "sh" }
