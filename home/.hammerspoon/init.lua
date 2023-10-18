------------------------------------------
-- Variables
------------------------------------------
local M = {}
local spaces = require("hs.spaces")
local monitor_benq = "758E5DAE-250B-4686-8171-9BEAA176F7B2"
local monitor_macbook = "37D8832A-2D66-02CA-B9F7-8F30A301B230"
local yabai_bin = "/opt/homebrew/bin/yabai"

------------------------------------------
-- Helper functions
------------------------------------------
M.contains = function(set, key)
	return set[key] ~= nil
end

-- Get the list of spaces in order, independently from screens
M.get_ordered_spaces = function()
	local all_spaces = spaces.allSpaces()
	local ordered_spaces = {}
	if M.contains(all_spaces, monitor_benq) then
		ordered_spaces = all_spaces[monitor_benq]
		for _, space in pairs(all_spaces[monitor_macbook]) do
			table.insert(ordered_spaces, space)
		end
	else
		ordered_spaces = all_spaces[monitor_macbook]
	end
	return ordered_spaces
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
		.new(yabai_bin, nil, function(...)
			return true
		end, args)
		:start()
end

-- Focus a window or a screen based on a direction
M.focus_window_or_screen = function(direction)
	local args = { "-m", "window", "--focus", direction }
	hs.task
		.new(yabai_bin, function(exit_code, ...)
			if exit_code == 1 then
				if direction == "east" then
					M.focus_screen(hs.window.focusedWindow():screen():next())
				end
				if direction == "west" then
					M.focus_screen(hs.window.focusedWindow():screen():previous())
				end
			end
		end, function(...)
			return true
		end, args)
		:start()
end

-- Focus a window or a screen based on a direction
M.resize_window = function(direction1, direction2)
	local args = { "-m", "window", "--resize", direction1 }
	hs.task
		.new(yabai_bin, function(exit_code, ...)
			if exit_code == 1 then
                local args = { "-m", "window", "--resize", direction2 }
				M.yabai(args)
			end
		end, function(...)
			return true
		end, args)
		:start()
end

-- Include minimized/hidden windows, current Space only
local window_switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter({}))
window_switcher.ui.showTitles = false
window_switcher.ui.showThumbnails = false
window_switcher.ui.showSelectedThumbnail = false
window_switcher.ui.showSelectedTitle = false

------------------------------------------
-- Keybindings
------------------------------------------
-- Open applications
hs.hotkey.bind({ "cmd" }, "return", function()
	os.execute("/Applications/kitty.app/Contents/MacOS/kitty --single-instance --instance-group=1 ~ &")
end)
hs.hotkey.bind({ "cmd", "shift" }, "return", function()
	os.execute(
		"/Applications/kitty.app/Contents/MacOS/kitty --single-instance --instance-group=1 --title=float-term ~ &"
	)
	os.execute("sleep " .. tonumber(0.2))
	M.yabai({ "-m", "window", "--grid", "4:4:1:1:2:2" })
end)
hs.hotkey.bind({ "cmd", "shift" }, "e", function()
	hs.execute("bash ~/.bin/ide")
end)
hs.hotkey.bind({ "cmd", "shift" }, "b", function()
	hs.application.launchOrFocus("Finder")
end)

-- Switch windows
hs.hotkey.bind({ "cmd" }, "`", function()
	window_switcher:next()
end)
hs.hotkey.bind({ "cmd", "shift" }, "`", function()
	window_switcher:previous()
end)

-- Toggle window fullscreen
hs.hotkey.bind({ "cmd", "shift" }, "f", function()
	M.yabai({ "-m", "window", "--toggle", "zoom-fullscreen" })
end)
-- Toggle float and center window
hs.hotkey.bind({ "cmd" }, "\\", function()
	M.yabai({ "-m", "window", "--toggle", "float" })
	os.execute("sleep " .. tonumber(0.2))
	M.yabai({ "-m", "window", "--grid", "4:4:1:1:2:2" })
end)

-- Move windows to specific spaces
hs.hotkey.bind({ "cmd", "shift" }, "escape", function()
	M.move_current_window_to_space(1)
end)
hs.hotkey.bind({ "cmd", "shift" }, "F2", function()
	M.move_current_window_to_space(2)
end)
hs.hotkey.bind({ "cmd", "shift" }, "F1", function()
	M.move_current_window_to_space(3)
end)
hs.hotkey.bind({ "cmd", "shift" }, "F3", function()
	M.move_current_window_to_space(4)
end)
hs.hotkey.bind({ "cmd", "shift" }, "1", function()
	M.move_current_window_to_space(5)
end)
hs.hotkey.bind({ "cmd", "shift" }, "2", function()
	M.move_current_window_to_space(6)
end)
hs.hotkey.bind({ "cmd", "shift" }, "3", function()
	M.move_current_window_to_space(7)
end)
hs.hotkey.bind({ "cmd", "shift" }, "4", function()
	M.move_current_window_to_space(8)
end)
hs.hotkey.bind({ "cmd", "shift" }, "F4", function()
	M.move_current_window_to_space(9)
end)

-- Move focus right / left / top / bottom
hs.hotkey.bind({ "cmd" }, "right", function()
	M.focus_window_or_screen("east")
end)
hs.hotkey.bind({ "cmd" }, "left", function()
	M.focus_window_or_screen("west")
end)
hs.hotkey.bind({ "cmd" }, "up", function()
	M.yabai({ "-m", "window", "--focus", "north" })
end)
hs.hotkey.bind({ "cmd" }, "down", function()
	M.yabai({ "-m", "window", "--focus", "south" })
end)

-- Swap windows
hs.hotkey.bind({ "cmd", "shift" }, "right", function()
	M.yabai({ "-m", "window", "--swap", "east" })
end)
hs.hotkey.bind({ "cmd", "shift" }, "left", function()
	M.yabai({ "-m", "window", "--swap", "west" })
end)
hs.hotkey.bind({ "cmd", "shift" }, "up", function()
	M.yabai({ "-m", "window", "--swap", "north" })
end)
hs.hotkey.bind({ "cmd", "shift" }, "down", function()
	M.yabai({ "-m", "window", "--swap", "south" })
end)

-- Resize windows
hs.hotkey.bind({ "cmd", "alt" }, "right", function()
	M.resize_window("right:50:0", "left:50:0")
end)
hs.hotkey.bind({ "cmd", "alt" }, "left", function()
	M.resize_window("left:-50:0", "right:-50:0")
end)
hs.hotkey.bind({ "cmd", "alt" }, "up", function()
	M.resize_window("top:0:-50", "bottom:0:-50")
end)
hs.hotkey.bind({ "cmd", "alt" }, "down", function()
	M.resize_window("bottom:0:50", "top:0:50")
end)
