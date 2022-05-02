-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "prettierd",
        -- args = {},
        filetypes = { "yaml" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Lsp server override
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "yamlls" })

local opts = {
    settings = {
        yaml = {
            hover = true,
            completion = true,
            validate = true,
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {
                kubernetes = {
                    "daemon.{yml,yaml}",
                    "manager.{yml,yaml}",
                    "restapi.{yml,yaml}",
                    "kubectl-edit*.yaml",
                },
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/configmap.json"] = "*onfigma*.{yml,yaml}",
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/deployment.json"] = "*eployment*.{yml,yaml}",
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/service.json"] = "*ervic*.{yml,yaml}",
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/ingress.json"] = "*ngres*.{yml,yaml}",
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/secret.json"] = "*ecre*.{yml,yaml}",
            },
        },
    },
}

require("lvim.lsp.manager").setup("yamlls", opts)
