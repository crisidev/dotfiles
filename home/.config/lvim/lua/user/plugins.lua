local M = {}

M.config = function()
    lvim.plugins = {
        ------------------------------------------------------------------------------
        -- Themes and visual stuff.
        ------------------------------------------------------------------------------
        {
            -- "folke/tokyonight.nvim",
            "abzcoding/tokyonight.nvim",
            branch = "feat/local",
            config = function()
                require("user.theme").tokyonight()
                vim.cmd [[colorscheme tokyonight]]
            end,
        },
        -- Colorizer
        {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require("user.colorizer").config()
            end,
        },
        ------------------------------------------------------------------------------
        -- Git and VCS.
        ------------------------------------------------------------------------------
        -- Fugitive
        {
            "tpope/vim-fugitive",
            cmd = { "Git", "Gdiffsplit" },
            ft = { "fugitive" },
        },
        -- Git blame
        {
            "APZelos/blamer.nvim",
            setup = function()
                local icons = require("user.icons").icons
                vim.g.blamer_enabled = 0
                vim.g.blamer_prefix = " " .. icons.magic .. " "
                vim.g.blamer_template = "<committer-time> • <author> • <summary>"
                vim.g.blamer_relative_time = 1
                vim.g.blamer_delay = 200
                vim.cmd "highlight Blamer guifg=#d3d3d3"
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
                        mappings = nil,
                    },
                    callbacks = {
                        ["code.crisidev.org"] = require("gitlinker.hosts").get_gitea_type_url,
                        ["git.amazon.com"] = require("user.amzn").get_amazon_type_url,
                    },
                }
            end,
            requires = "nvim-lua/plenary.nvim",
        },
        ------------------------------------------------------------------------------
        -- Telescope extensions.
        ------------------------------------------------------------------------------
        -- Telescope zoxide
        {
            "jvgrootveld/telescope-zoxide",
            requires = { "nvim-telescope/telescope.nvim" },
        },
        -- Telescope repo
        {
            "cljoly/telescope-repo.nvim",
            requires = { "nvim-lua/plenary.nvim" },
        },
        -- Telescope UI select
        { "nvim-telescope/telescope-ui-select.nvim" },
        -- Telescope file browser
        { "nvim-telescope/telescope-file-browser.nvim" },
        -- Telescope live grep
        { "nvim-telescope/telescope-live-grep-raw.nvim" },
        -- Tele tabby
        { "TC72/telescope-tele-tabby.nvim" },
        -- Telescope gradle
        { "aloussase/telescope-gradle.nvim" },
        ------------------------------------------------------------------------------
        -- LSP extensions.
        ------------------------------------------------------------------------------
        -- Lsp signature
        {
            "ray-x/lsp_signature.nvim",
            config = function()
                require("user/lsp_signature").config()
            end,
            event = { "BufRead", "BufNew" },
        },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        -- Lsp progreess in fidget
        {
            "j-hui/fidget.nvim",
            config = function()
                require("user.fidget").config()
            end,
        },
        -- Lsp Rust
        {
            "simrat39/rust-tools.nvim",
            ft = { "rust", "rs" },
            config = function()
                require("user.lsp.rust").config()
            end,
        },
        -- Lsp java
        {
            "mfussenegger/nvim-jdtls",
            ft = "java",
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
            config = function()
                require("user.lsp.typescript").config()
            end,
        },
        -- Lsp Cland Extensions
        {
            "p00f/clangd_extensions.nvim",
            ft = { "c", "cpp", "objc", "objcpp" },
            config = function()
                require("user.lsp.c").config()
            end,
        },
        -- Crates cmp
        {
            "Saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("crates").setup {}
            end,
        },
        -- Scala metals
        {
            "scalameta/nvim-metals",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("user.lsp.scala").config()
            end,
            ft = { "scala", "sbt" },
        },
        ------------------------------------------------------------------------------
        -- Copilot baby..
        ------------------------------------------------------------------------------
        -- Copilot
        {
            "github/copilot.vim",
            config = function()
                require("user.copilot").config()
            end,
            disable = not lvim.builtin.copilot.active or lvim.builtin.copilot.cmp_source,
        },
        -- Tabout
        {
            "abecodes/tabout.nvim",
            wants = { "nvim-treesitter" },
            after = { "nvim-cmp" },
            config = function()
                require("user.tabout").config()
            end,
            disable = not lvim.builtin.copilot.active or lvim.builtin.copilot.cmp_source,
        },
        -- Copilot Lua
        {
            "zbirenbaum/copilot.lua",
            event = "VimEnter",
            disable = not lvim.builtin.copilot.active or not lvim.builtin.copilot.cmp_source,
        },
        {
            "zbirenbaum/copilot-cmp",
            after = { "copilot.lua", "nvim-cmp" },
            disable = not lvim.builtin.copilot.active or not lvim.builtin.copilot.cmp_source,
        },
        ------------------------------------------------------------------------------
        -- Cmp all the things.
        ------------------------------------------------------------------------------
        -- Cmp for command line
        { "hrsh7th/cmp-cmdline" },
        -- Cmp for LateX symbols.
        {
            "kdheepak/cmp-latex-symbols",
            requires = "hrsh7th/nvim-cmp",
            ft = "tex",
        },
        -- Cmp for emojis..
        { "hrsh7th/cmp-emoji" },
        -- Cmp for to calculate maths expressions.
        { "hrsh7th/cmp-calc" },
        -- Cmp for spelling and dictionary.
        { "f3fora/cmp-spell" },
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
        -- Cmp for github/gitlab issues
        {
            "petertriho/cmp-git",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("cmp_git").setup()
            end,
        },
        ------------------------------------------------------------------------------
        -- Markdown support
        ------------------------------------------------------------------------------
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
        -- Markdown TOC
        {
            "mzlogin/vim-markdown-toc",
            ft = "markdown",
        },
        ------------------------------------------------------------------------------
        -- Spelling and grammar
        ------------------------------------------------------------------------------
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
        -- Grammarous
        {
            "rhysd/vim-grammarous",
            cmd = "GrammarousCheck",
        },
        -- Grammar guard
        {
            "brymer-meneses/grammar-guard.nvim",
            filetype = { "latex", "tex", "bib", "markdown", "rst", "text" },
            requires = {
                "neovim/nvim-lspconfig",
                "williamboman/nvim-lsp-installer",
            },
        },
        -- Pick up where you left
        {
            "vladdoster/remember.nvim",
            config = function()
                require("remember").setup {}
            end,
            event = "BufWinEnter",
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
        ------------------------------------------------------------------------------
        -- Zen mode
        ------------------------------------------------------------------------------
        {
            "folke/zen-mode.nvim",
            config = function()
                require("user.zen").config()
            end,
            event = "BufRead",
        },
        {
            "folke/twilight.nvim",
            config = function()
                require("user.twilight").config()
            end,
            event = "BufRead",
            disable = not lvim.builtin.twilight.enable,
        },
        ------------------------------------------------------------------------------
        -- Search and replace
        ------------------------------------------------------------------------------
        -- Hlslens
        {
            "kevinhwang91/nvim-hlslens",
            config = function()
                require("user.hlslens").config()
            end,
            event = "BufReadPost",
        },
        -- Spectre
        {
            "windwp/nvim-spectre",
            event = "BufRead",
            config = function()
                require("user.spectre").config()
            end,
        },
        ------------------------------------------------------------------------------
        -- Miscellaneous
        ------------------------------------------------------------------------------
        -- Python coverage highlight
        { "mgedmin/coverage-highlight.vim" },
        -- Screenshots
        {
            "JMcKiern/vim-shoot",
            run = "./install.py geckodriver",
            config = function()
                vim.api.nvim_set_var("shoot_zoom_factor", 1)
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
        -- TODO comments
        {
            "folke/todo-comments.nvim",
            requires = "nvim-lua/plenary.nvim",
            config = function()
                require("user.todo_comments").config()
            end,
            event = "BufRead",
        },
        -- Qbf
        {
            "kevinhwang91/nvim-bqf",
            config = function()
                require("user.bqf").config()
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
        -- Smart quit
        {
            "marklcrns/vim-smartq",
            config = function()
                vim.g.smartq_default_mappings = 0
            end,
        },
        -- Startup time
        { "dstein64/vim-startuptime" },
        -- Editor config
        {
            "editorconfig/editorconfig-vim",
            event = "BufRead",
        },
        -- Faster filetype
        {
            "nathom/filetype.nvim",
            config = function()
                require("user.filetype").config()
            end,
        },
        -- Dressing
        {
            "stevearc/dressing.nvim",
            config = function()
                require("user.dress").config()
            end,
            event = "BufWinEnter",
        },
        -- Vista
        {
            "liuchengxu/vista.vim",
            setup = function()
                require("user.vista").config()
            end,
            event = "BufReadPost",
        },
        -- Refactoring
        {
            "ThePrimeagen/refactoring.nvim",
            ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java" },
            event = "BufRead",
            config = function()
                require("user.refactoring").config()
            end,
        },
        -- i3 syntax
        { "mboughaba/i3config.vim" },
        -- Visual multi
        {
            "mg979/vim-visual-multi",
            config = function()
                vim.cmd [[
                    let g:VM_maps = {}
                    let g:VM_maps['Find Under'] = '<C-l>'
                ]]
            end,
            branch = "master",
        },
        -- Incline
        {
            "b0o/incline.nvim",
            config = function()
                require("user.incline").config()
            end,
        },
    }
end

return M
