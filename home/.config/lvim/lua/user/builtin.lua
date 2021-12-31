local M = {}

M.cpmenu = function()
    return {
        {
            "File",
            { "entire selection", ':call feedkeys("GVgg")' },
            { "file browser", ":lua require('user.telescope').file_browser()", 1 },
            { "files", ":lua require('telescope.builtin').find_files()", 1 },
            { "git files", ":lua require('user.telescope').git_files()", 1 },
            { "last search", ":lua require('user.telescope').grep_last_search()", 1 },
            { "quit", ":qa" },
            { "save all files", ":wa" },
            { "save current file", ":w" },
            { "search word", ":lua require('user.telescope').find_string()", 1 },
        },
        {
            "Lsp",
            { "formatting", ":lua vim.lsp.buf.formatting_seq_sync()" },
            { "workspace diagnostics", ":Telescope lsp_workspace_diagnostics" },
            { "workspace symbols", ":Telescope lsp_workspace_symbols" },
        },
        {
            "Project",
            { "list", ":Telescope projects" },
            { "build", ":AsyncTask project-build" },
            { "run", ":AsyncTask project-run" },
        },
        {
            "Vim",
            { "buffers", ":Telescope buffers" },
            { "check health", ":checkhealth" },
            { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
            { "command history", ":lua require('telescope.builtin').command_history()" },
            { "commands", ":lua require('telescope.builtin').commands()" },
            { "cursor column", ":set cursorcolumn!" },
            { "cursor line", ":set cursorline!" },
            { "jumps", ":lua require('telescope.builtin').jumplist()" },
            { "keymaps", ":lua require('telescope.builtin').keymaps()" },
            { "paste mode", ":set paste!" },
            { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
            { "relative number", ":set relativenumber!" },
            { "reload vimrc", ":source $MYVIMRC" },
            { "search highlighting", ":set hlsearch!" },
            { "search history", ":lua require('telescope.builtin').search_history()" },
            { "spell checker", ":set spell!" },
            { "vim options", ":lua require('telescope.builtin').vim_options()" },
        },
        {
            "Help",
            { "cheatsheet", ":help index" },
            { "quick reference", ":help quickref" },
            { "search help", ":lua require('telescope.builtin').help_tags()", 1 },
            { "summary", ":help summary" },
            { "tips", ":help tips" },
            { "tutorial", ":help tutor" },
        },
        {
            "Dap",
            { "brakpoints", ":lua require'telescope'.extensions.dap.list_breakpoints{}" },
            { "clear breakpoints", ":lua require('dap.breakpoints').clear()" },
            { "close", ":lua require'dap'.close(); require'dap'.repl.close()" },
            { "commands", ":lua require'telescope'.extensions.dap.commands{}" },
            { "configurations", ":lua require'telescope'.extensions.dap.configurations{}" },
            { "continue", ":lua require'dap'.continue()" },
            { "current scopes floating window", ":lua ViewCurrentScopesFloatingWindow()" },
            { "current scopes", ':lua ViewCurrentScopes(); vim.cmd("wincmd w|vertical resize 40")' },
            { "current value floating window", ":lua ViewCurrentValueFloatingWindow()" },
            { "frames", ":lua require'telescope'.extensions.dap.frames{}" },
            { "pause", ":lua require'dap'.pause()" },
            { "repl", ":lua require'dap'.repl.open(); vim.cmd(\"wincmd w|resize 12\")" },
            { "run to cursor", ":lua require'dap'.run_to_cursor()" },
            { "step back", ":lua require'dap'.step_back()" },
            { "step into", ":lua require'dap'.step_into()" },
            { "step out", ":lua require'dap'.step_out()" },
            { "step over", ":lua require'dap'.step_over()" },
            { "toggle breakpoint", ":lua require'dap'.toggle_breakpoint()" },
        },
    }
end

M.config = function()
    -- Evil stuff
    lvim.builtin.copilot = { active = true }
    lvim.builtin.tabnine = { active = false }
    if lvim.builtin.copilot.active then
        lvim.keys.insert_mode["<c-h>"] = { [[copilot#Accept("\<CR>")]], { expr = true, script = true } }
        local cmp = require "cmp"
        lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(M.tab, { "i", "c" })
        lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(M.shift_tab, { "i", "c" })
    end

    -- Status line
    lvim.builtin.fancy_bufferline = { active = true }
    if lvim.builtin.fancy_bufferline.active then
        lvim.builtin.bufferline.active = false
    end
    lvim.builtin.fancy_wild_menu = { active = false }

    -- Nvimtree
    lvim.builtin.nvimtree.side = "left"
    lvim.builtin.nvimtree.show_icons.git = 0
    lvim.builtin.nvimtree.icons = require("user.lsp").nvim_tree_icons

    -- Debugging
    lvim.builtin.dap.active = true

    -- Dashboard
    lvim.builtin.dashboard.active = true
    lvim.builtin.dashboard.custom_section = {
        a = {
            description = { "  New File           " },
            command = "DashboardNewFile",
        },
        b = {
            description = { "  Recent Projects    " },
            command = "lua require('telescope').extensions.project.project{}",
        },
        c = {
            description = { "  Recently Used Files" },
            command = "lua require('user.telescope').recent_files()",
        },
        e = {
            description = { "  Find File          " },
            command = "lua require('user.telescope').find_files()",
        },
        f = {
            description = { "  Find Word          " },
            command = "lua require('user.telescope').find_string()",
        },
        g = {
            description = { "  Configuration      " },
            command = ":e ~/.config/lvim/config.lua",
        },
    }

    -- Cmp
    lvim.builtin.cmp.sources = {
        { name = "nvim_lsp" },
        { name = "cmp_tabnine", max_item_count = 3 },
        { name = "buffer", max_item_count = 5, keyword_length = 5 },
        { name = "path", max_item_count = 5 },
        { name = "luasnip", max_item_count = 3 },
        { name = "nvim_lua" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
        { name = "dictionary", keyword_length = 2 },
    }
    lvim.builtin.cmp.documentation.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    lvim.builtin.cmp.experimental = {
        ghost_text = false,
        native_menu = false,
        custom_menu = true,
    }
    lvim.builtin.cmp.formatting.kind_icons = require("user.lsp").cmp_kind
    lvim.builtin.cmp.formatting.source_names = {
        buffer = "(buf)",
        nvim_lsp = "(lsp)",
        luasnip = "(snip)",
        treesitter = "",
        nvim_lua = "(lua)",
        spell = "暈",
        dictionary = "暈",
        emoji = "",
        path = "",
        calc = "",
        cmp_tabnine = "ﮧ",
        crates = "(crates)",
    }

    -- Terminal
    lvim.builtin.terminal.active = true
    lvim.builtin.terminal.open_mapping = [[<c-\\>]]
    lvim.builtin.terminal.execs = {
        { "zsh", "<c-\\>", "zsh", "float" },
        { "lazygit", "<c-g>", "LazyGit", "float" },
    }

    -- Notify popup
    lvim.builtin.notify.active = true
    lvim.log.level = "info"
end

function M.tab(fallback)
    local methods = require("lvim.core.cmp").methods
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local copilot_keys = vim.fn["copilot#Accept"]()
    if cmp.visible() then
        cmp.select_next_item()
    elseif vim.api.nvim_get_mode().mode == "c" then
        fallback()
    elseif copilot_keys ~= "" then -- prioritise copilot over snippets
        -- Copilot keys do not need to be wrapped in termcodes
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
    elseif luasnip.expandable() then
        luasnip.expand()
    elseif methods.jumpable() then
        luasnip.jump(1)
    elseif methods.check_backspace() then
        fallback()
    else
        methods.feedkeys("<Plug>(Tabout)", "")
    end
end

function M.shift_tab(fallback)
    local methods = require("lvim.core.cmp").methods
    local luasnip = require "luasnip"
    local cmp = require "cmp"
    if cmp.visible() then
        cmp.select_prev_item()
    elseif vim.api.nvim_get_mode().mode == "c" then
        fallback()
    elseif methods.jumpable(-1) then
        luasnip.jump(-1)
    else
        local copilot_keys = vim.fn["copilot#Accept"]()
        if copilot_keys ~= "" then
            methods.feedkeys(copilot_keys, "i")
        else
            methods.feedkeys("<Plug>(Tabout)", "")
        end
    end
end

function M.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

return M
