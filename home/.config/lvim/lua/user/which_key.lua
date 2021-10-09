local M = {}

M.config = function()
    lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<cr>", "Projects" }
    lvim.builtin.which_key.mappings["B"] = { "<cmd>lua require('user.telescope').buffers()<cr>", "Buffers" }

    -- Rust tools
    lvim.builtin.which_key.mappings["R"] = {
        name = "Rust Tools",
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
    -- Close buffer with Leader-q
    lvim.builtin.which_key.mappings["q"] = { "<cmd>BufferClose<cr>", "Close buffer" }
    lvim.builtin.which_key.mappings["c"] = { "<cmd>set operatorfunc=CommentOperator<CR>g@l", "Comment out" }
    lvim.builtin.which_key.mappings["Q"] = { "<cmd>quit<cr>", "Quit" }
    -- Goyo
    lvim.builtin.which_key.mappings["G"] = { "<cmd>Goyo 90%x90%<cr>", "Start Goyo" }
end

return M
