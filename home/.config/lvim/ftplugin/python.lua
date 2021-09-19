lvim.lang.python.linters = {
	{
		exe = "flake8",
		args = { "--max-line-length=120" },
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
	local dap_install = require("dap-install")
	dap_install.config("python", {})
end
