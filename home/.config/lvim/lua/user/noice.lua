local M = {}

M.config = function()
    local status_ok, noice = pcall(require, "noice")
    if not status_ok then
        return
    end
    local icons = require("user.icons").icons
    local spinners = require "noice.util.spinners"
    spinners.spinners["mine"] = {
        frames = {
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
            " ",
        },
        interval = 80,
    }
    noice.setup {
        format = {
            spinner = {
                name = "mine",
            },
        },
        presets = {
            bottom_search = true,
            inc_rename = true,
            lsp_doc_border = true,
            command_palette = false,
        },
        lsp = {
            progress = {
                enabled = true,
                format = {
                    { "{spinner}", hl_group = "NoiceLspProgressSpinner" },
                    { "{data.progress.percentage} ", hl_group = "NoiceLspProgressClient" },
                    { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
                },
                format_done = {},
            },
            hover = { enabled = true },
            signature = { enabled = false, auto_open = { enabled = false } },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = false,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        cmdline = {
            view = "cmdline",
            format = {
                cmdline = { pattern = "^:", icon = "", lang = "vim" },
                search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
                search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" },
                filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
                help = { pattern = "^:%s*h%s+", icon = "" },
                calculator = { pattern = "^=", icon = "", lang = "vimnormal" },
                input = {},
            },
        },
        messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "split",
            view_search = false,
        },
        popupmenu = {
            enabled = true,
            backend = "nui",
            kind_icons = {},
        },
        commands = {
            history = {
                view = "split",
                opts = { enter = true, format = "details" },
                filter = {
                    any = {
                        { event = "notify" },
                        { error = true },
                        { warning = true },
                        { event = "msg_show", kind = { "" } },
                        { event = "lsp", kind = "message" },
                    },
                },
            },
            last = {
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = {
                    any = {
                        { event = "notify" },
                        { error = true },
                        { warning = true },
                        { event = "msg_show", kind = { "" } },
                        { event = "lsp", kind = "message" },
                    },
                },
                filter_opts = { count = 1 },
            },
            errors = {
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = { error = true },
                filter_opts = { reverse = true },
            },
        },
        views = {
            cmdline = {
                win_options = {
                    winblend = 5,
                    winhighlight = {
                        Normal = "NormalFloat",
                        FloatBorder = "NoiceCmdlinePopupBorder",
                        IncSearch = "",
                        Search = "",
                    },
                    cursorline = false,
                },
            },
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    find = "%d+L, %d+B",
                },
                view = "mini",
            },
            {
                view = "cmdline_output",
                filter = { cmdline = "^:", min_height = 5 },
                -- BUG: will be fixed after https://github.com/neovim/neovim/issues/21044 gets merged
            },
            {
                filter = { event = "msg_show", kind = "search_count" },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "; before #",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "; after #",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = " lines, ",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "go up one level",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "yanked",
                },
                opts = { skip = true },
            },
            {
                filter = { find = "No information available" },
                opts = { skip = true },
            },
            {
                filter = { find = "No active Snippet" },
                opts = { skip = true },
            },
            {
                filter = { find = "waiting for cargo metadata" },
                opts = { skip = true },
            },
            {
                filter = { find = "E21: Cannot make changes, 'modifiable' is off" },
                opts = { skip = true },
            },
            {
                filter = { find = "E433: No tags file" },
                opts = { skip = true },
            },
            {
                filter = { find = "E426: Tag not found:" },
                opts = { skip = true },
            },
        },
    }
end

return M
