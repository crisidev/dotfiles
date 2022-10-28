local M = {}

M.config = function()
    if lvim.builtin.noice.active then
        vim.lsp.handlers["textDocument/signatureHelp"] = require("noice.util").protect(require("noice.lsp").signature)
    end
    local status_ok, noice = pcall(require, "noice")
    if not status_ok then
        return
    end
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
                hl = "Constant",
            },
        },
        lsp = {
            progress = {
                enabled = lvim.builtin.noice.lsp_progress,
                format = {
                    { "{data.progress.percentage} ", hl_group = "Comment" },
                    { "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
                    { "{data.progress.title} ", hl_group = "Comment" },
                },
                format_done = {},
            },
            hover = { enabled = true },
            signature = { enabled = false, auto_open = false },
        },
        cmdline = {
            -- view = "cmdline",
            -- view_search = "cmdline",
            format = {
                filter = { pattern = "^:%s*!", icon = "", ft = "sh" },
                IncRename = {
                    pattern = "^:%s*IncRename%s+",
                    icon = " ",
                    conceal = true,
                    opts = {
                        relative = "cursor",
                        size = { min_width = 20 },
                        position = { row = -3, col = 0 },
                        buf_options = { filetype = "text" },
                    },
                },
            },
        },
        views = {
            cmdline_popup = {
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
                position = {
                    row = "93%",
                    col = "50%",
                },
            },
        },
        popupmenu = {
            enabled = false,
        },
        routes = {
            {
                filter = { event = "msg_show", kind = "search_count" },
                opts = { skip = true },
            },
            {
                view = "split",
                filter = { event = "msg_show", min_height = 30 },
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
                filter = { find = "No active Snippet" },
                opts = { skip = true },
            },
            -- Disabled filters.
            -- {
            --     view = "notify",
            --     filter = { event = "msg_showmode" },
            -- },
            -- {
            --     filter = { find = "more lines" },
            --     opts = { skip = true },
            -- },
            -- {
            --     filter = { find = "fewer lines" },
            --     opts = { skip = true },
            -- },
            -- {
            --     filter = {
            --         event = "msg_show",
            --         find = "E486:",
            --     },
            --     opts = { skip = true },
            -- },
        },
    }
end

return M
