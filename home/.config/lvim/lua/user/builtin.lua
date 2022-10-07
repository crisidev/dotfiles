local M = {}

M.config = function()
    local icons = require("user.icons").icons

    -- Tree support
    lvim.builtin.tree_provider = "neo-tree"
    -- Sidebar
    lvim.builtin.sidebar = { active = false }
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
    lvim.builtin.noice = { active = true }
    -- Cmpline
    lvim.builtin.cmdline = { active = true }

    -- Theme
    lvim.builtin.theme.options.style = "storm"
    lvim.builtin.theme.options.styles.comments = {}
    lvim.builtin.theme.options.dim_inactive = true

    -- Mason
    lvim.builtin.mason.ui.icons = require("user.icons").mason

    -- Nvimtree
    lvim.builtin.nvimtree.active = lvim.builtin.tree_provider == "nvimtree"
    lvim.builtin.nvimtree.side = "left"
    lvim.builtin.nvimtree.setup.diagnostics = {
        enable = true,
        icons = {
            hint = icons.hint,
            info = icons.info,
            warning = icons.warn,
            error = icons.error,
        },
    }
    lvim.builtin.nvimtree.setup.actions.open_file.resize_window = true
    lvim.builtin.nvimtree.setup.diagnostics.enable = true
    lvim.builtin.nvimtree.setup.hijack_netrw = false
    lvim.builtin.nvimtree.setup.disable_netrw = false
    lvim.builtin.nvimtree.setup.renderer.icons.show = {
        git = false,
        folder = true,
        file = true,
        folder_arrow = true,
    }
    lvim.builtin.nvimtree.setup.renderer.icons.webdev_colors = true
    lvim.builtin.nvimtree.setup.view.width = 60
    lvim.builtin.nvimtree.setup.view.preserve_window_proportions = true

    -- Dashboard
    lvim.builtin.alpha.active = true
    lvim.builtin.alpha.mode = "custom"
    lvim.builtin.alpha["custom"] = { config = require("user.dashboard").config() }

    -- Notify popup
    lvim.builtin.notify.active = true
    lvim.builtin.notify.opts.icons = {
        ERROR = icons.error,
        WARN = icons.warn,
        INFO = icons.info,
        DEBUG = icons.debug,
        TRACE = icons.trace,
    }
    lvim.builtin.notify.opts.min_width = function()
        return math.floor(vim.o.columns * 0.4)
    end
    lvim.builtin.notify.opts.max_width = function()
        return math.floor(vim.o.columns * 0.4)
    end
    lvim.builtin.notify.opts.max_height = function()
        return math.floor(vim.o.lines * 0.8)
    end
    lvim.builtin.notify.opts.render = function(...)
        local notif = select(2, ...)
        local style = notif.title[1] == "" and "minimal" or "default"
        require("notify.render")[style](...)
    end
    lvim.builtin.notify.opts.stages = "fade_in_slide_out"
    lvim.builtin.notify.opts.timeout = 3000
    lvim.builtin.notify.opts.background_colour = "NormalFloat"

    -- Git signs
    lvim.builtin.gitsigns.opts._threaded_diff = true
    lvim.builtin.gitsigns.opts._extmark_signs = true
    lvim.builtin.gitsigns.opts.current_line_blame_formatter = " <author>, <author_time> · <summary>"

    -- Disable q/wq when running inside the IDE.
    if vim.g.crisidev_ide then
        vim.cmd [[ 
            cnoremap <expr> <cr> getcmdtype() == ":" && index(["q", "wq"], getcmdline()) >= 0 ? "<C-u>" : "<cr>"
        ]]
    end

    -- Log level
    lvim.log.level = "warn"
end

return M
