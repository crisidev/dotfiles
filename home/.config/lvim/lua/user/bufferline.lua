local M = {}
M.config = function()
	local kind = require("user.lsp")
	local List = require("plenary.collections.py_list")
	lvim.builtin.bufferline.options.diagnostics_indicator = function(_, _, diagnostics)
		local result = {}
		local symbols = { error = kind.icons.error, warning = kind.icons.warn, info = kind.icons.info }
		for name, count in pairs(diagnostics) do
			if symbols[name] and count > 0 then
				table.insert(result, symbols[name] .. count)
			end
		end
		result = table.concat(result, " ")
		return #result > 0 and result or ""
	end

	lvim.builtin.bufferline.options.groups = {
		options = {
			toggle_hidden_on_enter = true,
		},
		items = {
			{ name = "ungrouped" },
			M.language_files("rust", "#FF6965", "rs"),
			M.language_files("python", "#006400", "py"),
			M.language_files("kotlin", "#966fd6", "kt"),
			M.language_files("ruby", "#FF6965", "rb"),
			{
				highlight = { guisp = "#51AFEF" },
				name = "tests",
				icon = kind.icons.test,
				matcher = function(buf)
					return buf.filename:match("_spec") or buf.filename:match("test")
				end,
			},
			{
				highlight = { guisp = "#C678DD" },
				name = "docs",
				matcher = function(buf)
					local list = List({ "md", "org", "norg", "wiki" })
					return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
				end,
			},
			{
				highlight = { guisp = "#F6A878" },
				name = "config",
				matcher = function(buf)
					return buf.filename:match("go.mod")
						or buf.filename:match("go.sum")
						or buf.filename:match("Cargo.toml")
						or buf.filename:match("manage.py")
						or buf.filename:match("config.toml")
						or buf.filename:match("setup.py")
						or buf.filename:match("Makefile")
						or buf.filename:match("Config")
						or buf.filename:match("gradle.properties")
						or buf.filename:match("build.gradle.kts")
						or buf.filename:match("setting.gradle.kts")
				end,
			},
		},
	}
	lvim.builtin.bufferline.options.separator_style = os.getenv("KITTY_WINDOW_ID") and "slant" or "thin"
	lvim.builtin.bufferline.options.mode = "buffers"
	lvim.builtin.bufferline.options.sort_by = "insert_after_current"
end

M.language_files = function(name, guisp, extension)
	local opts = {
		highlight = { guisp = guisp },
		name = name,
		matcher = function(buf)
			return vim.fn.fnamemodify(buf.path, ":e") == extension
		end,
	}
	return opts
end

return M
