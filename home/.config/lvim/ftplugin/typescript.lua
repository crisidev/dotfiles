-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettierd",
        -- args = {},
        filetypes = { "javascript", "typescript" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "eslint_d",
        -- args = {},
        filetypes = { "javascript", "typescript" },
    },
}

-- Lsp confiig
require("user.lsp").config_tsserver()

-- Additional mappings
lvim.lsp.buffer_mappings.normal_mode["gT"] = {
    name = "☢ TS Tools",
    a = { "<cmd>TSLspImportAll<cr>", "Import all" },
    r = { "<cmd>TSLspRenameFile<cr>", "Rename file" },
    o = { "<cmd>TSLspOrganize<cr>", "Organize" },
}
