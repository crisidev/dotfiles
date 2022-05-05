local M = {}

M.themes = function()
    return {
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
    }
end

M.git = function()
    return {
        -- Fugitive
        {
            "tpope/vim-fugitive",
            cmd = { "Git", "Gdiffsplit" },
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
    }
end

M.telescope = function()
    return {
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
        -- Telescope lua snippets
        {
            "benfowler/telescope-luasnip.nvim",
            module = "telescope._extensions.luasnip", -- if you wish to lazy-load
        },
    }
end

M.lsp = function()
    return {
        -- Lsp signature
        {
            "ray-x/lsp_signature.nvim",
            config = function()
                require("user/lsp_signature").config()
            end,
            event = { "BufRead", "BufNew" },
        },
        -- Lsp progress lualine
        {
            "arkav/lualine-lsp-progress",
            disable = lvim.builtin.fidget.active,
        },
        -- Lsp progreess in fidget
        {
            "j-hui/fidget.nvim",
            config = function()
                require("user.fidget").config()
            end,
            disable = not lvim.builtin.fidget.active,
        },
        -- Lsp Rust
        {
            "simrat39/rust-tools.nvim",
            branch = "modularize_and_inlay_rewrite",
            ft = { "rust", "rs" },
        },
        -- Lsp java
        { "mfussenegger/nvim-jdtls", ft = "java" },
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
        -- Lsp Cland Extensions
        {
            "p00f/clangd_extensions.nvim",
            ft = { "c", "cpp", "objc", "objcpp" },
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
            ft = { "rust", "go", "c", "cpp", "typescript", "typescriptreact" },
        },
        -- Scala metals
        {
            "scalameta/nvim-metals",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("user.metals").config()
            end,
            ft = { "scala", "sbt" },
        },
        -- Dressing
        {
            "stevearc/dressing.nvim",
            config = function()
                require("user.dress").config()
            end,
            disable = not lvim.builtin.dressing.active,
            event = "BufWinEnter",
        },
        -- Symbol outline
        {
            "simrat39/symbols-outline.nvim",
            config = function()
                require("user.symbols_outline").config()
            end,
            event = "BufReadPost",
            disable = lvim.builtin.tag_provider ~= "symbols-outline",
        },
        -- Vista
        {
            "liuchengxu/vista.vim",
            setup = function()
                require("user.vista").config()
            end,
            event = "BufReadPost",
            disable = lvim.builtin.tag_provider ~= "vista",
        },
        -- Refactoring
        {
            "ThePrimeagen/refactoring.nvim",
            ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
            event = "BufRead",
            config = function()
                require("refactoring").setup {}
            end,
            disable = not lvim.builtin.refactoring.active,
        },
    }
end

M.markdown = function()
    return {
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
        -- Crates cmp
        {
            "Saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("crates").setup {}
            end,
        },
        -- Markdown TOC
        {
            "mzlogin/vim-markdown-toc",
            ft = "markdown",
        },
    }
end

M.copilot = function()
    return {
        -- Copilot
        {
            "github/copilot.vim",
            config = function()
                require("user.copilot").config()
            end,
            disable = not lvim.builtin.copilot.active or lvim.builtin.copilot.cmp,
        },
        -- Copilot cmp
        {
            "zbirenbaum/copilot.lua",
            after = "nvim-cmp",
            requires = { "zbirenbaum/copilot-cmp" },
            config = function()
                local cmp_source = { name = "copilot", group_index = 2 }
                table.insert(lvim.builtin.cmp.sources, cmp_source)
                vim.defer_fn(function()
                    require("copilot").setup()
                end, 100)
            end,
            disable = not lvim.builtin.copilot.cmp,
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
    }
end

M.filetype = function()
    return {
        -- i3 syntax
        { "mboughaba/i3config.vim" },
        -- Smithy
        { "jasdel/vim-smithy" },
        -- Editor config
        {
            "editorconfig/editorconfig-vim",
            event = "BufRead",
            disable = not lvim.builtin.editorconfig.active,
        },
        -- Faster filetype
        {
            "nathom/filetype.nvim",
            config = function()
                require("user.filetype").config()
            end,
        },
    }
end

M.grammar = function()
    return {
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
            disable = not lvim.builtin.grammar_guard.active,
        },
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
    }
end

M.session = function()
    return {
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
    }
end

M.zen_mode = function()
    return {
        -- Zen mode
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
    }
end

M.config = function()
    lvim.plugins = {
        -- Hlslens
        {
            "kevinhwang91/nvim-hlslens",
            config = function()
                require("user.hlslens").config()
            end,
            event = "BufReadPost",
            disable = not lvim.builtin.hlslens.active,
        },
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
        -- Web API
        { "mattn/webapi-vim" },
        -- Startup time
        { "dstein64/vim-startuptime" },
        {
            "hrsh7th/cmp-cmdline",
            disable = not lvim.builtin.fancy_wild_menu.active,
        },
        {
            "kdheepak/cmp-latex-symbols",
            requires = "hrsh7th/nvim-cmp",
            ft = "tex",
        },
    }
    table.insert(lvim.plugins, M.themes())
    table.insert(lvim.plugins, M.git())
    table.insert(lvim.plugins, M.telescope())
    table.insert(lvim.plugins, M.lsp())
    table.insert(lvim.plugins, M.markdown())
    table.insert(lvim.plugins, M.copilot())
    table.insert(lvim.plugins, M.filetype())
    table.insert(lvim.plugins, M.grammar())
    table.insert(lvim.plugins, M.session())
    table.insert(lvim.plugins, M.zen_mode())
end

return M
