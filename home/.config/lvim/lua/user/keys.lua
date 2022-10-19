local M = {}

M.which_keys_normal = function()
    local icons = require("user.icons").icons
    local picker = require "window-picker"

    function _pick_window()
        local picked_window_id = picker.pick_window {
            include_current_win = true,
        } or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(picked_window_id)
    end

    -- Find
    lvim.builtin.which_key.mappings["F"] = {
        name = icons.telescope .. " Find",
        f = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" },
        p = { "<cmd>lua require('user.telescope').find_project_files()<cr>", "Find files" },
        F = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "File certain filetype" },
        b = { "<cmd>lua require('user.telescope').file_browser()<cr>", "File browser" },
        p = { "<cmd>lua require('user.telescope').projects()<cr>", "Projects" },
        s = { "<cmd>lua require('user.telescope').find_string()<cr>", "Find string" },
        S = { "<cmd>lua require('user.telescope').find_identifier()<cr>", "Find identifier under cursor" },
        r = { "<cmd>lua require('user.telescope').recent_files()<cr>", "Recent files" },
        R = { "<cmd>lua require('user.telescope').raw_grep()<cr>", "Raw grep" },
        z = { "<cmd>lua require('user.telescope').zoxide()<cr>", "Zoxide list" },
    }
    lvim.builtin.which_key.mappings["T"] = {
        "<cmd>lua require('user.telescope').resume()<cr>",
        icons.clock .. "Last Search",
    }
    lvim.builtin.which_key.mappings["i"] = {
        "<cmd>lua require('user.telescope').find_identifier()<cr>",
        icons.find .. " Find identifier",
    }

    -- File browser
    lvim.builtin.which_key.mappings["E"] = {
        "<cmd>lua require('user.telescope').file_browser()<cr>",
        icons.folder .. " File browser",
    }

    -- File search
    lvim.builtin.which_key.mappings["f"] = {
        "<cmd>lua require('user.telescope').find_project_files()<cr>",
        icons.files .. "Find files",
    }

    -- File browser
    lvim.builtin.which_key.mappings["C"] = {
        "<cmd>lua require('user.telescope').neoclip()<cr>",
        icons.docs .. "Clipboard",
    }

    -- Noice
    lvim.builtin.which_key.mappings["N"] = {
        "<cmd>lua require('user.telescope').noice()<cr>",
        icons.package .. " Noice",
    }

    -- String search
    lvim.builtin.which_key.mappings["s"] = {
        "<cmd>lua require('user.telescope').find_string()<cr>",
        icons.find .. " Find string",
    }

    -- Recent files
    lvim.builtin.which_key.mappings["r"] = {
        "<cmd>lua require('user.telescope').recent_files()<cr>",
        icons.calendar .. "Recent files",
    }

    -- Zoxide
    lvim.builtin.which_key.mappings["z"] = {
        "<cmd>lua require('user.telescope').zoxide()<cr>",
        "Z Zoxide",
    }

    -- Zen mode
    lvim.builtin.which_key.mappings["Z"] = {
        "<cmd>ZenMode<cr>",
        icons.screen .. "Zen mode",
    }

    -- Buffers
    lvim.builtin.which_key.mappings["B"] = {
        name = icons.buffers .. "Buffers",
        b = { "<cmd>lua require('user.telescope').buffers()<cr>", "Show buffers" },
        l = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
        P = { "<cmd>BufferLineTogglePin<cr>", "Pin/Unpin buffer" },
        p = { "<cmd>BufferLineCyclePrev<cr>", "Next buffer" },
        n = { "<cmd>BufferLineCycleNext<cr>", "Prev buffer" },
    }
    lvim.builtin.which_key.mappings["b"] = {
        "<cmd>lua require('user.telescope').buffers()<cr>",
        icons.buffers .. "Show buffers",
    }

    -- Sessions
    lvim.builtin.which_key.mappings["S"] = {
        name = icons.session .. "Session",
        l = { "<cmd>lua require('user.telescope').persisted()<cr>", "List available sessions" },
        d = { "<cmd>SessionDelete<cr>", "Delete session" },
        L = { "<cmd>SessionLoadLast<cr>", "Restore last session" },
        c = { "<cmd>SessionLoad<cr>", "Restore current dir session" },
        s = { "<cmd>SessionSave<cr>", "Save current session" },
    }

    -- Git
    lvim.builtin.which_key.mappings["g"] = {
        name = " Git",
        b = { "<cmd>BlamerToggle<cr>", "Toggle inline git blame" },
        B = { "<cmd>Git blame<cr>", "Open git blame" },
        g = { "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='lazygit'})<cr>", "LazyGit" },
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
    }

    -- Replace
    lvim.builtin.which_key.mappings["R"] = {
        name = icons.replace .. " Replace",
        f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Current Buffer" },
        p = { "<cmd>lua require('spectre').open()<cr>", "Project" },
        w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
    }

    -- Grammarous
    lvim.builtin.which_key.mappings["H"] = {
        name = icons.grammar .. "Grammarous",
        c = { "<cmd>GrammarousCheck<cr>", "Run grammar check" },
        p = { "<Plug>(grammarous-move-to-previous-error)", "Goto previous error" },
        n = { "<Plug>(grammarous-move-to-next-error)", "Goto next error" },
        f = { "<Plug>(grammarous-fixit)", "Fix the error under the cursor" },
        F = { "<Plug>(grammarous-fixall)", "Fix all errors int the document" },
        o = { "<Plug>(grammarous-open-info-window)", "Open info window" },
        q = { "<Plug>(grammarous-close-info-window)", "Close info window" },
        d = { "<Plug>(grammarous-disable-rule)", "Disable rule under cursor" },
    }

    -- Nvimtree
    if lvim.builtin.tree_provider == "neo-tree" then
        lvim.builtin.which_key.mappings["e"] = { "<cmd>NeoTreeRevealToggle<CR>", icons.world .. "Explorer" }
    else
        lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<cr>", icons.world .. "Explorer" }
    end

    -- Save
    lvim.builtin.which_key.mappings["w"] = { "<cmd>w!<cr>", icons.ok .. " Save buffer" }

    -- Window picket
    lvim.builtin.which_key.mappings["W"] = { "<cmd>lua _pick_window()<cr>", icons.world .. "Pick window" }

    -- Close buffer with Leader-q
    lvim.builtin.which_key.mappings["q"] =
    { "<cmd>lua require('user.bufferline').delete_buffer()<cr>", icons.no .. " Close buffer" }
    lvim.builtin.which_key.mappings["Q"] = { "<cmd>config qall<cr>", icons.no .. " Close all" }

    -- Dashboard
    lvim.builtin.which_key.mappings[";"] = { "<cmd>Alpha<CR>", icons.dashboard .. "Dashboard" }

    -- Telescope resume
    lvim.builtin.which_key.mappings["t"] = {
        "<cmd>lua require('user.telescope').resume()<CR>",
        icons.resume .. "Last action",
    }

    -- Telescope suggest spell
    lvim.builtin.which_key.mappings["G"] = {
        "<cmd>lua require('user.telescope').spell_suggest()<cr>",
        icons.grammar .. "Spelling",
    }

    -- Comment
    lvim.builtin.which_key.mappings["/"] = {
        "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
        icons.comment .. " Comment",
    }

    -- Names
    lvim.builtin.which_key.mappings["L"]["name"] = icons.moon .. " Lunarvim"
    lvim.builtin.which_key.mappings["p"]["name"] = icons.package .. " Packer"

    -- Disable
    lvim.builtin.which_key.mappings["h"] = nil
    lvim.builtin.which_key.mappings["l"] = nil
    lvim.builtin.which_key.mappings["n"] = nil
    lvim.builtin.which_key.mappings["c"] = nil
end

M.which_keys_visual = function()
    local icons = require("user.icons").icons

    lvim.builtin.which_key.vmappings["g"] = {
        name = " Git",
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
    }
    -- String search
    lvim.builtin.which_key.vmappings["s"] = {
        "<cmd>lua require('user.telescope').find_string_visual()<cr>",
        icons.find .. " Find string",
    }
end

-- NORMAL MODE
M.normal_keys = function()
    lvim.keys.normal_mode = {
        -- Buffers
        ["<F1>"] = "<cmd>BufferLineCyclePrev<cr>",
        ["<F2>"] = "<cmd>BufferLineCycleNext<cr>",
        ["<A-S-Left>"] = "<cmd>BufferLineMovePrev<cr>",
        ["<A-S-Right>"] = "<cmd>BufferLineMoveNext<cr>",
        -- Toggle tree
        ["<F3>"] = "<cmd>NeoTreeRevealToggle<cr>",
        -- ["<S-F3>"] = "<cmd>NvimTreeRefresh<cr>",
        -- Toggle sidebar
        ["<F5>"] = "<cmd>MouseToggle<cr>",
        -- Yank current path
        ["<F6>"] = '<cmd>let @+ = expand("%:p")<cr>',
        -- Symbols vista
        ["<F10>"] = "<cmd>Vista!!<cr>",
        -- Toggle numbers
        ["<F11>"] = "<cmd>NoNuMode<cr>",
        ["<F12>"] = "<cmd>NuModeToggle<cr>",
        -- Windows navigation
        ["<A-Up>"] = "<cmd>wincmd k<cr>",
        ["<A-Down>"] = "<cmd>wincmd j<cr>",
        ["<A-Left>"] = "<cmd>wincmd h<cr>",
        ["<A-Right>"] = "<cmd>wincmd l<cr>",
        -- Align text
        ["<"] = "<<",
        [">"] = ">>",
        -- Yank to the end of line
        ["Y"] = "y$",
        -- Toggle terminals
        ["<C-\\>"] = "<cmd>lua require('user.terminal').float_terminal_toggle('zsh', 100)<cr>",
        ["<C-]>"] = "<cmd>lua require('user.terminal').horizontal_terminal_toggle('zsh', 101, 20)<cr>",
        ["<C-g>"] = "<cmd>lua require('user.terminal').float_terminal_toggle('lazygit', 102)<cr>",
        ["<C-B>"] = "<cmd>lua require('user.terminal').horizontal_terminal_toggle('bemol --watch', 103, 10)<cr>",
        -- Legendary
        ["<C-P>"] = "<cmd>lua require('legendary').find()<cr>",
    }

    -- File explorer
    if lvim.builtin.tree_provider == "neo-tree" then
        lvim.keys.normal_mode["<F3>"] = { "<cmd>NeoTreeRevealToggle<cr>" }
    else
        lvim.keys.normal_mode["<F3>"] = { "<cmd>NvimTreeToggle<cr>" }
        lvim.keys.normal_mode["<S-F3>"] = { "<cmd>NvimTreeRefresh<cr>" }
    end
end

local Terminal = require("toggleterm.terminal").Terminal

M.float_terminal_toggle = function(cmd)
    local term = Terminal:new {
        cmd = cmd,
        hidden = true,
        direction = "float",
        on_open = function(_)
            vim.cmd "startinsert!"
        end,
        on_close = function(_) end,
        count = 99,
    }
    term:toggle()
end

-- INSERT MODE
M.insert_keys = function()
    lvim.keys.insert_mode = {
        -- Buffers
        ["<F1>"] = "<esc><cmd>BufferLineCyclePrev<cr>",
        ["<F2>"] = "<esc><cmd>BufferLineCycleNext<cr>",
        ["<A-S-Left>"] = "<cmd>BufferLineMovePrev<cr>",
        ["<A-S-Right>"] = "<cmd>BufferLineMoveNext<cr>",
        -- Toggle mouse
        ["<F5>"] = "<esc><cmd>MouseToggle<cr>",
        -- Yank current path
        ["<F6>"] = '<esc><cmd>let @+ = expand("%:p")<cr>',
        -- Symbols vista
        ["<F10>"] = "<esc><cmd>Vista!!<cr>",
        -- Windows navigation
        ["<A-Up>"] = "<cmd>wincmd k<cr>",
        ["<A-Down>"] = "<cmd>wincmd j<cr>",
        ["<A-Left>"] = "<cmd>wincmd h<cr>",
        ["<A-Right>"] = "<cmd>wincmd l<cr>",
        -- Paste with Ctrl-v
        ["<C-v>"] = "<C-r><C-o>+",
        -- Snippets
        ["<C-s>"] = "<cmd>lua require('telescope').extensions.luasnip.luasnip{}<cr>",
        -- Toggle terminals
        ["<C-\\>"] = "<cmd>lua require('user.terminal').float_terminal_toggle('zsh', 100)<cr>",
        ["<C-]>"] = "<cmd>lua require('user.terminal').horizontal_terminal_toggle('zsh', 101, 20)<cr>",
        ["<C-g>"] = "<cmd>lua require('user.terminal').float_terminal_toggle('lazygit', 102)<cr>",
        ["<C-B>"] = "<cmd>lua require('user.terminal').horizontal_terminal_toggle('bemol --watch', 103, 10)<cr>",
    }

    -- File explorer
    if lvim.builtin.tree_provider == "neo-tree" then
        lvim.keys.insert_mode["<F3>"] = { "<esc><cmd>NeoTreeRevealToggle<cr>" }
    else
        lvim.keys.insert_mode["<F3>"] = { "<esc><cmd>NvimTreeToggle<cr>" }
        lvim.keys.insert_mode["<S-F3>"] = { "<esc><cmd>NvimTreeRefresh<cr>" }
    end
end

-- VISUAL MODE
M.visual_keys = function()
    lvim.keys.visual_mode = {
        -- Yank with Ctrl-c
        ["<C-c>"] = '"+yi',
        -- Cut with Ctrl-x
        ["<C-x>"] = '"+c',
        -- Paste with Ctrl-v
        ["<C-v>"] = 'c<Esc>"+p',
    }
end

M.hlslens_keys = function()
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap(
        "n",
        "n",
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
        opts
    )
    vim.api.nvim_set_keymap(
        "n",
        "N",
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
        opts
    )
    vim.api.nvim_set_keymap("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", opts)
    vim.api.nvim_set_keymap("n", "#", "#<Cmd>lua require('hlslens').start()<CR>", opts)
end

M.terminal_keys = function()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

M.config = function()
    lvim.builtin.which_key.setup.icons = {
        breadcrumb = "/", -- symbol used in the command line area that shows your active key combo
        separator = "·", -- symbol used between a key and it's label
        group = "", -- symbol prepended to a group
    }
    lvim.builtin.which_key.setup.window.winblend = 10
    lvim.builtin.which_key.setup.window.border = "none"
    lvim.builtin.which_key.setup.plugins.presets.z = true
    lvim.builtin.which_key.setup.plugins.presets.f = true
    lvim.builtin.which_key.setup.plugins.presets.windows = true
    lvim.builtin.which_key.setup.plugins.presets.nav = true
    lvim.builtin.which_key.setup.plugins.marks = true
    lvim.builtin.which_key.setup.plugins.registers = true
    lvim.builtin.which_key.setup.triggers = { "<leader>", "<space>", "f", "z", "]", "[" }
    lvim.builtin.which_key.setup.ignore_missing = false

    M.normal_keys()
    M.insert_keys()
    M.visual_keys()
    M.which_keys_normal()
    M.which_keys_visual()
end

return M
