local M = {}

M.config = function()
    if lvim.builtin.copilot.active then
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ""
        local cmp = require "cmp"
        lvim.builtin.cmp.mapping["<C-e>"] = function(fallback)
            cmp.mapping.abort()
            local copilot_keys = vim.fn["copilot#Accept"]()
            if copilot_keys ~= "" then
                vim.api.nvim_feedkeys(copilot_keys, "i", true)
            else
                fallback()
            end
        end
    end
end

return M
