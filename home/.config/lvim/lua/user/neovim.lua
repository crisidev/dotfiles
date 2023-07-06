local M = {}

M.config = function()
    -- Disable certain plugins
    local disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
    }
    for _, plugin in pairs(disabled_plugins) do
        vim.g["loaded_" .. plugin] = 1
    end
    -- Vim basic configurations
    -- vim.g.did_load_filetypes = 1
    vim.g.ultest_summary_width = 30
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.opt.diffopt = {
        "internal",
        "filler",
        "closeoff",
        "hiddenoff",
        "algorithm:minimal",
    }
    vim.g.toggle_theme_icon = "   "
    -- Set wrap
    vim.opt.wrap = true
    -- Enable term GUI
    vim.opt.termguicolors = true
    -- Set timeouts
    vim.opt.updatetime = 100
    vim.opt.timeoutlen = 250
    vim.opt.redrawtime = 1500
    vim.opt.ttimeoutlen = 10
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
    -- Display lines as one long line
    vim.opt.wrap = true
    -- We need to see things like -- INSERT --
    vim.opt.showmode = true
    -- What the title of the window will be set to
    -- vim.opt.titlestring = "neovim %<%F%=%l/%L"
    vim.opt.titlestring = "neovim"
    -- Ignore case in search
    vim.opt.ignorecase = true
    -- Space in the neovim command line for displaying messages
    vim.opt.cmdheight = 1
    -- Searches wrap around the end of the file
    vim.opt.wrapscan = true
    vim.opt.mousescroll = { "ver:3", "hor:6" }
    vim.opt.mousefocus = true
    vim.opt.mousemoveevent = true
    -- Disable autocmd etc for project local vimrc files.
    vim.opt.secure = true
    -- Disable autocmd etc for project local vimrc files.
    vim.opt.exrc = false
    vim.opt.list = true
    -- Make vim prompt me to save before doing destructive things
    vim.opt.confirm = true
    -- Automatically :write before running commands and changing files
    vim.opt.autowriteall = true
    -- Type of clipboard
    vim.opt.clipboard = "unnamedplus"

    vim.opt.shortmess = {
        t = true, -- truncate file messages at start
        A = false, -- ignore annoying swap file messages
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
    vim.opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim"
    vim.opt.ttyfast = true

    -- Cursorline highlighting control
    --  Only have it on in the active buffer
    vim.opt.cursorline = true -- Highlight the current line
    local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
    vim.api.nvim_create_autocmd("WinLeave", {
        group = group,
        callback = function()
            vim.opt_local.cursorline = false
        end,
    })
    vim.api.nvim_create_autocmd("WinEnter", {
        group = group,
        callback = function()
            if vim.bo.filetype ~= "alpha" then
                vim.opt_local.cursorline = true
            end
        end,
    })

    -- Better fillchars
    vim.opt.fillchars = {
        eob = " ", -- suppress ~ at EndOfBuffer
        diff = "╱", -- alternatives = ⣿ ░ ─
        msgsep = "‾",
        fold = " ",
        foldopen = "",
        foldclose = "",
        foldsep = " ",
        horiz = "━",
        horizup = "┻",
        horizdown = "┳",
        vert = "┃",
        vertleft = "┫",
        vertright = "┣",
        verthoriz = "╋",
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
        -- Rust
        "Cargo.lock,Cargo.Bazel.lock",
    }

    -- Disable perl and ruby providers.
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_ruby_provider = 0

    -- Folding
    if lvim.builtin.ufo.active then
        vim.o.foldcolumn = "1" -- Show the fold column
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    else
        vim.o.foldcolumn = "1" -- Show the fold column
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "nvim_treesitter#foldexpr()"
        vim.o.foldlevel = 4
        vim.o.foldtext =
            [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
        vim.o.foldnestmax = 3
        vim.o.foldminlines = 1
    end

    -- Conceal
    -- vim.o.conceallevel = 2

    -- Setup clipboard
    vim.opt.clipboard = { "unnamedplus" }

    -- QFTF
    vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

    -- Session
    vim.o.sessionoptions = "buffers,curdir,folds,globals,help,tabpages,winpos,winsize,terminal"

    -- Splitkeep
    vim.o.splitkeep = "screen"

    -- Colorcolumn
    vim.cmd [[set colorcolumn=]]

    -- Editorconfig
    vim.g.editorconfig = true

    -- Mouse handling
    vim.cmd [[
        function! s:MouseToggleFunc()
            if !exists('s:old_mouse')
                let s:old_mouse = 'a'
            endif

            if &mouse ==? ''
                let &mouse = s:old_mouse
                echo 'Mouse is for Vim (' . &mouse . ')'
            else
                let s:old_mouse = &mouse
                let &mouse=''
                echo 'Mouse is for terminal'
            endif
        endfunction
        command! MouseToggle :call <SID>MouseToggleFunc()
    ]]

    -- Toggle numbers
    vim.cmd [[
        function! s:NuModeToggleFunc()
            if &number == 1
                set relativenumber!
            else
                set number!
            endif
        endfunction
        command! NuModeToggle :call <SID>NuModeToggleFunc()
    ]]

    -- No numbers
    vim.cmd [[
        function! s:NoNuModeFunc()
            set norelativenumber
            set nonumber
        endfunction
        command! NoNuMode :call <SID>NoNuModeFunc()
    ]]

    -- Clean search with <esc>
    vim.cmd [[
        nnoremap <silent><esc> :noh<CR>
        nnoremap <esc>[ <esc>[
    ]]
end

function M.maximize_current_split()
    local cur_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_var("non_float_total", 0)
    vim.cmd "windo if &buftype != 'nofile' | let g:non_float_total += 1 | endif"
    vim.api.nvim_set_current_win(cur_win or 0)
    if vim.api.nvim_get_var "non_float_total" == 1 then
        if vim.fn.tabpagenr "$" == 1 then
            return
        end
        vim.cmd "tabclose"
    else
        local last_cursor = vim.api.nvim_win_get_cursor(0)
        vim.cmd "tabedit %:p"
        vim.api.nvim_win_set_cursor(0, last_cursor)
    end
end

function _G.qftf(info)
    local fn = vim.fn
    local items
    local ret = {}
    if info.quickfix == 1 then
        items = fn.getqflist({ id = info.id, items = 0 }).items
    else
        items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end
    local limit = 25
    local fname_fmt1, fname_fmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
    local valid_fmt, invalid_fmt = "%s |%5d:%-3d|%s %s", "%s"
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ""
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = vim.api.nvim_buf_get_name(e.bufnr)
                if fname == "" then
                    fname = "[No Name]"
                else
                    fname = fname:gsub("^" .. vim.env.HOME, "~")
                end
                if fn.strwidth(fname) <= limit then
                    fname = fname_fmt1:format(fname)
                else
                    fname = fname_fmt2:format(fname:sub(1 - limit, -1))
                end
            end
            local lnum = e.lnum > 99999 and "inf" or e.lnum
            local col = e.col > 999 and "inf" or e.col
            local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
            str = valid_fmt:format(fname, lnum, col, qtype, e.text)
        else
            str = invalid_fmt:format(e.text)
        end
        table.insert(ret, str)
    end
    return ret
end

return M
