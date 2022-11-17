local M = {}

M.config = function()
    local status_ok, persisted = pcall(require, "persisted")
    if not status_ok then
        return
    end
    persisted.setup {
        use_git_branch = true,
        autosave = true,
        autoload = false,
        after_source = function()
            -- Reload the LSP servers
            vim.lsp.stop_client(vim.lsp.get_active_clients())
        end,
    }
end

return M
