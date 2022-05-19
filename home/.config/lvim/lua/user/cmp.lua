local M = {}

-- I am the king of the worl

M.config = function()
    lvim.builtin.cmp.sources = {
        -- Index 1
        { name = "nvim_lsp", group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
        { name = "buffer", group_index = 1, max_item_count = 5, keyword_length = 3 },
        { name = "path", group_index = 1, max_item_count = 5 },
        { name = "git", group_index = 1 },
        { name = "crates", group_index = 1 },
        { name = "dictionary", group_index = 1 },
        -- Index 2
        { name = "spell", group_index = 2 },
        { name = "cmdline", group_index = 2 },
        { name = "copilot", group_index = 2 },
        { name = "calc", group_index = 2 },
        { name = "emoji", group_index = 2 },
        { name = "treesitter", group_index = 2 },
        { name = "latex_symbols", group_index = 2 },
    }
    lvim.builtin.cmp.experimental = {
        ghost_text = false,
        native_menu = false,
        custom_menu = true,
    }
    local kind = require "user.lsp"
    local cmp_sources = {
        ["vim-dadbod-completion"] = "(DadBod)",
        buffer = "(Buffer)",
        crates = "(Crates)",
        latex_symbols = "(LaTeX)",
        nvim_lua = "(NvLua)",
        copilot = "(Copilot)",
        dictionary = "(Dict)",
        spell = "(Spell)",
    }
    lvim.builtin.cmp.formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            if entry.source.name == "cmdline" then
                vim_item.kind = "⌘"
                vim_item.menu = ""
                return vim_item
            end
            vim_item.menu = cmp_sources[entry.source.name] or vim_item.kind
            vim_item.kind = kind.cmp_kind[vim_item.kind] or vim_item.kind

            return vim_item
        end,
    }
    local cmp_ok, cmp = pcall(require, "cmp")
    if not cmp_ok or cmp == nil then
        cmp = {
            mapping = function(...) end,
            setup = { filetype = function(...) end, cmdline = function(...) end },
            config = { sources = function(...) end },
        }
    end
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline {},
        sources = {
            { name = "cmdline", group_index = 1 },
            { name = "path", group_index = 1 },
        },
    })
    cmp.setup.filetype("toml", {
        sources = cmp.config.sources({
            { name = "nvim_lsp", group_index = 1 },
            { name = "path", group_index = 1, max_item_count = 5 },
            { name = "crates", group_index = 1 },
            { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
        }, {
            { name = "buffer", group_index = 1, max_item_count = 5, keyword_length = 3 },
        }),
    })
    cmp.setup.filetype("tex", {
        sources = cmp.config.sources({
            { name = "nvim_lsp", group_index = 1 },
            { name = "latex_symbols", group_index = 1, max_item_count = 3, keyword_length = 3 },
            { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
        }, {
            { name = "buffer", group_index = 1, max_item_count = 5, keyword_length = 3 },
        }),
    })
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "nvim_lsp", group_index = 1 },
            { name = "git", group_index = 1 },
            { name = "path", group_index = 1, max_item_count = 5 },
            { name = "dictionary", group_index = 1 },
            { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
            { name = "emoji", group_index = 2 },
        }, {
            { name = "buffer", group_index = 1, max_item_count = 5, keyword_length = 3 },
        }),
    })
    cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
            { name = "nvim_lsp", group_index = 1 },
            { name = "path", group_index = 1, max_item_count = 5 },
            { name = "dictionary", group_index = 1 },
            { name = "spell", group_index = 1 },
            { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
            { name = "calc", group_index = 2 },
            { name = "emoji", group_index = 2 },
        }, {
            { name = "buffer", group_index = 1, max_item_count = 5, keyword_length = 3 },
        }),
    })

    -- Evil stuff
    if lvim.builtin.copilot.active and not lvim.builtin.copilot.cmp_source then
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
