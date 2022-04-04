local M = {}

M.config = function()
    -- Neovide options
    vim.g.neovide_refresh_rate = 100
    vim.g.neovide_transparency = 1.0
    vim.g.neovide_touch_deadzone = 6.0
    vim.g.neovide_input_use_logo = true
    -- Disable nonsense
    vim.g.neovide_cursor_vfx_mode = nil
    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_cursor_trail_length = 0.0
    vim.g.neovide_cursor_vfx_particle_lifetime = 0.0
    vim.g.neovide_cursor_antialiasing = true

    -- Remember window size
    vim.g.neovide_remember_window_size = true

    -- What the title of the window will be set to
    vim.opt.titlestring = "ide | %<%F"
end

return M
