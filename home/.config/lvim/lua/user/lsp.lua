local M = {}

-- Location information about the last message printed. The format is
-- `(did print, buffer number, line number)`.
local last_echo = { false, -1, -1 }
-- The timer used for displaying a diagnostic in the commandline.
local echo_timer = nil
-- The timer after which to display a diagnostic in the commandline.
local echo_timeout = 250
-- The highlight group to use for hint messages.
local hint_hlgroup = "markdownCode"
-- The highlight group to use for info messages.
local info_hlgroup = "HopNextKey2"
-- The highlight group to use for warning messages.
local warning_hlgroup = "WarningMsg"
-- The highlight group to use for error messages.
local error_hlgroup = "ErrorMsg"
-- If the first diagnostic line has fewer than this many characters, also add
-- the second line to it.
local short_line_limit = 20

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
    ls_inactive = "轢",
    ls_active = "歷",
    question = " ",
    added = "  ",
    modified = "柳",
    removed = " ",
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

-- Prints the first diagnostic for the current line.
M.echo_diagnostic = function()
    if echo_timer then
        echo_timer:stop()
    end

    echo_timer = vim.defer_fn(function()
        local line = vim.fn.line "." - 1
        local bufnr = vim.api.nvim_win_get_buf(0)

        if last_echo[1] and last_echo[2] == bufnr and last_echo[3] == line then
            return
        end

        local diags = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line, { severity_limit = "Hint" })

        if #diags == 0 then
            -- If we previously echo'd a message, clear it out by echoing an empty
            -- message.
            if last_echo[1] then
                last_echo = { false, -1, -1 }

                vim.api.nvim_command 'echo ""'
            end

            return
        end

        last_echo = { true, bufnr, line }

        local diag = diags[1]
        local width = vim.api.nvim_get_option "columns" - 15
        local lines = vim.split(diag.message, "\n")
        local message = lines[1]

        if #lines > 1 and #message <= short_line_limit then
            message = message .. " " .. lines[2]
        end

        if width > 0 and #message >= width then
            message = message:sub(1, width) .. "..."
        end

        local kind = "hint"
        local hlgroup = hint_hlgroup

        if diag.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
            kind = "error"
            hlgroup = error_hlgroup
        elseif diag.severity == vim.lsp.protocol.DiagnosticSeverity.Warning then
            kind = "warning"
            hlgroup = warning_hlgroup
        elseif diag.severity == vim.lsp.protocol.DiagnosticSeverity.Info then
            kind = "info"
            hlgroup = info_hlgroup
        end

        local chunks = {
            { kind .. ": ", hlgroup },
            { message },
        }

        vim.api.nvim_echo(chunks, false, {})
    end, echo_timeout)
end

M.normal_buffer_mappings = function()
    -- Buffer mapping
    lvim.lsp.buffer_mappings.normal_mode = require("user.which_key").n_keys()
    -- Keybindings
    -- Hover
    lvim.lsp.buffer_mappings.normal_mode["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" }
    -- Code actions popup
    lvim.lsp.buffer_mappings.normal_mode["ga"] = {
        "<cmd>CodeActionMenu<cr>",
        "Code action",
    }
    lvim.lsp.buffer_mappings.normal_mode["gA"] = {
        "<cmd>lua vim.lsp.codelens.run()<cr>",
        "Codelens action",
    }
    -- Goto
    lvim.lsp.buffer_mappings.normal_mode["gg"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" }
    lvim.lsp.buffer_mappings.normal_mode["gt"] = {
        name = "Goto",
        g = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
        d = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
        i = { "<cmd>lua require('user.telescope').lsp_implementations()<cr>", "Implementation" },
        r = { "<cmd>lua require('user.telescope').lsp_references()<cr>", "References" },
    }
    -- Signature
    lvim.lsp.buffer_mappings.normal_mode["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature help" }
    -- Diagnostics
    lvim.lsp.buffer_mappings.normal_mode["gl"] = {
        "<cmd>lua require('lvim.lsp.handlers').show_line_diagnostics()<CR>",
        "Show line diagnostics",
    }
    -- Peek
    lvim.lsp.buffer_mappings.normal_mode["gP"] = {
        name = "Peek",
        p = { "<cmd>lua require('lvim.lsp.peek').Peek('definition')<CR>", "Peek definition" },
        d = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Preview definition" },
        r = { "<cmd>lua require('goto-preview').goto_preview_references()<cr>", "Preview references" },
        i = { "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", "Preview implementation" },
        q = { "<cmd>lua require('goto-preview').close_all_win()<cr>", "Close all preview windows" },
    }
    -- Copilot
    if lvim.builtin.copilot.active then
        lvim.lsp.buffer_mappings.normal_mode["gC"] = {
            name = "Copilot",
            e = { "<cmd>Copilot enable<cr>", "Enable" },
            d = { "<cmd>Copilot disable<cr>", "Disable" },
            s = { "<cmd>Copilot status<cr>", "Status" },
        }
    end
    -- Rename
    lvim.lsp.buffer_mappings.normal_mode["gr"] = { "<cmd>lua require('renamer').rename()<cr>", "Rename symbol" }
    -- Diagnostics
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
        n = {
            "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
            "Next Diagnostic",
        },
        p = {
            "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
            "Prev Diagnostic",
        },
    }
    -- Format
    lvim.lsp.buffer_mappings.normal_mode["gF"] = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format file" }
    -- Empty
end

M.config_prosemd = function()
    local lsp_configs = require "lspconfig.configs"

    lsp_configs.prosemd = {
        default_config = {
            -- Update the path to prosemd-lsp
            cmd = { "prosemd-lsp", "--stdio" },
            root_dir = function(fname)
                return require("lspconfig").util.root_pattern ".git"(fname)
                    or require("lspconfig").util.path.dirname(fname)
            end,
        },
    }

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

M.config_bashls = function()
    -- Lsp config
    local lsp_configs = require "lspconfig.configs"
    lsp_configs.bashls = {
        default_config = {
            -- Update the path to prosemd-lsp
            cmd = {
                "node",
                "/home/matbigoi/.local/share/nvim/lsp_servers/bash/node_modules/bash-language-server/bin/main.js",
                "start",
            },
            root_dir = function(fname)
                return require("lspconfig").util.root_pattern ".git"(fname)
                    or require("lspconfig").util.path.dirname(fname)
            end,
        },
    }

    -- Use your attach function here
    local status_ok, lsp = pcall(require, "lspconfig")
    lsp.bashls.setup {
        on_attach = require("lvim.lsp").common_on_attach,
        on_init = require("lvim.lsp").common_on_init,
        capabilities = require("lvim.lsp").common_capabilities(),
    }
end

M.config_tsserver = function()
    local status_ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")
    if not status_ok then
        vim.cmd [[ packadd nvim-lsp-ts-utils ]]
        ts_utils = require "nvim-lsp-ts-utils"
    end

    local opts = {
        on_attach = function(client, bufnr)
            -- defaults
            ts_utils.setup {
                debug = false,
                disable_commands = false,
                enable_import_on_completion = false,
                import_all_timeout = 5000, -- ms

                -- eslint
                eslint_enable_code_actions = true,
                eslint_enable_disable_comments = true,
                eslint_bin = "eslint_d",
                eslint_config_fallback = nil,
                eslint_enable_diagnostics = false,

                -- formatting
                enable_formatting = false,
                formatter = "prettierd",
                formatter_config_fallback = nil,

                -- parentheses completion
                complete_parens = false,
                signature_help_in_parens = false,

                -- update imports on file move
                update_imports_on_move = false,
                require_confirmation_on_move = false,
                watch_dir = nil,
            }
            ts_utils.setup_client(client)
            require("lvim.lsp").common_on_attach(client, bufnr)
        end,
        init_options = require("nvim-lsp-ts-utils").init_options,
        on_init = require("lvim.lsp").common_on_init,
        capabilities = require("lvim.lsp").common_capabilities(),
    }

    local servers = require "nvim-lsp-installer.servers"
    local server_available, requested_server = servers.get_server "tsserver"
    if server_available then
        opts.cmd_env = requested_server:get_default_options().cmd_env
    end

    require("lvim.lsp.manager").setup("tsserver", opts)
end

M.config = function()
    vim.lsp.set_log_level "warn"
    -- Use rust-tools.nvim
    vim.list_extend(lvim.lsp.override, {
        "rust_analyzer",
        "gopls",
        "jsonls",
        "dockerls",
        "tsserver",
        "sumneko_lua",
        "yamlls",
        "bashls",
        "r_language_server",
        "grammar_guard",
    })
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

    local ok, _ = pcall(require, "vim.diagnostic")
    if ok then
        vim.diagnostic.config { virtual_text = false }
    end

    -- Initialize grammar-guard
    require("grammar-guard").init()

    -- Mappings
    M.normal_buffer_mappings()
end

return M
