local M = {}

M.config = function()
    local icons = require("user.icons").icons

    lvim.colorscheme = "tokyonight"
    lvim.leader = ","
    lvim.format_on_save = false
    lvim.line_wrap_cursor_movement = false
    lvim.termguicolors = true
    lvim.transparent_window = true
    lvim.reload_config_on_save = true
    lvim.debug = false

    -- Cmp borders
    lvim.builtin.borderless_cmp = true
    -- Tree support
    lvim.builtin.tree_provider = "neo-tree"
    -- Project
    lvim.builtin.project.active = true
    lvim.builtin.project.detection_methods = { "lsp", "pattern" }
    -- Debugging
    lvim.builtin.dap.active = true
    -- Twilight
    lvim.builtin.twilight = { active = true }
    -- Copilot
    lvim.builtin.copilot = { active = true }
    -- Telescope max path length
    lvim.builtin.telescope.max_path_length = 5
    -- LSP Signature help
    lvim.builtin.lsp_signature_help = { active = false }
    -- Twilight
    lvim.builtin.twilight.enable = true
    -- Lir
    lvim.builtin.lir.active = false
    -- Breadcrumbs
    lvim.builtin.breadcrumbs.active = false
    -- Illuminate
    lvim.builtin.illuminate.active = true
    -- Indent lines
    lvim.builtin.indentlines.active = false
    -- Global status line
    lvim.builtin.global_statusline = true
    -- Winbar provider
    lvim.builtin.winbar_provider = "navic"
    -- Noice
    lvim.builtin.noice = {
        active = true,
        lsp_progress = false,
    }
    -- Session manager
    lvim.builtin.session_manager = "persisted"
    -- Movements
    lvim.builtin.motion_provider = "hop"
    -- Cmpline
    lvim.builtin.cmp.cmdline.enable = false
    -- Orgmode
    lvim.builtin.orgmode = { active = false }
    -- Legendary
    lvim.builtin.legendary = { active = false }
    -- Hlargs
    lvim.builtin.hlargs = { active = true }
    -- UltTest
    lvim.builtin.test_runner = { active = true }
    lvim.builtin.task_runner = { active = true }

    -- Theme
    require("user.theme").tokyonight()
    lvim.builtin.theme.name = "tokyonight"

    -- Mason
    lvim.builtin.mason.ui.icons = require("user.icons").mason

    -- Nvimtree
    lvim.builtin.nvimtree.active = false

    -- Dashboard
    lvim.builtin.alpha.active = true
    lvim.builtin.alpha.mode = "custom"
    lvim.builtin.alpha["custom"] = { config = require("user.dashboard").config() }

    -- Git signs
    lvim.builtin.gitsigns.opts._threaded_diff = true
    lvim.builtin.gitsigns.opts._extmark_signs = true
    lvim.builtin.gitsigns.opts.current_line_blame_formatter = " <author>, <author_time> · <summary>"

    -- Disable q/wq when running inside the IDE.
    if vim.g.crisidev_ide then
        vim.cmd [[
            cnoremap <expr> <cr> getcmdtype() == ":" && index(["q", "wq"], getcmdline()) >= 0 ? "<C-u>" : "<cr>"
            cabbrev wq w
        ]]
    end

    -- Log level
    lvim.log.level = "warn"
end

return M
