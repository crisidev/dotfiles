local M = {}

M.nightfox = function()
    require("nightfox").setup {
        options = {
            -- Compiled file's destination location
            compile_path = vim.fn.stdpath "cache" .. "/nightfox",
            compile_file_suffix = "_compiled", -- Compiled file suffix
            transparent = false, -- Disable setting background
            terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
            dim_inactive = true, -- Non focused panes set to alternative background
            module_default = true, -- Default enable value for modules
            styles = { -- Style to be applied to different syntax groups
                comments = "italic", -- Value is any valid attr-list value `:help attr-list`
                conditionals = "NONE",
                constants = "NONE",
                functions = "NONE",
                keywords = "italic",
                types = "italic,bold",
                numbers = "NONE",
                operators = "NONE",
                strings = "NONE",
                variables = "NONE",
            },
            inverse = { -- Inverse highlight for different types
                match_paren = false,
                visual = false,
                search = false,
            },
        },
    }
end

M.tokyonight = function()
    -- require("tokyonight").setup {
    lvim.builtin.theme.tokyonight.options = {
        style = "storm",
        transparent = lvim.transparent_window,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            sidebars = "dark",
            floats = "dark",
        },
        sidebars = {
            "qf",
            "vista_kind",
            "terminal",
            "lazy",
            "spectre_panel",
            "NeogitStatus",
            "help",
        },
        day_brightness = 0.3,
        hide_inactive_statusline = true,
        dim_inactive = true,
        lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

        on_colors = function(colors)
            colors.git = { change = "#6183bb", add = "#449dab", delete = "#f7768e", conflict = "#bb7a61" }
            colors.bg_dark = "#1a1e30"
            colors.bg_dim = "#1f2335"
            colors.bg_float = "#1a1e30"
        end,
        on_highlights = function(hl, c)
            c.bg_dark = "#1a1e30"
            c.bg_dim = "#1f2335"
            c.bg_float = "#1a1e30"
            local current_colors = M.colors.tokyonight_colors
            hl.NormalFloat = { fg = current_colors.fg, bg = "#181924" }
            hl.Cursor = { fg = current_colors.bg, bg = current_colors.fg }
            hl.NormalNC = { fg = current_colors.fg_dark, bg = "#1c1d28" }
            hl.Normal = { fg = current_colors.fg, bg = "#1f2335" }
            hl.CursorLineNr = { fg = current_colors.orange, style = "bold" }
        end,
    }
end

M.kanagawa = function()
    local kanagawa = require "kanagawa"
    kanagawa.setup {
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
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
            NvimTreeFolderIcon = { fg = "#7e9cd8" },
            CmpItemKindEnum = { fg = "#957FB8" },
            ["@parameter"] = { fg = "#DCA561" },
        },
    }
end

M.colors = {
    tokyonight_colors = {
        cmp_border = "#181924",
        none = "NONE",
        bg_dark = "#1f2335",
        bg_alt = "#1a1b26",
        bg = "#24283b",
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
        violet = "#bb9af7",
        magenta = "#bb9af7",
        magenta2 = "#ff007c",
        purple = "#9d7cd8",
        orange = "#ff9e64",
        yellow = "#e0af68",
        hlargs = "#e0af68",
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
        cmp_border = "#16161D",
        bg = "#21212A",
        bg_alt = "#1F1F28",
        bg_br = "#363646",
        fg = "#DCD7BA",
        fg_dark = "#DCD7BA",
        red = "#E46876",
        orange = "#FFA066",
        yellow = "#DCA561",
        hlargs = "#DCA561",
        blue = "#7FB4CA",
        cyan = "#658594",
        violet = "#957FB8",
        magenta = "#938AA9",
        green = "#76946A",
        git = {
            add = "#76946A",
            conflict = "#DCA561",
            delete = "#E46876",
            change = "#7FB4CA",
        },
    },
}

M.current_colors = function()
    if lvim.builtin.theme.name == "tokyonight" then
        return M.colors.tokyonight_colors
    elseif lvim.builtin.theme.name == "nightfox" then
        return M.colors.tokyonight_colors
    elseif lvim.builtin.theme.name == "kanagawa" then
        return M.colors.kanagawa_colors
    else
        return M.colors.tokyonight_colors
    end
end

M.hi_colors = function()
    local colors = {
        bg = "#16161D",
        bg_alt = "#404040",
        fg = "#DCD7BA",
        green = "#76946A",
        red = "#E46876",
        blue = "#7aa0f7",
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

M.telescope_theme = function(colorset)
    local function link(group, other)
        vim.cmd("highlight! link " .. group .. " " .. other)
    end

    local function set_bg(group, bg)
        vim.cmd("hi " .. group .. " guibg=" .. bg)
    end

    local function set_fg_bg(group, fg, bg)
        vim.cmd("hi " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
    end

    set_fg_bg("SpecialComment", "#9ca0a4", "bold")
    link("FocusedSymbol", "LspHighlight")
    link("LspCodeLens", "SpecialComment")
    link("LspDiagnosticsSignError", "DiagnosticError")
    link("LspDiagnosticsSignHint", "DiagnosticHint")
    link("LspDiagnosticsSignInfo", "DiagnosticInfo")
    link("NeoTreeDirectoryIcon", "NvimTreeFolderIcon")
    link("IndentBlanklineIndent1 ", "@comment")
    local current_colors = colorset
    if colorset == nil or #colorset == 0 then
        current_colors = M.current_colors()
    end
    set_fg_bg("Hlargs", current_colors.hlargs, "none")
    set_fg_bg("CmpBorder", current_colors.cmp_border, current_colors.cmp_border)
    link("NoiceCmdlinePopupBorder", "CmpBorder")
    link("NoiceCmdlinePopupBorderCmdline", "CmpBorder")
    link("NoiceCmdlinePopupBorderFilter", "CmpBorder")
    link("NoiceCmdlinePopupBorderHelp", "CmpBorder")
    link("NoiceCmdlinePopupBorderIncRename", "CmpBorder")
    link("NoiceCmdlinePopupBorderInput", "CmpBorder")
    link("NoiceCmdlinePopupBorderLua", "CmpBorder")
    link("NoiceCmdlinePopupBorderSearch", "CmpBorder")
    set_fg_bg("diffAdded", current_colors.git.add, "NONE")
    set_fg_bg("diffRemoved", current_colors.git.delete, "NONE")
    set_fg_bg("diffChanged", current_colors.git.change, "NONE")
    set_fg_bg("WinSeparator", current_colors.bg_alt, current_colors.bg_alt)
    set_fg_bg("SignColumn", current_colors.bg, "NONE")
    set_fg_bg("SignColumnSB", current_colors.bg, "NONE")

    local hi_colors = M.hi_colors()
    set_fg_bg("NormalFloat", hi_colors.fg, hi_colors.bg)
    set_fg_bg("FloatBorder", hi_colors.fg, hi_colors.bg)
    set_fg_bg("TelescopeBorder", hi_colors.bg_alt, hi_colors.bg)
    set_fg_bg("TelescopePromptBorder", hi_colors.bg, hi_colors.bg)
    set_fg_bg("TelescopePromptNormal", hi_colors.fg, hi_colors.bg_alt)
    set_fg_bg("TelescopePromptPrefix", hi_colors.red, hi_colors.bg)
    set_bg("TelescopeNormal", hi_colors.bg)
    set_fg_bg("TelescopePreviewTitle", hi_colors.bg, hi_colors.green)
    set_fg_bg("LvimInfoHeader", hi_colors.bg, hi_colors.green)
    set_fg_bg("LvimInfoIdentifier", hi_colors.red, hi_colors.bg_alt)
    set_fg_bg("TelescopePromptTitle", hi_colors.bg, hi_colors.red)
    set_fg_bg("TelescopeResultsTitle", hi_colors.bg, hi_colors.bg)
    set_fg_bg("TelescopeResultsBorder", hi_colors.bg, hi_colors.bg)
    set_bg("TelescopeSelection", hi_colors.bg_alt)
end

M.dashboard_theme = function()
    -- Dashboard header colors
    vim.api.nvim_set_hl(0, "StartLogo1", { fg = "#1C506B" })
    vim.api.nvim_set_hl(0, "StartLogo2", { fg = "#1D5D68" })
    vim.api.nvim_set_hl(0, "StartLogo3", { fg = "#1E6965" })
    vim.api.nvim_set_hl(0, "StartLogo4", { fg = "#1F7562" })
    vim.api.nvim_set_hl(0, "StartLogo5", { fg = "#21825F" })
    vim.api.nvim_set_hl(0, "StartLogo6", { fg = "#228E5C" })
    vim.api.nvim_set_hl(0, "StartLogo7", { fg = "#239B59" })
    vim.api.nvim_set_hl(0, "StartLogo8", { fg = "#24A755" })
end

M.toggle_theme = function()
    local theme = lvim.colorscheme
    local colorset = require("user.theme").colors.tokyonight_colors
    if theme == "tokyonight" then
        lvim.colorscheme = "nightfox"
        lvim.builtin.theme.name = "nightfox"
        colorset = require("user.theme").colors.tokyonight_colors
    elseif theme == "nightfox" then
        lvim.colorscheme = "kanagawa"
        lvim.builtin.theme.name = "kanagawa"
        colorset = require("user.theme").colors.kanagawa_colors
    else
        lvim.colorscheme = "tokyonight"
        lvim.builtin.theme.name = "tokyonight"
    end
    vim.cmd("colorscheme " .. lvim.colorscheme)
    require("user.theme").telescope_theme(colorset)
end

return M
