-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettierd",
        -- args = {},
        filetypes = { "javascript", "typescript" },
    },
}

local M = {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "eslint_d",
        -- args = {},
        filetypes = { "javascript", "typescript" },
    },
}

-- Additional mappings
local icons = require("user.icons").icons
local which_key = require "which-key"
which_key.register {
    ["f"] = {
        B = {
            name = icons.nuclear .. " TypeScript Tools",
            a = { "<cmd>TypescriptAddMissingImports<cr>", "Add missing imports" },
            o = { "<cmd>TypescriptOrganizeImports<cr>", "Organize imports" },
            f = { "<cmd>TypescriptFixAll<cr>", "Fix all" },
            r = { "<cmd>TypescriptRenameFile<cr>", "Rename file" },
            u = { "<cmd>TypescriptRemoveUnused<cr>", "Remove unused" },
        },
    },
}
