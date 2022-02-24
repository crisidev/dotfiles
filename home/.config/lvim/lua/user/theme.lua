local M = {}

M.tokyonight = function()
    vim.g.tokyonight_dev = true
    vim.g.tokyonight_style = "storm"
    vim.g.tokyonight_sidebars = {
        "qf",
        "vista_kind",
        "terminal",
        "packer",
        "spectre_panel",
        "NeogitStatus",
        "help",
    }
    vim.g.tokyonight_cterm_colors = false
    vim.g.tokyonight_terminal_colors = true
    vim.g.tokyonight_italic_comments = true
    vim.g.tokyonight_italic_keywords = true
    vim.g.tokyonight_italic_functions = false
    vim.g.tokyonight_italic_variables = false
    vim.g.tokyonight_transparent = lvim.transparent_window
    vim.g.tokyonight_hide_inactive_statusline = true
    vim.g.tokyonight_dark_sidebar = true
    vim.g.tokyonight_dark_float = true
    vim.g.tokyonight_colors = {
        git = { change = "#6183bb", add = "#449dab", delete = "#f7768e", conflict = "#bb7a61" },
    }
end

M.kanagwa = function()
    local kanagawa = require "kanagawa"
    kanagawa.setup {
        undercurl = true, -- enable undercurls
        commentStyle = "italic",
        functionStyle = "NONE",
        keywordStyle = "italic",
        statementStyle = "bold",
        typeStyle = "NONE",
        variablebuiltinStyle = "italic",
        specialReturn = true, -- special highlight for the return keyword
        specialException = true, -- special highlight for exception handling keywords
        transparent = lvim.transparent_window,
        colors = {},
        overrides = {},
    }
end

M.colors = {
    tokyonight_colors = {
        none = "NONE",
        bg_dark = "#1f2335",
        bg_alt = "#1f2335",
        bg = "#1a1b26",
        bg_br = "#292e42",
        terminal_black = "#414868",
        fg = "#c0caf5",
        fg_dark = "#a9b1d6",
        fg_gutter = "#3b4261",
        dark3 = "#545c7e",
        comment = "#565f89",
        dark5 = "#737aa2",
        blue0 = "#3d59a1",
        blue = "#7aa2f7",
        cyan = "#7dcfff",
        blue1 = "#2ac3de",
        blue2 = "#0db9d7",
        blue5 = "#89ddff",
        blue6 = "#B4F9F8",
        blue7 = "#394b70",
        magenta = "#bb9af7",
        magenta2 = "#ff007c",
        purple = "#9d7cd8",
        orange = "#ff9e64",
        yellow = "#e0af68",
        green = "#9ece6a",
        green1 = "#73daca",
        green2 = "#41a6b5",
        teal = "#1abc9c",
        red = "#f7768e",
        red1 = "#db4b4b",
        -- git = { change = "#6183bb", add = "#449dab", delete = "#914c54", conflict = "#bb7a61" },
        git = { change = "#6183bb", add = "#449dab", delete = "#f7768e", conflict = "#bb7a61" },
        gitSigns = { add = "#164846", change = "#394b70", delete = "#823c41" },
    },
    kanagawa_colors = {
        bg = "#16161D",
        bg_alt = "#1F1F28",
        fg = "#DCD7BA",
        red = "#43242B",
        orange = "#FFA066",
        yellow = "#DCA561",
        blue = "#7FB4CA",
        cyan = "#658594",
        violet = "#957FB8",
        magenta = "#938AA9",
        git = {
            add = "#76946A",
            conflict = "#252535",
            delete = "#C34043",
            change = "#DCA561",
        },
    },
}

function M.telescope_theme()
    if lvim.builtin.fancy_telescope.active then
        local colors = M.current_colors()
        M.fg_bg("TelescopeBorder", colors.bg_alt, colors.bg)
        M.fg_bg("TelescopePromptBorder", colors.bg, colors.bg)
        M.fg_bg("TelescopePromptNormal", colors.fg, colors.bg_alt)
        M.fg_bg("TelescopePromptPrefix", colors.red, colors.bg)
        M.bg("TelescopeNormal", colors.bg)
        M.fg_bg("TelescopePreviewTitle", colors.bg, colors.green)
        M.fg_bg("TelescopePromptTitle", colors.bg, colors.red)
        M.fg_bg("TelescopeResultsTitle", colors.bg, colors.bg)
        M.fg_bg("TelescopeResultsBorder", colors.bg, colors.bg)
        M.bg("TelescopeSelection", colors.bg_alt)
    end
end

function M.bg(group, col)
    vim.cmd("hi " .. group .. " guibg=" .. col)
end

function M.fg_bg(group, fgcol, bgcol)
    vim.cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

return M
