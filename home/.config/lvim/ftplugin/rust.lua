-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "rustfmt",
        -- args = { },
        filetypes = { "rust" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Debugging
if lvim.builtin.dap.active then
    local dap_install = require "dap-install"
    dap_install.config("codelldb", {})
end

-- Rust tools mappings
lvim.lsp.buffer_mappings.normal_mode["gR"] = {
    name = "Rust",
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
