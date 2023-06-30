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
                only_current_line = false,
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
            a = { "<cmd>RustCodeAction<cr>", "Code action" },
            i = { "<cmd>RustToggleInlayHints<cr>", "Toggle inlay hints" },
            r = { "<cmd>RustRunnables<cr>", "Run targes" },
            R = { "<cmd>RustDebuggables<cr>", "Debug targes" },
            e = { "<cmd>RustExpandMacro<cr>", "Expand macro" },
            m = { "<cmd>RustParentModule<cr>", "Parent module" },
            u = { "<cmd>RustMoveItemUp<cr>", "Move item up" },
            d = { "<cmd>RustMoveItemDown<cr>", "Move item down" },
            h = { "<cmd>RustHoverActions<cr>", "Hover actions" },
            H = { "<cmd>RustHoverRange<cr>", "Hover range" },
            c = { "<cmd>RustOpenCargo<cr>", "Open Cargo.toml" },
            w = { "<cmd>RustReloadWorkspace<cr>", "Reload workspace" },
            D = { "<cmd>RustOpenExternalDocs<cr>", "Open documentation for identifier" },
        },
    }
    which_key.register(mappings, opts)
end

return M
