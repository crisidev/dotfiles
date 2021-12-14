local M = {}

M.n_keys = function()
    local ok, lazygit = pcall(require, "toggleterm.terminal")
    if ok then
        local t = lazygit.Terminal:new { cmd = "lazygit", hidden = true }
        function _lazygit_toggle()
            t:toggle()
        end
    end
    return {
        -- Find
        ["gf"] = {
            name = "Find",
            F = { "<cmd>lua require('user.telescope').file_browser()<cr>", "File browser" },
            f = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" },
            B = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
            b = { "<cmd>lua require('user.telescope').buffers()<cr>", "Show buffers" },
            l = {
                "<cmd>lua require('user.telescope').grep_last_search({layout_strategy = \"vertical\"})<cr>",
                "Last Search",
            },
            L = {
                "<cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<cr>",
                "Live grep",
            },
            p = { "<cmd>Telescope projects<cr>", "Projects" },
            s = { "<cmd>lua require('user.telescope').find_string()<cr>", "Find string in file" },
            z = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "Certain Filetype" },
        },
        -- Buffers
        ["gq"] = { "<cmd>SmartQ<cr>", "Close buffer" },
        ["gQ"] = { "<cmd>SmartQ!<cr>", "Force close buffer" },
        -- Session management
        ["gh"] = {
            name = "Session",
            s = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
            l = { "<cmd>lua require('persistence').load({ last = true})<cr>", "Restore last session" },
            q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
        },
        -- Git
        ["gv"] = { "<cmd>lua _lazygit_toggle()<cr>", "LazyGit" },
        ["gG"] = {
            name = "Git",
            b = { "<cmd>GitBlameToggle<cr>", "Toggle inline git blame" },
            B = { "<cmd>Git blame<cr>", "Open git blame" },
            d = { "<cmd>DiffviewOpen<cr>", "Git diff" },
            g = { "<cmd>lua _lazygit_toggle()<cr>", "LazyGit" },
            l = {
                "<cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require('gitlinker.actions').open_in_browser})<cr>",
                "Open line in browser",
                silent = true,
            },
        },
    }
end

M.config = function()
    lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<cr>", "Projects" }
    lvim.builtin.which_key.mappings["B"] = { "<cmd>lua require('user.telescope').buffers()<cr>", "Buffers" }
    lvim.builtin.which_key.mappings["N"] = { "<cmd>Telescope file_create<CR>", "Create new file" }

    -- Close buffer with Leader-q
    lvim.builtin.which_key.mappings["q"] = { "<cmd>SmartQ<cr>", "Close buffer" }
    lvim.builtin.which_key.mappings["Q"] = { "<cmd>quit<cr>", "Quit" }
    -- Goyo
    lvim.builtin.which_key.mappings["G"] = { "<cmd>Goyo 90%x90%<cr>", "Start Goyo" }
    -- Mappings
    lvim.builtin.which_key.on_config_done = function(wk)
        local v_keys = {
            ["gG"] = {
                name = "Git",
                l = {
                    "<cmd>lua require('gitlinker').get_buf_range_url('v', {action_callback = require('gitlinker.actions').open_in_browser})<cr>",
                    "Open line in browser",
                },
            },
        }
        wk.register(M.n_keys(), { mode = "n" })
        wk.register(v_keys, { mode = "v" })
    end
end

return M
