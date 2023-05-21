local M = {}

local icons = require("user.icons").icons

M.enabled = function()
    if lvim.builtin.copilot.active then
        for idx, source in pairs(vim.lsp.get_active_clients()) do
            if source.name == "copilot" then
                return true
            end
        end
    end
    return false
end

M.help = function()
    vim.notify [[
Copilot suggestions mapping:
    accept = alt-l
    next = alt-]
    prev = alt-[
    dismiss = ctrl-]

Copilot panel mapping:
    jump_prev = [[
    jump_next = \]\]
    accept = enter
    refresh = gr
    open = alt-enter
    ]]
end

M.enable = function()
    if lvim.builtin.copilot.active then
        vim.defer_fn(function()
            local home = vim.env.HOME
            require("copilot").setup {
                server_opts_overrides = {
                    settings = {
                        advanced = {
                            listCount = 10, -- #completions for panel
                            inlineSuggestCount = 5, -- #completions for getCompletions
                        },
                    },
                },
                filetypes = {
                    yaml = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                    ["*"] = true,
                },
                plugin_manager_path = home .. "/.local/share/lunarvim" .. "/site/pack/lazy",
            }
        end, 100)
    end
end

M.disable = function()
    if lvim.builtin.copilot.active then
        for idx, source in pairs(vim.lsp.get_active_clients()) do
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
