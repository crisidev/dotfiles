local M = {}

M.config = function()
    -- Lsp config
    local status_ok, jdtls = pcall(require, "jdtls")
    if not status_ok then
        return
    end

    -- Determine paths
    local home = vim.env.HOME
    local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason")
    local launcher_path = vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
    if #launcher_path == 0 then
        launcher_path = vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", 1, 1)[1]
    end
    if vim.fn.has "mac" == 1 then
        CONFIG = "mac"
        WORKSPACE_PATH = home .. "/.cache/jdtls/workspace/"
    elseif vim.fn.has "unix" == 1 then
        CONFIG = "linux"
        WORKSPACE_PATH = home .. "/.cache/.jdtls/workspace/"
    else
        print("Unsupported system")
        return
    end

    -- Find root of project
    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    if root_dir == "" then
        return
    end

    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = WORKSPACE_PATH .. project_name

    -- Debug bundles
    local bundles = vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar")
    if #bundles == 0 then
        bundles = vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar", 1, 1)
    end
    local extra_bundles = vim.fn.glob(mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
    if #extra_bundles == 0 then
        extra_bundles = vim.fn.glob(mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1, 1)
    end
    vim.list_extend(bundles, extra_bundles)

    -- LSP configuration.
    local config = {
        cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
            "-Xms1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            launcher_path,
            "-configuration",
            mason_path .. "/packages/jdtls/config_" .. CONFIG,
            "-data",
            workspace_dir,
        },
        on_attach = function(client, bufnr)
            local _, _ = pcall(vim.lsp.codelens.refresh)
            require("jdtls.dap").setup_dap_main_class_configs()
            require("jdtls").setup_dap { hotcodereplace = "auto" }
            require("lvim.lsp").on_attach(client, bufnr)
        end,
        on_init = require("lvim.lsp").common_on_init,
        on_exit = require("lvim.lsp").common_on_exit,
        capabilities = require("lvim.lsp").common_capabilities(),
        root_dir = root_dir,
        settings = {
            java = {
                -- jdt = {
                --   ls = {
                --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
                --   }
                -- },
                eclipse = {
                    downloadSources = true,
                },
                configuration = {
                    updateBuildConfiguration = "interactive",
                },
                maven = {
                    downloadSources = true,
                },
                implementationsCodeLens = {
                    enabled = true,
                },
                referencesCodeLens = {
                    enabled = true,
                },
                references = {
                    includeDecompiledSources = true,
                },
                inlayHints = {
                    parameterNames = {
                        enabled = "all", -- literals, all, none
                    },
                },
                format = {
                    enabled = true,
                    settings = {
                        profile = "GoogleStyle",
                        url = home .. "/.config/lvim/.java-google-formatter.xml",
                    },
                },
            },
            signatureHelp = { enabled = true },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
            },
            contentProvider = { preferred = "fernflower" },
            extendedClientCapabilities = extendedClientCapabilities,
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
            },
        },
        flags = {
            allow_incremental_sync = true,
            server_side_fuzzy_completion = true,
        },
        init_options = {
            bundles = bundles,
        },
    }

    jdtls.start_or_attach(config)
end

return M
