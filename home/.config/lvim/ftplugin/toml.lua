-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettierd",
        -- args = {},
        filetypes = { "toml" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

if vim.fn.expand "%:t" == "Cargo.toml" then
    -- Cargo tools mappings
    local which_key = require "which-key"
    local icons = require("user.icons").icons
    which_key.register {
        ["f"] = {
            B = {
                name = icons.nuclear .. " Cargo Tools",
                t = { "<cmd>lua require('crates').toggle()<cr>", "Toggle crates info" },
                r = { "<cmd>lua require('crates').reload()<cr>", "Reload crates info" },
                v = { "<cmd>lua require('crates').show_versions_popup()<cr>", "Show versions popup" },
                f = { "<cmd>lua require('crates').show_features_popup()<cr>", "Show features popup" },
                u = { "<cmd>lua require('crates').update_crate()<cr>", "Update crate" },
                a = { "<cmd>lua require('crates').update_all_crates()<cr>", "Update all crates" },
                U = { "<cmd>lua require('crates').upgrade_crate()<cr>", "Upgrade crate" },
                A = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Upgrade all crates" },
                h = { "<cmd>lua require('crates').open_homepage()<cr>", "Open crate homepage" },
                R = { "<cmd>lua require('crates').open_repository()<cr>", "Open crate repository" },
                d = { "<cmd>lua require('crates').open_documentation()<cr>", "Open crate documentation" },
                c = { "<cmd>lua require('crates').open_crates_io()<cr>", "Open crates.io" },
            },
        },
    }
end
