local M = {}

M.kind = {
    Class = " ",
    Color = " ",
    Constant = "",
    Constructor = " ",
    Default = " ",
    Enum = "練",
    EnumMember = " ",
    Event = " ",
    Field = "ﰠ ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Keyword = " ",
    Method = "",
    Module = "",
    Operator = " ",
    Property = " ",
    Reference = "",
    Snippet = " ", -- ""," "," "
    Struct = "פּ",
    Text = " ",
    TypeParameter = "  ",
    Unit = "塞",
    Value = " ",
    Variable = "",
    Copilot = "",
}

M.config = function()
    lvim.builtin.cmp.sources = {
        { name = "nvim_lsp", group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "luasnip", group_index = 1, max_item_count = 5, keyword_length = 3 },
        { name = "path", group_index = 1, max_item_count = 5 },
        { name = "git", group_index = 1 },
        { name = "crates", group_index = 1 },
        { name = "nvim_lsp_signature_help", group_index = 1 },
        { name = "copilot", group_index = 1 },
        { name = "dictionary", group_index = 1 },
        { name = "spell", group_index = 1 },
        { name = "calc", group_index = 1 },
        { name = "emoji", group_index = 1 },
        { name = "buffer", group_index = 1, max_item_count = 5, keyword_length = 3 },
    }

    lvim.builtin.cmp.experimental = {
        ghost_text = false,
        native_menu = false,
        custom_menu = true,
    }
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
            vim_item.kind = M.kind[vim_item.kind] or vim_item.kind

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
    for _, cmd_type in ipairs { ":", "/", "?", "@" } do
        cmp.setup.cmdline(cmd_type, {
            mapping = cmp.mapping.preset.cmdline {
                ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            },
            sources = {
                { name = "cmdline", group_index = 1 },
                { name = "path", group_index = 1 },
                { name = "cmdline_history", group_index = 2, keyword_length = 5 },
            },
        })
    end
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
end

return M
