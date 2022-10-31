local M = {}

M.config = function()
    local status_ok, possession = pcall(require, "possession")
    if not status_ok then
        return
    end
    local Path = require "plenary.path"
    possession.setup {
        session_dir = (Path:new(vim.fn.stdpath "data") / "possession"):absolute(),
        silent = false,
        load_silent = true,
        debug = false,
        prompt_no_cr = false,
        autosave = {
            current = false, -- or fun(name): boolean
            tmp = false, -- or fun(): boolean
            tmp_name = "tmp",
            on_load = true,
            on_quit = true,
        },
        hooks = {
            before_load = function(name, user_data)
                vim.cmd "%bdelete"
                socket = require "socket"
                socket.sleep(1)
                return user_data
            end,
        },
        plugins = {
            close_windows = false,
            delete_hidden_buffers = false,
            nvim_tree = false,
            tabby = false,
            delete_buffers = false,
        },
    }
end

return M
