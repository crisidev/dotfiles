local M = {}

M.config = function()
    -- NORMAL
    lvim.keys.normal_mode = {
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
        -- Align text
        ["<"] = "<<",
        [">"] = ">>",
        -- Yank to the end of line
        ["Y"] = "y$",
        -- Open horizontal terminal
        ["<C-s-\\>"] = "<cmd>ToggleTerm direction=horizontal<cr>",
    }
    -- INSERT
    lvim.keys.insert_mode = {
        -- Toggle tree
        ["<F3>"] = "<cmd>NvimTreeToggle<cr>",
        -- Toggle sidebar
        ["<F4>"] = "<cmd>SidebarNvimToggle<cr>",
        -- Toggle mouse
        ["<F5>"] = "<cmd>MouseToggle<cr>",
        -- Yank current path
        ["<F6>"] = '<cmd>let @+ = expand("%:p")<cr>',
        -- Symbols
        ["<F10>"] = "<cmd>SymbolsOutline<cr>",
        -- Windows navigation
        ["<A-Up>"] = "<cmd>wincmd k<cr>",
        ["<A-Down>"] = "<cmd>wincmd j<cr>",
        ["<A-Left>"] = "<cmd>wincmd h<cr>",
        ["<A-Right>"] = "<cmd>wincmd l<cr>",
        -- Paste with Ctrl-v
        ["<C-v>"] = "<C-r><C-o>+",
        -- Snippets
        ["<C-s>"] = "<cmd>lua require('telescope').extensions.luasnip.luasnip(require('telescope.themes').get_cursor({}))<cr>",
        -- Open horizontal terminal
        ["<C-s-\\>"] = "<cmd>ToggleTerm direction=horizontal<cr>",
    }
    -- VISUAL
    lvim.keys.visual_mode = {
        -- Yank with Ctrl-c
        ["<C-c>"] = '"+yi',
        -- Cut with Ctrl-x
        ["<C-x>"] = '"+c',
        -- Paste with Ctrl-v
        ["<C-v>"] = 'c<Esc>"+p',
    }

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
end

return M
