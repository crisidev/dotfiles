local M = {}

M.kind = {
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Default = " ",
    Enum = "練",
    EnumMember = " ",
    Event = " ",
    Field = " ", -- "ﰠ"
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Operator = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ", -- ""," "," "
    Struct = "舘",
    Text = " ",
    TypeParameter = "  ",
    Unit = "塞",
    Value = " ",
    Variable = " ",
    Copilot = " ",
}

M.config = function()
    local cmp = require "cmp"
    lvim.builtin.cmp.sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    }
    lvim.builtin.cmp.sources = {
        { name = "copilot", group_index = 1 },
        { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
        { name = "nvim_lsp", group_index = 1 },
        { name = "nvim_lsp_signature_help", group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "buffer", group_index = 1, max_item_count = 5, keyword_length = 4 },
        { name = "path", group_index = 1 },
        { name = "dictionary", group_index = 1, keyword_length = 4 },
        { name = "git", group_index = 1 },
        { name = "crates", group_index = 1 },
        { name = "emoji", group_index = 1 },
    }

    lvim.builtin.cmp.experimental = {
        ghost_text = false,
        native_menu = false,
        custom_menu = true,
    }
    local cmp_border = {
        { "╭", "CmpBorder" },
        { "─", "CmpBorder" },
        { "╮", "CmpBorder" },
        { "│", "CmpBorder" },
        { "╯", "CmpBorder" },
        { "─", "CmpBorder" },
        { "╰", "CmpBorder" },
        { "│", "CmpBorder" },
    }
    local cmp_sources = {
        ["vim-dadbod-completion"] = "(DadBod)",
        buffer = "(Buffer)",
        crates = "(Crates)",
        latex_symbols = "(LaTeX)",
        nvim_lua = "(NvLua)",
        copilot = "(Copilot)",
        dictionary = "(Dict)",
    }
    -- Borderless cmp
    vim.opt.pumblend = 4
    lvim.builtin.cmp.formatting.fields = { "abbr", "kind", "menu" }
    lvim.builtin.cmp.window = {
        completion = {
            border = cmp_border,
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
            border = cmp_border,
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
        },
    }
    lvim.builtin.cmp.formatting.format = function(entry, vim_item)
        if entry.source.name == "cmdline_history" or entry.source.name == "cmdline" then
            vim_item.kind = "⌘"
            vim_item.menu = ""
            return vim_item
        end
        vim_item.kind =
            string.format("%s %s", M.kind[vim_item.kind] or " ", cmp_sources[entry.source.name] or vim_item.kind)

        return vim_item
    end
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline {
            ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        },
        sources = {
            { name = "cmdline" },
            { name = "path" },
        },
        window = {
            completion = {
                border = cmp_border,
                winhighlight = "Search:None",
            },
        },
    })
    for _, cmd_type in ipairs { "/", "?" } do
        cmp.setup.cmdline(cmd_type, {
            mapping = cmp.mapping.preset.cmdline {},
            sources = {
                { name = "buffer" },
                { name = "path" },
            },
            window = {
                completion = {
                    border = cmp_border,
                    winhighlight = "Search:None",
                },
            },
        })
    end
    cmp.setup.filetype("kotlin", {
        sources = cmp.config.sources({
            { name = "copilot", group_index = 1 },
            { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
            { name = "nvim_lsp", group_index = 1 },
            { name = "buffer", group_index = 1, max_item_count = 5, keyword_length = 4 },
            { name = "path", group_index = 1 },
            { name = "dictionary", group_index = 1, keyword_length = 4 },
            { name = "emoji", group_index = 2 },
        }, {}),
    })
    cmp.setup.filetype("toml", {
        sources = cmp.config.sources({
            { name = "nvim_lsp", group_index = 1 },
            { name = "path", group_index = 1, max_item_count = 5 },
            { name = "buffer", group_index = 1 },
            { name = "crates", group_index = 1 },
            { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
        }, {}),
    })
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources {
            { name = "nvim_lsp", group_index = 1 },
            { name = "git", group_index = 1 },
            { name = "path", group_index = 1 },
            { name = "buffer", group_index = 1 },
            { name = "dictionary", group_index = 1 },
            { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
            { name = "emoji", group_index = 2 },
        },
    })
    cmp.setup.filetype("markdown", {
        sources = cmp.config.sources {
            { name = "nvim_lsp", group_index = 1 },
            { name = "path", group_index = 1 },
            { name = "dictionary", group_index = 1 },
            { name = "buffer", group_index = 1 },
            { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
            { name = "emoji", group_index = 2 },
        },
    })
end

return M
