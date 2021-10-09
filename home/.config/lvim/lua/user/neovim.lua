local M = {}

M.config = function()
    -- Vim basic configurations
    -- Set relative numbered lines
    vim.opt.relativenumber = true
    -- The number of spaces inserted for each indentation
    vim.opt.shiftwidth = 4
    -- Insert 2 spaces for a tab
    vim.opt.tabstop = 4
    -- Creates a swapfile
    vim.opt.swapfile = true
    -- The font used in graphical neovim applications
    vim.opt.guifont = "FiraCode Nerd Font:h10"
    -- Display lines as one long line
    vim.opt.wrap = true
    -- We need to see things like -- INSERT --
    vim.opt.showmode = true
    -- What the title of the window will be set to
    vim.opt.titlestring = "neovim %<%F%=%l/%L"
    -- Ignore case in search
    vim.opt.ignorecase = true
    -- Space in the neovim command line for displaying messages
    vim.opt.cmdheight = 1
    -- Python2 provider
    vim.g.python_host_prog = "$HOME/.pyenv/versions/2.7.17/bin/python"
    -- Disable statusline in dashboard
    vim.g.dashboard_disable_statusline = 1

    -- Better fillchars
    vim.opt.fillchars = {
        vert = "▕", -- alternatives │
        fold = " ",
        eob = " ", -- suppress ~ at EndOfBuffer
        diff = "╱", -- alternatives = ⣿ ░ ─
        msgsep = "‾",
        foldopen = "▾",
        foldsep = "│",
        foldclose = "▸",
    }

    -- Pumblend
    vim.opt.pumblend = 10

    -- Other
    vim.opt.joinspaces = false
    vim.opt.list = false

    -- GitBlame
    vim.g.gitblame_enabled = 0
    vim.g.gitblame_message_template = "<date> • <author> • <summary>"
    vim.g.gitblame_date_format = "%r"

    -- Enable markdown
    vim.g.markdown_fenced_languages = { "python", "rust", "ruby", "sh" }
end

M.setcwd = function()
    local filename = vim.fn.expand "%:p:h"
    local filedir = io.open(os.getenv "HOME" .. "/.config/nvim/filedir", "w")
    io.output(filedir)
    io.write(filename)
    io.close(filedir)

    local projname = vim.fn.getcwd()
    local projdir = io.open(os.getenv "HOME" .. "/.config/nvim/projdir", "w")
    io.output(projdir)
    io.write(projname)
    io.close(projdir)
end

return M
