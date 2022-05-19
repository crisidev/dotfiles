-- NOTE: install using `R -e 'install.packages("languageserver",repos = "http://cran.us.r-project.org")'`
-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Start lsp
local lspconfig = require "lspconfig"
local configs = require "lspconfig/configs"
local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local shell = require "nvim-lsp-installer.installers.shell"
