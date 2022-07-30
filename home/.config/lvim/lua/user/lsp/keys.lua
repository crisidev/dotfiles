local M = {}

M.config = function()
    local icons = require("user.icons").icons
    local wk = require "which-key"

    -- Hover
    lvim.lsp.buffer_mappings.normal_mode["K"] = {
        "<cmd>lua require('user.lsp').show_documentation()<CR>",
        icons.docs .. "Show Documentation",
    }
    lvim.lsp.buffer_mappings.visual_mode["K"] = lvim.lsp.buffer_mappings.normal_mode["K"]

    wk.register {
        -- Lsp
        ["f"] = {
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
            e = {
                "<cmd>lua require('user.telescope').diagnostics()<cr>",
                icons.hint .. "All diagnostics",
            },
            n = {
                "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
                icons.hint .. "Next diagnostic",
            },
            p = {
                "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
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
                icons.palette .. "Rename symbol",
            },
            -- Peek
            P = {
                "<cmd>lua require('lvim.lsp.peek').Peek('definition')<cr>",
                icons.find .. " Peek definition",
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

return M
