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

    -- Multigrid workaround
    vim.g.neovide_floating_blur = 0

    -- Remember window size
    vim.g.neovide_remember_window_size = true

    -- What the title of the window will be set to
    vim.opt.titlestring = "ide | %<%F"
end

return M
