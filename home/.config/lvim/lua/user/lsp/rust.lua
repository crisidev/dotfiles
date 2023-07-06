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
                auto = false,
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
        server = {
            on_attach = function(client, bufnr)
                require("lvim.lsp").common_on_attach(client, bufnr)
            end,
            on_init = require("lvim.lsp").common_on_init,
            capabilities = require("lvim.lsp").common_capabilities(),
            settings = {
                ["rust-analyzer"] = {
                    inlayHints = {
                        locationLinks = false,
                    },
                    lens = {
                        enable = true,
                    },
                    checkOnSave = {
                        enable = true,
                        command = "check",
                    },
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
    else
        vim.notify("please reinstall codellb, cannot find liblldb or codelldb", vim.log.levels.WARN)
    end
    rust_tools.setup(opts)
end

M.build_tools = function()
    local which_key = require "which-key"
    local icons = require "user.icons"
    local opts = {
        mode = "n",
        prefix = "f",
        buffer = vim.fn.bufnr(),
        silent = true,
        noremap = true,
        nowait = true,
    }
    local mappings = {
        K = { "<cmd>RustOpenExternalDocs<cr>", icons.icons.docs .. "Open docs.rs" },
        B = {
            name = icons.languages.rust .. " Build helpers",
            a = { "<cmd>lua require('rust-tools').hove_actions.hover_actions()<cr>", "Hover actions" },
            A = { "<cmd>lua require('rust-tools').code_action_group.code_action_group()<cr>", "Code action group" },
            r = { "<cmd>lua require('rust-tools').runnables.runnables()<cr>", "Run targes" },
            R = { "<cmd>lua require('rust-tools').debuggables.debuggables()<cr>", "Debug targes" },
            e = { "<cmd>lua require('rust-tools').expand_macro.expand_macro()<cr>", "Expand macro" },
            m = { "<cmd>lua require('rust-tools').parent_module.parent_module()<cr>", "Parent module" },
            u = { "<cmd>lua require('rust-tools').move_item.move_item(true)<cr>", "Move item up" },
            d = { "<cmd>lua require('rust-tools').move_item.move_item(false)<cr>", "Move item down" },
            H = { "<cmd>lua require('rust-tools').hover_range.hover_range()<cr>", "Hover range" },
            c = { "<cmd>lua require('rust-tools').open_cargo_toml.open_cargo_toml()<cr>", "Open Cargo.toml" },
            j = { "<cmd>lua require('rust-tools').join_lines.join_lines()", "Join lines" },
            w = { "<cmd>RustReloadWorkspace<cr>", "Reload workspace" },
            D = { "<cmd>RustOpenExternalDocs<cr>", "Open docs.rs" },
        },
    }
    which_key.register(mappings, opts)
end

return M
