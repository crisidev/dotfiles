local M = {}

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
        green = "#9ece6a",
        green1 = "#73daca",
        green2 = "#41a6b5",
        teal = "#1abc9c",
        red = "#f7768e",
        red1 = "#db4b4b",
        git = { change = "#6183bb", add = "#449dab", delete = "#f7768e", conflict = "#bb7a61" },
        gitSigns = { add = "#164846", change = "#394b70", delete = "#823c41" },
    },
}

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

M.telescope_theme = function()
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

    local tokyonight_colors = M.colors.tokyonight_colors
    set_fg_bg("Hlargs", tokyonight_colors.yellow, "none")
    set_fg_bg("CmpBorder", tokyonight_colors.cmp_border, tokyonight_colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorder", tokyonight_colors.cmp_border, tokyonight_colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorderCmdline", tokyonight_colors.cmp_border, tokyonight_colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorderFilter", tokyonight_colors.cmp_border, tokyonight_colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorderLua", tokyonight_colors.cmp_border, tokyonight_colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorderSearch", tokyonight_colors.cmp_border, tokyonight_colors.cmp_border)
    set_fg_bg("diffAdded", tokyonight_colors.git.add, "NONE")
    set_fg_bg("diffRemoved", tokyonight_colors.git.delete, "NONE")
    set_fg_bg("diffChanged", tokyonight_colors.git.change, "NONE")
    set_fg_bg("WinSeparator", tokyonight_colors.bg_alt, tokyonight_colors.bg_alt)
    set_fg_bg("SignColumn", tokyonight_colors.bg, "NONE")
    set_fg_bg("SignColumnSB", tokyonight_colors.bg, "NONE")
    set_fg_bg("NormalFloat", tokyonight_colors.fg, "#181924")
    set_fg_bg("Cursor", tokyonight_colors.bg, tokyonight_colors.fg)
    set_fg_bg("NormalNC", tokyonight_colors.fg_dark, "#1c1d28")
    set_fg_bg("Normal", tokyonight_colors.fg, "#1f2335")
    set_fg_bg("CursorLineNr", tokyonight_colors.orange, "bold")

    local hi_colors = M.hi_colors()
    set_fg_bg("NormalFloat", hi_colors.fg, hi_colors.bg)
    set_fg_bg("FloatBorder", hi_colors.fg, hi_colors.bg)
    set_fg_bg("TelescopeBorder", hi_colors.bg_alt, hi_colors.bg)
    set_fg_bg("TelescopePromptBorder", hi_colors.bg, hi_colors.bg)
    set_fg_bg("TelescopePromptNormal", hi_colors.fg, hi_colors.bg_alt)
    set_fg_bg("TelescopePromptPrefix", hi_colors.blue, hi_colors.bg)
    set_bg("TelescopeNormal", hi_colors.bg)
    set_fg_bg("TelescopePreviewTitle", hi_colors.blue, hi_colors.bg)
    set_fg_bg("LvimInfoHeader", hi_colors.bg, hi_colors.blue)
    set_fg_bg("LvimInfoIdentifier", hi_colors.blue, hi_colors.bg_alt)
    set_fg_bg("TelescopePromptTitle", hi_colors.bg, hi_colors.blue)
    set_fg_bg("TelescopeResultsTitle", hi_colors.blue, hi_colors.bg)
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

return M
