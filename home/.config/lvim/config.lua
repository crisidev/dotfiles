-- General
vim.opt.guifont = "FiraCode Nerd Font:h10"
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "tokyonight"
lvim.line_wrap_cursor_movement = false
lvim.termguicolors = true
lvim.transparent_window = false
lvim.debug = false
lvim.leader = "space"
vim.o.conceallevel = 2

-- Vimscript if needed
vim.cmd "source ~/.config/lvim/vimscript/user.pre.vim"

-- Builtin
require("user.builtin").config()

-- Builtin
require("user.neovim").config()

-- Additional Plugins
require("user.plugins").config()

-- Treesitter
require("user.treesitter").config()

-- Telescope
require("user.telescope").config()

-- Command palette
require("user.cpmenu").config()

-- Barbar
require("user.bufferline").config()

-- Status line
require("user.lualine").config()

-- Keys
require("user.keys").config()

-- Which key
require("user.which_key").config()

-- Autocommands
require("user.autocmd").config()

-- Lsp
require("user.lsp").config()

-- Neovide
if vim.g.neovide then
    require("user.neovide").config()
end

-- Debugging
require("user.dap").config()

-- Custom work stuff
local ok, amzn = pcall(require, "user.amzn")
if ok then
    amzn.config()
end

-- Copilot
require("user.copilot").config()

-- Vimscript if needed
vim.cmd "source ~/.config/lvim/vimscript/user.post.vim"
