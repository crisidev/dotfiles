local M = {}

local icons = require("user.icons").icons
local ok, wk = pcall(require, "which-key")
if not ok then
    return
end

M.comments_keys = function()
    -- NORMAL mode mappings
    vim.keymap.set("n", "fc", "<Plug>(comment_toggle_linewise)", { desc = icons.comment .. " Comment linewise" })
    vim.keymap.set("n", "fcc", function()
        return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)"
    end, { expr = true, desc = "Comment toggle current line" })

    vim.keymap.set("n", "fb", "<Plug>(comment_toggle_blockwise)", { desc = icons.comment .. " Comment blockwise" })
    vim.keymap.set("n", "fbc", function()
        return vim.v.count == 0 and "<Plug>(comment_toggle_blockwise_current)"
            or "<Plug>(comment_toggle_blockwise_count)"
    end, { expr = true, desc = "Comment toggle current block" })

    -- Above, below, eol
    vim.keymap.set(
        "n",
        "fco",
        '<cmd>lua require("Comment.api").locked.insert_linewise_below()<cr>',
        { desc = "Comment insert below" }
    )
    vim.keymap.set(
        "n",
        "fcO",
        '<cmd>lua require("Comment.api").locked.insert_linewise_above()<cr>',
        { desc = "Comment insert above" }
    )
    vim.keymap.set(
        "n",
        "fcA",
        '<cmd>lua require("Comment.api").locked.insert_linewise_eol()<cr>',
        { desc = "Comment insert end of line" }
    )

    -- VISUAL mode mappings
    vim.keymap.set("x", "fc", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment toggle linewise (visual)" })
    vim.keymap.set("x", "fb", "<Plug>(comment_toggle_blockwise_visual)", { desc = "Comment toggle blockwise (visual)" })
end

M.lsp_normal_keys = function()
    -- Hover
    lvim.lsp.buffer_mappings.normal_mode["K"] = {
        "<cmd>lua require('user.lsp').show_documentation()<CR>",
        icons.docs .. "Show Documentation",
    }
    lvim.lsp.buffer_mappings.visual_mode["K"] = lvim.lsp.buffer_mappings.normal_mode["K"]

    wk.register {
        -- Lsp
        ["f"] = {
            name = icons.codelens .. "Lsp actions",
            -- Code actions popup
            A = {
                "<cmd>lua vim.lsp.codelens.run()<cr>",
                icons.codelens .. "Codelens actions",
            },
            a = {
                --     "<cmd>CodeActionMenu<cr>",
                "<cmd>lua vim.lsp.buf.code_action()<cr>",
                icons.codelens .. "Code actions",
            },
            -- Goto
            f = {
                "<cmd>lua vim.lsp.buf.definition()<cr>",
                icons.go .. " Goto definition",
            },
            t = {
                "<cmd>lua vim.lsp.buf.type_definition()<cr>",
                icons.go .. " Goto type definition",
            },
            d = {
                "<cmd>lua vim.lsp.buf.declaration()<cR>",
                icons.go .. " Goto declaration",
            },
            r = {
                "<cmd>lua require('user.telescope').lsp_references()<cr>",
                icons.go .. " Goto references",
            },
            i = {
                "<cmd>lua require('user.telescope').lsp_implementations()<cr>",
                icons.go .. " Goto implementations",
            },
            -- Signature
            s = {
                "<cmd>lua vim.lsp.buf.signature_help()<cr>",
                icons.Function .. " Show signature help",
            },
            -- Diagnostics
            l = {
                "<cmd>lua vim.diagnostic.open_float()<cr>",
                icons.hint .. "Show line diagnostics",
            },
            L = {
                "<cmd>lua require('lsp_lines').toggle()<cr>",
                icons.hint .. "Toggle LSP lines",
            },
            e = {
                "<cmd>lua require('user.telescope').diagnostics()<cr>",
                icons.hint .. "All diagnostics",
            },
            N = {
                "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.ERROR}})<cr>",
                icons.hint .. "Next ERROR diagnostic",
            },
            P = {
                "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.ERROR}})<cr>",
                icons.hint .. "Previous ERROR diagnostic",
            },
            n = {
                "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.WARN}})<cr>",
                icons.hint .. "Next diagnostic",
            },
            p = {
                "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.WARN}})<cr>",
                icons.hint .. "Previous diagnostic",
            },
            -- Format
            F = {
                "<cmd>lua vim.lsp.buf.format { async = true }<cr>",
                icons.magic .. "Format file",
            },
            -- Rename
            R = {
                "<cmd>lua vim.lsp.buf.rename()<cr>",
                icons.magic .. "Rename symbol",
            },
            -- Peek
            z = {
                "<cmd>lua require('user.peek').Peek('definition')<cr>",
                icons.find .. " Peek definition",
            },
            Z = {
                name = icons.find .. " Peek",
                d = { "<cmd>lua require('user.peek').Peek('definition')<cr>", "Definition" },
                t = { "<cmd>lua require('user.peek').Peek('typeDefinition')<cr>", "Type Definition" },
                i = { "<cmd>lua require('user.peek').Peek('implementation')<cr>", "Implementation" },
            },
            -- Refactoring
            X = {
                name = icons.palette .. "Refactoring",
                f = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract function" },
                F = {
                    "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
                    "Extract function to file",
                },
                v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract variable" },
                i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline variable" },
                b = { "<cmd>lua require('refactoring').refactor('Extract Block')<cr>", "Extract block" },
                B = {
                    "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>",
                    "Extract block to file",
                },
            },
            -- Trouble
            D = {
                name = icons.error .. "Trouble",
                r = { "<cmd>Trouble lsp_references<cr>", "References" },
                f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
                d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
                q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
                l = { "<cmd>Trouble loclist<cr>", "LocationList" },
                w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
            },
        },
    }
    -- Copilot
    if lvim.builtin.copilot.active then
        wk.register {
            ["f"] = {
                C = {
                    name = icons.copilot .. " Copilot",
                    e = { "<cmd>lua require('user.copilot').enable()<cr>", "Enable" },
                    d = { "<cmd>lua require('user.copilot').disable()<cr>", "Disable" },
                    s = { "<cmd>lua require('user.copilot').status()<cr>", "Status" },
                    h = { "<cmd>lua require('user.copilot').help()<cr>", "Help" },
                    r = { "<cmd>lua require('user.copilot').restart()<cr>", "Restart" },
                    l = { "<cmd>lua require('user.copilot').logs()<cr>", "Logs" },
                },
            },
        }
    end
end

M.lsp_visual_keys = function()
    -- Visual
    wk.register({
        ["f"] = {
            name = icons.codelens .. "Lsp actions",
            -- Refactoring
            X = {
                name = icons.palette .. "Refactoring",
                f = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract function" },
                F = {
                    "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
                    "Extract function to file",
                },
                v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract variable" },
                i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline variable" },
                b = { "<cmd>lua require('refactoring').refactor('Extract Block')<cr>", "Extract block" },
                B = {
                    "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>",
                    "Extract block to file",
                },
            },
            -- Rename
            R = {
                "<cmd>lua vim.lsp.buf.rename()<cr>",
                icons.magic .. "Rename symbol",
            },
            -- Range code actions
            a = {
                "<cmd>lua vim.lsp.buf.range_code_action()<cr>",
                icons.code_lens_action .. " Code actions",
            },
        },
    }, { mode = "v" })
end

M.config = function()
    M.comments_keys()
    M.lsp_normal_keys()
    M.lsp_visual_keys()
end

return M
