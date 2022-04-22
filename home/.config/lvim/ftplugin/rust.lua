-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Lsp config
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

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
            auto_focus = false,
        },
    },
    server = {
        cmd_env = requested_server._default_options.cmd_env,
        on_attach = require("lvim.lsp").common_on_attach,
        on_init = require("lvim.lsp").common_on_init,
    },
}
local extension_path = vim.fn.expand "~/" .. ".vscode/extensions/vadimcn.vscode-lldb-1.7.0"

local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

opts.dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
}
rust_tools.setup(opts)

-- Rust tools mappings
local icons = require("user.lsp").icons
lvim.lsp.buffer_mappings.normal_mode["gT"] = {
    name = icons.nuclear .. " Rust Tools",
    a = { "<cmd>RustCodeAction<cr>", "Code action" },
    i = { "<cmd>RustToggleInlayHints<cr>", "Toggle inlay hints" },
    r = { "<cmd>RustRunnables<cr>", "Run targes" },
    D = { "<cmd>RustDebuggables<cr>", "Debug targes" },
    e = { "<cmd>RustExpandMacro<cr>", "Expand macro" },
    m = { "<cmd>RustParentModule<cr>", "Parent module" },
    u = { "<cmd>RustMoveItemUp<cr>", "Move item up" },
    d = { "<cmd>RustMoveItemDown<cr>", "Move item down" },
    h = { "<cmd>RustHoverActions<cr>", "Hover actions" },
    H = { "<cmd>RustHoverRange<cr>", "Hover range" },
    c = { "<cmd>RustOpenCargo<cr>", "Open Cargo.toml" },
    R = { "<cmd>RustReloadWorkspace<cr>", "Reload workspace" },
}

lvim.lsp.buffer_mappings.normal_mode["gB"] = {
    name = icons.settings .. "Build helpers",
    b = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo build;read',count=2,direction='horizontal'})<cr>",
        "Run cargo build",
    },
    r = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo run;read',count=2,direction='horizontal'})<cr>",
        "Run cargo run",
    },
    C = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo check;read',count=2,direction='horizontal'})<cr>",
        "Run cargo check",
    },
    t = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo test;read',count=2,direction='horizontal'})<cr>",
        "Run cargo test",
    },
    c = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo clippy;read',count=2,direction='horizontal'})<cr>",
        "Run cargo clippy",
    },
    B = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo bench;read',count=2,direction='horizontal'})<cr>",
        "Run cargo bench",
    },
}
