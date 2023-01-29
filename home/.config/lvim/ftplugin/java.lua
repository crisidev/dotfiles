-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Lsp config
require("user.lsp.java").config()

-- Additional mappings
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

local icons = require "user.icons"
local which_key = require "which-key"
which_key.register {
    ["f"] = {
        B = {
            name = icons.icons.nuclear .. " Build helpers",
            j = {
                name = icons.languages.java .. " Java",
                o = { "<Cmd>lua require('jdtls').organize_imports()<CR>", "Organize Imports" },
                v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
                c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
                m = { "<Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
                t = { "<Cmd>lua require('jdtls').test_nearest_method()<CR>", "Test Method" },
                T = { "<Cmd>lua require('jdtls').test_class()<CR>", "Test Class" },
                u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
            },
        },
    },
}
