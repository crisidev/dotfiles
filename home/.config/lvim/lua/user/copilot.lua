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
        if lvim.builtin.copilot.cmp_source then
            for idx, source in pairs(vim.lsp.buf_get_clients()) do
                if source.name == "copilot" then
                    return true
                end
            end
        else
            return vim.g.copilot_enabled == 1
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
        if lvim.builtin.copilot.cmp_source then
            vim.cmd [[Copilot help"]]
        else
            print(icons.ls_inactive .. "Copilot.lua has no help")
        end
    end
end

M.logs = function()
    if lvim.builtin.copilot.active then
        if lvim.builtin.copilot.cmp_source then
            vim.cmd [[Copilot logs"]]
        else
            print(icons.ls_inactive .. "See copilot.lua LSP logs")
        end
    end
end

M.enable = function()
    if lvim.builtin.copilot.active then
        if lvim.builtin.copilot.cmp_source then
            vim.defer_fn(function()
                local home = os.getenv "HOME"
                require("copilot").setup {
                    plugin_manager_path = home .. "/.local/share/lunarvim" .. "/site/pack/packer",
                }
            end, 100)
        else
            vim.cmd [[
                Copilot enable
                Copilot split
            ]]
        end
    end
end

M.disable = function()
    if lvim.builtin.copilot.active then
        if lvim.builtin.copilot.cmp_source then
            for idx, source in pairs(vim.lsp.buf_get_clients()) do
                if source.name == "copilot" then
                    vim.lsp.stop_client(source.id)
                end
            end
        else
            vim.cmd [[Copilot disable]]
        end
    end
end

M.restart = function()
    M.disable()
    M.enable()
end

return M
