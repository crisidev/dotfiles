local M = {}

M.config = function()
    local icons = require("user.icons").icons
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

return M
