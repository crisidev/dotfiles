local M = {}

M.config = function()
    -- Tree sitter
    lvim.builtin.treesitter.highlight.enabled = true
    lvim.builtin.treesitter.context_commentstring.enable = true
    local languages = vim.tbl_flatten {
        { "bash", "c", "c_sharp", "cmake", "comment", "cpp", "css", "d", "dart" },
        { "dockerfile", "elixir", "elm", "erlang", "fennel", "fish", "go", "gomod" },
        { "gomod", "graphql", "hcl", "vimdoc", "html", "java", "javascript", "jsdoc" },
        { "json", "jsonc", "julia", "kotlin", "latex", "ledger", "lua", "make" },
        { "markdown", "nix", "ocaml", "perl", "php", "python", "query", "r" },
        { "regex", "rego", "ruby", "rust", "scala", "scss", "solidity", "swift" },
        { "teal", "toml", "tsx", "typescript", "vim", "vue", "yaml", "zig", "smithy" },
        { "markdown_inline", "gitcommit" },
    }
    lvim.builtin.treesitter.ensure_installed = languages
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
    lvim.builtin.treesitter.highlight.enable = true
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
                ["aA"] = "@attribute.outer",
                ["iA"] = "@attribute.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ac"] = "@call.outer",
                ["ic"] = "@call.inner",
                ["at"] = "@class.outer",
                ["it"] = "@class.inner",
                ["a/"] = "@comment.outer",
                ["i/"] = "@comment.inner",
                ["ai"] = "@conditional.outer",
                ["ii"] = "@conditional.inner",
                ["aF"] = "@frame.outer",
                ["iF"] = "@frame.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["av"] = "@variable.outer",
                ["iv"] = "@variable.inner",
                ["is"] = "@scopename.inner",
                ["as"] = "@statement.outer",
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
end

return M
