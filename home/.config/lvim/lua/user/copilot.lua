local M = {}

local icons = require("user.icons").icons

M.enabled = function()
    if lvim.builtin.copilot.active then
        for idx, source in pairs(vim.lsp.buf_get_clients()) do
            if source.name == "copilot" then
                return true
            end
        end
    end
    return false
end

M.enable = function()
    if lvim.builtin.copilot.active then
        vim.defer_fn(function()
            local home = vim.env.HOME
            require("copilot").setup {
                plugin_manager_path = home .. "/.local/share/lunarvim" .. "/site/pack/packer",
            }
        end, 100)
    end
end

M.disable = function()
    if lvim.builtin.copilot.active then
        for idx, source in pairs(vim.lsp.buf_get_clients()) do
            if source.name == "copilot" then
                vim.lsp.stop_client(source.id)
            end
        end
    end
end

M.restart = function()
    M.disable()
    M.enable()
end

return M
