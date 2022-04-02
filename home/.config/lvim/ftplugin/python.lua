-- Formatting
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{
		exe = "black",
		args = { "--fast", "--line-length=120" },
		filetypes = { "python" },
	},
	{
		exe = "isort",
		args = { "--profile", "black", "-l", "120", "-m", "3", "-tc" },
		filetypes = { "python" },
	},
})

-- Linting
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{
		exe = "flake8",
		args = { "--max-line-length=120" },
		filetypes = { "python" },
	},
})

-- Debugging
if lvim.builtin.dap.active then
	local dap_install = require("dap-install")
	dap_install.config("python", {})
end

-- Lsp config
vim.list_extend(lvim.lsp.override, { "pyright" })

local opts = {
	root_dir = function(fname)
		local util = require("lspconfig.util")
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
			or util.root_pattern(".git")(fname)
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

local servers = require("nvim-lsp-installer.servers")
local server_available, requested_server = servers.get_server("pyright")
if server_available then
	opts.cmd_env = requested_server:get_default_options().cmd_env
end

require("lvim.lsp.manager").setup("pyright", opts)
