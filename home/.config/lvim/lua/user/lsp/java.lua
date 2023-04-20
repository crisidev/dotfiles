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
        launcher_path =
            vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]
    end
    local CONFIG = "linux"
    if vim.fn.has "mac" == 1 then
        CONFIG = "mac"
        WORKSPACE_PATH = home .. "/.cache/jdtls/workspace/"
    elseif vim.fn.has "unix" == 1 then
        WORKSPACE_PATH = home .. "/.cache/jdtls/workspace/"
    else
        vim.notify("Unsupported system", vim.log.levels.ERROR)
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
    local bundles = { vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar", true) }
    if #bundles == 0 then
        bundles = { vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar", true) }
    end
    local extra_bundles = vim.fn.glob(
        mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
        true
    )
    if #extra_bundles == 0 then
        extra_bundles = vim.fn.glob(
            mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
            true
        )
    end
    vim.list_extend(bundles, { extra_bundles })

    -- LSP configuration.
    local config = {
        cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-javaagent:" .. mason_path .. "/packages/jdtls/lombok.jar",
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

M.build_tools = function()
    -- Additional mappings
    vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
    vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
    vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
    vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

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
            name = icons.languages.java .. " Build helpers",
            o = { "<Cmd>lua require('jdtls').organize_imports()<CR>", "Organize Imports" },
            v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
            c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
            m = { "<Cmd>lua require('jdtls').extract_method()<CR>", "Extract Method" },
            t = { "<Cmd>lua require('jdtls').test_nearest_method()<CR>", "Test Method" },
            T = { "<Cmd>lua require('jdtls').test_class()<CR>", "Test Class" },
            u = { "<Cmd>lua require('jdtls').update_project_config()<CR>", "Update Config" },
            x = { "<Cmd>lua require('jdtls').javap()<CR>", "Bytecode" },
            S = { "<Cmd>lua require('jdtls').jshell()<CR>", "Jshell" },
            B = { "<Cmd>lua require('jdtls').compile('full')<CR>", "Compile full" },
            b = { "<Cmd>lua require('jdtls').compile('incremental')<CR>", "Compile incremental" },
            s = { "<Cmd>lua require('jdtls').super_implementation()<CR>", "Go to super" },
            r = { "<Cmd>JdtSetRuntime<CR>", "Set runtime" },
        },
    }
    local vopts = {
        mode = "v",
        prefix = "f",
        buffer = vim.fn.bufnr(),
        silent = true,
        noremap = true,
        nowait = true,
    }
    local vmappings = {
        B = {
            name = icons.languages.java .. " Build helpers",
            v = { "<Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
            c = { "<Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
            m = { "<Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
        },
    }
    which_key.register(mappings, opts)
    which_key.register(vmappings, vopts)
end

return M
