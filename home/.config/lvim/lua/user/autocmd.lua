local M = {}

-- Function to replace local autocmds with global ones.

M.config = function()
    -- Autocommands
    vim.api.nvim_clear_autocmds { pattern = "lir", group = "_filetype_settings" }
    vim.api.nvim_create_augroup("_lvim_user", {})

    -- Codelense viewer
    vim.api.nvim_create_autocmd("CursorHold", {
        group = "_lvim_user",
        pattern = { "*.rs", "*.c", "*.cpp", "*.go", "*.ts", "*.tsx", "*.kt", "*.py", "*.pyi", "*.java" },
        command = "lua require('user.codelens').show_line_sign()",
    })

    -- Terminal
    vim.api.nvim_create_autocmd("TermOpen", {
        group = "_lvim_user",
        pattern = "term://*",
        command = "lua require('user.keys').terminal_keys()",
    })

    -- Smithy filetype
    vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
        group = "_lvim_user",
        pattern = "*.smithy",
        command = "setfiletype smithy",
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
        group = "_lvim_user",
        pattern = "*.md",
        command = "set syntax=markdown textwidth=80",
    })

    -- Disable colorcolumn
    vim.api.nvim_create_autocmd("BufEnter", {
        group = "_lvim_user",
        pattern = "*",
        command = "set colorcolumn=",
    })

    -- Disable undo for certain files
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = "_lvim_user",
        pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
        callback = function()
            vim.opt_local.undofile = false
        end,
    })

    -- Allow hlslense in scrollbar
    vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = "_lvim_user",
        pattern = "*",
        command = "lua ok, sb = pcall(require, 'scrollbar.handlers.search'); if ok then sb.handler.hide() end",
    })

    -- Start metals
    vim.api.nvim_create_autocmd("Filetype", {
        group = "_lvim_user",
        pattern = { "scala", "sbt" },
        callback = require("user.lsp.scala").start,
    })

    -- Faster yank
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = "_general_settings",
        pattern = "*",
        desc = "Highlight text on yank",
        callback = function()
            require("vim.highlight").on_yank { higroup = "Search", timeout = 200 }
        end,
    })

    -- Orgmode triggers
    vim.api.nvim_create_autocmd("Filetype", {
        group = "_lvim_user",
        pattern = { "org" },
        callback = function()
            lvim.builtin.which_key.setup.triggers = { "<leader>", "<space>", "g", "f", "z", "]", "[" }
        end,
    })
end

return M
