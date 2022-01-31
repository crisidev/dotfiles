local M = {}

M.config = function()
    lvim.plugins = {
        -- Color schemes
        {
            "folke/tokyonight.nvim",
            config = function()
                require("user.theme").tokyonight()
            end,
        },
        { "folke/lsp-colors.nvim" },
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
            cmd = { "DiffviewOpen", "DiffviewFileHistory" },
            module = "diffview",
            keys = "<leader>gd",
            setup = function()
                -- require("which-key").register { ["Gd"] = "diffview: diff HEAD" }
            end,
            config = function()
                require("diffview").setup {
                    enhanced_diff_hl = true,
                    key_bindings = {
                        file_panel = { q = "<Cmd>DiffviewClose<CR>" },
                        view = { q = "<Cmd>DiffviewClose<CR>" },
                    },
                }
            end,
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
                vim.g.gitblame_enabled = 0
                vim.g.gitblame_message_template = "<date> • <author> • <summary>"
                vim.g.gitblame_date_format = "%r"
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
        -- Git linker
        {
            "ruifm/gitlinker.nvim",
            event = "BufRead",
            config = function()
                require("gitlinker").setup {
                    opts = {
                        -- adds current line nr in the url for normal mode
                        add_current_line_on_normal_mode = true,
                        -- callback for what to do with the url
                        action_callback = require("gitlinker.actions").copy_to_clipboard,
                        -- print the url after performing the action
                        print_url = false,
                        -- mapping to call url generation
                        mappings = "gy",
                    },
                    callbacks = {
                        ["code.crisidev.org"] = require("gitlinker.hosts").get_gitea_type_url,
                        ["git.amazon.com"] = require("user.amzn").get_amazon_type_url,
                    },
                }
            end,
            requires = "nvim-lua/plenary.nvim",
        },

        -- Session manager
        {
            "Shatur/neovim-session-manager",
            config = function()
                local Path = require "plenary.path"
                require("session_manager").setup {
                    sessions_dir = Path:new(vim.fn.stdpath "config", "/sessions/"),
                    path_replacer = "__",
                    colon_replacer = "++",
                    autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
                    autosave_last_session = true,
                    autosave_ignore_not_normal = true,
                    autosave_only_in_session = false,
                }
            end,
            requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
        },
        -- Lsp
        -- Lsp signature
        -- {
        --     "ray-x/lsp_signature.nvim",
        --     ft = { "python", "rust", "go" },
        --     event = { "BufRead", "BufNew" },
        --     config = function()
        --         require("lsp_signature").on_attach {
        --             bind = true,
        --             handler_opts = {
        --                 border = "single",
        --             },
        --             doc_lines = 0,
        --             transpancy = 60,
        --             shadow_blend = 30,
        --             hint_enable = false,
        --             toggle_key = "<C-L>",
        --             padding = " ",
        --             -- extra_trigger_chars = { "(", "," },
        --         }
        --     end,
        -- },
        -- Lsp goto preview
        {
            "arkav/lualine-lsp-progress",
            disable = lvim.builtin.fidget.active,
        },
        {
            "j-hui/fidget.nvim",
            config = function()
                require("user.fidget").config()
            end,
            disable = not lvim.builtin.fidget.active,
        },
        {
            "rmagatti/goto-preview",
            config = function()
                require("goto-preview").setup {
                    default_mappings = false,
                }
            end,
        },
        -- Lsp Rust
        {
            "simrat39/rust-tools.nvim",
            ft = { "rust", "rs" },
            config = function()
                require("user.rust-tools").config()
            end,
        },
        -- Lsp Typescript
        {
            "jose-elias-alvarez/nvim-lsp-ts-utils",
            ft = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
            },
            opt = true,
            event = "BufReadPre",
            before = "williamboman/nvim-lsp-installer",
        },
        -- Code action with menu
        {
            "weilbith/nvim-code-action-menu",
            cmd = "CodeActionMenu",
            config = function ()
                vim.g.code_action_menu_show_diff = false
            end
        },
        -- Copilot
        {
            "github/copilot.vim",
            config = function()
                vim.g.copilot_no_tab_map = true
                vim.g.copilot_assume_mapped = true
                vim.g.copilot_tab_fallback = ""
                vim.g.copilot_filetypes = {
                    ["*"] = false,
                    python = true,
                    lua = true,
                    go = true,
                    rust = true,
                    html = true,
                    c = true,
                    cpp = true,
                    javascript = true,
                    typescript = true,
                }
            end,
            disable = not lvim.builtin.copilot.active,
        },
        -- Grammar
        {
            "brymer-meneses/grammar-guard.nvim",
            config = function()
                require("grammar-guard").init()
            end,
            filetype = { "latex", "tex", "bib", "markdown", "rst", "text" },
            requires = {
                "neovim/nvim-lspconfig",
                "williamboman/nvim-lsp-installer",
            },
        },
        -- Renamer
        {
            "filipdutescu/renamer.nvim",
            config = function()
                require("user.renamer").config()
            end,
        },
        -- Cmp
        -- Dictionary cmp
        {
            "uga-rosa/cmp-dictionary",
            config = function()
                require("cmp_dictionary").setup {
                    dic = {
                        ["markdown"] = { "/usr/share/dict/words", "/usr/share/dict/british-english" },
                        ["rst"] = { "/usr/share/dict/words", "/usr/share/dict/british-english" },
                        ["*"] = {},
                    },
                }
            end,
            rocks = { "mpack" },
        },
        -- Crates cmp
        {
            "Saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("crates").setup()
            end,
        },
        -- Treesitter cmp
        {
            "ray-x/cmp-treesitter",
            requires = "nvim-treesitter/nvim-treesitter",
        },
        -- Better comparison order
        { "lukas-reineke/cmp-under-comparator" },
        -- Neogen
        {
            "danymat/neogen",
            config = function()
                require("neogen").setup {
                    enabled = true,
                }
            end,
            event = "InsertEnter",
            requires = "nvim-treesitter/nvim-treesitter",
        },
        -- Symbol outline
        {
            "zeertzjq/symbols-outline.nvim",
            branch = "patch-1",
            config = function()
                local kind = require("user.lsp").symbols_outline
                local opts = {
                    highlight_hovered_item = true,
                    show_guides = true,
                    auto_preview = false,
                    position = "right",
                    width = 25,
                    show_numbers = false,
                    show_relative_numbers = false,
                    show_symbol_details = true,
                    preview_bg_highlight = "Pmenu",
                    keymaps = { -- These keymaps can be a string or a table for multiple keys
                        close = { "<Esc>", "q" },
                        goto_location = "<Cr>",
                        focus_location = "o",
                        hover_symbol = "<C-space>",
                        toggle_preview = "K",
                        rename_symbol = "r",
                        code_actions = "a",
                    },
                    lsp_blacklist = {},
                    symbol_blacklist = {},
                    symbols = {
                        File = { icon = kind.File, hl = "TSURI" },
                        Module = { icon = kind.Module, hl = "TSNamespace" },
                        Namespace = { icon = kind.Namespace, hl = "TSNamespace" },
                        Package = { icon = kind.Package, hl = "TSNamespace" },
                        Class = { icon = kind.Class, hl = "TSType" },
                        Method = { icon = kind.Method, hl = "TSMethod" },
                        Property = { icon = kind.Property, hl = "TSMethod" },
                        Field = { icon = kind.Field, hl = "TSField" },
                        Constructor = { icon = kind.Constructor, hl = "TSConstructor" },
                        Enum = { icon = kind.Enum, hl = "TSType" },
                        Interface = { icon = kind.Interface, hl = "TSType" },
                        Function = { icon = kind.Function, hl = "TSFunction" },
                        Variable = { icon = kind.Variable, hl = "TSConstant" },
                        Constant = { icon = kind.Constant, hl = "TSConstant" },
                        String = { icon = kind.String, hl = "TSString" },
                        Number = { icon = kind.Number, hl = "TSNumber" },
                        Boolean = { icon = kind.Boolean, hl = "TSBoolean" },
                        Array = { icon = kind.Array, hl = "TSConstant" },
                        Object = { icon = kind.Object, hl = "TSType" },
                        Key = { icon = kind.Key, hl = "TSType" },
                        Null = { icon = kind.Null, hl = "TSType" },
                        EnumMember = { icon = kind.EnumMember, hl = "TSField" },
                        Struct = { icon = kind.Struct, hl = "TSType" },
                        Event = { icon = kind.Event, hl = "TSType" },
                        Operator = { icon = kind.Operator, hl = "TSOperator" },
                        TypeParameter = { icon = kind.TypeParameter, hl = "TSParameter" },
                    },
                }
                require("symbols-outline").setup(opts)
            end,
            -- cmd = "SymbolsOutline",
            event = "BufReadPost",
        },
        -- Lightbulb
        {
            "kosayoda/nvim-lightbulb",
            config = function()
                vim.fn.sign_define(
                    "LightBulbSign",
                    { text = require("user.lsp").icons.code_action, texthl = "DiagnosticInfo" }
                )
            end,
            event = "BufRead",
            ft = { "rust", "go" },
        },
        -- Diagnostics
        {
            "folke/trouble.nvim",
            config = function()
                require("trouble").setup {
                    auto_open = true,
                    auto_close = true,
                    padding = false,
                    height = 10,
                    use_diagnostic_signs = true,
                }
            end,
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
        -- {
        --     "nacro90/numb.nvim",
        --     event = "BufRead",
        --     config = function()
        --         require("numb").setup {
        --             show_numbers = true,
        --             show_cursorline = true,
        --         }
        --     end,
        -- },
        -- -- Spelling
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
        -- TODO comments
        {
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                local icons = require("user.lsp").todo_comments
                require("todo-comments").setup {
                    keywords = {
                        FIX = { icon = icons.FIX },
                        TODO = { icon = icons.TODO, alt = { "WIP" } },
                        HACK = { icon = icons.HACK, color = "hack" },
                        WARN = { icon = icons.WARN },
                        PERF = { icon = icons.PERF },
                        NOTE = { icon = icons.NOTE, alt = { "INFO", "NB" } },
                        ERROR = { icon = icons.ERROR, color = "error", alt = { "ERR" } },
                        REFS = { icon = icons.REFS },
                    },
                    highlight = { max_line_len = 120 },
                    colors = {
                        error = { "DiagnosticError" },
                        warning = { "DiagnosticWarn" },
                        info = { "DiagnosticInfo" },
                        hint = { "DiagnosticHint" },
                        hack = { "Function" },
                        ref = { "FloatBorder" },
                        default = { "Identifier" },
                    },
                }
            end,
        },
        -- Spectre
        {
            "windwp/nvim-spectre",
            event = "BufRead",
            config = function()
                require("user.spectre").config()
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
        -- Sidebar
        {
            "sidebar-nvim/sidebar.nvim",
            config = function()
                require("user.sidebar").config()
            end,
            -- event = "BufRead",
            disable = not lvim.builtin.sidebar.active,
        },
        -- Zoxide
        { "nanotee/zoxide.vim" },
        -- Faster filetype
        {
            "nathom/filetype.nvim",
            config = function()
                require("filetype").setup {
                    overrides = {
                        literal = {
                            ["kitty.conf"] = "kitty",
                            [".gitignore"] = "conf",
                        },
                    },
                }
            end,
        },
        -- Telescope zoxide
        {
            "jvgrootveld/telescope-zoxide",
            event = "BufWinEnter",
            requires = { "nvim-telescope/telescope.nvim" },
        },
        -- Telescope frecency
        {
            "nvim-telescope/telescope-frecency.nvim",
            event = "BufWinEnter",
            requires = { "tami5/sqlite.lua", "nvim-telescope/telescope.nvim" },
        },
        -- Telescope repo
        {
            "cljoly/telescope-repo.nvim",
            event = "BufWinEnter",
            requires = { "nvim-lua/plenary.nvim" },
        },
        -- Telescope UI select
        { "nvim-telescope/telescope-ui-select.nvim" },
        -- Telescope file browser
        { "nvim-telescope/telescope-file-browser.nvim" },
        -- Stable window open
        {
            "luukvbaal/stabilize.nvim",
            config = function()
                require("stabilize").setup {
                    forcemark = "f",
                    nested = "QuickFixCmdPost,User LspDiagnosticsChanged",
                }
            end,
        },
        -- Log highlight
        {
            "mtdl9/vim-log-highlighting",
            ft = { "text", "log" },
        },
        -- Fancy bufferline
        {
            "akinsho/bufferline.nvim",
            config = function()
                require("user.bufferline").config()
            end,
            requires = "nvim-web-devicons",
            disable = not lvim.builtin.fancy_bufferline.active,
        },
        -- Smart quit
        {
            "marklcrns/vim-smartq",
            config = function()
                vim.g.smartq_default_mappings = 0
            end,
        },
        -- Wilder
        {
            "gelguy/wilder.nvim",
            -- event = { "CursorHold", "CmdlineEnter" },
            rocks = { "luarocks-fetch-gitrec", "pcre2" },
            requires = { "romgrk/fzy-lua-native" },
            config = function()
                vim.cmd(string.format("source %s", "~/.config/lvim/vimscript/wilder.vim"))
            end,
            run = ":UpdateRemotePlugins",
            disable = not lvim.builtin.fancy_wild_menu.active,
        },
        -- Tabout
        {
            "abecodes/tabout.nvim",
            wants = { "nvim-treesitter" },
            after = { "nvim-cmp" },
            config = function()
                require("user.tabout").config()
            end,
            disable = not lvim.builtin.copilot.active,
        },
        -- Json
        { "b0o/schemastore.nvim" },
        -- Scala metals
        {
            "scalameta/nvim-metals",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("user.metals").config()
            end,
            ft = { "scala", "sbt" },
        },
        -- Web API
        { "mattn/webapi-vim" },
    }
end

return M
