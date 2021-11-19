local M = {}

M.config = function()
    -- Autocommands
    lvim.autocommands.custom_groups = {
        -- Goyo
        { "User", "GoyoEnter", "Limelight" },
        { "User", "GoyoLeave", "Limelight!" },
        -- Shell
        { "FileType", "sh,zsh", "setlocal ts=2 sw=2 sts=2 et" },
        -- Disable copilot for new files
        { "BufRead", "*", "Copilot disable" },
        -- LSP diagnostics
        -- { "CursorMoved", "*", "lua require('user.lsp').echo_diagnostic()" },
    }
    -- if not vim.g.neovide then
    --     table.insert(lvim.autocommands.custom_groups, { "BufRead", "*", "lua require('persistence').stop()" })
    -- end
end

return M
