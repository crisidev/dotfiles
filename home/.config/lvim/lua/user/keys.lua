local M = {}

M.config = function()
    -- NORMAL
    lvim.keys.normal_mode = {
        ["<F3>"] = "<cmd>NvimTreeToggle<cr>",
        ["<F4>"] = "<cmd>MouseToggle<cr>",
        -- Yank current path
        ["<F5>"] = '<cmd>let @+ = expand("%:p")<cr>',
        -- Windows navigation
        ["<A-Up>"] = "<cmd>wincmd k<cr>",
        ["<A-Down>"] = "<cmd>wincmd j<cr>",
        ["<A-Left>"] = "<cmd>wincmd h<cr>",
        ["<A-Right>"] = "<cmd>wincmd l<cr>",
        -- Symbols
        ["<F10>"] = "<cmd>SymbolsOutline<cr>",
        -- Toggle numbers
        ["<F11>"] = "<cmd>NoNuMode<cr>",
        ["<F12>"] = "<cmd>NuModeToggle<cr>",
        -- Align text
        ["<"] = "<<",
        [">"] = ">>",
        -- Yank to the end of line
        ["Y"] = "y$",
    }
    -- INSERT
    lvim.keys.insert_mode = {
        -- Buffer navigation
        ["<F3>"] = "<Esc><cmd>NvimTreeToggle<cr>",
        -- Yank current path
        ["<F5>"] = '<Esc><cmd>let @+ = expand("%:p")<cr>',
        -- Symbols
        ["<F10>"] = "<Esc><cmd>SymbolsOutline<cr>",
        -- Windows navigation
        ["<A-Up>"] = "<Esc><Esc> <cmd>wincmd k<cr>",
        ["<A-Down>"] = "<Esc><Esc> <cmd>wincmd j<cr>",
        ["<A-Left>"] = "<Esc><Esc> <cmd>wincmd h<cr>",
        ["<A-Right>"] = "<Esc><Esc> <cmd>wincmd l<cr>",
    }
    -- VISUAL
    lvim.keys.visual_mode = {}

    if lvim.builtin.fancy_bufferline.active then
        -- Buffer navigation
        lvim.keys.normal_mode["<F1>"] = "<cmd>BufferLineCyclePrev<cr>"
        lvim.keys.normal_mode["<F2>"] = "<cmd>BufferLineCycleNext<cr>"
        lvim.keys.insert_mode["<F1>"] = "<cmd>BufferLineCyclePrev<cr>"
        lvim.keys.insert_mode["<F2>"] = "<cmd>BufferLineCycleNext<cr>"
        -- Move buffers
        lvim.keys.normal_mode["<A-S-Left>"] = "<cmd>BufferLineMovePrev<cr>"
        lvim.keys.normal_mode["<A-S-Right>"] = "<cmd>BufferLineMoveNext<cr>"
        lvim.keys.insert_mode["<A-S-Left>"] = "<cmd>BufferLineMovePrev<cr>"
        lvim.keys.insert_mode["<A-S-Right>"] = "<cmd>BufferLineMoveNext<cr>"
    else
        -- Buffer navigation
        lvim.keys.normal_mode["<F1>"] = "<cmd>BufferPrev<cr>"
        lvim.keys.normal_mode["<F2>"] = "<cmd>BufferNext<cr>"
        lvim.keys.insert_mode["<F1>"] = "<cmd>BufferPrev<cr>"
        lvim.keys.insert_mode["<F2>"] = "<cmd>BufferNext<cr>"
        -- Move buffers
        lvim.keys.normal_mode["<A-S-Left>"] = "<cmd>BufferMovePrevious<cr>"
        lvim.keys.normal_mode["<A-S-Right>"] = "<cmd>BufferMoveNext<cr>"
        lvim.keys.insert_mode["<A-S-Left>"] = "<cmd>BufferMovePrevious<cr>"
        lvim.keys.insert_mode["<A-S-Right>"] = "<cmd>BufferMoveNext<cr>"
    end
end

return M
