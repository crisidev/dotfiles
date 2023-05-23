local M = {}

-- Function to replace local autocmds with global ones.

M.config = function()
    -- Colorscheme
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        desc = "Apply the custom colorschemes",
        callback = function()
            require("user.theme").telescope_theme()
            require("user.theme").dashboard_theme()
            require("user.icons").define_dap_signs()
            if lvim.use_icons == false and lvim.builtin.custom_web_devicons then
                require("user.icons").set_icon()
            end
        end,
    })

    -- Cleanup.
    vim.api.nvim_clear_autocmds { pattern = "lir", group = "_filetype_settings" }
    vim.api.nvim_clear_autocmds { pattern = "*", group = "_lvim_colorscheme" }

    -- Custom group.
    vim.api.nvim_create_augroup("_lvim_user", {})

    -- Prevent entering buffers in insert mode.
    vim.api.nvim_create_autocmd("WinLeave", {
        group = "_lvim_user",
        desc = "Prevent entering buffers in insert mode.",
        callback = function()
            if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
            end
        end,
    })

    -- Close Neotree during wq
    vim.api.nvim_create_autocmd("VimLeave", {
        group = "_lvim_user",
        pattern = "*",
        desc = "Close Neotree during quit",
        command = "Neotree close",
    })

    -- Codelense viewer
    vim.api.nvim_create_autocmd("CursorHold", {
        group = "_lvim_user",
        pattern = { "*.rs", "*.c", "*.cpp", "*.go", "*.ts", "*.tsx", "*.py", "*.pyi", "*.java" },
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
    if lvim.builtin.metals.active then
        vim.api.nvim_create_autocmd("Filetype", {
            group = "_lvim_user",
            pattern = { "scala", "sbt" },
            desc = "Start Scala metals",
            callback = require("user.lsp.scala").start,
        })
    end

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

    -- Build tools mappings
    vim.api.nvim_create_augroup("_build_tools", {})
    vim.api.nvim_create_augroup("_format_tools", {})

    -- Cargo.toml
    vim.api.nvim_create_autocmd("FileType", {
        group = "_build_tools",
        pattern = "toml",
        desc = "Set additional buffer keymaps for Cargo.toml",
        callback = require("user.lsp.toml").build_tools,
    })

    -- Rust
    vim.api.nvim_create_autocmd("FileType", {
        group = "_build_tools",
        pattern = { "rust", "rs" },
        desc = "Set additional buffer keymaps for Rust files",
        callback = require("user.lsp.rust").build_tools,
    })

    -- Python
    vim.api.nvim_create_autocmd("FileType", {
        group = "_build_tools",
        pattern = "python",
        desc = "Set additional buffer keymaps for Python files",
        callback = require("user.lsp.python").build_tools,
    })
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --     group = "_format_tools",
    --     pattern = { "*.py", "*.pyi" },
    --     callback = function()
    --         require("lvim.lsp.utils").format {
    --             timeout_ms = 2500,
    --             filter = require("lvim.lsp.utils").format_filter,
    --         }
    --     end,
    -- })

    -- Java
    vim.api.nvim_create_autocmd("FileType", {
        group = "_build_tools",
        pattern = "java",
        desc = "Set additional buffer keymaps for Java files",
        callback = function(_args)
            require("user.lsp.java").config()
            require("user.lsp.java").build_tools()
        end,
    })

    -- Js/Ts
    vim.api.nvim_create_autocmd("FileType", {
        group = "_build_tools",
        pattern = { "typescript", "javascript" },
        desc = "Set additional buffer keymaps for Typescript files",
        callback = require("user.lsp.typescript").build_tools,
    })

    -- Go
    vim.api.nvim_create_autocmd("FileType", {
        group = "_build_tools",
        pattern = "go",
        desc = "Set additional buffer keymaps for Go files",
        callback = require("user.lsp.go").build_tools,
    })

    -- Kotlin
    vim.api.nvim_create_autocmd("FileType", {
        group = "_build_tools",
        pattern = "kotlin",
        desc = "Set additional buffer keymaps for Kotlin files",
        callback = require("user.lsp.kotlin").build_tools,
    })
end

return M
