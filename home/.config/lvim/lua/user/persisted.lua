local M = {}

M.config = function()
    require("persisted").setup {
        use_git_branch = true,
        autosave = true,
        autoload = false,
        after_source = function()
            -- Reload the LSP servers
            vim.lsp.stop_client(vim.lsp.get_active_clients())
        end,
        telescope = {
            before_source = function()
                -- Close all open buffers
                -- Thanks to https://github.com/avently
                vim.api.nvim_input "<ESC>:%bd<CR>"
            end,
            after_source = function(session)
                vim.notify("Loaded session " .. session.name)
            end,
        },
    }
end

return M
