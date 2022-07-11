local M = {}

-- Function to replace local autocmds with global ones.

M.config = function()
    local create_aucmd = vim.api.nvim_create_autocmd
    vim.api.nvim_create_augroup("_lvim_user", {})

    -- Codelense viewer
    create_aucmd("CursorHold", {
        group = "_lvim_user",
        pattern = { "*.c", "*.cpp", "*.go", "*.ts", "*.tsx", "*.kt", "*.py", "*.pyi", "*.java" },
        command = "lua require('user.codelens').show_line_sign()",
    })

    -- Terminal
    create_aucmd("TermOpen", {
        group = "_lvim_user",
        pattern = "term://*",
        command = "lua require('user.keys').set_terminal_keymaps()",
    })

    -- Smithy filetype
    create_aucmd("BufRead,BufNewFile", {
        group = "_lvim_user",
        pattern = "*.smithy",
        command = "setfiletype smithy",
    })

    -- Disable Copilot globally
    create_aucmd("BufRead", {
        group = "_lvim_user",
        pattern = "*",
        command = "lua require('user.copilot').disable()",
    })

    create_aucmd("BufWritePre", {
        group = "_lvim_user",
        pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
        callback = function()
            vim.opt_local.undofile = false
        end,
    })
end

return M
