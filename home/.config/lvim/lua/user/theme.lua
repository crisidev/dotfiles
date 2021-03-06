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
    vim.g.tokyonight_italic_comments = false
    vim.g.tokyonight_italic_keywords = true
    vim.g.tokyonight_italic_functions = false
    vim.g.tokyonight_italic_variables = false
    vim.g.tokyonight_transparent = lvim.transparent_window
    vim.g.tokyonight_hide_inactive_statusline = true
    vim.g.tokyonight_dark_sidebar = true
    vim.g.tokyonight_dark_float = true
    vim.g.tokyonight_dim_inactive = true
    vim.g.tokyonight_global_status = true
    vim.g.tokyonight_colors = {
        git = { change = "#6183bb", add = "#449dab", delete = "#f7768e", conflict = "#bb7a61" },
    }
end

M.catppuccin = function()
    local catppuccin = require "catppuccin"
    catppuccin.setup {
        transparent_background = lvim.transparent_window,
        term_colors = false,
        styles = {
            comments = "NONE",
            keywords = "italic",
        },
        integrations = {
            lsp_trouble = true,
            nvimtree = {
                transparent_panel = lvim.transparent_window,
            },
            which_key = true,
            lightspeed = lvim.builtin.motion_provider == "lightspeed",
            hop = lvim.builtin.motion_provider == "hop",
        },
    }
end

M.kanagawa = function()
    local kanagawa = require "kanagawa"
    kanagawa.setup {
        undercurl = true, -- enable undercurls
        commentStyle = {},
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { italic = true },
        typeStyle = {},
        variablebuiltinStyle = { italic = true },
        specialReturn = true, -- special highlight for the return keyword
        specialException = true, -- special highlight for exception handling keywords
        dimInactive = lvim.builtin.global_statusline, -- dim inactive window `:h hl-NormalNC`
        globalStatus = lvim.builtin.global_statusline, -- adjust window separators highlight for laststatus=3
        transparent = lvim.transparent_window,
        colors = { sumiInk1b = "#1b1b23" },
        overrides = {
            diffRemoved = { fg = "#E46876" },
        },
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

    catppuccin_colors = {
        rosewater = "#F5E0DC",
        flamingo = "#F2CDCD",
        violet = "#DDB6F2",
        pink = "#F5C2E7",
        red = "#F28FAD",
        maroon = "#E8A2AF",
        orange = "#F8BD96",
        yellow = "#FAE3B0",
        green = "#ABE9B3",
        blue = "#96CDFB",
        cyan = "#89DCEB",
        teal = "#B5E8E0",
        lavender = "#C9CBFF",
        white = "#D9E0EE",
        gray2 = "#C3BAC6",
        gray1 = "#988BA2",
        gray0 = "#6E6C7E",
        black4 = "#575268",
        bg_br = "#302D41",
        bg = "#1A1826",
        bg_alt = "#1E1E2E",
        fg = "#D9E0EE",
        black = "#1A1826",
        git = {
            add = "#ABE9B3",
            change = "#96CDFB",
            delete = "#F28FAD",
            conflict = "#FAE3B0",
        },
    },

    kanagawa_colors = {
        bg = "#16161D",
        bg_alt = "#1F1F28",
        bg_br = "#363646",
        fg = "#DCD7BA",
        red = "#E46876",
        orange = "#FFA066",
        yellow = "#DCA561",
        blue = "#7FB4CA",
        cyan = "#658594",
        violet = "#957FB8",
        magenta = "#938AA9",
        green = "#76946A",
        git = {
            add = "#76946A",
            conflict = "#252535",
            delete = "#C34043",
            change = "#DCA561",
        },
    },
}

M.hi_colors = function()
    local colors = {
        bg = "#16161D",
        bg_alt = "#1F1F28",
        fg = "#DCD7BA",
        green = "#76946A",
        red = "#E46876",
    }
    local color_binds = {
        bg = { group = "NormalFloat", property = "background" },
        bg_alt = { group = "Cursor", property = "foreground" },
        fg = { group = "Cursor", property = "background" },
        green = { group = "diffAdded", property = "foreground" },
        red = { group = "diffRemoved", property = "foreground" },
    }
    local function get_hl_by_name(name)
        local ret = vim.api.nvim_get_hl_by_name(name.group, true)
        return string.format("#%06x", ret[name.property])
    end

    for k, v in pairs(color_binds) do
        local found, color = pcall(get_hl_by_name, v)
        if found then
            colors[k] = color
        end
    end
    return colors
end

M.telescope_theme = function()
    local function set_bg(group, bg)
        vim.cmd("hi " .. group .. " guibg=" .. bg)
    end

    local function set_fg_bg(group, fg, bg)
        vim.cmd("hi " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
    end

    local colors = M.hi_colors()
    -- set_fg_bg("WinSeparator", colors.bg, "None")
    set_fg_bg("NormalFloat", colors.fg, colors.bg)
    set_fg_bg("FloatBorder", colors.fg, colors.bg)
    set_fg_bg("TelescopeBorder", colors.bg_alt, colors.bg)
    set_fg_bg("TelescopePromptBorder", colors.bg, colors.bg)
    set_fg_bg("TelescopePromptNormal", colors.fg, colors.bg_alt)
    set_fg_bg("TelescopePromptPrefix", colors.red, colors.bg)
    set_bg("TelescopeNormal", colors.bg)
    set_fg_bg("TelescopePreviewTitle", colors.bg, colors.green)
    set_fg_bg("LvimInfoHeader", colors.bg, colors.green)
    set_fg_bg("LvimInfoIdentifier", colors.red, colors.bg_alt)
    set_fg_bg("TelescopePromptTitle", colors.bg, colors.red)
    set_fg_bg("TelescopeResultsTitle", colors.bg, colors.bg)
    set_fg_bg("TelescopeResultsBorder", colors.bg, colors.bg)
    set_bg("TelescopeSelection", colors.bg_alt)
end

return M
