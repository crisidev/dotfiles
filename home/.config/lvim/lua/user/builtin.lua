local M = {}

M.config = function()
    local icons = require("user.icons").icons
    local nvimtree_icons = require("user.icons").nvimtree_icons

    -- Tree support
    lvim.builtin.tree_provider = "nvimtree"
    -- Sidebar
    lvim.builtin.sidebar = { active = false }
    -- Project
    lvim.builtin.project.active = true
    lvim.builtin.project.detection_methods = { "lsp", "pattern" }
    -- Debugging
    lvim.builtin.dap.active = true
    -- Twilight
    lvim.builtin.twilight = { active = false }
    -- Copilot
    lvim.builtin.copilot = { active = true }
    -- Telescope max path length
    lvim.builtin.telescope.max_path_length = 5
    -- LSP Signature help
    lvim.builtin.lsp_signature_help = { active = false }
    -- Twilight
    lvim.builtin.twilight.enable = true
    -- Other stuff
    lvim.builtin.lir.active = false
    lvim.builtin.breadcrumbs.active = true
    lvim.builtin.illuminate.active = true

    -- Theme
    lvim.builtin.theme.options.style = "storm"
    lvim.builtin.theme.options.styles.comments = {}
    lvim.builtin.theme.options.dim_inactive = true

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
    lvim.builtin.nvimtree.setup.renderer.icons.glyphs = nvimtree_icons
    lvim.builtin.nvimtree.setup.renderer.icons.webdev_colors = true
    lvim.builtin.nvimtree.setup.view.width = 60
    lvim.builtin.nvimtree.setup.view.preserve_window_proportions = true

    -- Dashboard
    lvim.builtin.alpha.active = true
    lvim.builtin.alpha.mode = "custom"
    lvim.builtin.alpha["custom"] = { config = require("user.dashboard").config() }

    -- Terminal
    lvim.builtin.terminal.autochdir = true
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
        ERROR = icons.error,
        WARN = icons.warn,
        INFO = icons.info,
        DEBUG = icons.debug,
        TRACE = icons.trace,
    }

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
