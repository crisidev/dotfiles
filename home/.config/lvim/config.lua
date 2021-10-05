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

-- Vimscript if needed
vim.cmd "source ~/.config/lvim/user.pre.vim"

-- Builtin
require("user.neovim").config()

-- Builtin
require("user.builtin").config()

-- Barbar
require("user.barbar").config()

-- Status line
if not lvim.builtin.firevim then
    require("user.lualine").config()
end

-- Additional Plugins
require("user.plugins").config()

-- Keys
require("user.keys").config()

-- Which key
require("user.which_key").config()

-- Autocommands
require("user.autocmd").config()

-- Lsp
require("user.lsp").config()

-- Formatters
require("user.providers").formatters()

-- Linters
require("user.providers").linters()

-- Glrnvim
if lvim.builtin.grlnvim then
    require("user.glrnvim").config()
end

-- Neovide
if lvim.builtin.neovide then
    require("user.neovide").config()
end

-- Debugging
require("user.dap").config()

-- Custom work stuff
local ok, amzn = pcall(require, "user.amzn")
if ok then
    amzn.config()
end

-- Firevim
if lvim.builtin.firevim then
    require("user.firevim").config()
end

-- Vimscript if needed
vim.cmd "source ~/.config/lvim/user.post.vim"
