local M = {}

-- Function to replace local autocmds with global ones.

M.config = function()
    -- Colorscheme
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        desc = "Apply the custom colorschemes",
        callback = function()
            require("user.theme").telescope_theme {}
            require("user.theme").dashboard_theme()
            require("user.icons").define_dap_signs()
        end,
    })

    -- Cleanup.
    vim.api.nvim_clear_autocmds { pattern = "lir", group = "_filetype_settings" }
    vim.api.nvim_clear_autocmds { pattern = "*", group = "_lvim_colorscheme" }

    -- Custom group.
    vim.api.nvim_create_augroup("_lvim_user", {})

    -- Close Neotree during wq
    vim.api.nvim_create_autocmd("VimLeave", {
        group = "_lvim_user",
        pattern = "*",
        desc = "Close Neotree during quit",
        command = "Neotree close",
    })

    if lvim.builtin.nonumber_unfocus.active then
        vim.api.nvim_create_autocmd("WinEnter", {
            group = "_lvim_user",
            pattern = "*",
            desc = "Enable numbers",
            command = "set relativenumber number",
        })
        vim.api.nvim_create_autocmd("WinLeave", {
            group = "_lvim_user",
            pattern = "*",
            desc = "Disable numbers",
            command = "set norelativenumber nonumber",
        })
    end

    -- Codelense viewer
    vim.api.nvim_create_autocmd("CursorHold", {
        group = "_lvim_user",
        pattern = { "*.rs", "*.c", "*.cpp", "*.go", "*.ts", "*.tsx", "*.kt", "*.py", "*.pyi", "*.java" },
        desc = "Enable and refresh codelens",
        command = "lua require('user.codelens').show_line_sign()",
    })

    -- Terminal
    vim.api.nvim_create_autocmd("TermOpen", {
        group = "_lvim_user",
        pattern = "term://*",
        desc = "Set terminal keymappings",
        command = "lua require('user.keys').terminal_keys()",
    })

    -- Smithy filetype
    vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
        group = "_lvim_user",
        pattern = "*.smithy",
        desc = "Set the smithy filetype",
        command = "setfiletype smithy",
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = "_lvim_user",
        pattern = "*.md",
        desc = "Beautify markdown",
        callback = function()
            vim.cmd [[set syntax=markdown textwidth=80]]
            require("user.markdown_syntax").config()
        end,
    })

    -- Disable colorcolumn
    vim.api.nvim_create_autocmd("BufEnter", {
        group = "_lvim_user",
        pattern = "*",
        desc = "Disable the ANNOYING colorcolumn",
        command = "set colorcolumn=",
    })

    -- Disable undo for certain files
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = "_lvim_user",
        pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
        desc = "Disable undo for specific files",
        callback = function()
            vim.opt_local.undofile = false
        end,
    })

    -- Allow hlslense in scrollbar
    vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = "_lvim_user",
        pattern = "*",
        desc = "Allow hlslense in scrollbar",
        command = "lua ok, sb = pcall(require, 'scrollbar.handlers.search'); if ok then sb.handler.hide() end",
    })

    -- Start metals
    vim.api.nvim_create_autocmd("Filetype", {
        group = "_lvim_user",
        pattern = { "scala", "sbt" },
        desc = "Start Scala metals",
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

    if lvim.builtin.inlay_hints.active then
        vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
        vim.api.nvim_create_autocmd("LspAttach", {
            group = "LspAttach_inlayhints",
            callback = function(args)
                if not (args.data and args.data.client_id) then
                    return
                end
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                require("lsp-inlayhints").on_attach(client, bufnr)
            end,
        })
    end
end

return M
