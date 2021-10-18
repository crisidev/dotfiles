local M = {}

M.config = function()
    local function sep_os_replacer(str)
        local result = str
        local path_sep = package.config:sub(1, 1)
        result = result:gsub("/", path_sep)
        return result
    end

    local status_ok, dap = pcall(require, "dap")
    if not status_ok then
        return
    end

    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Neovim attach",
            host = function()
                local value = vim.fn.input "Host [127.0.0.1]: "
                if value ~= "" then
                    return value
                end
                return "127.0.0.1"
            end,
            port = function()
                local val = tonumber(vim.fn.input "Port: ")
                assert(val, "Please provide a port number")
                return val
            end,
        },
    }

    dap.configurations.go = {
        {
            type = "go",
            name = "Debug",
            request = "launch",
            showLog = false,
            program = "${file}",
            dlvToolPath = vim.fn.exepath "dlv", -- Adjust to where delve is installed
        },
    }

    dap.configurations.cpp = {
        {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
            runInTerminal = false,
        },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- overwrite program
    dap.configurations.rust[1].externalConsole = true
    dap.configurations.rust[1].program = function()
        return sep_os_replacer(vim.fn.getcwd() .. "/target/debug/" .. "${workspaceFolderBasename}")
    end
end

return M
