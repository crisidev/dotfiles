-- Neovim
require("user.neovim").config()

-- Builtin
require("user.builtin").config()

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

-- Terminal
require("user.terminal").config()

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
