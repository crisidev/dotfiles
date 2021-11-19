local M = {}

M.config = function()
    -- Nvimtree
    lvim.builtin.nvimtree.side = "left"
    lvim.builtin.nvimtree.show_icons.git = 0
    lvim.builtin.nvimtree.icons = require("user.lsp").nvim_tree_icons

    -- Tree sitter
    lvim.builtin.treesitter.ensure_installed = "maintained"
    lvim.builtin.treesitter.highlight.enabled = true
    lvim.builtin.treesitter.ignore_install = { "haskell" }
    lvim.builtin.treesitter.ensure_installed = {
        "bash",
        "c",
        "go",
        "cpp",
        "json",
        "lua",
        "python",
        "rust",
        "java",
        "yaml",
        "kotlin",
    }

    -- Telescope
    lvim.builtin.telescope.defaults.path_display = { shorten = 10 }
    lvim.builtin.telescope.defaults.winblend = 6
    lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
    local actions = require "telescope.actions"
    lvim.builtin.telescope.defaults.mappings = {
        i = {
            ["<esc>"] = actions.close,
            ["<C-y>"] = actions.which_key,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
            ["<esc>"] = actions.close,
            ["<C-y>"] = actions.which_key,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
        },
    }
    lvim.builtin.telescope.defaults.file_ignore_patterns = {
        "vendor/*",
        "node_modules",
        "%.jpg",
        "%.jpeg",
        "%.png",
        "%.svg",
        "%.otf",
        "%.ttf",
        ".git",
        "target/*",
    }
    lvim.builtin.telescope.defaults.layout_config = require("user.telescope").layout_config()

    -- Terminal
    lvim.builtin.terminal.active = true

    -- Debugging
    lvim.builtin.dap.active = true

    -- Dashboard
    lvim.builtin.dashboard.active = true
    lvim.builtin.dashboard.custom_section = {
        a = {
            description = { "  New File           " },
            command = "DashboardNewFile",
        },
        b = {
            description = { "  Recent Projects    " },
            command = "Telescope projects",
        },
        c = {
            description = { "  Recently Used Files" },
            command = "lua require('user.telescope').recent_files()",
        },
        e = {
            description = { "  Find File          " },
            command = "lua require('user.telescope').find_files()",
        },
        f = {
            description = { "  Find Word          " },
            command = "lua require('user.telescope').find_string()",
        },
        g = {
            description = { "  Configuration      " },
            command = ":e ~/.config/lvim/config.lua",
        },
    }

    -- Cmp
    lvim.builtin.cmp.sources = {
        { name = "nvim_lsp" },
        { name = "cmp_tabnine", max_item_count = 3 },
        { name = "buffer", max_item_count = 5 },
        { name = "path", max_item_count = 5 },
        { name = "luasnip", max_item_count = 3 },
        { name = "nvim_lua" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
    }
    lvim.builtin.cmp.documentation.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    lvim.builtin.cmp.experimental = {
        ghost_text = false,
        native_menu = false,
        custom_menu = true,
    }
    lvim.builtin.cmp.formatting.kind_icons = require("user.lsp").cmp_kind
    lvim.builtin.cmp.formatting.source_names = {
        buffer = "(Buf)",
        nvim_lsp = "(Lsp)",
        luasnip = "(Snip)",
        treesitter = " ",
        nvim_lua = "(NvLua)",
        spell = " 暈",
        emoji = "  ",
        path = "  ",
        calc = "  ",
        cmp_tabnine = "  ",
    }

    -- Terminal
    lvim.builtin.terminal.open_mapping = [[<c-\>]]

    -- Which key
    lvim.builtin.which_key.setup.window.winblend = 10
    lvim.builtin.which_key.setup.window.border = "none"

    -- Notify popup
    lvim.builtin.notify.active = true
    lvim.log.level = "info"

    -- Evil stuff
    lvim.builtin.copilot = { active = true }
    lvim.builtin.tabnine = { active = false }

    -- Status line
    lvim.builtin.global_status_line = { active = true }
    lvim.builtin.fancy_bufferline = { active = true }
    if lvim.builtin.fancy_bufferline.active then
        lvim.builtin.bufferline.active = false
    end
end

return M
