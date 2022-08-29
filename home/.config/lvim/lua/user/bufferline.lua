local M = {}

M.config = function()
    local icons = require "user.icons"
    local List = require "plenary.collections.py_list"
    lvim.builtin.bufferline.highlights = {
        background = { italic = true },
        buffer_selected = { bold = true },
    }
    local g_ok, bufferline_groups = pcall(require, "bufferline.groups")
    if not g_ok then
        bufferline_groups = {
            builtin = {
                pinned = {
                    name = "pinned",
                    with = function(ico)
                        print(ico)
                    end,
                },
                ungroupued = { name = "ungrouped" },
            },
        }
    end
    lvim.builtin.bufferline.options = {
        navigation = { mode = "uncentered" },
        diagnostics = false, -- do not show diagnostics in bufferline
        diagnostics_indicator = function(_, _, diagnostics)
            local result = {}
            local symbols = { error = icons.error, warning = icons.warn, info = icons.info }
            for name, count in pairs(diagnostics) do
                if symbols[name] and count > 0 then
                    table.insert(result, symbols[name] .. count)
                end
            end
            result = table.concat(result, " ")
            return #result > 0 and result or ""
        end,

        mode = "buffers",
        sort_by = "insert_after_current",
        groups = {
            options = {
                toggle_hidden_on_enter = true,
            },
            items = {
                bufferline_groups.builtin.pinned:with { icon = "" },
                bufferline_groups.builtin.ungrouped,
                M.language_files("rust", "#ff6965", "rs"),
                M.language_files("python", "#006400", "py"),
                M.language_files("kotlin", "#966fd6", "kt"),
                M.language_files("java", "#966fd6", "java"),
                M.language_files("lua", "#ffaa1d", "lua"),
                M.language_files("ruby", "#ff6965", "rb"),
                M.language_files("smithy", "#ffff66", "smithy"),
                M.language_files("go", "#51AFEF", "go"),
                {
                    highlight = { sp = "#51AFEF" },
                    name = "tests",
                    icon = icons.test,
                    matcher = function(buf)
                        return buf.filename:match "_spec" or buf.filename:match "test_"
                    end,
                },
                {
                    highlight = { sp = "#C678DD" },
                    name = "docs",
                    matcher = function(buf)
                        local list = List { "md", "org", "norg", "wiki", "rst", "txt" }
                        return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
                    end,
                },
                {
                    highlight = { sp = "#F6A878" },
                    name = "cfg",
                    matcher = function(buf)
                        return buf.filename:match "go.mod"
                            or buf.filename:match "go.sum"
                            or buf.filename:match "Cargo.toml"
                            or buf.filename:match "manage.py"
                            or buf.filename:match "config.toml"
                            or buf.filename:match "setup.py"
                            or buf.filename:match "Makefile"
                            or buf.filename:match "Config"
                            or buf.filename:match "gradle.properties"
                            or buf.filename:match "build.gradle.kts"
                            or buf.filename:match "settings.gradle.kts"
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
                text = " FLUTTER OUTLINE",
                filetype = "flutterToolsOutline",
                highlight = "PanelHeading",
                separator = true,
            },
            {
                text = "UNDOTREE",
                filetype = "undotree",
                highlight = "PanelHeading",
                separator = true,
            },
            {
                text = " PACKER",
                filetype = "packer",
                highlight = "PanelHeading",
                separator = true,
            },
            {
                text = " DATABASE VIEWER",
                filetype = "dbui",
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
        separator_style = os.getenv "KITTY_WINDOW_ID" and "slant" or "thin",
        right_mouse_command = "vert sbuffer %d",
        show_close_icon = false,
        indicator = { style = "bold" },
        show_buffer_close_icons = true,
        diagnostics_update_in_insert = false,
    }
end

M.language_files = function(name, sp, extension)
    local opts = {
        highlight = { sp = sp },
        name = name,
        matcher = function(buf)
            return vim.fn.fnamemodify(buf.path, ":e") == extension
        end,
    }
    return opts
end

return M
