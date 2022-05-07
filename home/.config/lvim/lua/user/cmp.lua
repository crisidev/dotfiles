local M = {}

M.config = function()
    lvim.builtin.cmp.sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "buffer", max_item_count = 5, keyword_length = 5 },
        { name = "path", max_item_count = 5 },
        { name = "luasnip", max_item_count = 3 },
        { name = "nvim_lua" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
        { name = "dictionary", keyword_length = 2 },
        { name = "latex_symbols" },
        { name = "git" },
    }
    lvim.builtin.cmp.experimental = {
        ghost_text = true,
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
        latex_symbols = "(latex)",
        nvim_lsp_signature_help = "(sig)",
        git = "(git)",
    }
    local cmp_ok, cmp = pcall(require, "cmp")
    if not cmp_ok or cmp == nil then
        cmp = {
            mapping = function(...) end,
            setup = { filetype = function(...) end, cmdline = function(...) end },
            config = { sources = function(...) end },
        }
    end
    if lvim.builtin.fancy_wild_menu.active then
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline {},
            sources = {
                { name = "cmdline" },
                { name = "path" },
            },
        })
    end
    cmp.setup.filetype("toml", {
        sources = cmp.config.sources({
            { name = "path" },
            { name = "nvim_lsp", max_item_count = 8 },
            { name = "crates" },
            { name = "luasnip", max_item_count = 5 },
        }, {
            { name = "buffer", max_item_count = 5, keyword_length = 5 },
        }),
    })
    cmp.setup.filetype("tex", {
        sources = cmp.config.sources({
            { name = "latex_symbols", max_item_count = 3, keyword_length = 3 },
            { name = "nvim_lsp", max_item_count = 8 },
            { name = "luasnip", max_item_count = 5 },
        }, {
            { name = "buffer", max_item_count = 5, keyword_length = 5 },
        }),
    })
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "git" },
            { name = "path" },
            { name = "dictionary" },
            { name = "nvim_lsp", max_item_count = 8 },
            { name = "luasnip", max_item_count = 5 },
            { name = "emoji" },
        }, {
            { name = "buffer", max_item_count = 5, keyword_length = 5 },
        }),
    })
    cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
            { name = "path" },
            { name = "dictionary" },
            { name = "spell", keyword_length = 4 },
            { name = "luasnip", max_item_count = 5 },
            { name = "emoji" },
            { name = "calc" },
        }, {
            { name = "buffer", max_item_count = 5, keyword_length = 5 },
        }),
    })

    -- Evil stuff
    lvim.builtin.copilot = { active = true }
    if lvim.builtin.copilot.active then
        local function t(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        lvim.builtin.cmp.mapping["<c-h>"] = cmp.mapping(function()
            vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](t "<Tab>"), "n", true)
        end)
        lvim.keys.insert_mode["<M-]>"] = { "<Plug>(copilot-next)", { silent = true } }
        lvim.keys.insert_mode["<M-[>"] = { "<Plug>(copilot-previous)", { silent = true } }
        lvim.keys.insert_mode["<M-S-]>"] = { "<Cmd>vertical Copilot panel<CR>", { silent = true } }
        local cmp = require "cmp"
        lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(M.tab, { "i", "c" })
        lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(M.shift_tab, { "i", "c" })
    end
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
    elseif luasnip.expandable() then
        luasnip.expand()
    elseif methods.jumpable() then
        luasnip.jump(1)
    elseif copilot_keys ~= "" then -- prioritise copilot over snippets
        -- Copilot keys do not need to be wrapped in termcodes
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
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

return M
