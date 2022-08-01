-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Rust tools mappings
local icons = require("user.icons").icons
local which_key = require "which-key"
which_key.register {
    ["f"] = {
        K = { "<cmd>RustOpenExternalDocs<cr>", icons.docs .. "Open docs.rs" },
        T = {
            name = icons.nuclear .. " Rust Tools",
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
        B = {
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
        },
    },
}
