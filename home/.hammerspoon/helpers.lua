local spaces = require("hs.spaces")

------------------------------------------
-- Variables
------------------------------------------
local M = {}
M.monitor_benq = "758E5DAE-250B-4686-8171-9BEAA176F7B2"
M.monitor_macbook = "37D8832A-2D66-02CA-B9F7-8F30A301B230"
M.yabai_bin = "/Users/matteobigoi/.bin/yabai"
M.previous_space = 0
M.app_watchers = {}
M.float_windows_to_center = {
	"float-term",
	"Finder",
	"Bitwarden",
	"1Password",
	"The Unarchiver",
	"Archive Utility",
	"Activity Monitor",
	"Outlook Settings",
	"System Settings",
	"Rules",
	"AppCleaner",
	"Font Book",
	"Installer",
}

------------------------------------------
-- Helper functions
------------------------------------------
M.contains = function(set, key)
	return set[key] ~= nil
end

M.index_of = function(array, value)
	for i, v in ipairs(array) do
		if v == value then
			return i
		end
	end
	return nil
end

-- Get the list of spaces in order, independently from screens
M.get_ordered_spaces = function()
	local all_spaces = spaces.allSpaces()
	local ordered_spaces = {}
	if M.contains(all_spaces, M.monitor_benq) then
		ordered_spaces = all_spaces[M.monitor_benq]
		for _, space in pairs(all_spaces[M.monitor_macbook]) do
			table.insert(ordered_spaces, space)
		end
	else
		ordered_spaces = all_spaces[M.monitor_macbook]
	end
	return ordered_spaces
end

M.focus_space_or_previous = function(space)
	local current_space = hs.spaces.activeSpaceOnScreen()
	local ordered_spaces = M.get_ordered_spaces()
	local target_space = ordered_spaces[space]
	if M.previous_space and current_space == target_space then
		if M.previous_space == 1 then
			hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "escape", 0)
		elseif M.previous_space == 2 then
			hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f2", 0)
		elseif M.previous_space == 3 then
			hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f1", 0)
		elseif M.previous_space == 4 then
			hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f3", 0)
		elseif M.previous_space == 5 then
			hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "1", 0)
		elseif M.previous_space == 6 then
			hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "2", 0)
		elseif M.previous_space == 7 then
			hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "3", 0)
		elseif M.previous_space == 8 then
			hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "4", 0)
		elseif M.previous_space == 9 then
			hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f4", 0)
		end
	end
	M.previous_space = M.index_of(ordered_spaces, current_space)
end

-- Move windows to spaces
M.move_current_window_to_space = function(space)
	local win = hs.window.focusedWindow() -- current window
	local ordered_spaces = M.get_ordered_spaces()
	local space_id = ordered_spaces[space]
	spaces.moveWindowToSpace(win:id(), space_id)
end

-- Checks if a window belongs to a screen
M.is_in_screen = function(screen, win)
	return win:screen() == screen
end

-- Moves focus to a specific screen
M.focus_screen = function(screen)
	local windows = hs.fnutils.filter(hs.window.orderedWindows(), hs.fnutils.partial(M.is_in_screen, screen))
	local windowToFocus = #windows > 0 and windows[1] or hs.window.desktop()
	windowToFocus:focus()
end

-- Run a yabai command in background
M.yabai = function(args)
	hs.task
		.new(M.yabai_bin, nil, function()
			return true
		end, args)
		:start()
end

-- Focus a window or a screen based on a direction
M.focus_window_or_screen = function(direction)
	local args = { "-m", "window", "--focus", direction }
	hs.task
		.new(M.yabai_bin, function(exit_code)
			if exit_code == 1 then
				if direction == "east" then
					M.focus_screen(hs.window.focusedWindow():screen():next())
				end
				if direction == "west" then
					M.focus_screen(hs.window.focusedWindow():screen():previous())
				end
			end
		end, function()
			return true
		end, args)
		:start()
end

-- Focus a window or a screen based on a direction
M.resize_window = function(direction1, direction2)
	local args = { "-m", "window", "--resize", direction1 }
	hs.task
		.new(M.yabai_bin, function(exit_code)
			if exit_code == 1 then
				M.yabai({ "-m", "window", "--resize", direction2 })
			end
		end, function()
			return true
		end, args)
		:start()
end

-- Housekeeping for launched and terminated apps with their watchers
M.handle_global_event = function(_, event, app)
	if event == hs.application.watcher.launched then
		M.watch_app(app)
	elseif event == hs.application.watcher.terminated then
		-- Clean up
		local app_watcher = M.app_watchers[app:pid()]
		if app_watcher then
			app_watcher.watcher:stop()
			local windows = app_watcher.windows
			if windows then
				for _, watcher in pairs(app_watcher.windows) do
					watcher:stop()
				end
			end
			M.app_watchers[app:pid()] = nil
		end
	end
end

-- Handle any window event
M.handle_window_event = function(element, _, _, _)
	if hs.uielement.watcher.focusedWindowChanged then
		if element then
			local application = element:application()
			if application then
				local app_name = application:title()
				local window_title = element:title()
				local window = element:application():focusedWindow()
				if window then
					for _, title in pairs(M.float_windows_to_center) do
						if window_title and app_name and window_title == title or app_name == title then
							window:centerOnScreen(nil, true, 0)
						end
					end
				end
			end
		end
	end
end

-- Add a watcher for a new app
M.watch_app = function(app)
	if M.app_watchers[app:pid()] then
		return
	end

	local watcher = app:newWatcher(M.handle_window_event)
	M.app_watchers[app:pid()] = {
		watcher = watcher,
	}

	watcher:start({ hs.uielement.watcher.focusedWindowChanged })
end

-- Attatch all existing apps during startup
M.attach_existing_apps = function()
	local apps = hs.application.runningApplications()
	apps = hs.fnutils.filter(apps, function(app)
		return app:title() ~= "Hammerspoon"
	end)
	hs.fnutils.each(apps, function(app)
		M.watch_app(app)
	end)
end

-- Include minimized/hidden windows, current Space only
M.window_switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter({}))
M.window_switcher.ui.showTitles = false
M.window_switcher.ui.showThumbnails = false
M.window_switcher.ui.showSelectedThumbnail = false
M.window_switcher.ui.showSelectedTitle = false

-- Watch for application events
M.app_watcher = hs.application.watcher.new(M.handle_global_event):start()
M.attach_existing_apps()

return M
