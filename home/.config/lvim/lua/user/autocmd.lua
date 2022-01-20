local M = {}

M.config = function()
    -- Autocommands
    lvim.autocommands.custom_groups = {
        -- Goyo
        { "User", "GoyoEnter", "Limelight" },
        { "User", "GoyoLeave", "Limelight!" },
        -- Shell
        { "BufRead", "*", "Copilot disable" },
        -- LSP diagnostics
        -- { "CursorMoved", "*", "lua require('user.lsp').echo_diagnostic()" },
        -- Codelense viewer
        { "CursorHold", "*.rs,*.go,*.ts,*.tsx", "lua require('user.codelens').show_line_sign()" },
    }
end

return M
