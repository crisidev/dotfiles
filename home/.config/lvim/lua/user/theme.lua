local M = {}

M.tokyonight = function()
    -- require("tokyonight").setup {
    lvim.builtin.theme.tokyonight.options = {
        style = "storm",
        transparent = lvim.transparent_window,
        terminal_colors = true,
        styles = {
            comments = {},
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
            "packer",
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

M.rose_pine = function()
    require("rose-pine").setup {
        ---@usage 'main'|'moon'
        dark_variant = "main",
        bold_vert_split = false,
        dim_nc_background = lvim.builtin.global_statusline,
        disable_background = lvim.transparent_window,
        disable_float_background = true,
        disable_italics = true,
        ---@usage string hex value or named color from rosepinetheme.com/palette
        groups = {
            border = "highlight_med",
            comment = "muted",
            link = "iris",
            punctuation = "subtle",

            error = "love",
            hint = "iris",
            info = "foam",
            warn = "gold",

            headings = {
                h1 = "iris",
                h2 = "foam",
                h3 = "rose",
                h4 = "gold",
                h5 = "pine",
                h6 = "foam",
            },
        },
        highlight_groups = {
            Boolean = { fg = "love" },
            Cursor = { fg = "#232136", bg = "text" },
            NormalFloat = { bg = "base" },
            MsgArea = { fg = "text" },
            VertSplit = { fg = "highlight_low", bg = "highlight_low" },
            SignColumn = { fg = "text", bg = "none" },
            SignColumnSB = { fg = "text", bg = "none" },
            mkdInlineURL = { fg = "iris", style = "none" },
            ["@variable"] = { fg = "text" },
            ["@variable.builtin"] = { fg = "love" },
            ["@type"] = { fg = "foam" },
            ["@text"] = { fg = "text" },
            ["@property"] = { fg = "iris" },
            ["@parameter"] = { fg = "iris" },
            ["@constant.builtin"] = { fg = "love" },
            ["@constant"] = { fg = "foam" },
            ["@constructor"] = { fg = "foam" },
            ["@field"] = { fg = "foam" },
            ["@function.builtin"] = { fg = "love" },
            ["@function"] = { fg = "rose" },
            ["@include"] = { fg = "pine" },
            ["@keyword"] = { fg = "pine" },
            ["@keyword.operator"] = { fg = "subtle" },
            ["@label"] = { fg = "foam" },
            ["@punctuation.bracket"] = { fg = "muted" },
            ["@punctuation.delimiter"] = { fg = "muted" },
            ["@punctuation.special"] = { fg = "muted" },
            ["@string.escape"] = { fg = "pine" },
            ["@string.special"] = { fg = "gold" },
            ["@tag"] = { fg = "foam" },
            ["@tag.delimiter"] = { fg = "subtle" },
            ["@text.title"] = { fg = "iris", style = "bold" },
            ["@text.uri"] = { fg = "iris" },
            CmpItemKindText = { fg = "gold" },
            CmpItemKindConstructor = { fg = "foam" },
            CmpItemKindField = { fg = "foam" },
            CmpItemKindValue = { fg = "text" },
            CmpItemKindEvent = { fg = "text" },
            CmpItemKindUnit = { fg = "gold" },
            CmpItemKindConstant = { fg = "gold" },
            CmpItemKindModule = { fg = "iris" },
            CmpItemKindEnum = { fg = "#c5a8e8" },
            CmpItemKindStruct = { fg = "#56949f" },
            CmpItemKindTypeParameter = { fg = "foam" },
            CmpItemKindTypeKeyword = { fg = "pine" },
            CmpItemKindTypeDirectory = { fg = "foam" },
            CmpItemKindReference = { fg = "gold" },
            CmpItemKindOperator = { fg = "subtle" },
            CmpItemKindTypeSnippet = { fg = "pine" },
        },
    }
end

M.catppuccin = function()
    local catppuccin = require "catppuccin"
    local opts = {
        flavour = "mocha",
        background = { light = "latte", dark = "mocha" },
        transparent_background = lvim.transparent_window,
        term_colors = false,
        styles = {
            comments = {},
            keywords = { "italic" },
        },
        compile = {
            enabled = true, -- NOTE: make sure to run `:CatppuccinCompile`
            path = vim.fn.stdpath "cache" .. "/catppuccin",
        },
        dim_inactive = {
            enabled = lvim.builtin.global_statusline,
            shade = "dark",
            percentage = 0.15,
        },
        integrations = {
            cmp = true,
            fidget = true,
            lsp_trouble = true,
            telescope = true,
            treesitter = true,
            mason = true,
            neotest = lvim.builtin.test_runner == "neotest",
            noice = lvim.builtin.noice.active,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = {},
                    warnings = { "italic" },
                    information = {},
                },
                underlines = {
                    errors = { "undercurl" },
                    hints = {},
                    warnings = { "undercurl" },
                    information = {},
                },
            },
            dap = {
                enabled = lvim.builtin.dap.active,
                enable_ui = lvim.builtin.dap.active,
            },
            indent_blankline = {
                enabled = true,
                colored_indent_levels = false,
            },
            gitsigns = lvim.builtin.gitsigns.active,
            notify = lvim.builtin.noice.active,
            nvimtree = true,
            neotree = lvim.builtin.tree_provider == "neo-tree",
            overseer = lvim.builtin.task_runner == "overseer",
            symbols_outline = lvim.builtin.tag_provider == "symbols-outline",
            which_key = lvim.builtin.which_key.active,
            leap = lvim.builtin.motion_provider == "leap",
            hop = lvim.builtin.motion_provider == "hop",
        },
        highlight_overrides = {
            mocha = {
                NormalFloat = { fg = "#CDD6F4", bg = "#151521" },
                CmpItemKindEnum = { fg = "#B4BEFE" },
                CmpItemKindEnumMember = { fg = "#F5C2E7" },
                CmpItemMenu = { fg = "#7F849C" },
                CmpItemAbbr = { fg = "#BAC2DE" },
                Cursor = { fg = "#1e1e2e", bg = "#d9e0ee" },
                ["@constant.builtin"] = { fg = "#EBA0AC" },
                TSConstBuiltin = { fg = "#EBA0AC" },
            },
        },
    }
    if lvim.transparent_window then
        local colors = require("catppuccin.palettes").get_palette()
        colors.none = "NONE"
        opts.custom_highlights = {
            Comment = { fg = colors.overlay1 },
            LineNr = { fg = colors.overlay1 },
            CursorLine = { bg = colors.none },
            CursorLineNr = { fg = colors.lavender },
            DiagnosticVirtualTextError = { bg = colors.none },
            DiagnosticVirtualTextWarn = { bg = colors.none },
            DiagnosticVirtualTextInfo = { bg = colors.none },
            DiagnosticVirtualTextHint = { bg = colors.none },
        }
    end
    catppuccin.setup(opts)
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

    rose_pine_colors = {
        cmp_border = "#191724",
        none = "NONE",
        bg = "#2a273f",
        fg = "#e0def4",
        fg_gutter = "#3b4261",
        black = "#393b44",
        gray = "#2a2e36",
        red = "#eb6f92",
        green = "#97c374",
        yellow = "#ea9d34",
        hlargs = "#c4a7e7",
        blue = "#9ccfd8",
        magenta = "#c4a7e7",
        cyan = "#9ccfd8",
        white = "#dfdfe0",
        orange = "#ea9a97",
        pink = "#D67AD2",
        black_br = "#7f8c98",
        red_br = "#e06c75",
        green_br = "#58cd8b",
        yellow_br = "#FFE37E",
        bg_br = "#393552",
        blue_br = "#84CEE4",
        violet = "#B8A1E3",
        cyan_br = "#59F0FF",
        white_br = "#FDEBC3",
        orange_br = "#F6A878",
        pink_br = "#DF97DB",
        comment = "#526175",
        bg_alt = "#191724",
        git = {
            add = "#84Cee4",
            change = "#c4a7e7",
            delete = "#eb6f92",
            conflict = "#f6c177",
        },
    },

    catppuccin_colors = {
        cmp_border = "#151521",
        rosewater = "#F5E0DC",
        flamingo = "#F2CDCD",
        violet = "#DDB6F2",
        pink = "#F5C2E7",
        red = "#F28FAD",
        maroon = "#E8A2AF",
        orange = "#FAB387",
        yellow = "#F9E2AF",
        hlargs = "#EBA0AC",
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
        bg = "#302D41",
        surface1 = "#302D41",
        bg_alt = "#1E1E2E",
        fg = "#D9E0EE",
        fg_dark = "#D9E0EE",
        black = "#1A1826",
        git = {
            add = "#ABE9B3",
            change = "#96CDFB",
            delete = "#F28FAD",
            conflict = "#FAE3B0",
        },
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
    elseif lvim.builtin.theme.name == "catppuccin" then
        return M.colors.catppuccin_colors
    elseif lvim.builtin.theme.name == "kanagawa" then
        return M.colors.kanagawa_colors
    elseif lvim.builtin.theme.name == "rose-pine" then
        return M.colors.rose_pine_colors
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

    local colors = M.current_colors()
    set_fg_bg("Hlargs", colors.yellow, "none")
    set_fg_bg("CmpBorder", colors.cmp_border, colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorder", colors.cmp_border, colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorderCmdline", colors.cmp_border, colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorderFilter", colors.cmp_border, colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorderLua", colors.cmp_border, colors.cmp_border)
    set_fg_bg("NoiceCmdlinePopupBorderSearch", colors.cmp_border, colors.cmp_border)
    set_fg_bg("diffAdded", colors.git.add, "NONE")
    set_fg_bg("diffRemoved", colors.git.delete, "NONE")
    set_fg_bg("diffChanged", colors.git.change, "NONE")
    set_fg_bg("WinSeparator", colors.bg_alt, colors.bg_alt)
    set_fg_bg("SignColumn", colors.bg, "NONE")
    set_fg_bg("SignColumnSB", colors.bg, "NONE")
    set_fg_bg("NormalFloat", colors.fg, "#181924")
    set_fg_bg("Cursor", colors.bg, colors.fg)
    set_fg_bg("NormalNC", colors.fg_dark, "#1c1d28")
    set_fg_bg("Normal", colors.fg, "#1f2335")
    set_fg_bg("CursorLineNr", colors.orange, "bold")

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
