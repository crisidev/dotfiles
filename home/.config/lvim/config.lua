-- Builtin
require("user.builtin").config()

-- Neovim
require("user.neovim").config()
require("user.neovide").config()

-- Additional Plugins
require("user.plugins").config()

-- Autocommands
require("user.autocmd").config()

-- Cmp
require("user.cmp").config()

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

-- Lsp
require("user.lsp").config()

-- Debugging
require("user.dap").config()

-- Custom work stuff
local ok, amzn = pcall(require, "user.amzn")
if ok then
    amzn.config()
end
