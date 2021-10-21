-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "rustfmt",
        -- args = { },
        filetypes = { "rust" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
}

-- Debugging
if lvim.builtin.dap.active then
    local dap_install = require "dap-install"
    dap_install.config("rust", {})
end
