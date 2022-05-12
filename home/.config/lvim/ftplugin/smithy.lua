-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Lsp config
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "smithy_language_server" })

local util = require "lspconfig.util"
local configs = require "lspconfig.configs"
if not configs.smithy_language_server then
    local home = os.getenv "HOME"
    configs.smithy_language_server = {
        default_config = {
            -- NOTE: to install and run the smithy_language_server you need to do this:
            -- $ git clone https://github.com/awslabs/smithy-language-server $HOME/.local/share/nvim/lsp_servers/smithy_language_server
            -- $ cd $HOME/.local/share/nvim/lsp_servers/smithy_language_server
            -- $ ./gradlew build

            -- This will generate the jar with the server implementation.
            -- Otherwise there is the Disney maven package, but it requires cs:
            -- cmd = { "cs", "launch", "com.disneystreaming.smithy:smithy-language-server:0.0.10", "--", "0" },
            cmd = {
                "java",
                "-jar",
                home
                    .. "/.local/share/nvim/lsp_servers/smithy_language_server/build/libs/smithy-language-server-0.0.0-SNAPSHOT.jar",
                "0",
            },
            filetypes = { "smithy" },
            root_dir = function(fname)
                return util.root_pattern "smithy-build.json"(fname)
                    or require("lspconfig").util.find_git_ancestor(fname)
                    or vim.fn.getcwd()
            end,
            message_level = vim.lsp.protocol.MessageType.Log,
            init_options = {
                statusBarProvider = "show-message",
                isHttpEnabled = true,
                compilerOptions = {
                    snippetAutoIndent = false,
                },
            },
        },
        docs = {
            description = [[
    Wake and bake, slumming it bruh
]],
            default_config = {
                root_dir = [[util.root_pattern("smithy-build.json")]],
            },
        },
    }
end

local status_ok, lsp = pcall(require, "lspconfig")
if not status_ok then
    return
end

lsp.smithy_language_server.setup {
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
}

vim.cmd [[LspStart smithy_language_server]]
