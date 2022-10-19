local M = {}

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
    local sessions = ""
    local date = os.date "%a %d %b"
    local version = " " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    local handle = io.popen 'fd -d 2 . $HOME"/.local/share/lunarvim/site/pack/packer" | grep pack | wc -l | tr -d "\n" '
    if handle then
        plugins = handle:read "*a"
        handle:close()
        plugins = plugins:gsub("^%s*(.-)%s*$", "%1")
    end

    local handle = io.popen 'fd -d 1 . $HOME"/.local/share/nvim/sessions" | wc -l | tr -d "\n" '
    if handle then
        sessions = handle:read "*a"
        handle:close()
    end

    local version = text(version, "Function")
    date = text("┌─ " .. icons.calendar .. "Today is " .. date .. "  ─┐")
    local plugin_count = text("❙  " .. kind.Module .. " " .. plugins .. " plugins in total ❙")
    local session_count = text("└─ " .. icons.session .. " " .. sessions .. " neovim sessions  ─┘")

    local fortune = require "alpha.fortune" ()
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
        val = {
            button("r", " " .. icons.clock .. " Recent files", ":lua require('user.telescope').recent_files()<cr>"),
            button("l", " " .. icons.magic .. " Last session", ":SessionLoadLast<cr>"),
            button("S", " " .. icons.session .. " Sessions", ":lua require('user.telescope').persisted()<cr>"),
            button("z", " " .. icons.folder .. "  Zoxide", ":lua require('user.telescope').zoxide()<cr>"),
            button("f", " " .. kind.File .. " Find file", ":lua require('user.telescope').find_project_files()<cr>"),
            button("s", " " .. icons.text .. "  Find word", ":lua require('user.telescope').find_string()<cr>"),
            button("n", " " .. icons.stuka .. " New file", ":ene <BAR> startinsert <cr>"),
            button("b", " " .. icons.files .. " File browswer", ":lua require('user.telescope').file_browser()<cr>"),
            button("p", " " .. icons.project .. " Projects", ":lua require('user.telescope').projects()<cr>"),
            button("q", " " .. icons.exit .. " Quit", ":confirm qall<cr>"),
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
        session_count = session_count,
        buttons = buttons,
        footer = footer,
    }

    local opts = {
        layout = {
            { type = "padding", val = 1 },
            section.header,
            { type = "padding", val = 2 },
            section.version,
            { type = "padding", val = 1 },
            section.date,
            section.plugin_count,
            section.session_count,
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
    return opts
end

return M
