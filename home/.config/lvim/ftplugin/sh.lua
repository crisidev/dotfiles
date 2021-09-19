lvim.lang.sh.linters = {
	{
		exe = "shellcheck",
		-- args = {},
	},
}

lvim.lang.sh.formatters = {
	{
		exe = "shfmt",
		args = { "-i", "2", "-ci" },
	},
}
