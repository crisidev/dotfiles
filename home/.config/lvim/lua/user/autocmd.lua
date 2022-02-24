local M = {}

M.config = function()
    -- Autocommands
    lvim.autocommands.custom_groups = {
        -- Goyo
        { "User", "GoyoEnter", "Limelight" },
        { "User", "GoyoLeave", "Limelight!" },
        -- Disable Copilot
        { "BufRead", "*", "Copilot disable" },
        -- Codelense viewer
        { "CursorHold", "*.rs,*.go,*.ts,*.tsx", "lua require('user.codelens').show_line_sign()" },
        -- Configure crates on Cargo.toml
        {
            "BufRead,BufNewFile",
            "*Cargo.toml",
            "lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }",
        },
    }
end

return M
