local M = {}

M.config = function()
    local home = vim.env.HOME
    local cmd_path =
        vim.fn.glob(home .. "/github/kotlin-language-server/server/build/install/server/bin/kotlin-language-server")
    local util = require "lspconfig.util"
    local opts = {
        cmd = { cmd_path },
        -- on_attach = require("lvim.lsp").common_on_attach,
        on_init = require("lvim.lsp").common_on_init,
        capabilities = require("lvim.lsp").common_capabilities(),
        filetypes = { "kotlin", "kt", "kts" },
        root_dir = util.root_pattern("settings.gradle.kts", "gradlew"),
        settings = {
            kotlin = {
                compiler = {
                    jvm = {
                        target = "1.8",
                    },
                },
            },
        },
    }

    require("lvim.lsp.manager").setup("kotlin_language_server", opts)
end

M.build_tools = function()
    local icons = require "user.icons"
    local which_key = require "which-key"
    local opts = {
        mode = "n",
        prefix = "f",
        buffer = vim.fn.bufnr(),
        silent = true,
        noremap = true,
        nowait = true,
    }
    local mappings = {
        B = {
            name = icons.languages.kotlin .. " Build helpers",
            c = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='./gradlew codegen-core:check;read',count=3,direction='float'})<cr>",
                "Run codegen-core tests",
            },
            C = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='./gradlew codegen-client:check;read',count=3,direction='float'})<cr>",
                "Run codegen-client tests",
            },
            s = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='./gradlew codegen-server:check;read',count=3,direction='float'})<cr>",
                "Run codegen-server tests",
            },
            t = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='./gradlew codegen-server-test:assemble;read',count=3,direction='float'})<cr>",
                "Assemble codegen-server-test tests",
            },
            T = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='./gradlew codegen-server-test:check;read',count=3,direction='float'})<cr>",
                "Run codegen-server-test tests",
            },
            p = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='./gradlew codegen-server-test:python:assemble;read',count=3,direction='float'})<cr>",
                "Assemble codegen-server-test:python tests",
            },
            P = {
                "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='./gradlew codegen-server-test:python:check;read',count=3,direction='float'})<cr>",
                "Run codegen-server-test:python tests",
            },
        },
    }
    which_key.register(mappings, opts)
end

return M
