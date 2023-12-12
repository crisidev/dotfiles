-- vim: ft=lua tw=80

std = {
	globals = {
        "sbar",
        "reload",
		"CONFIG_PATH",
		"CACHE_PATH",
		"DATA_PATH",
		"TERMINAL",
		"USER",
        "C",
        "Config",
        "WORKSPACE_PATH",
        "JAVA_LS_EXECUTABLE",
        "MUtils",
        os = {fields = {"capture"}}
	},
	read_globals = {
        "sbar",
		"jit",
		"os",
	},
}

-- Don't report unused self arguments of methods.
self = false

-- Rerun tests only if their modification time changed.
cache = true

ignore = {
	"631", -- max_line_length
	"212/_.*", -- unused argument, for vars with "_" prefix
}
