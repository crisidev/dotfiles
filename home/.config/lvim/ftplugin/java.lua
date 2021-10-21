-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

vim.api.nvim_set_keymap("n", "ga", ":lua require('jdtls').code_action()<CR>", { noremap = true, silent = true })
