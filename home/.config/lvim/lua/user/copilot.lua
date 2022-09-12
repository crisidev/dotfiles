local M = {}

local icons = require("user.icons").icons

M.config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    vim.g.copilot_filetypes = {
        ["*"] = false,
        sh = true,
        python = true,
        ruby = true,
        lua = true,
        go = true,
        rust = true,
        html = true,
        c = true,
        cpp = true,
        java = true,
        javascript = true,
        typescript = true,
        javascriptreact = true,
        typescriptreact = true,
        terraform = true,
    }
end

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

M.status = function()
    if M.enable() then
        print(icons.copilot .. " Copilot is running")
    else
        print(icons.ls_inactive .. "Copilot is NOT running")
    end
end

M.help = function()
    if lvim.builtin.copilot.active then
        print(icons.ls_inactive .. "Copilot.lua has no help")
    else
        M.status()
    end
end

M.logs = function()
    if lvim.builtin.copilot.active then
        print(icons.ls_inactive .. "See copilot.lua LSP logs")
    else
        M.status()
    end
end

M.enable = function()
    if lvim.builtin.copilot.active then
        vim.defer_fn(function()
            local home = os.getenv "HOME"
            require("copilot").setup {
                cmp_method = "getCompletionsCycling",
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
