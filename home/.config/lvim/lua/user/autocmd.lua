local M = {}

M.config = function()
    -- Autocommands
    lvim.autocommands.custom_groups = {
        -- Goyo
        { "User", "GoyoEnter", "Limelight" },
        { "User", "GoyoLeave", "Limelight!" },
        -- Rust
        { "FileType", "rust", "nmap <silent> K :lua vim.lsp.buf.hover()<cr>"},
        -- Shell
        { "FileType", "sh,zsh", "setlocal ts=2 sw=2 sts=2 et"},
        -- LSP diagnostics
        { "CursorMoved", "*", "lua require('user.lsp').echo_diagnostic()"},
    }
end

return M
