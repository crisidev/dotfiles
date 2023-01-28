local M = {}

local icons = require("user.icons").icons

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
    local ok, wk = pcall(require, "which-key")
    if not ok then
        return
    end

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
            e = {
                "<cmd>lua require('user.telescope').diagnostics()<cr>",
                icons.hint .. "All diagnostics",
            },
            N = {
                "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.ERROR}})<cr>",
                icons.error .. "Next ERROR diagnostic",
            },
            P = {
                "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.ERROR}})<cr>",
                icons.error .. "Previous ERROR diagnostic",
            },
            n = {
                "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.WARN}})<cr>",
                icons.warn .. "Next diagnostic",
            },
            p = {
                "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}, severity = {min = vim.diagnostic.severity.WARN}})<cr>",
                icons.warn .. "Previous diagnostic",
            },
            -- Format
            F = {
                "<cmd>lua vim.lsp.buf.format { async = true }<cr>",
                icons.magic .. "Format file",
            },
            -- Rename
            R = {
                "<cmd>lua vim.lsp.buf.rename()<cr>",
                icons.rename .. "Rename symbol",
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
            -- Inlay hints
            E = { "<cmd>lua require('lsp-inlayhints').toggle()<cr>", icons.inlay .. "Toggle Inlay" },
            -- Neotest
            T = {
                name = icons.settings .. "Tests",
                f = {
                    "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), env=require('user.ntest').get_env()})<cr>",
                    "File",
                },
                o = { "<cmd>lua require('neotest').output.open({ enter = true, short = false })<cr>", "Output" },
                r = { "<cmd>lua require('neotest').run.run({env=require('user.ntest').get_env()})<cr>", "Run" },
                a = { "<cmd>lua require('user.ntest').run_all()<cr>", "Run All" },
                c = { "<cmd>lua require('user.ntest').cancel()<cr>", "Cancel" },
                R = { "<cmd>lua require('user.ntest').run_file_sync()<cr>", "Run Async" },
                s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Toggle summary" },
                n = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", "Jump to next failed" },
                p = {
                    "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>",
                    "Jump to previous failed",
                },
                d = { "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<cr>", "Dap Run" },
                l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Last" },
                x = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
                w = { "<cmd>lua require('neotest').watch.watch()<cr>", "Watch" },
                t = { "<cmd>OverseerToggle<cr>", "Toggle tests" },
                T = { "<cmd>OverseerRun<cr>", "Run task" },
                Tc = { "<cmd>OverseerRunCmd<cr>", "Run task with Cmd" },
            },
        },
    }

    -- Incremental rename
    if lvim.builtin.noice.active then
        wk.register {
            ["f"] = {
                I = {
                    function()
                        return ":IncRename " .. vim.fn.expand "<cword>"
                    end,
                    icons.rename .. "Rename incremental",
                    expr = true,
                },
            },
        }
    end

    -- Copilot
    if lvim.builtin.copilot.active then
        wk.register {
            ["f"] = {
                C = {
                    name = icons.copilot .. " Copilot",
                    e = { "<cmd>lua require('user.copilot').enable()<cr>", "Enable" },
                    d = { "<cmd>lua require('user.copilot').disable()<cr>", "Disable" },
                    v = { "<cmd>Copilot status<cr>", "Status" },
                    h = { "<cmd>lua require('user.copilot').help()<cr>", "Help" },
                    r = { "<cmd>lua require('user.copilot').restart()<cr>", "Restart" },
                    t = { "<cmd>Copilot toggle<cr>", "Toggle" },
                    P = { "<cmd>Copilot panel<cr>", "Panel" },
                    p = {
                        name = "Panel mode",
                        a = { "<cmd>Copilot panel accept<cr>", "Accept" },
                        n = { "<cmd>Copilot panel jump_next<cr>", "Next" },
                        p = { "<cmd>Copilot panel jump_prev<cr>", "Prev" },
                        r = { "<cmd>Copilot panel refresh<cr>", "Refresh" },
                    },
                    s = { "<cmd>Copilot suggestion<cr>", "Suggestion" },
                    S = { "<cmd>Copilot suggestion toggle_auth_trigger<cr>", "Suggestion auto trigger" },
                },
            },
        }
    end
end

M.lsp_visual_keys = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then
        return
    end

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
