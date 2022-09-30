local M = {}
local icons = require("user.icons").icons
local file_icons = require("user.icons").file_icons

local mode = function()
    local mod = vim.fn.mode()
    if mod == "n" or mod == "no" or mod == "nov" then
        return " "
    elseif mod == "i" or mod == "ic" or mod == "ix" then
        return " "
    elseif mod == "V" or mod == "v" or mod == "vs" or mod == "Vs" or mod == "cv" then
        return " "
    elseif mod == "c" or mod == "ce" then
        return " "
    elseif mod == "r" or mod == "rm" or mod == "r?" then
        return " "
    elseif mod == "R" or mod == "Rc" or mod == "Rv" or mod == "Rv" then
        return " "
    else
        return " "
    end
end

local file_icon_colors = {
    Brown = "#905532",
    Aqua = "#3AFFDB",
    Blue = "#689FB6",
    DarkBlue = "#44788E",
    Purple = "#834F79",
    Red = "#AE403F",
    Beige = "#F5C06F",
    Yellow = "#F09F17",
    Orange = "#D4843E",
    DarkOrange = "#F16529",
    Pink = "#CB6F6F",
    Salmon = "#EE6E73",
    Green = "#8FAA54",
    LightGreen = "#31B53E",
    White = "#FFFFFF",
    LightBlue = "#5fd7ff",
}

local function get_file_info()
    return vim.fn.expand "%:t", vim.fn.expand "%:e"
end

local function get_file_icon()
    local icon
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        print "No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'"
        return ""
    end
    local f_name, f_extension = get_file_info()
    icon = devicons.get_icon(f_name, f_extension)
    if icon == nil then
        icon = icons.question
    end
    return icon
end

local function get_file_icon_color()
    local f_name, f_ext = get_file_info()
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    if has_devicons then
        local icon, iconhl = devicons.get_icon(f_name, f_ext)
        if icon ~= nil then
            return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg")
        end
    end

    local icon = get_file_icon():match "%S+"
    for k, _ in pairs(file_icons) do
        if vim.fn.index(file_icons[k], icon) ~= -1 then
            return file_icon_colors[k]
        end
    end
end

M.numbers = {
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
}

M.config = function()
    local theme = require "user.theme"
    local colors = theme.colors.tokyonight_colors

    -- Color table for highlights
    local mode_color = {
        n = colors.git.delete,
        i = colors.green,
        v = colors.yellow,
        [""] = colors.blue,
        V = colors.yellow,
        c = colors.cyan,
        no = colors.magenta,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
    }
    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand "%:t") ~= 1
        end,
        hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end,
        hide_small = function()
            return vim.fn.winwidth(0) > 150
        end,
        check_git_workspace = function()
            local filepath = vim.fn.expand "%:p:h"
            local gitdir = vim.fn.finddir(".git", filepath .. ";")
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
    }

    -- Config
    local config = {
        options = {
            icons_enabled = true,
            -- Disable sections and component separators
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            theme = "auto",
            disabled_filetypes = {
                "dashboard",
                "NvimTree",
                "neo-tree",
                "Outline",
                "alpha",
                "vista",
                "vista_kind",
                "TelescopePrompt",
            },
            always_divide_middle = true,
            globalstatus = lvim.builtin.global_statusline,
        },
        sections = {
            -- these are to remove the defaults
            lualine_a = {},

            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            -- These will be filled later
            lualine_c = {},
            lualine_x = {},
        },
        inactive_sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_v = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {
                {
                    function()
                        local icns = {
                            "  ",
                            "  ",
                            "  ",
                        }
                        return icns[1]
                    end,
                    color = function()
                        return { fg = mode_color[vim.fn.mode()], bg = colors.bg_alt }
                    end,
                    padding = { left = 1, right = 0 },
                },
                {
                    "filename",
                    cond = conditions.buffer_not_empty,
                    color = { fg = colors.blue, gui = "bold", bg = colors.bg },
                },
            },
            lualine_x = {},
        },
    }

    if lvim.builtin.global_statusline then
        config.options.disabled_filetypes = { "alpha" }
    end

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x ot right section
    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    -- Mode icon
    ins_left {
        function()
            return mode()
        end,
        color = function()
            return { fg = mode_color[vim.fn.mode()], bg = colors.bg }
        end,
        padding = { left = 1, right = 0 },
    }

    -- Branch
    ins_left {
        "b:gitsigns_head",
        icon = " ",
        cond = conditions.check_git_workspace,
        color = { fg = colors.blue, bg = colors.bg },
        padding = 0,
    }

    -- File icons
    ins_left {
        function()
            vim.api.nvim_command("hi! LualineFileIconColor guifg=" .. get_file_icon_color() .. " guibg=" .. colors.bg)
            local fname = vim.fn.expand "%:p"
            if string.find(fname, "term://") ~= nil then
                return icons.term
            end
            local winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
            if winnr > 10 then
                winnr = 10
            end
            local win = M.numbers[winnr]
            return win .. " " .. get_file_icon()
        end,
        padding = { left = 2, right = 0 },
        cond = function()
            return conditions.buffer_not_empty() and conditions.hide_small()
        end,
        color = "LualineFileIconColor",
        gui = "bold",
    }

    -- File name
    ins_left {
        function()
            local fname = vim.fn.expand "%:p"
            local ftype = vim.bo.filetype
            local cwd = vim.api.nvim_call_function("getcwd", {})
            if (vim.fn.has "linux" == 1) or (vim.fn.has "mac" == 1) then
                if string.find(fname, "zsh;#toggleterm") ~= nil then
                    return icons.term .. " " .. cwd
                elseif string.find(fname, "lazygit;#toggleterm") ~= nil then
                    local git_repo_cmd = io.popen 'git remote get-url origin | tr -d "\n"'
                    local git_repo = git_repo_cmd:read "*a"
                    git_repo_cmd:close()
                    local git_branch_cmd = io.popen 'git branch --show-current | tr -d "\n"'
                    local git_branch = git_branch_cmd:read "*a"
                    git_branch_cmd:close()
                    return icons.term .. " " .. git_repo .. "~" .. git_branch
                elseif #ftype < 1 and string.find(fname, "term") ~= nil then
                    return icons.term
                end
            end
            local show_name = vim.fn.expand "%:t"
            local modified = ""
            if vim.bo.modified then
                modified = "  "
            end
            return show_name .. modified
        end,
        cond = function()
            return conditions.buffer_not_empty() and conditions.hide_small()
        end,
        padding = { left = 1, right = 1 },
        color = { fg = colors.fg, gui = "bold", bg = colors.bg },
    }

    -- Diff icons
    ins_left {
        "diff",
        source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
                return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                }
            end
        end,
        symbols = { added = icons.added, modified = icons.modified, removed = icons.removed },
        diff_color = {
            added = { fg = colors.git.add, bg = colors.bg },
            modified = { fg = colors.git.change, bg = colors.bg },
            removed = { fg = colors.git.delete, bg = colors.bg },
        },
        color = {},
        cond = nil,
    }

    -- Python env
    ins_left {
        function()
            local utils = require "lvim.core.lualine.utils"
            if vim.bo.filetype == "python" then
                local venv = os.getenv "CONDA_DEFAULT_ENV"
                if venv then
                    return string.format("  (%s)", utils.env_cleanup(venv))
                end
                venv = os.getenv "VIRTUAL_ENV"
                if venv then
                    return string.format("  (%s)", utils.env_cleanup(venv))
                end
                return ""
            end
            return ""
        end,
        color = { fg = colors.green },
        cond = conditions.hide_in_width,
    }

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left {
        function()
            return icons.circle_right
        end,
        padding = { left = 0, right = 0 },
        color = { fg = colors.bg },
        cond = nil,
    }

    ins_right {
        function()
            return icons.circle_left
        end,
        padding = { left = 0, right = 0 },
        color = { fg = colors.bg },
        cond = nil,
    }

    -- Right section.
    ins_right {
        function()
            if not vim.bo.readonly or not vim.bo.modifiable then
                return ""
            end
            return icons.lock -- """
        end,
        color = { fg = colors.red },
    }

    -- Diagnostics
    ins_right {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = icons.error, warn = icons.warn, info = icons.info, hint = icons.hint },
        cond = conditions.hide_in_width,
        color = { fg = colors.fg, bg = colors.bg },
    }

    -- Copilot icon
    ins_right {
        function()
            if require("user.copilot").enabled() then
                return " " .. icons.copilot .. " "
            else
                return ""
            end
        end,
        padding = 0,
        color = { fg = colors.red, bg = colors.bg },
    }

    -- Null-ls icon
    ins_right {
        function()
            local buf_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
            if next(buf_clients) == nil then
                return ""
            end
            for _, client in pairs(buf_clients) do
                if client.name == "null-ls" then
                    return " " .. icons.code_lens_action .. " "
                end
            end
            return ""
        end,
        padding = 0,
        color = { fg = colors.blue, bg = colors.bg },
        cond = conditions.hide_in_width,
    }

    -- Session availability
    ins_right {
        function()
            if vim.g.persisting then
                return icons.presence_on
            elseif vim.g.persisting == false then
                return icons.presence_off
            end
        end,
        cond = function()
            return vim.g.persisting ~= nil
        end,
        color = { fg = colors.green, bg = colors.bg },
    }

    -- Treesitter icon
    ins_right {
        function()
            if next(vim.treesitter.highlighter.active) then
                return " " .. icons.treesitter .. " "
            end
            return ""
        end,
        padding = 0,
        color = { fg = colors.green, bg = colors.bg },
        cond = conditions.hide_in_width,
    }

    -- Lsp providers
    ins_right {
        function(msg)
            msg = msg or icons.ls_inactive
            local buf_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
            if next(buf_clients) == nil then
                if type(msg) == "boolean" or #msg == 0 then
                    return icons.ls_inactive
                end
                return msg
            end
            local buf_ft = vim.bo.filetype
            local buf_client_names = {}
            local trim_width = 100
            local trim = vim.fn.winwidth(0) < trim_width

            for _, client in pairs(buf_clients) do
                if not (client.name == "copilot" or client.name == "null-ls") then
                    local _added_client = client.name
                    if trim then
                        _added_client = string.sub(client.name, 1, 4)
                    end
                    table.insert(buf_client_names, _added_client)
                end
            end

            -- add formatter
            local formatters = require "lvim.lsp.null-ls.formatters"
            local supported_formatters = {}
            for _, fmt in pairs(formatters.list_registered(buf_ft)) do
                local _added_formatter = fmt
                if trim then
                    _added_formatter = string.sub(fmt, 1, 4)
                end
                table.insert(supported_formatters, _added_formatter)
            end
            vim.list_extend(buf_client_names, supported_formatters)

            -- add linter
            local linters = require "lvim.lsp.null-ls.linters"
            local supported_linters = {}
            for _, lnt in pairs(linters.list_registered(buf_ft)) do
                local _added_linter = lnt
                if trim then
                    _added_linter = string.sub(lnt, 1, 4)
                end
                table.insert(supported_linters, _added_linter)
            end
            vim.list_extend(buf_client_names, supported_linters)

            return icons.ls_active .. table.concat(buf_client_names, ", ")
        end,
        color = { fg = colors.fg, bg = colors.bg },
        cond = conditions.hide_in_width,
    }

    -- File location
    ins_right {
        "location",
        padding = 0,
        color = { fg = colors.orange, bg = colors.bg },
    }

    -- File size
    ins_right {
        function()
            local function format_file_size(file)
                local size = vim.fn.getfsize(file)
                if size <= 0 then
                    return ""
                end
                local sufixes = { "b", "k", "m", "g" }
                local i = 1
                while size > 1024 do
                    size = size / 1024
                    i = i + 1
                end
                return string.format("%.1f%s", size, sufixes[i])
            end

            local file = vim.fn.expand "%:p"
            if string.len(file) == 0 then
                return ""
            end
            return format_file_size(file)
        end,
        cond = conditions.buffer_not_empty,
        color = { fg = colors.fg, bg = colors.bg },
    }

    -- File format
    ins_right {
        "fileformat",
        fmt = string.upper,
        icons_enabled = true,
        color = { fg = colors.green, gui = "bold", bg = colors.bg },
        cond = conditions.hide_in_width,
    }

    -- File position
    ins_right {
        function()
            local current_line = vim.fn.line "."
            local total_lines = vim.fn.line "$"
            local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
        end,
        padding = 0,
        color = { fg = colors.yellow, bg = colors.bg },
        cond = nil,
    }

    -- Now don't forget to initialize lualine
    lvim.builtin.lualine.options = config.options
    lvim.builtin.lualine.sections = config.sections
    lvim.builtin.lualine.inactive_sections = config.inactive_sections
end

return M
