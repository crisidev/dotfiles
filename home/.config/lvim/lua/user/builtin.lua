local M = {}

M.config = function()
    -- Nvimtree
    lvim.builtin.nvimtree.side = "left"
    local kind = require "user.lsp"
    lvim.builtin.nvimtree.setup.diagnostics = {
        enable = true,
        icons = {
            hint = kind.icons.hint,
            info = kind.icons.info,
            warning = kind.icons.warn,
            error = kind.icons.error,
        },
    }
    lvim.builtin.nvimtree.setup.actions.open_file.resize_window = true
    lvim.builtin.nvimtree.icons = kind.nvim_tree_icons
    lvim.builtin.nvimtree.setup.diagnostics.enable = true
    lvim.builtin.nvimtree.setup.hijack_netrw = false
    lvim.builtin.nvimtree.setup.disable_netrw = false
    lvim.builtin.nvimtree.setup.renderer.icons.webdev_colors = true
    lvim.builtin.nvimtree.show_icons = {
        git = 0,
        folders = 1,
        files = 1,
        folder_arrows = 1,
    }

    -- Sidebar
    lvim.builtin.sidebar = { active = true }
    -- Statusline
    lvim.builtin.global_statusline = { active = true }
    -- Project
    lvim.builtin.project.active = true
    lvim.builtin.project.detection_methods = { "lsp", "pattern" }
    -- Debugging
    lvim.builtin.dap.active = true
    -- File browser
    lvim.builtin.file_browser = { active = true }
    -- Fidget vs lualine lsp progress
    lvim.builtin.fidget = { active = true }
    -- Editor config
    lvim.builtin.editorconfig = { active = true }
    -- Grammar guard
    lvim.builtin.grammar_guard = { active = true }
    -- Hlslens
    lvim.builtin.hlslens = { active = true }
    -- Twilight
    lvim.builtin.twilight = { active = false }
    -- Async tasks
    lvim.builtin.async_tasks = { active = true }
    -- Dressing
    lvim.builtin.dressing = { active = true }
    -- Fancy menu
    lvim.builtin.fancy_wild_menu = { active = true }
    -- Refactoring
    lvim.builtin.refactoring = { active = true }
    -- Copilot
    lvim.builtin.copilot = { active = true, cmp_source = false }

    -- Dashboard
    lvim.builtin.alpha.active = true
    lvim.builtin.alpha.mode = "custom"
    lvim.builtin.alpha["custom"] = { config = require("user.dashboard").config() }

    -- Terminal
    lvim.builtin.terminal.active = true
    lvim.builtin.terminal.open_mapping = [[<c-\\>]]
    lvim.builtin.terminal.execs = {
        { "zsh", "<c-\\>", "Terminal", "float" },
        { "zsh", "<c-]>", "Terminal", "horizontal" },
        { "lazygit", "<c-g>", "LazyGit", "float" },
    }

    -- Notify popup
    lvim.builtin.notify.active = true
    lvim.builtin.notify.opts.icons = {
        ERROR = kind.icons.error,
        WARN = kind.icons.warn,
        INFO = kind.icons.info,
        DEBUG = kind.icons.debug,
        TRACE = kind.icons.trace,
    }

    -- Log level
    lvim.log.level = "warn"
end

-- Utility
function M.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

return M
