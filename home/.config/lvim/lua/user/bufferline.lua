local M = {}
M.config = function()
    local kind = require "user.lsp"
    local List = require "plenary.collections.py_list"
    local g_ok, bufferline_groups = pcall(require, "bufferline.groups")
    if not g_ok then
        bufferline_groups = { builtin = { ungrouped = { name = "ungrouped" } } }
    end
    lvim.builtin.bufferline.options.show_buffer_icons = true
    lvim.builtin.bufferline.options.show_buffer_close_icons = true
    lvim.builtin.bufferline.options.diagnostics = false -- do not show diagnostics in bufferline
    lvim.builtin.bufferline.options.diagnostics_indicator = function(_, _, diagnostics)
        local result = {}
        local symbols = { error = kind.icons.error, warning = kind.icons.warn, info = kind.icons.info }
        for name, count in pairs(diagnostics) do
            if symbols[name] and count > 0 then
                table.insert(result, symbols[name] .. count)
            end
        end
        result = table.concat(result, " ")
        return #result > 0 and result or ""
    end

    lvim.builtin.bufferline.options.groups = {
        options = {
            toggle_hidden_on_enter = true,
        },
        items = {
            M.language_files("rust", "#ff6965", "rs"),
            M.language_files("python", "#006400", "py"),
            M.language_files("kotlin", "#966fd6", "kt"),
            M.language_files("java", "#966fd6", "java"),
            M.language_files("lua", "#ffaa1d", "lua"),
            M.language_files("ruby", "#ff6965", "rb"),
            M.language_files("smithy", "#ffff66", "smithy"),
            {
                highlight = { guisp = "#51AFEF" },
                name = "tests",
                icon = kind.icons.test,
                matcher = function(buf)
                    return buf.filename:match "_spec" or buf.filename:match "test_"
                end,
            },
            {
                highlight = { guisp = "#C678DD" },
                name = "docs",
                matcher = function(buf)
                    local list = List { "md", "org", "norg", "wiki", "rst", "txt" }
                    return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
                end,
            },
            {
                highlight = { guisp = "#F6A878" },
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
                        or buf.filename:match "setting.gradle.kts"
                end,
            },
            { name = bufferline_groups.builtin.ungrouped.name },
        },
    }
    lvim.builtin.bufferline.options.separator_style = "slant"
    lvim.builtin.bufferline.options.mode = "buffers"
    lvim.builtin.bufferline.options.sort_by = "insert_after_current"
end

M.language_files = function(name, guisp, extension)
    local opts = {
        highlight = { guisp = guisp },
        name = name,
        matcher = function(buf)
            return vim.fn.fnamemodify(buf.path, ":e") == extension
        end,
    }
    return opts
end

return M
