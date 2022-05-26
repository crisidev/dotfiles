local M = {}

M.config = function()
    local icons = require("user.icons").icons

    -- Hover
    -- lvim.lsp.buffer_mappings.normal_mode["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" }
    lvim.lsp.buffer_mappings.normal_mode["K"] = {
        "<cmd>lua require('user.lsp').show_documentation()<CR>",
        icons.docs .. "Show Documentation",
    }
    lvim.lsp.buffer_mappings.visual_mode["K"] = lvim.lsp.buffer_mappings.normal_mode["K"]

    -- Code actions popup
    lvim.lsp.buffer_mappings.normal_mode["gA"] = {
        "<cmd>lua vim.lsp.codelens.run()<cr>",
        icons.codelens .. "Codelens actions",
    }
    lvim.lsp.buffer_mappings.visual_mode["gA"] = lvim.lsp.buffer_mappings.normal_mode["gA"]
    lvim.lsp.buffer_mappings.normal_mode["ga"] = {
        --     "<cmd>CodeActionMenu<cr>",
        "<cmd>lua vim.lsp.buf.code_action()<cr>",
        icons.codelens .. "Code actions",
    }
    lvim.lsp.buffer_mappings.visual_mode["ga"] = lvim.lsp.buffer_mappings.normal_mode["ga"]

    -- Goto
    lvim.lsp.buffer_mappings.normal_mode["gg"] = {
        "<cmd>lua vim.lsp.buf.definition()<CR>",
        icons.go .. " Goto definition",
    }
    lvim.lsp.buffer_mappings.visual_mode["gg"] = lvim.lsp.buffer_mappings.normal_mode["gg"]
    lvim.lsp.buffer_mappings.normal_mode["gt"] = {
        "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        icons.go .. " Goto type definition",
    }
    lvim.lsp.buffer_mappings.visual_mode["gt"] = lvim.lsp.buffer_mappings.normal_mode["gt"]
    lvim.lsp.buffer_mappings.normal_mode["gd"] = {
        "<cmd>lua vim.lsp.buf.declaration()<CR>",
        icons.go .. " Goto declaration",
    }
    lvim.lsp.buffer_mappings.visual_mode["gd"] = lvim.lsp.buffer_mappings.normal_mode["gd"]
    lvim.lsp.buffer_mappings.normal_mode["gr"] = {
        "<cmd>lua require('user.telescope').lsp_references()<cr>",
        icons.go .. " Goto references",
    }
    lvim.lsp.buffer_mappings.visual_mode["gr"] = lvim.lsp.buffer_mappings.normal_mode["gr"]
    lvim.lsp.buffer_mappings.normal_mode["gi"] = {
        "<cmd>lua require('user.telescope').lsp_implementations()<cr>",
        icons.go .. " Goto implementations",
    }
    lvim.lsp.buffer_mappings.visual_mode["gi"] = lvim.lsp.buffer_mappings.normal_mode["gi"]
    -- Copilot
    if lvim.builtin.copilot.active then
        lvim.lsp.buffer_mappings.normal_mode["gC"] = {
            name = icons.copilot .. " Copilot",
            e = { "<cmd>lua require('user.copilot').enable()<cr>", "Enable" },
            d = { "<cmd>lua require('user.copilot').disable()<cr>", "Disable" },
            s = { "<cmd>lua require('user.copilot').status()<cr>", "Status" },
            h = { "<cmd>lua require('user.copilot').help()<cr>", "Help" },
            h = { "<cmd>lua require('user.copilot').restart()<cr>", "Restart" },
            l = { "<cmd>lua require('user.copilot').logs()<cr>", "Logs" },
        }
        lvim.lsp.buffer_mappings.visual_mode["gC"] = lvim.lsp.buffer_mappings.normal_mode["gC"]
    end

    -- Signature
    lvim.lsp.buffer_mappings.normal_mode["gs"] = {
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        icons.Function .. " Show signature help",
    }
    lvim.lsp.buffer_mappings.visual_mode["gs"] = lvim.lsp.buffer_mappings.normal_mode["gs"]

    -- Diagnostics
    lvim.lsp.buffer_mappings.normal_mode["gl"] = {
        "<cmd>lua vim.diagnostic.open_float()<CR>",
        icons.hint .. "Show line diagnostics",
    }
    lvim.lsp.buffer_mappings.visual_mode["gl"] = lvim.lsp.buffer_mappings.normal_mode["gl"]
    lvim.lsp.buffer_mappings.normal_mode["gD"] = {
        "<cmd>lua require('user.telescope').diagnostics()<cr>",
        icons.hint .. "Show diagnostics",
    }
    lvim.lsp.buffer_mappings.visual_mode["gD"] = lvim.lsp.buffer_mappings.normal_mode["gD"]
    lvim.lsp.buffer_mappings.normal_mode["gn"] = {
        "<cmd>lua vim.diagnostic.goto_next({float = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
        icons.hint .. "Next diagnostic",
    }
    lvim.lsp.buffer_mappings.visual_mode["gn"] = lvim.lsp.buffer_mappings.normal_mode["gn"]

    lvim.lsp.buffer_mappings.normal_mode["gp"] = {
        "<cmd>lua vim.diagnostic.goto_prev({float = {border = 'rounded', focusable = false, source = 'always'}})<cr>",
        icons.hint .. "Previous diagnostic",
    }
    lvim.lsp.buffer_mappings.visual_mode["gp"] = lvim.lsp.buffer_mappings.normal_mode["gp"]

    -- Format
    lvim.lsp.buffer_mappings.normal_mode["gF"] = {
        "<cmd>lua vim.lsp.buf.format { async = true }<cr>",
        icons.magic .. "Format file",
    }
    lvim.lsp.buffer_mappings.visual_mode["gF"] = lvim.lsp.buffer_mappings.normal_mode["gF"]

    -- Refactoring
    lvim.lsp.buffer_mappings.normal_mode["gR"] = {
        "<esc><cmd>lua vim.lsp.buf.rename()<cr>",
        icons.palette .. "Rename symbol",
    }
    lvim.lsp.buffer_mappings.visual_mode["gR"] = lvim.lsp.buffer_mappings.normal_mode["gR"]
    lvim.lsp.buffer_mappings.normal_mode["gX"] = {
        name = icons.palette .. "Refactoring",
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol" },
        f = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract function" },
        F = {
            "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
            "Extract function to file",
        },
        v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract variable" },
        i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline variable" },
        b = { "<cmd>lua require('refactoring').refactor('Extract Block')<cr>", "Extract block" },
        B = { "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>", "Extract block to file" },
    }
    lvim.lsp.buffer_mappings.visual_mode["gX"] = lvim.lsp.buffer_mappings.normal_mode["gX"]

    -- Hlslens
    lvim.lsp.buffer_mappings.normal_mode["g*"] = {
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        icons.find .. " Start hlslens",
    }
    lvim.lsp.buffer_mappings.visual_mode["g*"] = lvim.lsp.buffer_mappings.normal_mode["g*"]
    lvim.lsp.buffer_mappings.normal_mode["g#"] = {
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        icons.find .. " Start hlslens",
    }
    lvim.lsp.buffer_mappings.visual_mode["g#"] = lvim.lsp.buffer_mappings.normal_mode["g*"]

    -- Comment
    lvim.lsp.buffer_mappings.normal_mode["gc"] = { name = icons.comment .. " Comment linewise" }
    lvim.lsp.buffer_mappings.normal_mode["gb"] = { name = icons.comment .. " Comment blockwise" }

    lvim.lsp.buffer_mappings.normal_mode["gI"] = nil
    lvim.lsp.buffer_mappings.normal_mode["g#"] = nil
    lvim.lsp.buffer_mappings.normal_mode["gv"] = {}
    lvim.lsp.buffer_mappings.normal_mode["gx"] = {}
    lvim.lsp.buffer_mappings.normal_mode["gf"] = {}
end

return M
