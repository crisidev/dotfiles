local M = {}

M.config = function()
    local icons = require("user.icons").icons
    vim.g.blamer_enabled = 0
    vim.g.blamer_prefix = " " .. icons.magic .. " "
    vim.g.blamer_template = "<committer-time> • <author> • <summary>"
    vim.g.blamer_relative_time = 1
    vim.g.blamer_delay = 200
    vim.cmd "highlight Blamer guifg=#d3d3d3"
end

return M
