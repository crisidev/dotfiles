local M = {}

M.which_keys = function()
    local ok, term = pcall(require, "toggleterm.terminal")
    if ok then
        local t = term.Terminal:new { cmd = "lazygit", hidden = true }
        function lazygit_toggle()
            t:toggle()
        end
    end

    local icons = require("user.lsp").icons

    -- Find
    lvim.builtin.which_key.mappings["F"] = {
        name = icons.telescope .. " Find",
        f = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" },
        F = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "File certain filetype" },
        b = { "<cmd>lua require('user.telescope').file_browser()<cr>", "File browser" },
        c = { "<cmd>lua require('user.telescope').file_create()<cr>", "Create file" },
        t = { "<cmd>lua require('user.telescope').resume()<cr>", "Last Search" },
        p = { "<cmd>lua require('user.telescope').projects()<cr>", "Projects" },
        s = { "<cmd>lua require('user.telescope').find_string()<cr>", " Find string in file" },
        r = { "<cmd>lua require('user.telescope').recent_files()<cr>", "Recent files" },
        R = { "<cmd>lua require('user.telescope').raw_grep()<cr>", "Raw grep" },
        z = { "<cmd>lua require('user.telescope').zoxide()<cr>", "Zoxide list" },
    }

    -- File browser
    lvim.builtin.which_key.mappings["o"] = {
        "<cmd>lua require('user.telescope').file_browser()<cr>",
        icons.folder .. " File browser",
    }

    -- File search
    lvim.builtin.which_key.mappings["f"] = {
        "<cmd>lua require('user.telescope').find_files()<cr>",
        icons.files .. "Find files",
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
        "Z Zoxide list",
    }

    -- Zen mode
    lvim.builtin.which_key.mappings["Z"] = {
        "<cmd>ZenMode<cr>",
        icons.screen .. " Zen mode",
    }

    -- Buffers
    lvim.builtin.which_key.mappings["B"] = {
        name = icons.buffers .. "Buffers",
        b = { "<cmd>lua require('user.telescope').buffers()<cr>", "Show buffers" },
        l = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
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
        l = { "<cmd>SessionManager load_session<cr>", "List available sessions" },
        d = { "<cmd>SessionManager delete_session<cr>", "Delete session" },
        L = { "<cmd>SessionManager load_last_session<cr>", "Restore last session" },
        c = { "<cmd>SessionManager load_current_dir_session<cr>", "Restore current dir session" },
        s = { "<cmd>SessionManager save_current_session<cr>", "Save current session" },
    }

    -- Git
    lvim.builtin.which_key.mappings["g"] = {
        name = " Git",
        b = { "<cmd>GitBlameToggle<cr>", "Toggle inline git blame" },
        B = { "<cmd>Git blame<cr>", "Open git blame" },
        d = { "<cmd>DiffviewOpen<cr>", "Git diff" },
        g = { "<cmd>lua lazygit_toggle()<cr>", "LazyGit" },
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
        name = icons.grammar .. " Grammarous",
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
    lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<cr>", icons.docs .. "Explorer" }

    -- Save
    lvim.builtin.which_key.mappings["w"] = { "<cmd>w!<cr>", icons.ok .. " Save buffer" }

    -- Close buffer with Leader-q
    lvim.builtin.which_key.mappings["q"] = { "<cmd>SmartQ<cr>", icons.no .. " Close buffer" }
    lvim.builtin.which_key.mappings["Q"] = { "<cmd>SmartQ!<cr>", icons.no .. " Force close buffer" }

    -- Dashboard
    lvim.builtin.which_key.mappings[";"] = { "<cmd>Alpha<CR>", icons.dashboard .. "Dashboard" }

    -- Telescope resume
    lvim.builtin.which_key.mappings["t"] = {
        "<cmd>lua require('user.telescope').resume()<CR>",
        icons.resume .. " Telescope resume",
    }

    -- Telescope suggest spell
    lvim.builtin.which_key.mappings["G"] = {
        "<cmd>lua require('user.telescope').spell_suggest()<cr>",
        icons.spelling .. "Spelling",
    }

    -- Names
    lvim.builtin.which_key.mappings["L"]["name"] = icons.moon .. " Lunarvim"
    lvim.builtin.which_key.mappings["p"]["name"] = icons.package .. " Packer"

    -- Disable
    lvim.builtin.which_key.mappings["h"] = nil
    lvim.builtin.which_key.mappings["T"] = nil
    lvim.builtin.which_key.mappings["l"] = nil

    -- lvim.builtin.which_key.on_config_done = function(wk)
    --     wk.register(M.n_keys(), { mode = "n" })
    -- end
end

M.normal_insert_keys = function()
    -- NORMAL
    lvim.keys.normal_mode = {
        -- Toggle tree
        ["<F3>"] = "<cmd>NvimTreeToggle<cr>",
        ["<S-F3>"] = "<cmd>NvimTreeRefresh<cr>",
        -- Toggle mouse
        ["<F4>"] = "<cmd>SidebarNvimToggle<cr>",
        -- Toggle sidebar
        ["<F5>"] = "<cmd>MouseToggle<cr>",
        -- Yank current path
        ["<F6>"] = '<cmd>let @+ = expand("%:p")<cr>',
        -- Windows navigation
        ["<A-Up>"] = "<cmd>wincmd k<cr>",
        ["<A-Down>"] = "<cmd>wincmd j<cr>",
        ["<A-Left>"] = "<cmd>wincmd h<cr>",
        ["<A-Right>"] = "<cmd>wincmd l<cr>",
        -- Toggle numbers
        ["<F11>"] = "<cmd>NoNuMode<cr>",
        ["<F12>"] = "<cmd>NuModeToggle<cr>",
        -- Align text
        ["<"] = "<<",
        [">"] = ">>",
        -- Yank to the end of line
        ["Y"] = "y$",
    }

    if lvim.builtin.tag_provider == "symbols-outline" then
        lvim.keys.normal_mode["<F10>"] = "<cmd>SymbolsOutline<cr>"
        lvim.keys.insert_mode["<F10>"] = "<cmd>SymbolsOutline<cr>"
    elseif lvim.builtin.tag_provider == "vista" then
        lvim.keys.normal_mode["<F10>"] = "<cmd>Vista!!<cr>"
        lvim.keys.insert_mode["<F10>"] = "<cmd>Vista!!<cr>"
    end
    -- INSERT
    lvim.keys.insert_mode = {
        -- Toggle tree
        ["<F3>"] = "<cmd>NvimTreeToggle<cr>",
        ["<S-F3>"] = "<cmd>NvimTreeRefresh<cr>",
        -- Toggle sidebar
        ["<F4>"] = "<cmd>SidebarNvimToggle<cr>",
        -- Toggle mouse
        ["<F5>"] = "<cmd>MouseToggle<cr>",
        -- Yank current path
        ["<F6>"] = '<cmd>let @+ = expand("%:p")<cr>',
        -- Windows navigation
        ["<A-Up>"] = "<cmd>wincmd k<cr>",
        ["<A-Down>"] = "<cmd>wincmd j<cr>",
        ["<A-Left>"] = "<cmd>wincmd h<cr>",
        ["<A-Right>"] = "<cmd>wincmd l<cr>",
        -- Paste with Ctrl-v
        ["<C-v>"] = "<C-r><C-o>+",
        -- Snippets
        ["<C-s>"] = "<cmd>lua require('telescope').extensions.luasnip.luasnip(require('telescope.themes').get_cursor({}))<cr>",
    }
    -- VISUAL
    lvim.keys.visual_mode = {
        -- Yank with Ctrl-c
        ["<C-c>"] = '"+yi',
        -- Cut with Ctrl-x
        ["<C-x>"] = '"+c',
        -- Paste with Ctrl-v
        ["<C-v>"] = 'c<Esc>"+p',
    }

    -- Buffer navigation
    lvim.keys.normal_mode["<F1>"] = "<cmd>BufferLineCyclePrev<cr>"
    lvim.keys.normal_mode["<F2>"] = "<cmd>BufferLineCycleNext<cr>"
    lvim.keys.insert_mode["<F1>"] = "<cmd>BufferLineCyclePrev<cr>"
    lvim.keys.insert_mode["<F2>"] = "<cmd>BufferLineCycleNext<cr>"
    -- Move buffers
    lvim.keys.normal_mode["<A-S-Left>"] = "<cmd>BufferLineMovePrev<cr>"
    lvim.keys.normal_mode["<A-S-Right>"] = "<cmd>BufferLineMoveNext<cr>"
    lvim.keys.insert_mode["<A-S-Left>"] = "<cmd>BufferLineMovePrev<cr>"
    lvim.keys.insert_mode["<A-S-Right>"] = "<cmd>BufferLineMoveNext<cr>"
end

M.set_hlslens_keymaps = function()
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
    vim.api.nvim_set_keymap("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", opts)
    vim.api.nvim_set_keymap("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", opts)
end

M.set_terminal_keymaps = function()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

M.config = function()
    M.normal_insert_keys()
    M.which_keys()
end

return M
