local M = {}

M.config = function()
    -- Lsp config
    local status_ok, rust_tools = pcall(require, "rust-tools")
    if not status_ok then
        return
    end

    local opts = {
        tools = {
            executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
            reload_workspace_from_cargo_toml = true,
            inlay_hints = {
                auto = true,
                only_current_line = true,
                show_parameter_hints = true,
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
            on_attach = require("lvim.lsp").common_on_attach,
            on_init = require("lvim.lsp").common_on_init,
            standalone = false,
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        features = "all",
                    },
                },
            },
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
