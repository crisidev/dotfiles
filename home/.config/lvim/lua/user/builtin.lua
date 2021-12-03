local M = {}

M.config = function()
    -- Nvimtree
    lvim.builtin.nvimtree.side = "left"
    lvim.builtin.nvimtree.show_icons.git = 0
    lvim.builtin.nvimtree.icons = require("user.lsp").nvim_tree_icons

    -- Tree sitter
    lvim.builtin.treesitter.highlight.enabled = true
    lvim.builtin.treesitter.context_commentstring.enable = true
    lvim.builtin.treesitter.ensure_installed = "maintained"
    lvim.builtin.treesitter.ignore_install = { "haskell" }
    lvim.builtin.treesitter.incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-n>",
            node_incremental = "<C-n>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-r>",
        },
    }
    lvim.builtin.treesitter.indent = { enable = true, disable = { "yaml", "python" } } -- treesitter is buggy :(
    lvim.builtin.treesitter.matchup.enable = true
    -- lvim.treesitter.textsubjects.enable = true
    -- lvim.treesitter.playground.enable = true
    lvim.builtin.treesitter.query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
    }
    lvim.builtin.treesitter.textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader><M-a>"] = "@parameter.inner",
                ["<leader><M-f>"] = "@function.outer",
                ["<leader><M-e>"] = "@element",
            },
            swap_previous = {
                ["<leader><M-A>"] = "@parameter.inner",
                ["<leader><M-F>"] = "@function.outer",
                ["<leader><M-E>"] = "@element",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    }
    lvim.builtin.treesitter.on_config_done = function()
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.jsonc.used_by = "json"
        parser_config.markdown = {
            install_info = {
                url = "https://github.com/ikatyang/tree-sitter-markdown",
                files = { "src/parser.c", "src/scanner.cc" },
            },
        }
    end

    -- Telescope
    lvim.builtin.telescope.defaults.path_display = { shorten = 10 }
    lvim.builtin.telescope.defaults.winblend = 6
    lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
    local actions = require "telescope.actions"
    lvim.builtin.telescope.defaults.mappings = {
        i = {
            ["<esc>"] = actions.close,
            ["<C-y>"] = actions.which_key,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
            ["<esc>"] = actions.close,
            ["<C-y>"] = actions.which_key,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
        },
    }
    lvim.builtin.telescope.defaults.file_ignore_patterns = {
        "vendor/*",
        "node_modules",
        "%.jpg",
        "%.jpeg",
        "%.png",
        "%.svg",
        "%.otf",
        "%.ttf",
        ".git",
        "target/*",
    }
    lvim.builtin.telescope.defaults.layout_config = require("user.telescope").layout_config()

    -- Terminal
    lvim.builtin.terminal.active = true

    -- Debugging
    lvim.builtin.dap.active = true

    -- Dashboard
    lvim.builtin.dashboard.active = true
    lvim.builtin.dashboard.custom_section = {
        a = {
            description = { "  New File           " },
            command = "DashboardNewFile",
        },
        b = {
            description = { "  Recent Projects    " },
            command = "Telescope projects",
        },
        c = {
            description = { "  Recently Used Files" },
            command = "lua require('user.telescope').recent_files()",
        },
        e = {
            description = { "  Find File          " },
            command = "lua require('user.telescope').find_files()",
        },
        f = {
            description = { "  Find Word          " },
            command = "lua require('user.telescope').find_string()",
        },
        g = {
            description = { "  Configuration      " },
            command = ":e ~/.config/lvim/config.lua",
        },
    }

    -- Cmp
    lvim.builtin.cmp.sources = {
        { name = "nvim_lsp" },
        { name = "cmp_tabnine", max_item_count = 3 },
        { name = "buffer", max_item_count = 5, keyword_length = 5 },
        { name = "path", max_item_count = 5 },
        { name = "luasnip", max_item_count = 3 },
        { name = "nvim_lua" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
        { name = "orgmode" },
    }
    lvim.builtin.cmp.documentation.border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    lvim.builtin.cmp.experimental = {
        ghost_text = false,
        native_menu = false,
        custom_menu = true,
    }
    lvim.builtin.cmp.formatting.kind_icons = require("user.lsp").cmp_kind
    lvim.builtin.cmp.formatting.source_names = {
        buffer = "(Buf)",
        nvim_lsp = "(Lsp)",
        luasnip = "(Snip)",
        treesitter = " ",
        nvim_lua = "(NvLua)",
        spell = " 暈",
        emoji = "  ",
        path = "  ",
        calc = "  ",
        cmp_tabnine = "ﮧ",
    }

    -- Terminal
    lvim.builtin.terminal.open_mapping = [[<c-\>]]

    -- Which key
    lvim.builtin.which_key.setup.window.winblend = 10
    lvim.builtin.which_key.setup.window.border = "none"

    -- Notify popup
    lvim.builtin.notify.active = true
    lvim.log.level = "info"

    -- Evil stuff
    lvim.builtin.copilot = { active = true }
    lvim.builtin.tabnine = { active = false }
    if lvim.builtin.copilot.active then
        lvim.keys.insert_mode["<c-h>"] = { [[copilot#Accept("\<CR>")]], { expr = true, script = true } }
        local cmp = require "cmp"
        lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(M.tab, { "i", "c" })
        lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(M.shift_tab, { "i", "c" })
    end

    -- Status line
    lvim.builtin.global_status_line = { active = true }
    lvim.builtin.fancy_bufferline = { active = true }
    if lvim.builtin.fancy_bufferline.active then
        lvim.builtin.bufferline.active = false
    end
    lvim.builtin.fancy_wild_menu = { active = false }
end

function M.tab(fallback)
    local methods = require("lvim.core.cmp").methods
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local copilot_keys = vim.fn["copilot#Accept"]()
    if cmp.visible() then
        cmp.select_next_item()
    elseif vim.api.nvim_get_mode().mode == "c" then
        fallback()
    elseif copilot_keys ~= "" then -- prioritise copilot over snippets
        -- Copilot keys do not need to be wrapped in termcodes
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
    elseif luasnip.expandable() then
        luasnip.expand()
    elseif methods.jumpable() then
        luasnip.jump(1)
    elseif methods.check_backspace() then
        fallback()
    else
        methods.feedkeys("<Plug>(Tabout)", "")
    end
end

function M.shift_tab(fallback)
    local methods = require("lvim.core.cmp").methods
    local luasnip = require "luasnip"
    local cmp = require "cmp"
    if cmp.visible() then
        cmp.select_prev_item()
    elseif vim.api.nvim_get_mode().mode == "c" then
        fallback()
    elseif methods.jumpable(-1) then
        luasnip.jump(-1)
    else
        local copilot_keys = vim.fn["copilot#Accept"]()
        if copilot_keys ~= "" then
            methods.feedkeys(copilot_keys, "i")
        else
            methods.feedkeys("<Plug>(Tabout)", "")
        end
    end
end

return M
