local M = {}

M.config = function()
    -- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
    lvim.builtin.terminal.active = true
    lvim.builtin.nvimtree.side = "left"
    lvim.builtin.nvimtree.show_icons.git = 0

    -- if you don't want all the parsers change this to a table of the ones you want
    lvim.builtin.treesitter.ensure_installed = "maintained"
    lvim.builtin.treesitter.highlight.enabled = true
    lvim.builtin.treesitter.ignore_install = { "haskell", "kotlin" }

    -- Telescope
    lvim.builtin.telescope.defaults.path_display = { shorten = 10 }
    lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
    lvim.builtin.telescope.defaults.layout_config = require("user.telescope").layout_config()
    lvim.builtin.telescope.defaults.mappings = {
        i = {
            ["<esc>"] = require("telescope.actions").close,
            ["<C-y>"] = require("telescope.actions").which_key,
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

    -- Debugging
    lvim.builtin.dap.active = true

    -- Dashboard
    lvim.builtin.dashboard.active = true
    lvim.builtin.dashboard.custom_section = {
        a = {
            description = { "  Recent Projects    " },
            command = "Telescope projects",
        },
        b = {
            description = { "  Recently Used Files" },
            command = "lua require('user.telescope').recent_files()",
        },
        c = {
            description = { "  Find File          " },
            command = "lua require('user.telescope').find_files()",
        },
        d = {
            description = { "  Find Word          " },
            command = "lua require('user.telescope').live_grep()",
        },
        e = {
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
    lvim.builtin.cmp.formatting.kind_icons = require("user.lsp").symbols()
    lvim.builtin.cmp.formatting.source_names = {
        buffer = "(Buffer)",
        nvim_lsp = "(LSP)",
        luasnip = "(Snip)",
        treesitter = " ",
        nvim_lua = "(NvLua)",
        spell = " 暈",
        emoji = "  ",
        path = "  ",
        calc = "  ",
        cmp_tabnine = "  ",
    }

    -- terminal
    lvim.builtin.terminal.open_mapping = [[<c-\>]]
end

return M
