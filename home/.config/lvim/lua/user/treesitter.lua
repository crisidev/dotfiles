local M = {}

M.config = function()
    -- Tree sitter
    lvim.builtin.treesitter.highlight.enabled = true
    lvim.builtin.treesitter.context_commentstring.enable = true
    local languages = vim.tbl_flatten {
        { "bash", "c", "c_sharp", "cmake", "comment", "cpp", "css", "d", "dart" },
        { "dockerfile", "elixir", "elm", "erlang", "fennel", "fish", "go" },
        { "gomod", "graphql", "hcl", "help", "html", "java", "javascript", "jsdoc" },
        { "json", "jsonc", "julia", "kotlin", "latex", "ledger", "lua", "make" },
        { "markdown", "nix", "ocaml", "perl", "php", "python", "query", "r" },
        { "regex", "rego", "ruby", "rust", "scala", "scss", "solidity", "swift" },
        { "teal", "toml", "tsx", "typescript", "vim", "vue", "yaml", "zig", "smithy" },
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
    lvim.builtin.treesitter.indent = { enable = true }
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
                ["av"] = "@variable.outer",
                ["iv"] = "@variable.inner",
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

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.smithy = {
        install_info = {
            url = "https://github.com/indoorvivants/tree-sitter-smithy",
            files = { "src/parser.c" },
            branch = "main",
            generate_requires_npm = true,
            requires_generate_from_grammar = true,
        },
        filetype = "smithy",
    }
end

return M
