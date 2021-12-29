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
        -- Buffers
        ["gb"] = {
            name = "Buffers",
            b = { "<cmd>lua require('user.telescope').buffers()<cr>", "Show buffers" },
            P = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
            p = { "<cmd>BufferLineCyclePrev<cr>", "Pick buffer" },
            n = { "<cmd>BufferLineCycleNext<cr>", "Pick buffer" },
        },
        -- Find
        ["gf"] = {
            name = "Find",
            f = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" },
            F = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "File certain filetype" },
            b = { "<cmd>lua require('user.telescope').file_browser()<cr>", "File browser" },
            l = {
                "<cmd>lua require('user.telescope').grep_last_search({layout_strategy = \"vertical\"})<cr>",
                "Last Search",
            },
            p = { "<cmd>Telescope projects<cr>", "Projects" },
            s = { "<cmd>lua require('user.telescope').find_string()<cr>", "Find string in file" },
            r = { "<cmd>lua require('user.telescope').recent_files()<cr>", "Recent files" },
            z = { "<cmd>lua require'telescope'.extensions.zoxide.list{}<cr>", "Zoxide list" },
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
                "<cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require('gitlinker.actions').copy_to_clipboard})<cr>",
                "Copy line",
                silent = false,
            },
            L = {
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
    -- Command palette
    lvim.builtin.which_key.mappings["C"] = {
        "<cmd>lua require('telescope').extensions.command_palette.command_palette()<cr>",
        "Command Palette",
    }
    -- Mappings
    lvim.builtin.which_key.on_config_done = function(wk)
        local v_keys = {
            ["gG"] = {
                name = "Git",
                l = {
                    "<cmd>lua require('gitlinker').get_buf_range_url('v', {action_callback = require('gitlinker.actions').copy_to_clipboard})<cr>",
                    "Copy line",
                },
                L = {
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
