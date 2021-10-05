local M = {}

M.formatters = function()
    lvim.lang.c.formatters = {
        {
            exe = "clang_format",
            -- args = {},
        },
    }
    lvim.lang.cpp.formatters = {
        {
            exe = "clang_format",
            -- args = {},
        },
    }
    lvim.lang.css.formatters = {
        {
            exe = "prettier",
            -- args = {},
        },
    }
    lvim.lang.go.formatters = {
        {
            exe = "goimports",
            -- args = {},
        },
    }
    if lvim.builtin.dap.active then
        local dap_install = require "dap-install"
        dap_install.config("go_delve", {})
    end
    lvim.lang.html.formatters = {
        {
            exe = "prettier",
            -- args = {},
        },
    }

    lvim.lang.javascript.formatters = {
        {
            exe = "prettier",
            -- args = {},
        },
    }
    lvim.lang.json.formatters = {
        {
            exe = "prettier",
            -- args = {},
        },
    }
    lvim.lang.lua.formatters = {
        {
            exe = "stylua",
            -- args = {},
        },
    }
    lvim.lang.markdown.formatters = {
        {
            exe = "prettier",
            -- args = {},
        },
    }
    lvim.lang.python.formatters = {
        {
            exe = "black",
            args = { "--line-length=120" },
        },
        {
            exe = "isort",
            args = { "-l 120 -m 3 -tc -sd THIRDPARTY" },
        },
    }
    if lvim.builtin.dap.active then
        local dap_install = require "dap-install"
        dap_install.config("python", {})
    end
    lvim.lang.sh.formatters = {
        {
            exe = "shfmt",
            args = { "-i", "2", "-ci" },
        },
    }
    lvim.lang.yaml.formatters = {
        {
            exe = "prettier",
            -- args = {},
        },
    }
end

M.linters = function()
    lvim.lang.dockerfile.linters = {
        {
            exe = "hadolint",
            -- args = {},
        },
    }
    lvim.lang.javascript.linters = {
        {
            exe = "eslint_d",
            -- args = {},
        },
    }
    lvim.lang.lua.linters = {
        {
            exe = "luacheck",
            -- args = {},
        },
    }
    lvim.lang.markdown.linters = {
        {
            exe = "vale",
            -- args = {},
        },
    }
    lvim.lang.python.linters = {
        {
            exe = "flake8",
            args = { "--max-line-length=120" },
        },
    }
    lvim.lang.sh.linters = {
        {
            exe = "shellcheck",
            -- args = {},
        },
    }
    lvim.lang.vim.linters = {
        {
            exe = "vint",
            -- args = {},
        },
    }
end

return M
