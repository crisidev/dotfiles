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
        should_autosave = function()
            -- do not autosave if the alpha dashboard is the current filetype
            if vim.bo.filetype == "alpha" or vim.bo.filetype == "neo-tree" then
                return false
            end
            return true
        end,
        telescope = { -- options for the telescope extension
            reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
            -- jump between session smoothly
            after_source = function(param)
                vim.api.nvim_command "%bd"
                local path = param.dir_path
                if string.find(path, "/") ~= 1 then
                    vim.api.nvim_command("cd " .. vim.fn.expand "~" .. "/" .. path)
                    vim.api.nvim_command("tcd " .. vim.fn.expand "~" .. "/" .. path)
                else
                    vim.api.nvim_command("cd " .. path)
                    vim.api.nvim_command("tcd " .. path)
                end
            end,
        },
        silent = false,
    }
end

return M
