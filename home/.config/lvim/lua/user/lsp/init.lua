local M = {}

M.show_documentation = function()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand "<cword>")
    elseif vim.fn.expand "%:t" == "Cargo.toml" then
        require("crates").show_popup()
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand "<cword>")
    elseif filetype == "rust" then
        local found, rt = pcall(require, "rust-tools")
        if found then
            rt.hover_actions.hover_actions()
        else
            vim.lsp.buf.hover()
        end
    else
        vim.lsp.buf.hover()
    end
end

M.config = function()
    local icons = require("user.icons").icons
    -- Log level
    vim.lsp.set_log_level "error"

    -- Installer
    vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
        "clangd",
        "gopls",
        "golangci_lint_ls",
        "jdtls",
        "pyright",
        "rust_analyzer",
        "tsserver",
        "yamlls",
        "grammar_guard",
    })
    lvim.lsp.document_highlight = true
    lvim.lsp.code_lens_refresh = true

    -- Disable inline diagnostics
    lvim.lsp.diagnostics.virtual_text = false
    -- LSP lines
    vim.diagnostic.config { virtual_lines = false }

    -- Setup diagnostics icons
    lvim.lsp.diagnostics.signs.values = {
        { name = "DiagnosticSignError", text = icons.error },
        { name = "DiagnosticSignWarn", text = icons.warn },
        { name = "DiagnosticSignInfo", text = icons.info },
        { name = "DiagnosticSignHint", text = icons.hint },
    }

    -- Borders
    lvim.lsp.float.border = {
        { "╔", "FloatBorder" },
        { "═", "FloatBorder" },
        { "╗", "FloatBorder" },
        { "║", "FloatBorder" },
        { "╝", "FloatBorder" },
        { "═", "FloatBorder" },
        { "╚", "FloatBorder" },
        { "║", "FloatBorder" },
    }
    lvim.lsp.diagnostics.float.border = {
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
    }
    if vim.env.KITTY_WINDOW_ID then
        lvim.lsp.float.border = {
            { "🭽", "FloatBorder" },
            { "▔", "FloatBorder" },
            { "🭾", "FloatBorder" },
            { "▕", "FloatBorder" },
            { "🭿", "FloatBorder" },
            { "▁", "FloatBorder" },
            { "🭼", "FloatBorder" },
            { "▏", "FloatBorder" },
        }
        lvim.lsp.diagnostics.float.border = lvim.lsp.float.border
    end

    -- Float
    lvim.lsp.diagnostics.float.focusable = false
    lvim.lsp.float.focusable = true
    lvim.lsp.diagnostics.float.source = "if_many"
    lvim.lsp.document_highlight = true
    lvim.lsp.code_lens_refresh = true

    local default_exe_handler = vim.lsp.handlers["workspace/executeCommand"]
    vim.lsp.handlers["workspace/executeCommand"] = function(err, result, ctx, config)
        -- supress NULL_LS error msg
        if err and vim.startswith(err.message, "NULL_LS") then
            return
        end
        return default_exe_handler(err, result, ctx, config)
    end

    -- Configure null-ls
    require("user.null_ls").config()

    -- Configure Lsp providers
    require("user.lsp.python").config()
    require("user.lsp.go").config()
    require("user.lsp.yaml").config()
    require("user.lsp.toml").config()
    require("user.lsp.markdown").config()

    -- Mappings
    require("user.comment").config()
    require("user.lsp.keys").config()
    require("user.debugprint").config()
end

return M
