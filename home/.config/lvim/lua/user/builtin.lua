local M = {}

M.config = function()
    -- Theme
    lvim.colorscheme = "tokyonight"
    require("user.theme").tokyonight()
    lvim.builtin.theme.name = "tokyonight"

    -- Builtins
    lvim.leader = ","
    lvim.format_on_save = false
    lvim.line_wrap_cursor_movement = false
    lvim.reload_config_on_save = false
    lvim.termguicolors = true
    lvim.transparent_window = false
    lvim.reload_config_on_save = true
    lvim.debug = false

    -- Tree support
    lvim.builtin.tree_provider = "neo-tree"
    lvim.builtin.nvimtree.active = false
    -- Project
    lvim.builtin.project.active = true
    lvim.builtin.project.detection_methods = { "lsp", "pattern" }
    -- Debugging
    lvim.builtin.dap.active = true
    -- Noice
    lvim.builtin.noice = { active = true }
    -- Grammarous
    lvim.builtin.grammarous = { active = false }
    -- Twilight
    lvim.builtin.twilight = { enable = true }
    -- Copilot
    lvim.builtin.copilot = { active = true }
    -- LSP Signature help
    lvim.builtin.lsp_signature_help = { active = true }
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
    -- Cmpline
    lvim.builtin.cmp.cmdline.enable = true
    lvim.builtin.cmp.dictionary = { enable = false }
    -- Big file management
    lvim.builtin.bigfile.active = true
    -- Drop stars
    lvim.builtin.drop = { active = false }
    -- Scala
    lvim.builtin.metals = { active = false }

    -- Mason
    lvim.builtin.mason.ui.icons = require("user.icons").mason
    lvim.builtin.treesitter_textobjects = { active = false }

    -- Icons
    lvim.builtin.custom_web_devicons = true
    lvim.use_icons = false
    if not lvim.use_icons and lvim.builtin.custom_web_devicons then
        require("user.icons").use_my_icons()
    end

    -- Dashboard
    lvim.builtin.alpha.active = true
    lvim.builtin.alpha.mode = "custom"
    lvim.builtin.alpha["custom"] = { config = require("user.dashboard").config() }

    -- Git signs
    lvim.builtin.gitsigns.opts._threaded_diff = true
    lvim.builtin.gitsigns.opts._extmark_signs = true
    lvim.builtin.gitsigns.opts.attach_to_untracked = false
    lvim.builtin.gitsigns.opts.current_line_blame_formatter = " <author>, <author_time> · <summary>"
    -- Log level
    lvim.log.level = "warn"
end

M.smart_quit = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    vim.cmd "Neotree close"
    if modified then
        vim.ui.input({
            prompt = "You have unsaved changes. Quit anyway? (y/n) ",
        }, function(input)
            if input == "y" then
                vim.cmd "q!"
            end
        end)
    else
        vim.cmd "q!"
    end
end

return M
