local M = {}

M.config = function()
    -- NOTE: By default, all null-ls providers are checked on startup.
    -- If you want to avoid that or want to only set up the provider
    -- when you opening the associated file-type,
    -- then you can use filetype plugins for this purpose.
    -- https://www.lunarvim.org/languages/#lazy-loading-the-formatter-setup
    local status_ok, nls = pcall(require, "null-ls")
    if not status_ok then
        return
    end

    local custom_go_actions = require "user.null_ls.go"
    local custom_md_hover = require "user.null_ls.markdown"

    -- you can either config null-ls itself
    nls.setup {
        on_attach = require("lvim.lsp").common_on_attach,
        debounce = 150,
        save_after_format = false,
        sources = {
            -- TODO: try these later on
            -- nls.builtins.formatting.google_java_format,
            -- nls.builtins.code_actions.refactoring,
            -- nls.builtins.code_actions.proselint,
            -- nls.builtins.diagnostics.proselint,
            custom_go_actions.gomodifytags,
            custom_go_actions.gostructhelper,
            custom_md_hover.dictionary,
        },
    }
end

return M
