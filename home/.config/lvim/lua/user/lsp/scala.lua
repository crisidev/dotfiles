local M = {}

M.start = function()
    local status_ok, metals = pcall(require, "metals")
    if not status_ok then
        return
    end

    local metals_config = metals.bare_config()

    vim.opt.shortmess:remove "F"
    require("telescope").load_extension "metals"

    metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
        excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl",
            "akka.stream.javadsl",
        },
        fallbackScalaVersion = "3.2.0-RC3",
        serverVersion = "0.11.12",
    }

    metals_config.init_options.statusBarProvider = "on"
    metals_config.capabilities = require("lvim.lsp").common_capabilities()
    metals_config.on_attach = function(client, bufnr)
        require("lvim.lsp").common_on_attach(client, bufnr)
        metals.setup_dap()
    end
    metals.initialize_or_attach(metals_config)
end

return M
