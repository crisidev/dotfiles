local M = {}

M.config = function()
    -- Neovide options
    -- Disable nonsense
    vim.g.neovide_cursor_vfx_mode = nil
    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_cursor_trail_length = 0.0
    vim.g.neovide_cursor_vfx_particle_lifetime = 0.0
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_input_use_logo = false

    -- Remember window size
    vim.g.neovide_remember_window_size = true

    -- What the title of the window will be set to
    vim.opt.titlestring = "ide | %<%F"

    -- Store CWD in file to allow nvim sync with terminal CWD
    table.insert(lvim.autocommands.custom_groups, { "BufEnter", "*", "lua require('user.neovim').setcwd()" })
end

return M
