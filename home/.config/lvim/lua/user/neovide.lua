local M = {}

M.config = function()
    if vim.g.neovide then
        vim.cmd [[
            let g:neovide_scale_factor = 1.0
            let g:neovide_transparency = 0.98
            let g:neovide_floating_blur_amount_x = 2.0
            let g:neovide_floating_blur_amount_y = 2.0
            let g:neovide_scroll_animation_length = 0.0
            let g:neovide_hide_mouse_when_typing = v:false
            let g:neovide_underline_automatic_scaling = v:false
            let g:neovide_refresh_rate = 60
            let g:neovide_refresh_rate_idle = 5
            let g:neovide_no_idle = v:true
            let g:neovide_confirm_quit = v:true
            let g:neovide_remember_window_size = v:false
            let g:neovide_fullscreen = v:false
            let g:neovide_profiler = v:false
            let g:neovide_input_use_logo = v:false
            let g:neovide_touch_deadzone = 6.0
            let g:neovide_touch_drag_timeout = 0.0
            let g:neovide_cursor_animation_length=0.0
            let g:neovide_cursor_trail_size = 0.8
            let g:neovide_cursor_antialiasing = v:true
            let g:neovide_cursor_unfocused_outline_width = 0.125
            let g:neovide_cursor_vfx_mode = ""
        ]]
    end
end

return M
