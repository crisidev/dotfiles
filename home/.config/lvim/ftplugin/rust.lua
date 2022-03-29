-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Rust tools mappings
lvim.lsp.buffer_mappings.normal_mode["gT"] = {
    name = "☢ Rust Tools",
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
    name = " Build helpers",
    b = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo build;read',count=2,direction='float'})<cr>",
        "Run cargo build",
    },
    r = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo run;read',count=2,direction='float'})<cr>",
        "Run cargo run",
    },
    C = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo check;read',count=2,direction='float'})<cr>",
        "Run cargo check",
    },
    t = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo test;read',count=2,direction='float'})<cr>",
        "Run cargo test",
    },
    c = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo clippy;read',count=2,direction='float'})<cr>",
        "Run cargo clippy",
    },
    B = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo bench;read',count=2,direction='float'})<cr>",
        "Run cargo bench",
    },
}
