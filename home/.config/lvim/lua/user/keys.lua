local M = {}

M.config = function()
    local common_keys = {
        -- Toggle tree
        ["<F3>"] = "<cmd>NvimTreeToggle<cr>",
        -- Toggle mouse
        ["<F4>"] = "<cmd>SidebarNvimToggle<cr>",
        -- Toggle sidebar
        ["<F5>"] = "<cmd>MouseToggle<cr>",
        -- Yank current path
        ["<F6>"] = '<cmd>let @+ = expand("%:p")<cr>',
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
        -- Snippets
        ["<C-s>"] = "<cmd>lua require('telescope').extensions.luasnip.luasnip(require('telescope.themes').get_cursor({}))<cr>",
    }

    -- NORMAL
    lvim.keys.normal_mode = common_keys
    -- Align text
    lvim.keys.normal_mode["<"] = "<<"
    lvim.keys.normal_mode[">"] = ">>"
    -- Yank to the end of line
    lvim.keys.normal_mode["Y"] = "y$"

    -- INSERT
    lvim.keys.insert_mode = common_keys

    -- VISUAL
    lvim.keys.visual_mode = {
        -- Yank with Ctrl-c
        ["<C-c>"] = '"+yi',
        -- Cut with Ctrl-x
        ["<C-x>"] = '"+c',
    }

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
