local M = {}

M.config = function()
    -- Lsp config
    local pyright_opts = {
        root_dir = function(fname)
            local util = require "lspconfig.util"
            local root_files = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "manage.py",
                "pyrightconfig.json",
            }
            return util.root_pattern(unpack(root_files))(fname)
                or util.root_pattern ".git"(fname)
                or util.path.dirname(fname)
        end,
        settings = {
            pyright = {
                disableLanguageServices = false,
                disableOrganizeImports = false,
            },
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                },
            },
        },
        single_file_support = true,
    }

    require("lvim.lsp.manager").setup("pyright", pyright_opts)
end

M.build_tools = function()
    local which_key = require "which-key"
    local icons = require "user.icons"
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
            name = icons.languages.python .. " Build helpers",
            c = { "<cmd>lua require('dap-python').test_class()<cr>", "Test class" },
            m = { "<cmd>lua require('dap-python').test_method()<cr>", "Test method" },
            s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug selection" },
            e = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Pick env" },
            E = { "<cmd>lua require('swenv.api').get_current_venv()<cr>", "Show env" },
        },
    }
    which_key.register(mappings, opts)
end

return M
