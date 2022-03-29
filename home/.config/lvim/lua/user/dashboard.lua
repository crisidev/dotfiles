local M = {}

M.config = function()
    local kind = require "user.lsp"

    local header = {
        type = "text",
        val = require("user.banners").dashboard(),
        opts = {
            position = "center",
            hl = "Comment",
        },
    }

    local plugins = ""
    local date = ""
    if vim.fn.has "linux" == 1 or vim.fn.has "mac" == 1 then
        local handle =
            io.popen 'fd -d 2 . $HOME"/.local/share/lunarvim/site/pack/packer" | grep pack | wc -l | tr -d "\n" '
        plugins = handle:read "*a"
        handle:close()

        local thingy = io.popen 'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'
        date = thingy:read "*a"
        thingy:close()
        plugins = plugins:gsub("^%s*(.-)%s*$", "%1")
    else
        plugins = "N/A"
        date = "  whatever "
    end

    local plugin_count = {
        type = "text",
        val = "└─ " .. kind.cmp_kind.Module .. " " .. plugins .. " plugins in total ─┘",
        opts = {
            position = "center",
            hl = "String",
        },
    }

    local heading = {
        type = "text",
        val = "┌─ " .. kind.icons.calendar .. " Today is " .. date .. " ─┐",
        opts = {
            position = "center",
            hl = "String",
        },
    }

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
            width = 30,
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
            button(
                "r",
                " " .. kind.icons.clock .. " Recent files",
                ":lua require('user.telescope').recent_files()<cr>"
            ),
            button("l", " " .. kind.icons.magic .. " Last session", ":SessionManager load_last_session<cr>"),
            button("S", " " .. kind.icons.session .. " Sessions", ":SessionManager load_session<cr>"),
            button("n", " " .. kind.icons.stuka .. " New file", ":ene <BAR> startinsert <cr>"),
            button("b", " " .. kind.icons.files .. " File browswer", ":Telescope file_browser<cr>"),
            button("f", " " .. kind.cmp_kind.File .. " Find file", ":lua require('user.telescope').find_files()<cr>"),
            button("s", " " .. kind.icons.text .. "  Find word", ":lua require('user.telescope').find_string()<cr>"),
            button(
                "p",
                " " .. kind.icons.project .. " Projects",
                ":lua require('telescope').extensions.repo.list{}<cr>"
            ),
            button(
                "z",
                " " .. kind.icons.zoxide .. "  Zoxide",
                ":lua require('telescope').extensions.zoxide.list{}<cr>"
            ),
            button(
                "g",
                " " .. kind.icons.git .. "  Git Status",
                ":lua require('lvim.core.terminal')._exec_toggle({cmd = 'lazygit', count = 1, direction = 'float'})<CR>"
            ),

            button("q", " " .. kind.icons.exit .. " Quit", ":SmartQ<cr>"),
        },
        opts = {
            spacing = 1,
        },
    }

    local section = {
        header = header,
        buttons = buttons,
        plugin_count = plugin_count,
        heading = heading,
        footer = footer,
    }

    local opts = {
        layout = {
            { type = "padding", val = 1 },
            section.header,
            { type = "padding", val = 2 },
            section.heading,
            section.plugin_count,
            { type = "padding", val = 1 },
            -- section.top_bar,
            section.buttons,
            -- section.bot_bar,
            -- { type = "padding", val = 1 },
            section.footer,
        },
        opts = {
            margin = 5,
        },
    }
    return opts
end

return M
