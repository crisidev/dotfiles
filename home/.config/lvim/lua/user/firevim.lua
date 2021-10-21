local M = {}

M.config = function()
    -- Configure Firevim
    vim.api.nvim_command [[ let g:firenvim_config = { 'globalSettings': { 'C-w': 'noop', 'C-n': 'default' }, 'localSettings': { '.*': { 'selector': 'textarea', 'takeover': 'never' } } } ]]

    -- Configure vim
    lvim.builtin.bufferline.active = false
    lvim.builtin.lualine.active = false
    lvim.builtin.dashboard.active = false
    vim.api.nvim_command "set laststatus=0"
    vim.api.nvim_command "set showtabline=0"
    vim.api.nvim_command "set laststatus=0"

    -- Github markdown
    table.insert(lvim.autocommands.custom_groups, { "BufEnter", "github.com_*.txt", "set filetype=markdown" })
end

return M
