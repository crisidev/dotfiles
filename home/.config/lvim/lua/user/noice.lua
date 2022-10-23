local M = {}

M.config = function()
    local status_ok, noice = pcall(require, "noice")
    if not status_ok then
        return
    end
    noice.setup {
        lsp_progress = {
            enabled = false,
        },
        cmdline = {
            view = "cmdline",
            view_search = "cmdline",
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
