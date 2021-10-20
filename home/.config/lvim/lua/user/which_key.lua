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
    -- Mappings
    lvim.builtin.which_key.on_config_done = function(wk)
        local keys = {
            -- Find
            ["gf"] = {
                name = "Find",
                b = { "<cmd>lua require('user.telescope').file_browser()<cr>", "File browser" },
                f = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" },
                l = {
                    "<cmd>lua require('user.telescope').grep_last_search({layout_strategy = \"vertical\"})<cr>",
                    "Last Search",
                },
                p = { "<cmd>lua require('user.telescope').project_search()<cr>", "Project" },
                r = { "<cmd>lua require('user.telescope').recent_files()<cr>", "Recent files" },
                s = { "<cmd>lua require('user.telescope').find_string()<cr>", "Find string in file" },
                z = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "Certain Filetype" },
            },
            -- Buffers
            ["gq"] = { "<cmd>BufferClose<cr>", "Close buffer" },
            ["gQ"] = { "<cmd>BufferClose!<cr>", "Force close buffer" },
            ["gB"] = { "<cmd>lua require('user.telescope').buffers()<cr>", "Buffers" },
            -- Session management
            ["gh"] = {
                name = "Session",
                s = { "<cmd>lua require('persistence').load()<cr>", "Restore for current dir" },
                l = { "<cmd>lua require('persistence').load({ last = true})<cr>", "Restore last session" },
                d = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
            },
            -- Git
            ["gG"] = {
                name = "Git",
                b = { "<cmd>GitBlameToggle<cr>", "Toggle inline git blame" },
                B = { "<cmd>Git blame<cr>", "Open git blame" },
                L = {
                    "<cmd>lua require('user.amzn').link_to_code_browser(1, vim.api.nvim_win_get_cursor(0)[1])<cr>",
                    "Copy browser line",
                },
            },
        }
        wk.register(keys, { mode = "n" })
    end
end

return M
