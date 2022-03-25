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
				local value = vim.fn.input("Host [127.0.0.1]: ")
				if value ~= "" then
					return value
				end
				return "127.0.0.1"
			end,
			port = function()
				local val = tonumber(vim.fn.input("Port: "))
				assert(val, "Please provide a port number")
				return val
			end,
		},
	}

	dap.adapters.go = function(callback, _)
		local stdout = vim.loop.new_pipe(false)
		local handle
		local pid_or_err
		local port = 38697
		local opts = {
			stdio = { nil, stdout },
			args = { "dap", "-l", "127.0.0.1:" .. port },
			detached = true,
		}
		handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
			stdout:close()
			handle:close()
			if code ~= 0 then
				print("dlv exited with code", code)
			end
		end)
		assert(handle, "Error running dlv: " .. tostring(pid_or_err))
		stdout:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				vim.schedule(function()
					require("dap.repl").append(chunk)
				end)
			end
		end)
		-- Wait for delve to start
		vim.defer_fn(function()
			callback({ type = "server", host = "127.0.0.1", port = port })
		end, 100)
	end
	-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
	dap.configurations.go = {
		{
			type = "go",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
		{
			type = "go",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
			mode = "test",
			program = "${file}",
		},
		-- works with go.mod packages and sub packages
		{
			type = "go",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
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
			stopOnEntry = true,
			args = {},
			runInTerminal = false,
		},
	}

	dap.adapters.codelldb = function(on_adapter)
		local stdout = vim.loop.new_pipe(false)
		local stderr = vim.loop.new_pipe(false)

		local cmd = vim.fn.expand("~/") .. ".vscode/extensions/vadimcn.vscode-lldb-1.6.10/adapter/codelldb"

		local handle, pid_or_err
		local opts = {
			stdio = { nil, stdout, stderr },
			detached = true,
		}
		handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
			stdout:close()
			stderr:close()
			handle:close()
			if code ~= 0 then
				print("codelldb exited with code", code)
			end
		end)
		assert(handle, "Error running codelldb: " .. tostring(pid_or_err))
		stdout:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				local port = chunk:match("Listening on port (%d+)")
				if port then
					vim.schedule(function()
						on_adapter({
							type = "server",
							host = "127.0.0.1",
							port = port,
						})
					end)
				else
					vim.schedule(function()
						require("dap.repl").append(chunk)
					end)
				end
			end
		end)
		stderr:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				vim.schedule(function()
					require("dap.repl").append(chunk)
				end)
			end
		end)
	end

	dap.configurations.cpp = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = true,
		},
	}
	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp

	dap.configurations.typescript = {
		{
			type = "node2",
			name = "node attach",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
		},
		{
			type = "chrome",
			name = "chrome",
			request = "attach",
			program = "${file}",
			-- cwd = "${workspaceFolder}",
			-- protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
			-- sourceMaps = true,
			sourceMapPathOverrides = {
				-- Sourcemap override for nextjs
				["webpack://_N_E/./*"] = "${webRoot}/*",
				["webpack:///./*"] = "${webRoot}/*",
			},
		},
	}

	dap.configurations.typescriptreact = {
		{
			type = "chrome",
			request = "chrome attach",
			name = "chrome",
			program = "${file}",
			-- cwd = "${workspaceFolder}",
			-- protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
			-- sourceMaps = true,
			sourceMapPathOverrides = {
				-- Sourcemap override for nextjs
				["webpack://_N_E/./*"] = "${webRoot}/*",
				["webpack:///./*"] = "${webRoot}/*",
			},
		},
	}

	dap.configurations.javascript = {
		{
			type = "node2",
			name = "node attach",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
		},
		{
			type = "node2",
			name = "node launch",
			request = "launch",
			program = "${workspaceFolder}/${file}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			protocol = "inspector",
		},
		{
			type = "chrome",
			request = "attach",
			name = "chrome",
			program = "${file}",
			port = 9222,
			webRoot = "${workspaceFolder}",
			sourceMapPathOverrides = {
				-- Sourcemap override for nextjs
				["webpack://_N_E/./*"] = "${webRoot}/*",
				["webpack:///./*"] = "${webRoot}/*",
			},
		},
	}

	dap.configurations.javascriptreact = {
		{
			type = "chrome",
			name = "chrome attach",
			request = "attach",
			program = "${file}",
			-- cwd = vim.fn.getcwd(),
			-- sourceMaps = true,
			-- protocol = "inspector",
			port = 9222,
			sourceMapPathOverrides = {
				-- Sourcemap override for nextjs
				["webpack://_N_E/./*"] = "${webRoot}/*",
				["webpack:///./*"] = "${webRoot}/*",
			},
		},
	}

	dap.configurations.scala = {
		{
			type = "scala",
			request = "launch",
			name = "Run or Test Target",
			metals = {
				runType = "runOrTestFile",
			},
		},
		{
			type = "scala",
			request = "launch",
			name = "Test Target",
			metals = {
				runType = "testTarget",
			},
		},
	}

	lvim.builtin.dap.on_config_done = function(_)
		lvim.builtin.which_key.mappings["d"].name = " Debug"
	end
end

return M
