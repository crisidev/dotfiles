-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "clang_format",
        -- args = {},
        filetypes = { "c", "cpp" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Additional mappings
local icons = require("user.icons")
local which_key = require "which-key"
which_key.register {
    ["f"] = {
        B = {
            name = icons.icons.nuclear .. " Build helpers",
            C = {
                name =  icons.languages.c .. " C/C++",
                H = {
                    "<Cmd>ClangdSwitchSourceHeader<CR>",
                    "Swich Header/Source",
                },
                g = { "<cmd>CMakeGenerate<CR>", "Generate CMake" },
                r = { "<cmd>CMakeRun<CR>", "Run CMake" },
                b = { "<cmd>CMakeBuild<CR>", "Build CMake" },
                d = { "<cmd>CMakeDebug<CR>", "Debug CMake" },
                sb = { "<cmd>CMakeSelectBuildType<CR>", "Select Build Type" },
                sB = { "<cmd>CMakeSelectBuildTarget<CR>", "Select Build Target" },
                st = { "<cmd>CMakeSelectLaunchTarget<CR>", "Select Launch Target" },
                o = { "<cmd>CMakeOpen<CR>", "Open CMake Console" },
                C = { "<cmd>CMakeClose<CR>", "Close CMake Console" },
                i = { "cmd>CMakeInstall<cr>", "Install CMake Targets" },
                c = { "<cmd>CMakeClean<CR>", "Clean CMake Targets" },
                s = { "<cmd>CMakeStop<CR>", "Stop CMake" },
            },
        },
    },
}
