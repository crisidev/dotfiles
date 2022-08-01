local M = {}

M.config = function()
    local status_ok, sidebar = pcall(require, "sidebar-nvim")
    if not status_ok then
        return
    end

    sidebar.setup {
        open = false,
        side = "right",
        initial_width = 40,
        enable_profile = false,
        sections = { "buffers", "diagnostics", "git" },
        datetime = {
            icon = "",
            format = "%a %b %d, %H:%M",
            clocks = {
                { name = "local" },
            },
        },
        -- TODO: some
        todos = {
            icon = "",
            ignored_paths = { "~" }, -- ignore certain paths, this will prevent huge folders like $HOME to hog Neovim with TODO searching
            initially_closed = false, -- whether the groups should be initially closed on start. You can manually open/close groups later.
        },
        bindings = {
            ["q"] = function()
                require("sidebar-nvim").close()
            end,
        },
        disable_closing_prompt = true,
    }
end

return M
