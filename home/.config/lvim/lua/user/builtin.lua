local M = {}

M.config = function()
    -- Evil stuff
    lvim.builtin.copilot = { active = true }
    if lvim.builtin.copilot.active then
        lvim.keys.insert_mode["<c-h>"] = { [[copilot#Accept("\<CR>")]], { expr = true, script = true } }
        local cmp = require "cmp"
        lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(M.tab, { "i", "c" })
        lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(M.shift_tab, { "i", "c" })
    end

    -- Sidebar
    lvim.builtin.sidebar = { active = true }

    -- Status line
    lvim.builtin.fancy_wild_menu = { active = false }

    -- Fancy telescope
    lvim.builtin.fancy_telescope = { active = false }

    -- Nvimtree
    lvim.builtin.nvimtree.side = "left"
    local kind = require "user.lsp"
    lvim.builtin.nvimtree.setup.diagnostics = {
        enable = true,
        icons = {
            hint = kind.icons.hint,
            info = kind.icons.info,
            warning = kind.icons.warn,
            error = kind.icons.error,
        },
    }
    lvim.builtin.nvimtree.setup.view.auto_resize = true
    lvim.builtin.nvimtree.setup.actions.open_file.resize_window = true
    lvim.builtin.nvimtree.icons = kind.nvim_tree_icons
    lvim.builtin.nvimtree.on_config_done = function(_)
        lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<CR>", " Explorer" }
    end
    lvim.builtin.nvimtree.show_icons.git = 0

    -- Project
    lvim.builtin.project.active = true
    lvim.builtin.project.detection_methods = { "lsp", "pattern" }

    -- Debugging
    lvim.builtin.dap.active = true

    -- File browser
    lvim.builtin.file_browser = { active = true }

    -- Fidget vs lualine lsp progress
    lvim.builtin.fidget = { active = true }

    -- Spinrun testing
    lvim.builtin.sniprun = { active = true }

    -- Dashboard
    lvim.builtin.dashboard.active = true
    lvim.builtin.dashboard.custom_section = {
        a = {
            description = { "  New File           " },
            command = "DashboardNewFile",
        },
        b = {
            description = { "⚝  Projects           " },
            command = "lua require('telescope').extensions.repo.list{}",
        },
        c = {
            description = { "  List Sessions      " },
            command = "SessionManager load_session",
        },
        d = {
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
            description = { "  File Browser       " },
            command = "Telescope file_browser",
        },
        h = {
            description = { "Ƶ  Zoxide             " },
            command = "lua require('telescope').extensions.zoxide.list{}",
        },
        i = {
            description = { "  Configuration      " },
            command = ":e ~/.config/lvim/config.lua",
        },
    }

    -- Cmp
    lvim.builtin.cmp.sources = {
        { name = "nvim_lsp" },
        { name = "buffer", max_item_count = 5, keyword_length = 5 },
        { name = "path", max_item_count = 5 },
        { name = "luasnip", max_item_count = 3 },
        { name = "nvim_lua" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
        { name = "dictionary", keyword_length = 2 },
    }
    lvim.builtin.cmp.documentation.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    lvim.builtin.cmp.experimental = {
        ghost_text = false,
        native_menu = false,
        custom_menu = true,
    }
    lvim.builtin.cmp.formatting.kind_icons = require("user.lsp").cmp_kind
    lvim.builtin.cmp.formatting.source_names = {
        buffer = "(buf)",
        nvim_lsp = "(lsp)",
        luasnip = "(snip)",
        treesitter = "",
        nvim_lua = "(lua)",
        spell = "暈",
        dictionary = "暈",
        emoji = "",
        path = "",
        calc = "",
        crates = "(crates)",
    }

    -- Terminal
    lvim.builtin.terminal.active = true
    lvim.builtin.terminal.open_mapping = [[<c-\\>]]
    lvim.builtin.terminal.execs = {
        { "zsh", "<c-\\>", "zsh", "float" },
        { "zsh", "<c-]>", "zsh", "horizontal" },
        { "lazygit", "<c-g>", "LazyGit", "float" },
    }

    -- Notify popup
    lvim.builtin.notify.active = true
    lvim.log.level = "info"
end

function M.tab(fallback)
    local methods = require("lvim.core.cmp").methods
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local copilot_keys = vim.fn["copilot#Accept"]()
    if cmp.visible() then
        cmp.select_next_item()
    elseif vim.api.nvim_get_mode().mode == "c" then
        fallback()
    elseif copilot_keys ~= "" then -- prioritise copilot over snippets
        -- Copilot keys do not need to be wrapped in termcodes
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
    elseif luasnip.expandable() then
        luasnip.expand()
    elseif methods.jumpable() then
        luasnip.jump(1)
    elseif methods.check_backspace() then
        fallback()
    else
        methods.feedkeys("<Plug>(Tabout)", "")
    end
end

function M.shift_tab(fallback)
    local methods = require("lvim.core.cmp").methods
    local luasnip = require "luasnip"
    local cmp = require "cmp"
    if cmp.visible() then
        cmp.select_prev_item()
    elseif vim.api.nvim_get_mode().mode == "c" then
        fallback()
    elseif methods.jumpable(-1) then
        luasnip.jump(-1)
    else
        local copilot_keys = vim.fn["copilot#Accept"]()
        if copilot_keys ~= "" then
            methods.feedkeys(copilot_keys, "i")
        else
            methods.feedkeys("<Plug>(Tabout)", "")
        end
    end
end

function M.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

return M
