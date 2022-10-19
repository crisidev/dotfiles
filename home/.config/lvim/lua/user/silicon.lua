local M = {}

M.config = function()
    vim.cmd [[
        let g:silicon = {
              \   'theme': 'Enki-Tokyo-Night',
              \   'font': 'FiraCode Nerd Font',
              \   'background':         '#AAAAFF',
              \   'shadow-color':       '#555555',
              \   'line-pad': 0,
              \   'pad-horiz': 0,
              \   'pad-vert': 0,
              \   'shadow-blur-radius': 0,
              \   'shadow-offset-x': 0,
              \   'shadow-offset-y': 0,
              \   'line-number': v:true,
              \   'round-corner': v:true,
              \   'window-controls': v:false,
              \   'output': "~/Pictures/vim-screenshot/{time:%Y-%m-%d-%H%M%S}.png",
              \ }
    ]]
end

return M
