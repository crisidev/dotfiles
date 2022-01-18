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
            l = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
            p = { "<cmd>BufferLineCyclePrev<cr>", "Next buffer" },
            n = { "<cmd>BufferLineCycleNext<cr>", "Prev buffer" },
        },
        -- Find
        ["gf"] = {
            name = "Find",
            f = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" },
            F = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "File certain filetype" },
            b = { "<cmd>lua require('user.telescope').file_browser()<cr>", "File browser" },
            l = { "<cmd>lua require('telescope.builtin').resume()<cr>", "Last Search" },
            p = { "<cmd>lua require('user.telescope').projects()<cr>", "Projects" },
            s = { "<cmd>lua require('user.telescope').find_string()<cr>", "Find string in file" },
            r = { "<cmd>lua require('user.telescope').recent_files()<cr>", "Recent files" },
            z = { "<cmd>lua require('user.telescope').zoxide()<cr>", "Zoxide list" },
        },
        -- Buffers
        ["gq"] = { "<cmd>SmartQ<cr>", "Close buffer" },
        ["gQ"] = { "<cmd>SmartQ!<cr>", "Force close buffer" },
        -- Session management
        ["gS"] = {
            name = "Session",
            l = { "<cmd>SessionManager load_session<cr>", "List available sessions" },
            d = { "<cmd>SessionManager delete_session<cr>", "Delete session" },
            L = { "<cmd>SessionManager load_last_session<cr>", "Restore last session" },
            c = { "<cmd>SessionManager load_current_dir_session<cr>", "Restore current dir session" },
            s = { "<cmd>SessionManager save_current_session<cr>", "Save current session" },
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
            s = { "<cmd>lua require('user.telescope').git_status()<cr>", "Repository status" },
            f = { "<cmd>lua require('user.telescope').git_files()<cr>", "Repository files" },
        },
        ["gN"] = {
            name = "Neogen",
            c = { "<cmd>lua require('neogen').generate({ type = 'class'})<CR>", "Class Documentation" },
            f = { "<cmd>lua require('neogen').generate({ type = 'func'})<CR>", "Function Documentation" },
            t = { "<cmd>lua require('neogen').generate({ type = 'type'})<CR>", "Type Documentation" },
            F = { "<cmd>lua require('neogen').generate({ type = 'file'})<CR>", "File Documentation" },
        },
    }
end

M.config = function()
    -- Settings
    lvim.builtin.which_key.setup.window.winblend = 10
    lvim.builtin.which_key.setup.window.border = "none"

    -- Telescope project
    lvim.builtin.which_key.mappings["P"] = {
        "<cmd>lua require('user.telescope').projects()<cr>",
        "Projects",
    }
    -- Telescope buffers
    lvim.builtin.which_key.mappings["B"] = { "<cmd>lua require('user.telescope').buffers()<cr>", "Buffers" }

    -- Close buffer with Leader-q
    lvim.builtin.which_key.mappings["q"] = { "<cmd>SmartQ<cr>", "Close buffer" }
    lvim.builtin.which_key.mappings["Q"] = { "<cmd>quit<cr>", "Quit" }
    -- Goyo
    lvim.builtin.which_key.mappings["G"] = { "<cmd>Goyo 90%x90%<cr>", "Start Goyo" }
    -- Command palette
    lvim.builtin.which_key.mappings["C"] = {
        "<cmd>lua require('user.telescope').command_palett()<cr>",
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
