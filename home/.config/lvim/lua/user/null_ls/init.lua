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
    local semgrep_rule_folder = vim.env.HOME .. "/.config/semgrep/semgrep-rules/"
    local use_semgrep = false
    if vim.fn.filereadable(semgrep_rule_folder .. "template.yaml") then
        use_semgrep = true
    end

    local custom_go_actions = require "user.null_ls.go"
    local custom_md_dictionary = require "user.null_ls.dictionary"

    local sources = {
        -- nls.builtins.formatting.prettier,
        nls.builtins.formatting.prettierd.with {
            condition = function(utils)
                return not utils.root_has_file { ".eslintrc", ".eslintrc.js" }
            end,
            prefer_local = "node_modules/.bin",
        },
        nls.builtins.formatting.eslint_d.with {
            condition = function(utils)
                return utils.root_has_file { ".eslintrc", ".eslintrc.js" }
            end,
            prefer_local = "node_modules/.bin",
        },
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.goimports,
        nls.builtins.formatting.cmake_format,
        nls.builtins.formatting.scalafmt,
        nls.builtins.formatting.sqlformat,
        nls.builtins.formatting.terraform_fmt,
        -- Support for nix files
        nls.builtins.formatting.alejandra,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.black,
        nls.builtins.formatting.isort,
        nls.builtins.diagnostics.ansiblelint.with {
            condition = function(utils)
                return (utils.root_has_file "roles" and utils.root_has_file "inventories") or utils.root_has_file "ansible"
            end,
        },
        nls.builtins.diagnostics.solhint.with {
            condition = function(utils)
                return utils.root_has_file ".solhint.json"
            end,
        },
        nls.builtins.diagnostics.hadolint,
        nls.builtins.diagnostics.eslint_d.with {
            condition = function(utils)
                return utils.root_has_file { ".eslintrc", ".eslintrc.js" }
            end,
            prefer_local = "node_modules/.bin",
        },
        nls.builtins.diagnostics.semgrep.with {
            condition = function(utils)
                return utils.root_has_file ".semgrepignore" and use_semgrep
            end,
            extra_args = { "--metrics", "off", "--exclude", "vendor", "--config", semgrep_rule_folder },
        },
        nls.builtins.diagnostics.shellcheck,
        nls.builtins.diagnostics.luacheck,
        nls.builtins.diagnostics.vint,
        nls.builtins.diagnostics.chktex,
        -- Support for nix files
        nls.builtins.diagnostics.deadnix,
        nls.builtins.diagnostics.statix,
        nls.builtins.diagnostics.markdownlint.with {
            filetypes = { "markdown" },
        },
        -- nls.builtins.diagnostics.vale.with {
        --     filetypes = { "markdown" },
        -- },
        nls.builtins.diagnostics.revive.with {
            condition = function(utils)
                return utils.root_has_file "revive.toml"
            end,
        },
        nls.builtins.code_actions.shellcheck,
        nls.builtins.code_actions.eslint_d.with {
            condition = function(utils)
                return utils.root_has_file { ".eslintrc", ".eslintrc.js" }
            end,
            prefer_local = "node_modules/.bin",
        },
        -- TODO: try these later on
        -- nls.builtins.formatting.google_java_format,
        -- nls.builtins.code_actions.proselint,
        -- nls.builtins.diagnostics.proselint,
        custom_go_actions.gomodifytags,
        custom_go_actions.gostructhelper,
        custom_md_dictionary.dictionary,
    }
    table.insert(
        sources,
        nls.builtins.code_actions.refactoring.with {
            filetypes = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
        }
    )

    -- you can either config null-ls itself
    nls.setup {
        on_attach = require("lvim.lsp").common_on_attach,
        debounce = 150,
        save_after_format = false,
        sources = sources,
    }
end

return M
