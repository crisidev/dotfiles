-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "black",
        args = { "--fast", "--line-length=120" },
        filetypes = { "python" },
    },
    {
        exe = "isort",
        args = { "--profile", "black", "-l", "120", "-m", "3", "-tc" },
        filetypes = { "python" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "flake8",
        args = { "--max-line-length=120" },
        filetypes = { "python" },
    },
}

-- Additional mappings
local icons = require("user.icons").icons
local which_key = require "which-key"
which_key.register {
    ["f"] = {
        B = {
            name = icons.nuclear .. " Python Tools",
            c = { "<cmd>lua require('dap-python').test_class()<cr>", "Test class" },
            m = { "<cmd>lua require('dap-python').test_method()<cr>", "Test method" },
            s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug selection" },
            e = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Pick env" },
            E = { "<cmd>lua require('swenv.api').get_current_venv()<cr>", "Show env" },
        },
    },
}
