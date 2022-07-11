-- NOTE: install using `R -e 'install.packages("languageserver",repos = "http://cran.us.r-project.org")'`
-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}
