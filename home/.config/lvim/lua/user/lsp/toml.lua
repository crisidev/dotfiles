local M = {}

M.config = function()
    local util = require "lspconfig.util"
    local opts = {
        cmd = { "taplo", "lsp", "stdio" },
        on_attach = require("lvim.lsp").common_on_attach,
        on_init = require("lvim.lsp").common_on_init,
        capabilities = require("lvim.lsp").common_capabilities(),
        root_dir = function(fname)
            return util.root_pattern "*.toml"(fname) or util.find_git_ancestor(fname)
        end,
        single_file_support = true,
    }

    require("lvim.lsp.manager").setup("taplo", opts)
end

M.build_tools = function()
    local which_key = require "which-key"
    local icons = require "user.icons"
    local opts = {
        mode = "n",
        prefix = "f",
        buffer = vim.fn.bufnr(),
        silent = true,
        noremap = true,
        nowait = true,
    }
    -- Cargo tools mappings
    local mappings = {
        B = {
            name = icons.languages.toml .. " Build helpers",
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
    }
    local vopts = {
        mode = "v",
        prefix = "f",
        buffer = vim.fn.bufnr(),
        silent = true,
        noremap = true,
        nowait = true,
    }
    -- Cargo tools mappings
    local vmappings = {
        B = {
            name = icons.languages.toml .. " Build helpers",
            u = { "<cmd>lua require('crates').update_crates()<cr>", "Update crates" },
            U = { "<cmd>lua require('crates').upgrade_crates()<cr>", "Upgrade crates" },
        },
    }
    which_key.register(mappings, opts)
    which_key.register(vmappings, vopts)
end

return M
