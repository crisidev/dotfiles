-- Formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        exe = "goimports",
        -- args = {},
        filetypes = { "go" },
    },
}

-- Linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {}

-- Debugging
if lvim.builtin.dap.active then
    local dap_install = require "dap-install"
    dap_install.config("go_delve", {})
end

-- Lsp config
local opts = {
    settings = {
        gopls = {
            gofumpt = true, -- A stricter gofmt
            codelenses = {
                gc_details = true, -- Toggle the calculation of gc annotations
                generate = true, -- Runs go generate for a given directory
                regenerate_cgo = true, -- Regenerates cgo definitions
                tidy = true, -- Runs go mod tidy for a module
                upgrade_dependency = true, -- Upgrades a dependency in the go.mod file for a module
                vendor = true, -- Runs go mod vendor for a module
            },
            diagnosticsDelay = "500ms",
            experimentalWatchedFileDelay = "100ms",
            symbolMatcher = "fuzzy",
            completeUnimported = true,
            staticcheck = true,
            matcher = "Fuzzy",
            usePlaceholders = true, -- enables placeholders for function parameters or struct fields in completion responses
            analyses = {
                fieldalignment = true, -- find structs that would use less memory if their fields were sorted
                nilness = true, -- check for redundant or impossible nil comparisons
                shadow = true, -- check for possible unintended shadowing of variables
                unusedparams = true, -- check for unused parameters of functions
                unusedwrite = true, -- checks for unused writes, an instances of writes to struct fields and arrays that are never read
            },
        },
    },
}

local servers = require "nvim-lsp-installer.servers"
local server_available, requested_server = servers.get_server "gopls"
if server_available then
    opts.cmd_env = requested_server:get_default_options().cmd_env
end

require("lvim.lsp.manager").setup("gopls", opts)

-- Additional mappings
lvim.lsp.buffer_mappings.normal_mode["gB"] = {
    name = " Build helpers",
    b = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go build .;read',count=2,direction='float'})<cr>",
        "Run go build",
    },
    v = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go vet .;read',count=2,direction='float'})<cr>",
        "Run go vet",
    },
    t = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go test .;read',count=2,direction='float'})<cr>",
        "Run go test",
    },
    r = {
        "<cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go run .;read',count=2,direction='float'})<cr>",
        "Run go run",
    },
}
