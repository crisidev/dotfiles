local M = {}

M.config = function()
    lvim.plugins = {
        -- Color schemes
        {
            "folke/tokyonight.nvim",
            config = function()
                require("user/theme").tokyonight()
            end,
        },
        { "folke/lsp-colors.nvim" },
        { "lunarvim/colorschemes" },
        { "Pocco81/Catppuccino.nvim" },
        -- Markdown preview
        {
            "iamcco/markdown-preview.nvim",
            run = "cd app && npm install",
            ft = { "markdown" },
            config = function()
                vim.g.mkdp_auto_start = 1
                vim.g.mkdp_browser = "/usr/bin/firefox"
            end,
        },
        -- Glow markdown preview
        {
            "ellisonleao/glow.nvim",
            ft = { "markdown" },
        },
        -- Better diff view
        {
            "sindrets/diffview.nvim",
            config = function()
                require("diffview").setup()
            end,
            event = "BufRead",
        },
        -- Pick up where you left
        {
            "ethanholz/nvim-lastplace",
            event = "BufRead",
            config = function()
                require("nvim-lastplace").setup {
                    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
                    lastplace_ignore_filetype = {
                        "gitcommit",
                        "gitrebase",
                        "svn",
                        "hgcommit",
                    },
                    lastplace_open_folds = true,
                }
            end,
        },
        -- Git
        -- Fugitive
        {
            "tpope/vim-fugitive",
            cmd = {
                "G",
                "Git",
                "Gdiffsplit",
                "Gread",
                "Gwrite",
                "Ggrep",
                "GMove",
                "GDelete",
                "GBrowse",
                "GRemove",
                "GRename",
                "Glgrep",
                "Gedit",
            },
            ft = { "fugitive" },
        },
        -- Git blame
        {
            "f-person/git-blame.nvim",
            config = function()
                vim.cmd "highlight default link gitblame Question"
            end,
        },
        -- Github management
        {
            "pwntester/octo.nvim",
            config = function()
                require("octo").setup()
            end,
            event = "BufRead",
        },
        -- Session manager
        {
            "folke/persistence.nvim",
            event = "BufReadPre",
            module = "persistence",
            config = function()
                require("persistence").setup {
                    dir = vim.fn.expand(vim.fn.stdpath "config" .. "/sessions/"),
                    options = { "buffers", "curdir", "tabpages", "winsize" },
                }
            end,
        },
        -- Kotlin
        {
            "udalov/kotlin-vim",
            ft = { "kotlin", "kt" },
        },
        -- Lsp
        -- Lsp progress
        { "arkav/lualine-lsp-progress" },
        -- Lsp signature
        {
            "ray-x/lsp_signature.nvim",
            ft = { "rust", "rs" },
            event = "InsertEnter",
            config = function()
                require("lsp_signature").on_attach {
                    bind = true,
                    handler_opts = {
                        border = "single",
                    },
                    -- extra_trigger_chars = { "(", "," },
                }
            end,
        },
        -- Lsp goto preview
        {
            "rmagatti/goto-preview",
            config = function()
                require("goto-preview").setup {
                    default_mappings = false,
                }
            end,
        },
        -- Lsp Lua
        {
            "folke/lua-dev.nvim",
            config = function()
                local luadev = require("lua-dev").setup {
                    lspconfig = lvim.lang.lua.lsp.setup,
                }
                lvim.lang.lua.lsp.setup = luadev
            end,
        },
        -- Lsp Rust
        {
            "simrat39/rust-tools.nvim",
            ft = { "rust", "rs" },
            config = function()
                local lsp_installer_servers = require "nvim-lsp-installer.servers"
                local _, requested_server = lsp_installer_servers.get_server "rust_analyzer"
                local opts = {
                    tools = {
                        autoSetHints = true,
                        hover_with_actions = true,
                        runnables = {
                            use_telescope = true,
                        },
                        debuggables = {
                            use_telescope = true,
                        },
                        inlay_hints = {
                            only_current_line = true,
                            show_parameter_hints = false,
                        },
                        hover_actions = {
                            auto_focus = false,
                        },
                    },
                    server = {
                        cmd = requested_server._default_options.cmd,
                        on_attach = require("lvim.lsp").common_on_attach,
                        on_init = require("lvim.lsp").common_on_init,
                    },
                }
                require("rust-tools").setup(opts)
            end,
        },
        -- Symbol outline
        {
            "simrat39/symbols-outline.nvim",
            config = function()
                local opts = {
                    highlight_hovered_item = true,
                    show_guides = true,
                    auto_preview = false,
                    position = "right",
                    width = 20,
                    show_numbers = false,
                    show_relative_numbers = false,
                    show_symbol_details = true,
                    keymaps = {
                        close = { "<Esc>", "q" },
                        goto_location = "<Cr>",
                        focus_location = "o",
                        hover_symbol = "<C-h",
                        toggle_preview = "K",
                        rename_symbol = "r",
                        code_actions = "a",
                    },
                }
                require("symbols-outline").setup(opts)
            end,
            cmd = "SymbolsOutline",
        },
        -- Diagnostics
        {
            "folke/trouble.nvim",
            cmd = "TroubleToggle",
        },
        -- Python coverage highlight
        { "mgedmin/coverage-highlight.vim" },
        -- Goyo
        { "junegunn/goyo.vim" },
        { "junegunn/limelight.vim" },
        -- Markdown TOC
        {
            "mzlogin/vim-markdown-toc",
            ft = "markdown",
        },
        -- Screenshots
        {
            "JMcKiern/vim-shoot",
            run = "./install.py geckodriver",
            config = function()
                vim.api.nvim_set_var("shoot_zoom_factor", 1)
            end,
        },
        -- Smithy
        { "jasdel/vim-smithy" },
        -- Multi-edit support
        { "mg979/vim-visual-multi" },
        -- Colorizer
        {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require("colorizer").setup()
            end,
        },
        -- Debugging UI
        {
            "rcarriga/nvim-dap-ui",
            config = function()
                require("dapui").setup()
            end,
            ft = { "python", "rust", "rs", "go", "c" },
            requires = { "mfussenegger/nvim-dap" },
            disable = not lvim.builtin.dap.active,
        },
        -- Peek line number
        {
            "nacro90/numb.nvim",
            event = "BufRead",
            config = function()
                require("numb").setup {
                    show_numbers = true,
                    show_cursorline = true,
                }
            end,
        },
        -- Spelling
        {
            "lewis6991/spellsitter.nvim",
            config = function()
                require("spellsitter").setup {
                    hl = "SpellBad",
                    captures = { "comment" },
                }
            end,
        },
        -- i3 syntax
        { "mboughaba/i3config.vim" },
        -- Firevim
        {
            "glacambre/firenvim",
            run = function()
                vim.fn["firenvim#install"](0)
            end,
        },
        -- TODO comments
        {
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("todo-comments").setup {}
            end,
        },
        -- Qbf
        {
            "kevinhwang91/nvim-bqf",
            config = function()
                require("bqf").setup {
                    auto_resize_height = true,
                    func_map = {
                        tab = "st",
                        split = "sv",
                        vsplit = "sg",

                        stoggleup = "K",
                        stoggledown = "J",
                        stogglevm = "<Space>",

                        ptoggleitem = "p",
                        ptoggleauto = "P",
                        ptogglemode = "zp",

                        pscrollup = "<C-b>",
                        pscrolldown = "<C-f>",

                        prevfile = "gk",
                        nextfile = "gj",

                        prevhist = "<S-Tab>",
                        nexthist = "<Tab>",
                    },
                    preview = {
                        auto_preview = true,
                        should_preview_cb = function(bufnr)
                            local ret = true
                            local filename = vim.api.nvim_buf_get_name(bufnr)
                            local fsize = vim.fn.getfsize(filename)
                            -- file size greater than 10k can't be previewed automatically
                            if fsize > 100 * 1024 then
                                ret = false
                            end
                            return ret
                        end,
                    },
                }
            end,
            event = "BufRead",
        },
    }
end

return M
