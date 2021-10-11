local M = {}

M.config = function()
    lvim.plugins = {
        -- Color schemes
        {
            "folke/tokyonight.nvim",
            config = function()
                require("user/theme").tokyonight()
            end,
            rocks = { "inspect", "luaposix" },
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
        -- Rainbow parentheses
        -- {
        -- 	"p00f/nvim-ts-rainbow",
        --             ft = not { "rust", "rs" },
        -- 	config = function()
        -- 		require("nvim-treesitter.configs").setup({
        -- 			rainbow = {
        -- 				enable = true,
        -- 				extended_mode = true,
        -- 			},
        -- 		})
        -- 	end,
        -- },
        -- Smooth scrolling
        -- {
        -- 	"karb94/neoscroll.nvim",
        -- 	config = function()
        -- 		require("neoscroll").setup()
        -- 	end,
        -- },
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
        -- Autosave work
        -- {
        -- 	"Pocco81/AutoSave.nvim",
        -- 	config = function()
        -- 		require("autosave").setup({
        --                     execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        -- 			clean_command_line_interval = 0,
        -- 			debounce_delay = 500,
        --                     conditions = {
        --                         filetype_is_not = { "picomconf" }
        --                     }
        -- 		})
        -- 	end,
        -- },
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
                local opts = {
                    tools = {
                        autoSetHints = true,
                        hover_with_actions = true,
                        inlay_hints = {
                            only_current_line = true,
                            show_parameter_hints = false,
                        },
                        hover_actions = {
                            auto_focus = true,
                        },
                    },
                    server = {
                        cmd = { vim.fn.stdpath "data" .. "/lspinstall/rust/rust-analyzer" },
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
        -- Telescope fzf
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "make",
            after = "telescope.nvim",
            config = function()
                require("telescope").load_extension "fzf"
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
    }
end

return M
