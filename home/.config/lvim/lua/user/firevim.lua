local M = {}

M.config = function()
    -- Configure Firevim
    vim.api.nvim_command [[ let g:firenvim_config = { 'globalSettings': { 'C-w': 'noop', 'C-n': 'default' }, 'localSettings': { '.*': { 'selector': 'textarea', 'takeover': 'never' } } } ]]

    -- Github markdown
    table.insert(lvim.autocommands.custom_groups, { "BufEnter", "github.com_*.txt", "set filetype=markdown" })
end

return M
