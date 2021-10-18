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

local kind_symbols = {
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

M.cmp_kind = function(kind)
    return kind_symbols[kind] or ""
end


M.symbols = function()
  return kind_symbols
end

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
    lvim.lsp.buffer_mappings.normal_mode = {
        ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
        -- Code actions popup
        ["ga"] = { "<cmd>lua require('user.telescope').code_actions()<cr>", "Code action" },
        ["gA"] = { "<cmd>lua require('user.telescope').codelens_actions()<cr>", "Codelens action" },
        -- Goto
        ["gg"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
        ["gd"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
        ["gi"] = { "<cmd>lua require('user.telescope').lsp_implementations()<cr>", "Goto Implementation" },
        ["gr"] = { "<cmd>lua require('user.telescope').lsp_references()<cr>", "Goto References" },
        ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature help" },
        ["gl"] = { "<cmd>lua require('lvim.lsp.handlers').show_line_diagnostics()<CR>", "Show line diagnostics" },
        -- Peek
        ["gp"] = { "<cmd>lua require('lvim.lsp.peek').Peek('definition')<CR>", "Peek definition" },
        ["gP"] = {
            name = "Peek",
            d = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Preview definition" },
            r = { "<cmd>lua require('goto-preview').goto_preview_references()<cr>", "Preview references" },
            i = { "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", "Preview implementation" },
            q = { "<cmd>lua require('goto-preview').close_all_win()<cr>", "Close all preview windows" },
        },
        -- Rename
        ["gR"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol" },
        -- Diagnostics
        ["ge"] = {
            name = "Diagnostics",
            e = { "<cmd>lua require('user.telescope').lsp_document_diagnostics()<cr>", "Document diagnostics" },
            n = {
                "<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
                "Next Diagnostic",
            },
            p = {
                "<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
                "Prev Diagnostic",
            },
        },
        -- Format
        ["gf"] = { "<cmd>lua vim.lsp.buf.formatting_seq_sync()<cr>", "Format file" },
        -- Find
        ["gF"] = {
            name = "Find",
            b = { "<cmd>lua require('user.telescope').file_browser()<cr>", "File browser" },
            f = { "<cmd>lua require('user.telescope').find_files()<cr>", "Find files" },
            l = {
                "<cmd>lua require('user.telescope').grep_last_search({layout_strategy = \"vertical\"})<cr>",
                "Last Search",
            },
            p = { "<cmd>lua require('user.telescope').project_search()<cr>", "Project" },
            r = { "<cmd>lua require('user.telescope').recent_files()<cr>", "Recent files" },
            s = { "<cmd>lua require('user.telescope').find_string()<cr>", "Find string in file" },
            z = { "<cmd>lua require('user.telescope').search_only_certain_files()<cr>", "Certain Filetype" },
        },
        -- Buffers
        ["gq"] = { "<cmd>BufferClose<cr>", "Close buffer" },
        ["gQ"] = { "<cmd>BufferClose!<cr>", "Force close buffer" },
        ["gB"] = { "<cmd>lua require('user.telescope').buffers()<cr>", "Buffers" },
        -- Session management
        ["gh"] = {
            name = "Session",
            s = { "<cmd>lua require('persistence').load()<cr>", "Restore for current dir" },
            l = { "<cmd>lua require('persistence').load({ last = true})<cr>", "Restore last session" },
            d = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
        },
        -- Git
        ["gG"] = {
            b = { "<cmd>GitBlameToggle<cr>", "Toggle inline git blame" },
            B = { "<cmd>Git blame<cr>", "Open git blame" },
            L = {
                "<cmd>lua require('user.amzn').link_to_code_browser(1, vim.api.nvim_win_get_cursor(0)[1])<cr>",
                "Copy browser line",
            },
        },
    }
end

M.config = function()
    -- Use rust-tools.nvim
    lvim.lsp.override = { "rust_analyzer" }
    lvim.lsp.automatic_servers_installation = true
    lvim.lsp.document_highlight = true
    lvim.lsp.code_lens_refresh = true

    -- Disable inline diagnostics
    lvim.lsp.diagnostics.virtual_text = false

    M.normal_buffer_mappings()
end

return M
