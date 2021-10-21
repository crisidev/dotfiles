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
    -- Crates backups
    vim.opt.backup = true
    vim.opt.backupdir = { vim.fn.stdpath "cache" .. "/backups" }
    -- Undodir
    vim.opt.undodir = vim.fn.stdpath "cache" .. "/undo"
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
    -- Searches wrap around the end of the file
    vim.opt.wrapscan = true
    vim.opt.list = true
    -- Make vim prompt me to save before doing destructive things
    vim.opt.confirm = true
    -- Automatically :write before running commands and changing files
    vim.opt.autowriteall = true

    vim.opt.shortmess = {
        t = true, -- truncate file messages at start
        A = true, -- ignore annoying swap file messages
        o = true, -- file-read message overwrites previous
        O = true, -- file-read message overwrites previous
        T = true, -- truncate non-file messages in middle
        f = true, -- (file x of x) instead of just (x of x
        F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
        s = true,
        c = true,
        W = true, -- Don't show [w] or written when writing
    }
    vim.opt.formatoptions = {
        ["1"] = true,
        ["2"] = true, -- Use indent from 2nd line of a paragraph
        q = true, -- continue comments with gq"
        c = true, -- Auto-wrap comments using textwidth
        r = true, -- Continue comments when pressing Enter
        n = true, -- Recognize numbered lists
        t = false, -- autowrap lines using text width value
        j = true, -- remove a comment leader when joining lines.
        -- Only break if the line was not longer than 'textwidth' when the insert
        -- started and only at a white character that has been entered during the
        -- current insert command.
        l = true,
        v = true,
    }
    vim.opt.listchars = {
        eol = nil,
        tab = "│ ",
        extends = "›", -- Alternatives: … »
        precedes = "‹", -- Alternatives: … «
        trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
    }

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

    -- Ignore
    vim.opt.wildignore = {
        "*.aux,*.out,*.toc",
        "*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
        -- media
        "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
        "*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm",
        "*.eot,*.otf,*.ttf,*.woff",
        "*.doc,*.pdf",
        -- archives
        "*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz",
        -- temp/system
        "*.*~,*~ ",
        "*.swp,.lock,.DS_Store,._*,tags.lock",
        -- version control
        ".git,.svn",
    }

    -- Python2 provider
    vim.g.python_host_prog = "$HOME/.pyenv/versions/2.7.17/bin/python"
    -- Disable statusline in dashboard
    vim.g.dashboard_disable_statusline = 1
end

return M
