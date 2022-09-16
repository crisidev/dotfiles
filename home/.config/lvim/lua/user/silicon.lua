local M = {}

M.config = function()
    vim.cmd [[
        let g:silicon = {
              \   'theme':              'Dracula',
              \   'font':                  'Hack',
              \   'background':         '#FFFFFF',
              \   'shadow-color':       '#555555',
              \   'line-pad':                   0,
              \   'pad-horiz':                  0,
              \   'pad-vert':                   0,
              \   'shadow-blur-radius':         0,
              \   'shadow-offset-x':            0,
              \   'shadow-offset-y':            0,
              \   'line-number':           v:true,
              \   'round-corner':          v:true,
              \   'window-controls':       v:true,
              \ }
        let g:silicon['output'] ="~/Pictures/silicon-{time:%Y-%m-%d-%H%M%S}.png"
    ]]
end

return M
