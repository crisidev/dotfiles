local M = {}

M.config = function()
    local status_ok, noice = pcall(require, "noice")
    if not status_ok then
        return
    end
    local icons = require("user.icons").icons
    noice.setup {
        presets = {
            bottom_search = true,
        },
        lsp = {
            progress = { enabled = false },
            messages = { enabled = false },
            hover = { enabled = false },
            signature = { enabled = false, auto_open = { enabled = false } },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        cmdline = {
            view = "cmdline",
            format = {
                filter = { pattern = "^:%s*!", icon = icons.term, ft = "sh" },
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
        popupmenu = {
            enabled = false,
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
                filter = {
                    event = "msg_show",
                    find = "no valid signature or incorrect lsp reponse",
                },
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
                filter = { find = "nil" },
                opts = { skip = true },
            },
        },
    }
end

return M
