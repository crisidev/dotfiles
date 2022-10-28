-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "uncrustify",
        -- args = {},
        filetypes = { "java" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Lsp config
require("user.lsp.java").config()

-- Additional mappings
local icons = require("user.icons").icons
local which_key = require "which-key"
which_key.register {
    ["f"] = {
        B = {
            name = icons.nuclear .. " JdtLs Tools",
            o = { "<Cmd>lua require('jdtls').organize_imports()<CR>", "Organize Imports" },
            v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
            c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
            m = { "<Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
            t = { "<Cmd>lua require('jdtls').test_nearest_method()<CR>", "Test Method" },
            T = { "<Cmd>lua require('jdtls').test_class()<CR>", "Test Class" },
            u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
        },
    },
}
