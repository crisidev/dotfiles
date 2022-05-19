-- General
vim.opt.guifont = "FiraCode Nerd Font:h10"
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "tokyonight"
lvim.line_wrap_cursor_movement = false
lvim.termguicolors = true
lvim.transparent_window = false
lvim.debug = false
lvim.leader = ","
vim.o.conceallevel = 2

-- Vimscript if needed
vim.cmd "source ~/.config/lvim/vimscript/user.pre.vim"

-- Builtin
require("user.builtin").config()

-- Neovim
require("user.neovim").config()

-- Cmp
require("user.cmp").config()

-- Additional Plugins
require("user.plugins").config()

-- Treesitter
require("user.treesitter").config()

-- Telescope
require("user.telescope").config()

-- Bufferline
require("user.bufferline").config()

-- Status line
require("user.lualine").config()

-- Keys
require("user.keys").config()

-- Autocommands
require("user.autocmd").config()

-- Lsp
require("user.lsp").config()

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
