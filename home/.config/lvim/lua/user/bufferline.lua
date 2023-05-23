local M = {}

M.config = function()
    vim.cmd "function! TbToggle_theme(a,b,c,d) \n lua require('user.theme').toggle_theme() \n endfunction"
    vim.cmd "function! Quit_vim(a,b,c,d) \n qa \n endfunction"
    local icons = require("user.icons").icons
    local List = require "plenary.collections.py_list"
    lvim.builtin.bufferline.highlights = {
        fill = {
            bg = {
                attribute = "bg",
                highlight = "NormalNC",
            },
        },
        background = { italic = true },
        buffer_selected = { bold = true },
    }
    lvim.builtin.bufferline.options = {
        separator_style = "slant",
        indicator = { style = "none" },
        max_name_length = 20,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 25,
        color_icons = true,
        diagnostics_update_in_insert = false,
        show_close_icon = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_tab_indicators = true,
        navigation = { mode = "uncentered" },
        mode = "buffers",
        sort_by = "insert_after_current",
        always_show_bufferline = true,
        hover = { enabled = true, reveal = { "close" } },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diagnostics, _)
            local result = {}
            local symbols = { error = icons.error, warning = icons.warn }
            for name, count in pairs(diagnostics) do
                if symbols[name] and count > 0 then
                    table.insert(result, symbols[name] .. count)
                end
            end
            local res = table.concat(result, " ")
            return #res > 0 and res or ""
        end,
        groups = {
            options = {
                toggle_hidden_on_enter = true,
            },
            items = {
                require("bufferline.groups").builtin.pinned:with { icon = "⭐" },
                require("bufferline.groups").builtin.ungrouped,
                M.language_group("rs", "rs", "#b7410e"),
                M.language_group("py", "py", "#195905"),
                M.language_group("kt", "kt", "#75368f"),
                M.language_group("js", "java", "#7db700"),
                M.language_group("lua", "lua", "#ffb300"),
                M.language_group("rb", "rb", "#ff4500"),
                M.language_group("smithy", "smithy", "#009bff"),
                M.language_group("go", "go", "#214b77"),
                {
                    highlight = { sp = "#483d8b" },
                    name = "tests",
                    icon = icons.test,
                    matcher = function(buf)
                        return vim.api.nvim_buf_get_name(buf.id):match "_spec"
                            or vim.api.nvim_buf_get_name(buf.id):match "test_"
                    end,
                },
                {
                    highlight = { sp = "#636363" },
                    name = "docs",
                    matcher = function(buf)
                        local list = List { "md", "org", "norg", "wiki", "rst", "txt" }
                        return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
                    end,
                },
                {
                    highlight = { sp = "#636363" },
                    name = "cfg",
                    matcher = function(buf)
                        return vim.api.nvim_buf_get_name(buf.id):match "go.mod"
                            or vim.api.nvim_buf_get_name(buf.id):match "go.sum"
                            or vim.api.nvim_buf_get_name(buf.id):match "Cargo.toml"
                            or vim.api.nvim_buf_get_name(buf.id):match "manage.py"
                            or vim.api.nvim_buf_get_name(buf.id):match "config.toml"
                            or vim.api.nvim_buf_get_name(buf.id):match "setup.py"
                            or vim.api.nvim_buf_get_name(buf.id):match "Makefile"
                            or vim.api.nvim_buf_get_name(buf.id):match "Config"
                            or vim.api.nvim_buf_get_name(buf.id):match "gradle.properties"
                            or vim.api.nvim_buf_get_name(buf.id):match "build.gradle.kt"
                            or vim.api.nvim_buf_get_name(buf.id):match "settings.gradle.kt"
                    end,
                },
                {
                    highlight = { sp = "#000000" },
                    name = "terms",
                    auto_close = true,
                    matcher = function(buf)
                        return buf.path:match "term://" ~= nil
                    end,
                },
            },
        },
        offsets = {
            {
                text = "EXPLORER",
                filetype = "neo-tree",
                highlight = "PanelHeading",
                text_align = "left",
                separator = true,
            },
            {
                text = "UNDOTREE",
                filetype = "undotree",
                highlight = "PanelHeading",
                separator = true,
            },
            {
                text = " LAZY",
                filetype = "lazy",
                highlight = "PanelHeading",
                separator = true,
            },
            {
                text = " DIFF VIEW",
                filetype = "DiffviewFiles",
                highlight = "PanelHeading",
                separator = true,
            },
        },
        custom_areas = {
            right = function()
                return {
                    { text = "%@TbToggle_theme@ " .. icons.magic .. " %X" },
                    { text = "%@Quit_vim@" .. icons.exit2 .. " %X", fg = "#f7768e" },
                }
            end,
        },
    }
end

M.language_group = function(name, extension, highlight)
    local opts = {
        highlight = { sp = highlight },
        name = name,
        matcher = function(buf)
            return vim.fn.fnamemodify(buf.path, ":e") == extension
        end,
    }
    return opts
end

M.delete_buffer = function()
    local fn = vim.fn
    local cmd = vim.cmd
    local buflisted = fn.getbufinfo { buflisted = 1 }
    local cur_winnr, cur_bufnr = fn.winnr(), fn.bufnr()
    if #buflisted < 2 then
        cmd "bd!"
        return
    end
    for _, winid in ipairs(fn.getbufinfo(cur_bufnr)[1].windows) do
        cmd(string.format("%d wincmd w", fn.win_id2win(winid)))
        cmd(cur_bufnr == buflisted[#buflisted].bufnr and "bp" or "bn")
    end
    cmd(string.format("%d wincmd w", cur_winnr))
    local is_terminal = fn.getbufvar(cur_bufnr, "&buftype") == "terminal"
    cmd(is_terminal and "bd! #" or "silent! confirm bd #")
end

return M
