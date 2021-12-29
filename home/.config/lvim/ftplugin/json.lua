-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettier",
        -- args = {},
        filetypes = { "json" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Lsp server override
local full_schemas = vim.tbl_deep_extend(
    "force",
    require("schemastore").json.schemas(),
    require("nlspsettings.jsonls").get_default_schemas()
)
local opts = {
    settings = {
        json = {
            schemas = full_schemas,
        },
    },
    setup = {
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
                end,
            },
        },
    },
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
}

local servers = require "nvim-lsp-installer.servers"
local server_available, requested_server = servers.get_server "jsonls"
if server_available then
    opts.cmd = requested_server:get_default_options().cmd
end

require("lvim.lsp.manager").setup("jsonls", opts)
