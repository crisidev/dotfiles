local M = {}

M.cpmenu = function()
    return {
        {
            "File",
            { "entire selection", ':call feedkeys("GVgg")' },
            { "file browser", ":lua require('user.telescope').file_browser()", 1 },
            { "files", ":lua require('telescope.builtin').find_files()", 1 },
            { "git files", ":lua require('user.telescope').git_files()", 1 },
            { "last search", ":lua require('telescope.builtin').resume({cache_index=3})" },
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
    -- Command palette
    lvim.builtin.cpmenu = M.cpmenu()
end

return M
