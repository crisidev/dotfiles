local M = {}

M.config = function()
    local status_ok, rust_tools = pcall(require, "rust-tools")
    if not status_ok then
        return
    end

    local extension_path = "/home/bigo/.local/share/codelldb/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    local lsp_installer_servers = require "nvim-lsp-installer.servers"
    local _, requested_server = lsp_installer_servers.get_server "rust_analyzer"

    local opts = {
        tools = {
            autoSetHints = true,
            hover_with_actions = true,
            executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
            runnables = {
                use_telescope = true,
                prompt_prefix = "  ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "descending",
                layout_strategy = "vertical",
                layout_config = {
                    width = 0.3,
                    height = 0.50,
                    preview_cutoff = 0,
                    prompt_position = "bottom",
                },
            },
            debuggables = {
                use_telescope = true,
            },
            inlay_hints = {
                only_current_line = true,
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
                auto_focus = true,
            },
        },
        dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        server = {
            cmd_env = requested_server._default_options.cmd_env,
            on_attach = require("lvim.lsp").common_on_attach,
            on_init = require("lvim.lsp").common_on_init,
        },
    }
    rust_tools.setup(opts)
end

return M
