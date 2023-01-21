local M = {}

M.session_load_last = function()
    if lvim.builtin.session_manager == "possession" then
        require("possession.commands").load()
    else
        require("persisted").load { last = true }
    end
end

M.config = function()
    local kind = require("user.cmp").kind
    local icons = require("user.icons").icons

    local banner = {
        [[                                                                   ]],
        [[      ████ ██████           █████      ██                    ]],
        [[     ███████████             █████                            ]],
        [[     █████████ ███████████████████ ███   ███████████  ]],
        [[    █████████  ███    █████████████ █████ ██████████████  ]],
        [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
        [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
        [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
    }

    -- Make the header a bit more fun with some color!
    local function colorize_header()
        local lines = {}

        for i, chars in pairs(banner) do
            local line = {
                type = "text",
                val = chars,
                opts = {
                    hl = "StartLogo" .. i,
                    shrink_margin = false,
                    position = "center",
                },
            }

            table.insert(lines, line)
        end

        return lines
    end

    local function text(message, hl, pos)
        if not hl then
            hl = "String"
        end
        if not pos then
            pos = "center"
        end
        return {
            type = "text",
            val = message,
            opts = {
                position = pos,
                hl = hl,
            },
        }
    end

    local header = {
        type = "group",
        val = colorize_header(),
    }

    local plugins = ""
    local handle = io.popen 'fd -d 2 . $HOME"/.local/share/lunarvim/site/pack/lazy" | grep pack | wc -l | tr -d "\n" '
    if handle then
        plugins = handle:read "*a"
        handle:close()
        plugins = plugins:gsub("^%s*(.-)%s*$", "%1")
    end

    local border_upper = text "╭──────────────────────────╮"
    local date = text("│  " .. icons.calendar .. "Today is " .. os.date "%a %d %b" .. "   │")
    local version = text(
        "│  "
            .. " Neovim version "
            .. vim.version().major
            .. "."
            .. vim.version().minor
            .. "."
            .. vim.version().patch
            .. "  │"
    )
    local plugin_count = text("│  " .. kind.Module .. plugins .. " plugins in total  │")
    local border_lower = text "╰──────────────────────────╯"

    local fortune = require "alpha.fortune"()
    -- fortune = fortune:gsub("^%s+", ""):gsub("%s+$", "")
    local footer = {
        type = "text",
        val = fortune,
        opts = {
            position = "center",
            hl = "Comment",
            hl_shortcut = "Comment",
        },
    }

    local function button(sc, txt, keybind)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

        local opts = {
            position = "center",
            text = txt,
            shortcut = sc,
            cursor = 5,
            width = 50,
            align_shortcut = "right",
            hl_shortcut = "Number",
            hl = "Function",
        }
        if keybind then
            opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
        end

        return {
            type = "button",
            val = txt,
            on_press = function()
                local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
                vim.api.nvim_feedkeys(key, "normal", false)
            end,
            opts = opts,
        }
    end

    local buttons = {
        type = "group",
        name = "some",
        val = {
            button("r", icons.clock .. " Smart open", ":lua require('user.telescope').smart_open()<cr>"),
            button("l", icons.magic .. " Last session", ":lua require('user.dashboard').session_load_last()<cr>"),
            button("S", icons.session .. " Sessions", ":lua require('user.telescope').session()<cr>"),
            button("z", icons.folder .. "  Zoxide", ":lua require('user.telescope').zoxide()<cr>"),
            button("f", kind.File .. " Find file", ":lua require('user.telescope').find_project_files()<cr>"),
            button("s", icons.text .. "  Find word", ":lua require('user.telescope').find_string()<cr>"),
            button("n", icons.stuka .. " New file", ":ene <BAR> startinsert <cr>"),
            button("b", icons.files .. " File browser", ":lua require('user.telescope').file_browser()<cr>"),
            button("p", icons.project .. " Projects", ":lua require('user.telescope').projects()<cr>"),
            button("q", icons.exit .. " Quit", ":lua require('user.builtin').smart_quit()<cr>"),
        },
        opts = {
            spacing = 1,
        },
    }

    local section = {
        header = header,
        version = version,
        date = date,
        plugin_count = plugin_count,
        buttons = buttons,
        footer = footer,
        border_upper = border_upper,
        border_lower = border_lower,
    }
    local opts = {
        layout = {
            { type = "padding", val = 1 },
            section.header,
            { type = "padding", val = 2 },
            section.border_upper,
            section.date,
            section.version,
            section.plugin_count,
            section.session_count,
            section.border_lower,
            -- section.top_bar,
            { type = "padding", val = 2 },
            section.buttons,
            -- section.bot_bar,
            { type = "padding", val = 1 },
            section.footer,
        },
        opts = {
            margin = 5,
        },
    }
    if lvim.builtin.session_manager == "possession" then
        local query = require "possession.query"
        local get_layout = function()
            local layout = query.alpha_workspace_layout({}, button, { others_name = "Sessions" })
            table.remove(layout[1]["val"], 1)
            table.remove(layout[1]["val"], 1)
            return layout
        end
        local utils = require "possession.utils"
        local function session()
            return {
                type = "group",
                val = utils.throttle(get_layout, 5000),
                opts = {
                    spacing = 1,
                },
            }
        end

        section = {
            header = header,
            version = version,
            date = date,
            plugin_count = plugin_count,
            buttons = buttons,
            footer = footer,
            border_upper = border_upper,
            border_lower = border_lower,
            session = session(),
        }

        opts = {
            layout = {
                { type = "padding", val = 1 },
                section.header,
                { type = "padding", val = 2 },
                section.border_upper,
                section.date,
                section.version,
                section.plugin_count,
                section.session_count,
                section.border_lower,
                -- section.top_bar,
                { type = "padding", val = 2 },
                section.buttons,
                -- section.bot_bar,
                { type = "padding", val = 1 },
                -- section.session,
                { type = "padding", val = 1 },
                section.footer,
            },
            opts = {
                margin = 5,
            },
        }
    end
    return opts
end

return M
