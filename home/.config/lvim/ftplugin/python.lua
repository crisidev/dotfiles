-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "black",
        args = { "--line-length=120" },
        filetypes = { "python" },
    },
    {
        exe = "isort",
        args = { "-l 120 -m 3 -tc -sd THIRDPARTY" },
        filetypes = { "python" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        exe = "flake8",
        args = { "--max-line-length=120" },
        filetypes = { "python" },
    },
}

-- Debugging
if lvim.builtin.dap.active then
    local dap_install = require "dap-install"
    dap_install.config("python", {})
end
