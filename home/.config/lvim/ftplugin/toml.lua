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

local opts = {}
local servers = require "nvim-lsp-installer.servers"
local server_available, requested_server = servers.get_server "taplo"
if server_available then
    opts.cmd_env = requested_server:get_default_options().cmd_env
end

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
