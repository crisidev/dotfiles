local M = {}

M.config = function()
    lvim.builtin.terminal.autochdir = true
    lvim.builtin.terminal.active = true
    lvim.builtin.terminal.execs = {}
end

local ok, terminal = pcall(require, "toggleterm.terminal")
if not ok then
    return M
end

M.float_terminal_toggle = function(cmd, id)
    local term = terminal.Terminal:new {
        cmd = cmd,
        hidden = true,
        direction = "float",
        float_opts = {
            border = "curved",
        },
        on_open = function(_)
            vim.cmd "startinsert!"
        end,
        on_close = function(_) end,
        count = id,
    }
    term:toggle()
end

M.horizontal_terminal_toggle = function(cmd, id, size)
    local term = terminal.Terminal:new {
        cmd = cmd,
        hidden = true,
        direction = "horizontal",
        on_open = function(_)
            vim.cmd "startinsert!"
        end,
        on_close = function(_) end,
        count = id,
        size = size,
    }
    term:toggle()
end

return M
