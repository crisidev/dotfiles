-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Rust tools mappings
lvim.lsp.buffer_mappings.normal_mode["gT"] = {
    name = "Rust Tools",
    a = { "<cmd>RustCodeAction<cr>", "Code action" },
    i = { "<cmd>RustToggleInlayHints<cr>", "Toggle inlay hints" },
    r = { "<cmd>RustRunnables<cr>", "Run targes" },
    D = { "<cmd>RustDebuggables<cr>", "Debug targes" },
    e = { "<cmd>RustExpandMacro<cr>", "Expand macro" },
    m = { "<cmd>RustExpandMacro<cr>", "Parent module" },
    u = { "<cmd>RustMoveItemUp<cr>", "Move item up" },
    d = { "<cmd>RustMoveItemDown<cr>", "Move item down" },
    h = { "<cmd>RustHoverActions<cr>", "Hover actions" },
    H = { "<cmd>RustHoverRange<cr>", "Hover range" },
    c = { "<cmd>RustOpenCargo<cr>", "Open Cargo.toml" },
}
lvim.lsp.buffer_mappings.normal_mode["gH"] = {
    "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo clippy;read',count=2,direction='float'})<cr>",
    "Run build help",
}
