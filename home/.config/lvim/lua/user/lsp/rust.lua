local M = {}

M.config = function()
    -- Lsp config
    local status_ok, rust_tools = pcall(require, "rust-tools")
    if not status_ok then
        return
    end

    local lsp_installer_servers = require "nvim-lsp-installer.servers"
    local _, requested_server = lsp_installer_servers.get_server "rust_analyzer"

    local opts = {
        tools = {
            autoSetHints = true,
            hover_with_actions = false,
            executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
            inlay_hints = {
                only_current_line = true,
                only_current_line_autocmd = "CursorHold",
                show_variable_name = true,
                show_parameter_hints = false,
                parameter_hints_prefix = "in: ",
                other_hints_prefix = " out: ",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "SpecialComment",
            },
            hover_actions = {
                border = {
                    { "╭", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "╮", "FloatBorder" },
                    { "│", "FloatBorder" },
                    { "╯", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "╰", "FloatBorder" },
                    { "│", "FloatBorder" },
                },
                auto_focus = false,
            },
        },
        server = {
            cmd_env = requested_server._default_options.cmd_env,
            on_attach = require("lvim.lsp").common_on_attach,
            on_init = require("lvim.lsp").common_on_init,
            standalone = true,
        },
    }
    local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.7.3/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    opts.dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    }
    rust_tools.setup(opts)
end

return M
