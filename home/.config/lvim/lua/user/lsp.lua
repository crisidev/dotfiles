local M = {}

M.cmp_kind = {
    Class = " ",
    Color = " ",
    Constant = "",
    Constructor = " ",
    Default = " ",
    Enum = "練",
    EnumMember = " ",
    Event = " ",
    Field = "ﰠ ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Keyword = " ",
    Method = "ƒ ",
    Module = " ",
    Operator = " ",
    Property = " ",
    Reference = "",
    Snippet = " ",
    Struct = "פּ",
    Text = " ",
    TypeParameter = "  ",
    Unit = "塞",
    Value = " ",
    Variable = " ",
}

M.icons = {
    error = " ",
    warn = " ",
    info = " ",
    hint = " ",
    code_action = " ",
    test = " ",
    docs = " ",
    clock = " ",
    calendar = " ",
    buffer = " ",
    settings = " ",
    ls_inactive_old = "轢",
    ls_active_old = "歷",
    ls_active = " ",
    ls_inactive = "",
    question = " ",
    added = "  ",
    modified = "柳",
    removed = " ",
    screen = "冷",
    dart = " ",
    config = " ",
    git = "",
    magic = " ",
    exit = " ",
    session = " ",
    project = "⚝ ",
    stuka = " ",
    text = "",
    files = " ",
    zoxide = "Z",
    repo = "",
    term = " ",
    palette = " ",
    buffers = "﩯",
    telescope = "",
    dashboard = "舘",
    quit = "",
    replace = "",
    find = "",
    grammar = "",
    comment = "",
    ok = "",
    no = "",
    moon = "",
    go = "",
}

M.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "",
        staged = "",
        unmerged = "",
        renamed = "➜",
        untracked = "",
        deleted = "",
        ignored = "◌",
    },
    folder = {
        arrow_closed = "",
        arrow_open = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = "",
    },
}

M.symbols_outline = {
    File = "",
    Module = "",
    Namespace = "",
    Package = "",
    Class = "",
    Method = "ƒ",
    Property = "",
    Field = "",
    Constructor = "",
    Enum = "練",
    Interface = "ﰮ",
    Function = "",
    Variable = "",
    Constant = "",
    String = "𝓐",
    Number = "#",
    Boolean = "⊨",
    Array = "",
    Object = "⦿",
    Key = "",
    Null = "NULL",
    EnumMember = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "𝙏",
}

M.todo_comments = {
    FIX = "律",
    TODO = " ",
    HACK = " ",
    WARN = "裂",
    PERF = "龍",
    NOTE = " ",
    ERROR = " ",
    REFS = "",
}

M.numbers = {
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
}

M.file_icons = {
    Brown = { "" },
    Aqua = { "" },
    LightBlue = { "", "" },
    Blue = { "", "", "", "", "", "", "", "", "", "", "", "", "" },
    Darkblue = { "", "" },
    Purple = { "", "", "", "", "" },
    Red = { "", "", "", "", "", "" },
    Beige = { "", "", "" },
    Yellow = { "", "", "λ", "", "" },
    Orange = { "", "" },
    Darkorange = { "", "", "", "", "" },
    Pink = { "", "" },
    Salmon = { "" },
    Green = { "", "", "", "", "", "" },
    Lightgreen = { "", "", "", "﵂" },
    White = { "", "", "", "", "", "" },
}

M.codes = {
    no_matching_function = {
        message = " Can't find a matching function",
        "redundant-parameter",
        "ovl_no_viable_function_in_call",
    },
    different_requires = {
        message = " Buddy you've imported this before, with the same name",
        "different-requires",
    },
    empty_block = {
        message = " That shouldn't be empty here",
        "empty-block",
    },
    missing_symbol = {
        message = " Here should be a symbol",
        "miss-symbol",
    },
    expected_semi_colon = {
        message = " Remember the `;` or `,`",
        "expected_semi_declaration",
        "miss-sep-in-table",
        "invalid_token_after_toplevel_declarator",
    },
    redefinition = {
        message = " That variable was defined before",
        "redefinition",
        "redefined-local",
    },
    no_matching_variable = {
        message = " Can't find that variable",
        "undefined-global",
        "reportUndefinedVariable",
    },
    trailing_whitespace = {
        message = " Remove trailing whitespace",
        "trailing-whitespace",
        "trailing-space",
    },
    unused_variable = {
        message = " Don't define variables you don't use",
        "unused-local",
    },
    unused_function = {
        message = " Don't define functions you don't use",
        "unused-function",
    },
    useless_symbols = {
        message = " Remove that useless symbols",
        "unknown-symbol",
    },
    wrong_type = {
        message = " Try to use the correct types",
        "init_conversion_failed",
    },
    undeclared_variable = {
        message = " Have you delcared that variable somewhere?",
        "undeclared_var_use",
    },
    lowercase_global = {
        message = " Should that be a global? (if so make it uppercase)",
        "lowercase-global",
    },
}

M.show_documentation = function()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand "<cword>")
    elseif vim.fn.expand "%:t" == "Cargo.toml" then
        require("crates").show_popup()
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand "<cword>")
    else
        vim.lsp.buf.hover()
    end
end

M.normal_buffer_mappings = function()
    -- Hover
    -- lvim.lsp.buffer_mappings.normal_mode["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" }
    lvim.lsp.buffer_mappings.normal_mode["K"] = {
        "<cmd>lua require('user.lsp').show_documentation()<CR>",
        "Show Documentation",
    }

    -- Code actions popup
    lvim.lsp.buffer_mappings.normal_mode["gA"] = { "<cmd>lua vim.lsp.codelens.run()<cr>", "Codelens Actions" }
    lvim.lsp.buffer_mappings.normal_mode["ga"] = {
        --     "<cmd>CodeActionMenu<cr>",
        "<cmd>lua require('user.telescope').code_actions()<cr>",
        "Code action",
    }
    -- Goto
    lvim.lsp.buffer_mappings.normal_mode["gg"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto definition" }
    lvim.lsp.buffer_mappings.normal_mode["gd"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" }
    lvim.lsp.buffer_mappings.normal_mode["gt"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto type definition" }
    lvim.lsp.buffer_mappings.normal_mode["gr"] = {
        "<cmd>lua require('user.telescope').lsp_references()<cr>",
        "Goto references",
    }
    lvim.lsp.buffer_mappings.normal_mode["gi"] = {
        "<cmd>lua require('user.telescope').lsp_implementations()<cr>",
        "Goto implementation",
    }
    -- Copilot
    if lvim.builtin.copilot.active then
        lvim.lsp.buffer_mappings.normal_mode["gC"] = {
            name = "Copilot",
            e = { "<cmd>Copilot enable<cr><cmd>Copilot split<cr>", "Enable" },
            d = { "<cmd>Copilot disable<cr>", "Disable" },
            s = { "<cmd>Copilot status<cr>", "Status" },
            h = { "<cmd>Copilot help<cr>", "Help" },
            r = { "<cmd>Copilot restart<cr>", "Restart" },
            l = { "<cmd>Copilot logs<cr>", "Logs" },
        }
    end
    -- Rename
    lvim.lsp.buffer_mappings.normal_mode["gR"] = { "<cmd>lua require('renamer').rename()<cr>", "Rename symbol" }
    -- Diagnostics
    lvim.lsp.buffer_mappings.normal_mode["gl"] = {
        "<cmd>lua require('lvim.lsp.handlers').show_line_diagnostics()<CR>",
        "Show line diagnostics",
    }
    lvim.lsp.buffer_mappings.normal_mode["gn"] = {
        "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
        "Next Diagnostic",
    }
    lvim.lsp.buffer_mappings.normal_mode["gp"] = {
        "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
        "Prev Diagnostic",
    }
    lvim.lsp.buffer_mappings.normal_mode["ge"] = {
        name = "Diagnostics",
        e = { "<cmd>Trouble document_diagnostics<cr>", "Document diagnostics" },
        l = { "<cmd>Trouble loclist<cr>", "Trouble loclist" },
        q = { "<cmd>Trouble quickfix<cr>", "Trouble quifix" },
        r = { "<cmd>Trouble lsp_references<cr>", "Trouble references" },
        w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace diagnostics" },
    }
    -- Format
    lvim.lsp.buffer_mappings.normal_mode["gF"] = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format file" }
    -- Quit
    lvim.lsp.buffer_mappings.normal_mode["gq"] = { "<cmd>SmartQ<cr>", "Close buffer" }
    lvim.lsp.buffer_mappings.normal_mode["gQ"] = { "<cmd>SmartQ!<cr>", "Force close buffer" }
    -- Buffers and files
    lvim.lsp.buffer_mappings.normal_mode["gx"] = { "<cmd>lua require('user.telescope').buffers()<cr>", "Show buffers" }
    lvim.lsp.buffer_mappings.normal_mode["gf"] = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" }
end

M.register_prosemd = function()
    vim.list_extend(lvim.lsp.override, { "prosemd" })

    local configs = require "lspconfig.configs"

    -- Check if the config is already defined (useful when reloading this file)
    if not configs.prosemd then
        configs.prosemd = {
            default_config = {
                cmd = { "prosemd-lsp", "--stdio" },
                filetypes = { "latex", "tex", "bib", "markdown", "rst", "text" },
                root_dir = function(fname)
                    return require("lspconfig").util.find_git_ancestor(fname) or vim.fn.getcwd()
                end,
            },
        }
    end

    -- Use your attach function here
    local status_ok, lsp = pcall(require, "lspconfig")
    if not status_ok then
        return
    end

    lsp.prosemd.setup {
        on_attach = require("lvim.lsp").common_on_attach,
        on_init = require("lvim.lsp").common_on_init,
        capabilities = require("lvim.lsp").common_capabilities(),
    }
end

M.register_grammar_guard = function()
    vim.list_extend(lvim.lsp.override, { "grammar_guard" })
    require("grammar-guard").init()

    local opts = {
        cmd = { "ltex-ls" },
        root_dir = function(fname)
            return require("lspconfig").util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        settings = {
            ltex = {
                checkFrequency = "edit",
                enabled = { "latex", "tex", "bib", "markdown", "rst", "text" },
                language = "en",
                diagnosticSeverity = "information",
                setenceCacheSize = 2000,
                additionalRules = {
                    enablePickyRules = true,
                    motherTongue = "en",
                },
                trace = { server = "warning" },
            },
        },
        on_attach = require("lvim.lsp").common_on_attach,
        on_init = require("lvim.lsp").common_on_init,
        capabilities = require("lvim.lsp").common_capabilities(),
    }
    -- Use your attach function here
    local status_ok, lsp = pcall(require, "lspconfig")
    if not status_ok then
        return
    end

    lsp.grammar_guard.setup(opts)
end

M.config = function()
    vim.lsp.set_log_level "warn"
    lvim.lsp.automatic_servers_installation = true
    lvim.lsp.document_highlight = true
    lvim.lsp.code_lens_refresh = true

    -- Disable inline diagnostics
    lvim.lsp.diagnostics.virtual_text = false

    -- Setup diagnostics icons
    lvim.lsp.diagnostics.signs.values = {
        { name = "DiagnosticSignError", text = M.icons.error },
        { name = "DiagnosticSignWarn", text = M.icons.warn },
        { name = "DiagnosticSignInfo", text = M.icons.info },
        { name = "DiagnosticSignHint", text = M.icons.hint },
    }

    -- Borders
    lvim.lsp.float.border = {
        { "╔", "FloatBorder" },
        { "═", "FloatBorder" },
        { "╗", "FloatBorder" },
        { "║", "FloatBorder" },
        { "╝", "FloatBorder" },
        { "═", "FloatBorder" },
        { "╚", "FloatBorder" },
        { "║", "FloatBorder" },
    }
    lvim.lsp.diagnostics.float.border = {
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
        { " ", "FloatBorder" },
    }
    if os.getenv "KITTY_WINDOW_ID" then
        lvim.lsp.float.border = {
            { "🭽", "FloatBorder" },
            { "▔", "FloatBorder" },
            { "🭾", "FloatBorder" },
            { "▕", "FloatBorder" },
            { "🭿", "FloatBorder" },
            { "▁", "FloatBorder" },
            { "🭼", "FloatBorder" },
            { "▏", "FloatBorder" },
        }
        lvim.lsp.diagnostics.float.border = lvim.lsp.float.border
    end

    -- Float
    lvim.lsp.diagnostics.float.focusable = false
    lvim.lsp.float.focusable = true
    lvim.lsp.diagnostics.float.source = "if_many"
    lvim.lsp.diagnostics.float.format = function(d)
        local t = vim.deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        for _, table in pairs(M.codes) do
            if vim.tbl_contains(table, code) then
                return table.message
            end
        end
        return t.message
    end

    -- Configure null-ls
    require("user.null_ls").config()

    -- Configure Lsp providers
    if lvim.builtin.grammar_guard.active then
        M.register_grammar_guard()
    end
    M.register_prosemd()

    -- Mappings
    M.normal_buffer_mappings()
end

return M
