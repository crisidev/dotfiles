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

-- Lsp config
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "taplo" })

local opts = {
    cmd = { "/home/matbigoi/.local/share/nvim/lsp_servers/taplo/taplo-lsp", "run" },
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
}

require("lvim.lsp.manager").setup("taplo", opts)

if vim.fn.expand "%:t" == "Cargo.toml" then
    -- Cargo tools mappings
    lvim.lsp.buffer_mappings.normal_mode["gT"] = {
        name = "☢ Cargo Tools",
        t = { "<cmd>lua require('crates').toggle()<cr>", "Toggle crates info" },
        r = { "<cmd>lua require('crates').reload()<cr>", "Reload crates info" },
        v = { "<cmd>lua require('crates').show_versions_popup()<cr>", "Show versions popup" },
        f = { "<cmd>lua require('crates').show_features_popup()<cr>", "Show features popup" },
        u = { "<cmd>lua require('crates').update_crate()<cr>", "Update crate" },
        a = { "<cmd>lua require('crates').update_all_crates()<cr>", "Update all crates" },
        U = { "<cmd>lua require('crates').upgrade_crate()<cr>", "Update crate" },
        A = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Update all crates" },
    }
    lvim.lsp.buffer_mappings.visual_mode["gT"] = {
        name = "☢ Cargo Tools",
        u = { "<cmd>lua require('crates').update_crates()<cr>", "Update selected crates" },
        U = { "<cmd>lua require('crates').upgrade_crates()<cr>", "Update selected crates" },
    }
end
