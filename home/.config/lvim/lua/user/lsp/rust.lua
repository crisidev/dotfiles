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
                auto_focus = true,
            },
        },
        server = {
            on_attach = require("lvim.lsp").common_on_attach,
            on_init = require("lvim.lsp").common_on_init,
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        features = "all",
                    },
                },
            },
        },
    }
    local path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/")
    local codelldb_path = path .. "adapter/codelldb"
    local liblldb_path = path .. "lldb/lib/liblldb.so"

    if vim.fn.has "mac" == 1 then
        liblldb_path = path .. "lldb/lib/liblldb.dylib"
    end

    if vim.fn.filereadable(codelldb_path) and vim.fn.filereadable(liblldb_path) then
        opts.dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        }
    end
    rust_tools.setup(opts)

    lvim.format_on_save = {
        pattern = "*.rs",
        timeout = 2000,
        filter = require("lvim.lsp.utils").format_filter,
    }
end

return M
