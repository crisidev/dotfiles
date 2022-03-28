local M = {}
local kind = require "user.lsp"

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

local function testing()
    if vim.g.testing_status == "running" then
        return " "
    end
    if vim.g.testing_status == "fail" then
        return ""
    end
    if vim.g.testing_status == "pass" then
        return " "
    end
    return nil
end
local function using_session()
    return (vim.g.using_persistence ~= nil)
end

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
        icon = kind.icons.question
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
    for k, _ in pairs(kind.file_icons) do
        if vim.fn.index(kind.file_icons[k], icon) ~= -1 then
            return file_icon_colors[k]
        end
    end
end

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
            theme = {
                -- We are going to use lualine_c an lualine_x as left and
                -- right section. Both are highlighted by c theme .  So we
                -- are just setting default looks o statusline
                normal = { c = { fg = colors.fg, bg = colors.bg } },
                inactive = { c = { fg = colors.fg, bg = colors.bg_alt } },
            },
            disabled_filetypes = {
                "dashboard",
                "NvimTree",
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
                    color = { fg = colors.blue, gui = "bold" },
                },
            },
            lualine_x = {},
        },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x ot right section
    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    ins_left {
        function()
            return mode()
        end,
        color = function()
            return { fg = mode_color[vim.fn.mode()], bg = colors.bg }
        end,
        padding = { left = 1, right = 0 },
    }
    ins_left {
        "b:gitsigns_head",
        icon = " ",
        cond = conditions.check_git_workspace,
        color = { fg = colors.blue },
        padding = 0,
    }

    ins_left {
        function()
            local utils = require "lvim.core.lualine.utils"
            local filename = vim.fn.expand "%"
            local kube_env = os.getenv "KUBECONFIG"
            local kube_filename = "kubectl-edit"
            if (vim.bo.filetype == "yaml") and (string.sub(filename, 1, kube_filename:len()) == kube_filename) then
                return string.format("⎈  (%s)", utils.env_cleanup(kube_env))
            end
            return ""
        end,
        color = { fg = colors.cyan },
        cond = conditions.hide_in_width,
    }

    ins_left {
        function()
            vim.api.nvim_command("hi! LualineFileIconColor guifg=" .. get_file_icon_color() .. " guibg=" .. colors.bg)
            local fname = vim.fn.expand "%:p"
            if string.find(fname, "term://") ~= nil then
                return kind.icons.term
            end
            local winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
            if winnr > 10 then
                winnr = 10
            end
            local win = kind.numbers[winnr]
            return win .. " " .. get_file_icon()
        end,
        padding = { left = 2, right = 0 },
        cond = conditions.buffer_not_empty,
        color = "LualineFileIconColor",
        gui = "bold",
    }

    ins_left {
        function()
            local fname = vim.fn.expand "%:p"
            local ftype = vim.fn.expand "%:e"
            local cwd = vim.api.nvim_call_function("getcwd", {})
            if
                string.find(fname, "term") ~= nil
                and string.find(fname, "lazygit;#toggleterm") ~= nil
                and (vim.fn.has "linux" == 1 or vim.fn.has "mac" == 1)
            then
                local git_repo_cmd = io.popen 'git remote get-url origin | tr -d "\n"'
                local git_repo = git_repo_cmd:read "*a"
                git_repo_cmd:close()
                local git_branch_cmd = io.popen 'git branch --show-current | tr -d "\n"'
                local git_branch = git_branch_cmd:read "*a"
                git_branch_cmd:close()
                return git_repo .. "~" .. git_branch
            end
            local show_name = vim.fn.expand "%:t"
            if #cwd > 0 and #ftype > 0 then
                show_name = fname:sub(#cwd + 2)
            end
            return show_name .. "%{&readonly?'  ':''}" .. "%{&modified?'  ':''}"
        end,
        cond = conditions.buffer_not_empty,
        padding = { left = 1, right = 1 },
        color = { fg = colors.fg, gui = "bold" },
    }

    ins_left {
        "diff",
        source = diff_source,
        symbols = { added = kind.icons.added, modified = kind.icons.modified, removed = kind.icons.removed },
        diff_color = {
            added = { fg = colors.git.add, bg = colors.bg },
            modified = { fg = colors.git.change, bg = colors.bg },
            removed = { fg = colors.git.delete, bg = colors.bg },
        },
        color = {},
        cond = nil,
    }

    if not lvim.builtin.fidget.active then
        ins_left {
            "lsp_progress",
            colors = {
                percentage = colors.cyan,
                title = colors.cyan,
                message = colors.cyan,
                spinner = colors.cyan,
                lsp_client_name = colors.magenta,
                use = true,
            },
            separators = {
                component = " ",
                progress = " | ",
                percentage = { pre = "", post = "%% " },
                title = { pre = "", post = ": " },
                lsp_client_name = { pre = "[", post = "]" },
                spinner = { pre = "", post = "" },
                message = { commenced = "In Progress", completed = "Completed", pre = "(", post = ")" },
            },
            display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
            timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
            spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
            cond = conditions.hide_small,
        }
    end

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

    ins_left {
        provider = function()
            return testing()
        end,
        enabled = function()
            return testing() ~= nil
        end,
        hl = {
            fg = colors.fg,
        },
        left_sep = " ",
        right_sep = {
            str = " |",
            hl = { fg = colors.fg },
        },
    }

    ins_left {
        provider = function()
            if vim.g.using_persistence then
                return "  |"
            elseif vim.g.using_persistence == false then
                return "  |"
            end
        end,
        enabled = function()
            return using_session()
        end,
        hl = {
            fg = colors.fg,
        },
    }

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left {
        function()
            return "%="
        end,
    }

    ins_right {
        function()
            if not vim.bo.readonly or not vim.bo.modifiable then
                return ""
            end
            return "" -- """
        end,
        color = { fg = colors.red },
    }

    ins_right {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = kind.icons.error, warn = kind.icons.warn, info = kind.icons.info, hint = kind.icons.hint },
        cond = conditions.hide_in_width,
    }

    ins_right {
        function()
            if next(vim.treesitter.highlighter.active) then
                return "  "
            end
            return ""
        end,
        padding = 0,
        color = { fg = colors.green },
        cond = conditions.hide_in_width,
    }

    ins_right {
        function(msg)
            msg = msg or kind.icons.ls_inactive
            local buf_clients = vim.lsp.buf_get_clients()
            if next(buf_clients) == nil then
                if type(msg) == "boolean" or #msg == 0 then
                    return kind.icons.ls_inactive
                end
                return msg
            end
            local buf_ft = vim.bo.filetype
            local buf_client_names = {}
            local trim_width = 120
            if lvim.builtin.global_statusline then
                trim_width = 100
            end
            local trim = vim.fn.winwidth(0) < trim_width

            for _, client in pairs(buf_clients) do
                if client.name ~= "null-ls" then
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

            return kind.icons.ls_active .. table.concat(buf_client_names, ", ")
        end,
        color = { fg = colors.fg },
        cond = conditions.hide_in_width,
    }

    ins_right {
        "location",
        padding = 0,
        color = { fg = colors.orange },
    }

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
    }

    ins_right {
        "fileformat",
        fmt = string.upper,
        icons_enabled = true,
        color = { fg = colors.green, gui = "bold" },
        cond = conditions.hide_in_width,
    }

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
