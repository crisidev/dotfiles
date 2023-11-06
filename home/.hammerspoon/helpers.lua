------------------------------------------
-- Variables
------------------------------------------
local homedir = os.getenv("HOME")
local M = {}
M.screen_macbook = "37D8832A-2D66-02CA-B9F7-8F30A301B230"
M.yabai_bin = homedir .. "/.bin/yabai"
M.sketchybar_bin = "/opt/homebrew/bin/sketchybar"
M.previous_space = 1
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
	"Company Portal",
	"AppCleaner",
	"Font Book",
	"Installer",
	"Color Picker",
	"Stats",
	"Weather",
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

function M.length(set)
	local c = 0
	for _, _ in pairs(set) do
		c = c + 1
	end
	return c
end

-- Get the list of spaces in order, independently from screens
M.get_ordered_spaces = function()
	local ordered_spaces = {}
	local all_spaces = hs.spaces.allSpaces()
	if all_spaces then
		for _, values in pairs(all_spaces) do
			for _, value in pairs(values) do
				table.insert(ordered_spaces, value)
			end
		end
	end
	return ordered_spaces
end

-- Check if a space is already visible
M.is_space_already_visible = function(active_spaces, space)
	for _, value in pairs(active_spaces) do
		if value == space then
			return true
		end
	end
	return false
end

-- Focus a space
M.focus_space = function(space)
	if space == 1 then
		hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "escape", 0)
	elseif space == 2 then
		hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f2", 0)
	elseif space == 3 then
		hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f1", 0)
	elseif space == 4 then
		hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f3", 0)
	elseif space == 5 then
		hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f4", 0)
	elseif space == 6 then
		hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "1", 0)
	elseif space == 7 then
		hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "2", 0)
	elseif space == 8 then
		hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "3", 0)
	elseif space == 9 then
		hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "4", 0)
	elseif space == 10 then
		hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "5", 0)
	else
		return nil
	end
end

-- Focus a specific space of the previous one if we are already on the target space
M.focus_space_or_previous = function(space)
	local current_space = hs.spaces.focusedSpace()
	local ordered_spaces = M.get_ordered_spaces()
	local target_space = ordered_spaces[space]
	if M.previous_space and current_space == target_space then
		if M.is_space_already_visible(hs.spaces.activeSpaces(), ordered_spaces[M.previous_space]) then
			M.focus_space_or_screen(M.previous_space)
			M.previous_space = M.index_of(ordered_spaces, current_space)
			return nil
		end
		M.focus_space(M.previous_space)
	else
		M.focus_space(space)
	end
	M.previous_space = M.index_of(ordered_spaces, current_space)
	M.focus_space_or_screen(space)
end

-- Focus a space in a specific direction
M.focus_space_in_direction = function(direction)
	local ordered_spaces = M.get_ordered_spaces()
	local ordered_spaces_length = M.length(ordered_spaces)
	local current_space = hs.spaces.focusedSpace()
	local index = M.index_of(ordered_spaces, current_space)
	local go_to = 1
	if direction == "left" then
		if index - 1 < 1 then
			go_to = ordered_spaces[ordered_spaces_length]
		else
			go_to = ordered_spaces[index - 1]
		end
	elseif direction == "right" then
		if index + 1 > ordered_spaces_length then
			go_to = ordered_spaces[1]
		else
			go_to = ordered_spaces[index + 1]
		end
	end
	hs.spaces.gotoSpace(go_to)
end

-- Ensure all spaces are present
M.ensure_all_spaces_are_present = function()
	-- 2 monitors
	if M.length(hs.spaces.allSpaces()) > 1 then
		local spaces_per_display = 5
		local main_spaces = hs.spaces.spacesForScreen()
		local main_spaces_len = M.length(main_spaces)
		if spaces_per_display > main_spaces_len then
			for i = 1, spaces_per_display - main_spaces_len do
                hs.spaces.addSpaceToScreen(hs.screen.mainScreen(), true)
			end
		elseif spaces_per_display < main_spaces_len then
			for i = #main_spaces, 1, -1 do
                if i > spaces_per_display then
                    hs.spaces.removeSpace(main_spaces[i], true)
                end
			end
		end
		local macbook_spaces = hs.spaces.spacesForScreen(M.screen_macbook)
        local macbook_spaces_len = M.length(macbook_spaces)
		if spaces_per_display > macbook_spaces_len then
			for i = 1, spaces_per_display - macbook_spaces_len do
                hs.spaces.addSpaceToScreen(M.screen_macbook, true)
			end
		elseif spaces_per_display < macbook_spaces_len then
			for i = #macbook_spaces, 1, -1 do
                if i > spaces_per_display then
                    hs.spaces.removeSpace(macbook_spaces[i], true)
                end
			end
		end
    -- 1 monitor
	else
		local spaces_per_display = 10
		local main_spaces = hs.spaces.spacesForScreen()
		local main_spaces_len = M.length(main_spaces)
		if spaces_per_display > main_spaces_len then
			for i = 1, spaces_per_display - main_spaces_len do
                hs.spaces.addSpaceToScreen(hs.screen.mainScreen(), true)
			end
		elseif spaces_per_display < main_spaces_len then
			for i = #main_spaces, 1, -1 do
                if i > spaces_per_display then
                    hs.spaces.removeSpace(main_spaces[i], true)
                end
			end
		end
	end
end

M.focus_space_mission_control = function(space)
	local ordered_spaces = M.get_ordered_spaces()
	local target_space = ordered_spaces[space]
	hs.spaces.gotoSpace(target_space)
end

-- Move windows to spaces
M.move_current_window_to_space = function(space)
	local win = hs.window.focusedWindow() -- current window
	local ordered_spaces = M.get_ordered_spaces()
	local space_id = ordered_spaces[space]
	hs.spaces.moveWindowToSpace(win:id(), space_id)
end

-- Cycle all mission control spaces
M.cycle_all_spaces_mission_control = function()
	local current_space = hs.spaces.focusedSpace()
	for i = 1, 10 do
		M.focus_space(i)
		os.execute("sleep 0.3")
	end
	M.focus_space(M.index_of(M.get_ordered_spaces(), current_space))
end

-- Checks if a window belongs to a screen
M.is_in_screen = function(screen, win)
	return win:screen() == screen
end

-- Moves focus to a specific screen
M.focus_screen = function(screen)
	local windows = hs.fnutils.filter(hs.window.orderedWindows(), hs.fnutils.partial(M.is_in_screen, screen))
	local window_to_focus = #windows > 0 and windows[1] or hs.window.desktop()
	window_to_focus:focus()
end

-- Focus a specific screen if the space is already visible
M.focus_space_or_screen = function(space)
	if M.length(hs.spaces.allSpaces()) > 1 then
		local ordered_spaces = M.get_ordered_spaces()
		local macbook_space_mission_control_id = hs.spaces.activeSpaceOnScreen(M.screen_macbook)
		local macbook_space = M.index_of(ordered_spaces, macbook_space_mission_control_id)
		if space == macbook_space then
			M.yabai({ "-m", "display", "--focus", "2" })
		else
			M.yabai({ "-m", "display", "--focus", "1" })
		end
	end
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
		if element and element["application"] then
			local application = element:application()
			if application then
				local app_name = application:title()
				local window_title = element:title()
				local window = element:application():focusedWindow()
				if window then
					for _, title in pairs(M.float_windows_to_center) do
						if window_title and app_name and window_title == title or app_name == title then
							window:centerOnScreen(nil, true, 0)
							hs.execute("/opt/homebrew/bin/sketchybar --trigger window_focus", false)
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
