local M = {}

M.config = function()
    lvim.plugins = {
        ------------------------------------------------------------------------------
        -- Themes and visual stuff.
        ------------------------------------------------------------------------------
        {
            "folke/tokyonight.nvim",
            config = function()
                require("user.theme").tokyonight()
                vim.cmd [[colorscheme tokyonight]]
            end,
            cond = lvim.builtin.theme.name == "tokyonight",
        },
        {
            "rose-pine/neovim",
            as = "rose-pine",
            config = function()
                require("user.theme").rose_pine()
                vim.cmd [[colorscheme rose-pine]]
            end,
            cond = lvim.builtin.theme.name == "rose-pine",
        },
        {
            "catppuccin/nvim",
            as = "catppuccin",
            run = ":CatppuccinCompile",
            config = function()
                require("user.theme").catppuccin()
                vim.cmd [[colorscheme catppuccin-mocha]]
            end,
            cond = lvim.builtin.theme.name == "catppuccin",
        },
        {
            "rebelot/kanagawa.nvim",
            config = function()
                require("user.theme").kanagawa()
                vim.cmd [[colorscheme kanagawa]]
            end,
            cond = lvim.builtin.theme.name == "kanagawa",
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
        -- Fugitive
        {
            "tpope/vim-fugitive",
            cmd = { "Git", "Gdiffsplit" },
            ft = { "fugitive" },
        },
        -- Git blame
        {
            "APZelos/blamer.nvim",
            config = function()
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
                require("user.octo").config()
            end,
            after = { "which-key.nvim" },
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
        -- Telescope file browser
        { "nvim-telescope/telescope-file-browser.nvim" },
        -- Telescope live grep
        { "nvim-telescope/telescope-live-grep-args.nvim" },
        {
            "sudormrfbin/cheatsheet.nvim",
            requires = {
                { "nvim-telescope/telescope.nvim" },
                { "nvim-lua/popup.nvim" },
                { "nvim-lua/plenary.nvim" },
            },
        },
        {
            "nvim-telescope/telescope-frecency.nvim",
            config = function()
                print()
            end,
            requires = { "kkharji/sqlite.lua" },
        },
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
            disable = not lvim.builtin.lsp_signature_help.active,
        },
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
            "jose-elias-alvarez/typescript.nvim",
            ft = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
            },
            opt = true,
            event = { "BufReadPre", "BufNew" },
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
        -- Lsp lines
        {
            "lvimuser/lsp-inlayhints.nvim",
            config = function()
                require("user.inlay").config()
            end,
            disable = not lvim.builtin.inlay_hints.active,
        },
        {
            "santigo-zero/right-corner-diagnostics.nvim",
            event = "LspAttach",
            config = function()
                vim.diagnostic.config {
                    -- Disable default virtual text since you are using this plugin
                    -- already :)
                    virtual_text = false,

                    -- Do not display diagnostics while you are in insert mode, so if you have
                    -- `auto_cmds = true` it will not update the diagnostics while you type.
                    update_in_insert = true,
                }
                require("rcd").setup {
                    position = "bottom",
                    auto_cmds = true,
                }
            end,
            disable = not lvim.builtin.right_corner_diagnostics.active,
        },
        -- Crates
        {
            "Saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            requires = { "nvim-lua/plenary.nvim" },
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
            requires = { "nvim-lua/plenary.nvim" },
            ft = { "scala", "sbt" },
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
            event = { "BufRead", "BufNew" },
        },
        -- Node
        {
            "vuki656/package-info.nvim",
            config = function()
                require("package-info").setup()
            end,
            opt = true,
            event = { "BufReadPre", "BufNew" },
        },
        -- Python venv
        {
            "AckslD/swenv.nvim",
            ft = "python",
            event = { "BufRead", "BufNew" },
        },
        -- Refactoring
        {
            "ThePrimeagen/refactoring.nvim",
            ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "rust", "kotlin" },
            event = "BufRead",
            config = function()
                require("user.refactoring").config()
            end,
        },
        -- Incremental rename
        {
            "smjonas/inc-rename.nvim",
            config = function()
                require("inc_rename").setup()
            end,
            disable = not lvim.builtin.noice.active,
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
            event = { "BufReadPost", "BufNew" },
        },
        {
            "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
            config = function()
                require("lsp_lines").setup()
            end,
        },
        ------------------------------------------------------------------------------
        -- Copilot baby..
        ------------------------------------------------------------------------------
        {
            "zbirenbaum/copilot.lua",
            event = "VimEnter",
            disable = not lvim.builtin.copilot.active,
        },
        {
            "zbirenbaum/copilot-cmp",
            after = { "copilot.lua", "nvim-cmp" },
            config = function()
                require("copilot_cmp").setup {
                    method = "getCompletionsCycling",
                }
            end,
            disable = not lvim.builtin.copilot.active,
        },
        ------------------------------------------------------------------------------
        -- Cmp all the things.
        ------------------------------------------------------------------------------
        -- Cmp for command line
        { "hrsh7th/cmp-cmdline" },
        { "dmitmel/cmp-cmdline-history" },
        -- Cmp for emojis..
        { "hrsh7th/cmp-emoji" },
        -- Cmp for to calculate maths expressions.
        { "hrsh7th/cmp-calc" },
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
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
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
            fd = { "markdown", "text", "rst" },
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
            requires = { "neovim/nvim-lspconfig" },
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
            event = "BufWinEnter",
        },
        -- Session manager
        {
            "olimorris/persisted.nvim",
            config = function()
                require("user.persisted").config()
            end,
            disable = lvim.builtin.session_manager ~= "persisted",
        },
        {
            "jedrzejboczar/possession.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("user.possession").config()
            end,
            disable = lvim.builtin.session_manager ~= "possession",
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
        -- Movements
        ------------------------------------------------------------------------------
        -- Zoxide
        { "nanotee/zoxide.vim" },
        -- Scrollbar
        {
            "petertriho/nvim-scrollbar",
            config = function()
                require("user.scrollbar").config()
            end,
            after = { "nvim-hlslens" },
        },
        -- Preview jumps
        {
            "nacro90/numb.nvim",
            event = "BufRead",
            config = function()
                require("numb").setup()
            end,
        },
        -- Window picker
        {
            "s1n7ax/nvim-window-picker",
            tag = "1.*",
            config = function()
                require("window-picker").setup {
                    autoselect_one = true,
                    include_current = false,
                    filter_rules = {
                        -- filter using buffer options
                        bo = {
                            -- if the file type is one of following, the window will be ignored
                            filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

                            -- if the buffer type is one of following, the window will be ignored
                            buftype = { "terminal" },
                        },
                    },
                    other_win_hl_color = "#e35e4f",
                }
            end,
        },
        -- Neotree
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            requires = { "MunifTanjim/nui.nvim" },
            config = function()
                require("user.neotree").config()
            end,
            disable = lvim.builtin.tree_provider ~= "neo-tree",
        },
        -- Treesitter textobject
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            after = "nvim-treesitter",
        },
        ------------------------------------------------------------------------------
        -- Debug
        ------------------------------------------------------------------------------
        {
            "leoluz/nvim-dap-go",
            config = function()
                require("dap-go").setup()
            end,
            ft = { "go", "gomod" },
            event = { "BufRead", "BufNew" },
        },
        {
            "mfussenegger/nvim-dap-python",
            config = function()
                local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
                require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
                require("dap-python").test_runner = "pytest"
            end,
            ft = "python",
            event = { "BufRead", "BufNew" },
        },
        ------------------------------------------------------------------------------
        -- Noice
        ------------------------------------------------------------------------------
        { "MunifTanjim/nui.nvim" },
        {
            "folke/noice.nvim",
            event = "VimEnter",
            config = function()
                require("user.noice").config()
            end,
            requires = {
                "MunifTanjim/nui.nvim",
                "rcarriga/nvim-notify",
            },
            disable = not lvim.builtin.noice.active,
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
        -- Trouble
        { "folke/trouble.nvim" },
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
            config = function()
                require("user.vista").config()
            end,
            event = "BufReadPost",
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
        -- Orgmode
        {
            "kristijanhusak/orgmode.nvim",
            ft = { "org" },
            config = function()
                require("user.orgmode").setup()
            end,
            disable = not lvim.builtin.orgmode.active,
        },
        -- Clipboard management
        {
            "AckslD/nvim-neoclip.lua",
            requires = {
                { "nvim-telescope/telescope.nvim" },
            },
            config = function()
                require("neoclip").setup {
                    on_paste = {
                        set_reg = true,
                    },
                }
            end,
        },
        -- Legendary
        {
            "mrjones2014/legendary.nvim",
            config = function()
                require("user.legendary").config()
            end,
            disable = not lvim.builtin.legendary.active,
        },
        {
            "m-demare/hlargs.nvim",
            config = function()
                require("hlargs").setup()
            end,
            requires = { "nvim-treesitter/nvim-treesitter" },
            disable = not lvim.builtin.hlargs.active,
        },
        {
            "stevearc/overseer.nvim",
            config = function()
                require("user.overseer").config()
            end,
            disable = not lvim.builtin.task_runner.active,
        },
        {
            "nvim-neotest/neotest",
            config = function()
                require("user.ntest").config()
            end,
            requires = {
                { "nvim-neotest/neotest-go" },
                { "nvim-neotest/neotest-python" },
                { "nvim-neotest/neotest-plenary" },
                { "rouge8/neotest-rust" },
                { "nvim-lua/plenary.nvim" },
                { "nvim-treesitter/nvim-treesitter" },
                { "antoinemadec/FixCursorHold.nvim" },
            },
            disable = not lvim.builtin.test_runner.active,
        },
        -- Hop
        {
            "ggandor/leap.nvim",
            config = function()
                require("user.leap").config()
            end,
            disable = lvim.builtin.motion_provider ~= "leap",
        },
        {
            "phaazon/hop.nvim",
            branch = "v2",
            event = "BufRead",
            config = function()
                require("user.hop").config()
            end,
            disable = lvim.builtin.motion_provider ~= "hop",
        },
    }
end

return M
