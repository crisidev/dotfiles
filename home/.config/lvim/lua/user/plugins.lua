local M = {}

M.config = function()
    lvim.plugins = {
        ------------------------------------------------------------------------------
        -- Themes and visual stuff.
        ------------------------------------------------------------------------------
        {
            "rebelot/kanagawa.nvim",
            config = function()
                require("user.theme").kanagawa()
            end,
        },
        {
            "EdenEast/nightfox.nvim",
            config = function()
                require("user.theme").nightfox()
            end,
        },
        -- Colorizer
        {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require("user.colorizer").config()
            end,
            event = "BufReadPre",
        },
        ------------------------------------------------------------------------------
        -- Git and VCS.
        ------------------------------------------------------------------------------
        -- Git blame
        {
            "APZelos/blamer.nvim",
            config = function()
                require("user.blamer").config()
            end,
        },
        -- Github management
        {
            "pwntester/octo.nvim",
            config = function()
                require("user.octo").config()
            end,
            lazy = true,
            dependencies = { "which-key.nvim" },
            cmd = "Octo",
        },
        -- Git linker
        {
            "ruifm/gitlinker.nvim",
            event = "BufRead",
            config = function()
                require("user.gitlinker").config()
            end,
            dependencies = "nvim-lua/plenary.nvim",
        },
        ------------------------------------------------------------------------------
        -- Telescope extensions.
        ------------------------------------------------------------------------------
        -- Telescope zoxide
        {
            "jvgrootveld/telescope-zoxide",
            dependencies = { "nvim-telescope/telescope.nvim" },
            lazy = true,
        },
        -- Telescope file browser
        {
            "nvim-telescope/telescope-file-browser.nvim",
            lazy = true,
        },
        -- Telescope live grep
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            lazy = true,
        },
        {
            "danielfalk/smart-open.nvim",
            branch = "0.2.x",
            dependencies = { "kkharji/sqlite.lua", "nvim-telescope/telescope-fzy-native.nvim" },
            lazy = true,
        },
        ------------------------------------------------------------------------------
        -- LSP extensions.
        ------------------------------------------------------------------------------
        -- Lsp signature
        {
            "ray-x/lsp_signature.nvim",
            config = function()
                require("user.lsp.signature").config()
            end,
            ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "rust" },
            enabled = lvim.builtin.lsp_signature_help.active,
        },
        -- Lsp Rust
        {
            "simrat39/rust-tools.nvim",
            ft = { "rust", "rs" },
            lazy = true,
        },
        -- Lsp java
        {
            "mfussenegger/nvim-jdtls",
            ft = "java",
        },
        -- Lsp Typescript
        {
            "jose-elias-alvarez/typescript.nvim",
            ft = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
            },
            lazy = true,
            config = function()
                require("user.lsp.typescript").config()
            end,
        },
        -- Lsp Cland Extensions
        {
            "p00f/clangd_extensions.nvim",
            ft = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
            config = function()
                require("user.lsp.c").config()
            end,
        },
        {
            "Civitasv/cmake-tools.nvim",
            config = function()
                require("user.lsp.c").cmake_config()
            end,
            ft = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
        },
        -- Crates
        {
            "Saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require("crates").setup {
                    null_ls = {
                        enabled = true,
                        name = "crates",
                    },
                }
            end,
        },
        -- Scala metals
        {
            "scalameta/nvim-metals",
            dependencies = { "nvim-lua/plenary.nvim" },
            ft = { "scala", "sbt" },
            enabled = lvim.builtin.metals.active,
        },
        -- Go
        {
            "olexsmir/gopher.nvim",
            config = function()
                require("gopher").setup {
                    commands = {
                        go = "go",
                        gomodifytags = "gomodifytags",
                        gotests = "gotests",
                        impl = "impl",
                        iferr = "iferr",
                    },
                }
            end,
            ft = { "go", "gomod" },
        },
        -- Node
        {
            "vuki656/package-info.nvim",
            config = function()
                require("package-info").setup()
            end,
            lazy = true,
            event = { "BufReadPre", "BufNew" },
        },
        -- Python venv
        {
            "AckslD/swenv.nvim",
            ft = "python",
        },
        -- Requirements
        {
            "raimon49/requirements.txt.vim",
            event = "VeryLazy",
        },
        -- Refactoring
        {
            "ThePrimeagen/refactoring.nvim",
            ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "rust", "kotlin" },
            lazy = true,
            config = function()
                require("user.refactoring").config()
            end,
        },
        {
            "cshuaimin/ssr.nvim",
            config = function()
                require("ssr").setup {
                    min_width = 50,
                    min_height = 5,
                    keymaps = {
                        close = "q",
                        next_match = "n",
                        prev_match = "N",
                        replace_all = "<leader><cr>",
                    },
                }
            end,
            lazy = true,
            event = { "BufReadPost", "BufNew" },
        },
        ------------------------------------------------------------------------------
        -- Copilot baby..
        ------------------------------------------------------------------------------
        {
            "zbirenbaum/copilot.lua",
            event = "VimEnter",
            enabled = lvim.builtin.copilot.active,
        },
        {
            "zbirenbaum/copilot-cmp",
            dependencies = { "copilot.lua", "nvim-cmp" },
            config = function()
                require("copilot_cmp").setup {
                    method = "getCompletionsCycling",
                }
            end,
            enabled = lvim.builtin.copilot.active,
        },
        ------------------------------------------------------------------------------
        -- Cmp all the things.
        ------------------------------------------------------------------------------
        -- Cmp for command line
        -- Cmp for emojis..
        {
            "hrsh7th/cmp-emoji",
            lazy = true,
        },
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
            lazy = true,
            enabled = lvim.builtin.cmp.dictionary.enable,
        },
        -- Cmp for github/gitlab issues
        {
            "petertriho/cmp-git",
            dependencies = "nvim-lua/plenary.nvim",
            lazy = true,
            config = function()
                require("cmp_git").setup()
            end,
        },
        {
            "hrsh7th/cmp-nvim-lsp-signature-help",
            enabled = not lvim.builtin.lsp_signature_help.active,
        },
        ------------------------------------------------------------------------------
        -- Markdown support
        ------------------------------------------------------------------------------
        -- Markdown preview
        {
            "iamcco/markdown-preview.nvim",
            build = "cd app && npm install",
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
        -- Markdown TOC
        {
            "mzlogin/vim-markdown-toc",
            ft = "markdown",
        },
        {
            "jghauser/follow-md-links.nvim",
            ft = { "markdown" },
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
            ft = { "markdown", "text", "rst" },
        },
        -- Grammarous
        {
            "rhysd/vim-grammarous",
            cmd = "GrammarousCheck",
            enabled = lvim.builtin.grammarous.active,
        },
        -- Grammar guard
        {
            "brymer-meneses/grammar-guard.nvim",
            ft = { "latex", "tex", "bib", "markdown", "rst", "text" },
            dependencies = { "neovim/nvim-lspconfig" },
        },
        ------------------------------------------------------------------------------
        -- Session and position
        ------------------------------------------------------------------------------
        -- Pick up where you left
        {
            "vladdoster/remember.nvim",
            config = function()
                require("remember").setup {}
            end,
        },
        -- Session manager
        {
            "olimorris/persisted.nvim",
            lazy = true,
            config = function()
                require("user.persisted").config()
            end,
        },
        ------------------------------------------------------------------------------
        -- Zen mode
        ------------------------------------------------------------------------------
        {
            "folke/zen-mode.nvim",
            cmd = "ZenMode",
            lazy = true,
            config = function()
                require("user.zen").config()
            end,
        },
        {
            "folke/twilight.nvim",
            config = function()
                require("user.twilight").config()
            end,
            lazy = true,
            cmd = "Twilight",
            enabled = lvim.builtin.twilight.enable,
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
            lazy = true,
            config = function()
                require("user.spectre").config()
            end,
        },
        ------------------------------------------------------------------------------
        -- Movements
        ------------------------------------------------------------------------------
        -- Zoxide
        { "nanotee/zoxide.vim" },
        -- Preview jumps
        {
            "nacro90/numb.nvim",
            event = "BufRead",
            config = function()
                require("numb").setup()
            end,
        },
        -- Neotree
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            dependencies = { "MunifTanjim/nui.nvim" },
            config = function()
                require("user.neotree").config()
            end,
            enabled = lvim.builtin.tree_provider == "neo-tree",
        },
        -- Treesitter textobject
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            lazy = true,
            event = "BufReadPre",
            dependencies = "nvim-treesitter",
            enabled = lvim.builtin.treesitter_textobjects.active,
        },
        ------------------------------------------------------------------------------
        -- Debug
        ------------------------------------------------------------------------------
        {
            "leoluz/nvim-dap-go",
            config = function()
                require("dap-go").setup()
            end,
            lazy = true,
            ft = { "go", "gomod" },
        },
        {
            "mfussenegger/nvim-dap-python",
            config = function()
                local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
                require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
                require("dap-python").test_runner = "pytest"
            end,
            lazy = true,
            ft = "python",
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            config = function()
                require("nvim-dap-virtual-text").setup()
            end,
            lazy = true,
        },
        ------------------------------------------------------------------------------
        -- Noice
        ------------------------------------------------------------------------------
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            config = function()
                require("user.noice").config()
            end,
            -- version = '1.5.2',
            dependencies = {
                "rcarriga/nvim-notify",
                "MunifTanjim/nui.nvim",
                "smjonas/inc-rename.nvim",
            },
            enabled = lvim.builtin.noice.active,
        },
        ------------------------------------------------------------------------------
        -- Miscellaneous
        ------------------------------------------------------------------------------
        -- Screenshots
        {
            "segeljakt/vim-silicon",
            config = function()
                require("user.silicon").config()
            end,
        },
        -- TODO comments
        {
            "folke/todo-comments.nvim",
            dependencies = "nvim-lua/plenary.nvim",
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
            event = "WinEnter",
        },
        -- Trouble
        {
            "folke/trouble.nvim",
            config = function()
                require("user.trouble").config()
            end,
            cmd = "Trouble",
            event = "VeryLazy",
        },
        -- Dressing
        {
            "stevearc/dressing.nvim",
            config = function()
                require("user.dress").config()
            end,
            lazy = true,
            event = "BufWinEnter",
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
        -- Cleanup whitespaces
        {
            "lewis6991/spaceless.nvim",
            config = function()
                require("spaceless").setup()
            end,
        },
        -- Better hl
        {
            "m-demare/hlargs.nvim",
            config = function()
                require("hlargs").setup {
                    excluded_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
                }
            end,
            lazy = true,
            event = "VeryLazy",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
        },
        -- Testing
        {
            "stevearc/overseer.nvim",
            config = function()
                require("user.overseer").config()
            end,
        },
        {
            "nvim-neotest/neotest",
            config = function()
                require("user.ntest").config()
            end,
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
                "antoinemadec/FixCursorHold.nvim",
            },
            event = { "BufReadPost", "BufNew" },
        },
        { "nvim-neotest/neotest-plenary" },
        { "nvim-neotest/neotest-go", event = { "BufEnter *.go" } },
        { "nvim-neotest/neotest-python", event = { "BufEnter *.py" } },
        { "rouge8/neotest-rust", event = { "BufEnter *.rs" } },
        -- Hop
        {
            "phaazon/hop.nvim",
            event = "VeryLazy",
            cmd = { "HopChar1CurrentLineAC", "HopChar1CurrentLineBC", "HopChar2MW", "HopWordMW" },
            config = function()
                require("hop").setup()
                require("user.keys").hop_keys()
            end,
            enabled = lvim.builtin.hop.active,
        },
        -- Matchup
        {
            "andymass/vim-matchup",
            event = "BufReadPost",
            config = function()
                vim.g.matchup_enabled = 1
                vim.g.matchup_surround_enabled = 1
                vim.g.matchup_matchparen_deferred = 1
                vim.g.matchup_matchparen_offscreen = { method = "popup" }
            end,
        },
        -- Highligh logs
        {
            "mtdl9/vim-log-highlighting",
            ft = { "text", "log" },
            lazy = true,
        },
        -- Powerful tab
        {
            "abecodes/tabout.nvim",
            config = function()
                require("user.tabout").config()
            end,
        },
        -- Debug print
        {
            "andrewferrier/debugprint.nvim",
            config = function()
                require("user.debugprint").config()
            end,
        },
        -- Custom icons
        {
            "abzcoding/nvim-mini-file-icons",
            config = function()
                require("nvim-web-devicons").setup()
            end,
            enabled = lvim.builtin.custom_web_devicons or not lvim.use_icons,
        },
        -- Ufo folding
        {
            "kevinhwang91/nvim-ufo",
            dependencies = "kevinhwang91/promise-async",
            config = function()
                require("user.ufo").config()
            end,
            enabled = lvim.builtin.ufo.active,
        },
        {
            "luukvbaal/statuscol.nvim",
            config = function()
                require("user.statuscol").config()
            end,
        },
    }
end

return M
