------------------------------------------
-- Spoons
------------------------------------------
hs.loadSpoon("EmmyLua")
hs.loadSpoon("HoldToQuit")
hs.loadSpoon("MicMute")
hs.loadSpoon("ReloadConfiguration")

spoon.HoldToQuit:start()
spoon.MicMute:bindHotkeys({ toggle = { { "fn" }, "f10" } }, 0.75)
spoon.ReloadConfiguration.watch_paths = {
	hs.configdir,
	"/Users/matteobigoi/.homesick/repos/dotfiles/home/.hammerspoon",
}
spoon.ReloadConfiguration:start()

hs.loadSpoon("TextClipboardHistory")
spoon.TextClipboardHistory.show_in_menubar = false
spoon.TextClipboardHistory:start()
spoon.TextClipboardHistory:bindHotkeys({ toggle_clipboard = { { "cmd", "option" }, "h" } })

------------------------------------------
-- Variables
------------------------------------------
local helpers = require("helpers")

------------------------------------------
-- Keybindings
------------------------------------------
-- Open applications
hs.hotkey.bind({ "cmd" }, "return", function()
	os.execute("/Applications/kitty.app/Contents/MacOS/kitty --single-instance --instance-group=1 ~ &")
end)
hs.hotkey.bind({ "cmd", "option" }, "return", function()
	os.execute(
		"/Applications/kitty.app/Contents/MacOS/kitty --single-instance --instance-group=1 --title=float-term ~ &"
	)
end)
hs.hotkey.bind({ "cmd", "shift" }, "e", function()
	hs.execute("/Users/matteobigoi/.bin/ide", true)
end)
hs.hotkey.bind({ "cmd", "option" }, "b", function()
	hs.application.launchOrFocus("Finder")
end)

-- Lock screen
hs.hotkey.bind({ "cmd", "option" }, "l", function()
	hs.caffeinate.lockScreen()
end)

-- Restart yabai
hs.hotkey.bind({ "cmd", "option" }, "y", function()
	hs.execute(helpers.yabai_bin .. " --restart-service")
end)

-- Switch windows
hs.hotkey.bind({ "cmd" }, "`", function()
	helpers.window_switcher:next()
end)
hs.hotkey.bind({ "cmd", "shift" }, "`", function()
	helpers.window_switcher:previous()
end)

-- Toggle window fullscreen
hs.hotkey.bind({ "cmd", "shift" }, "f", function()
	helpers.yabai({ "-m", "window", "--toggle", "zoom-fullscreen" })
end)
-- Toggle float and center window
hs.hotkey.bind({ "cmd" }, "\\", function()
	helpers.yabai({ "-m", "window", "--toggle", "float", "--grid", "4:4:1:1:2:2" })
end)

-- Focus space
hs.hotkey.bind({ "cmd" }, "escape", function()
	hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "escape", 0)
	helpers.focus_space_or_previous(1)
end)
hs.hotkey.bind({ "cmd" }, "f2", function()
	hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f2", 0)
	helpers.focus_space_or_previous(2)
end)
hs.hotkey.bind({ "cmd" }, "f1", function()
	hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f1", 0)
	helpers.focus_space_or_previous(3)
end)
hs.hotkey.bind({ "cmd" }, "f3", function()
	hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f3", 0)
	helpers.focus_space_or_previous(4)
end)
hs.hotkey.bind({ "cmd" }, "1", function()
	hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "1", 0)
	helpers.focus_space_or_previous(5)
end)
hs.hotkey.bind({ "cmd" }, "2", function()
	hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "2", 0)
	helpers.focus_space_or_previous(6)
end)
hs.hotkey.bind({ "cmd" }, "3", function()
	hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "3", 0)
	helpers.focus_space_or_previous(7)
end)
hs.hotkey.bind({ "cmd" }, "4", function()
	hs.eventtap.keyStroke({ "cmd", "alt", "shift" }, "4", 0)
	helpers.focus_space_or_previous(8)
end)
hs.hotkey.bind({ "cmd" }, "f4", function()
	hs.eventtap.keyStroke({ "fn", "cmd", "alt", "shift" }, "f4", 0)
	helpers.focus_space_or_previous(9)
end)

-- Move windows to specific spaces
hs.hotkey.bind({ "cmd", "shift" }, "escape", function()
	helpers.move_current_window_to_space(1)
end)
hs.hotkey.bind({ "cmd", "shift" }, "f2", function()
	helpers.move_current_window_to_space(2)
end)
hs.hotkey.bind({ "cmd", "shift" }, "f1", function()
	helpers.move_current_window_to_space(3)
end)
hs.hotkey.bind({ "cmd", "shift" }, "f3", function()
	helpers.move_current_window_to_space(4)
end)
hs.hotkey.bind({ "cmd", "shift" }, "1", function()
	helpers.move_current_window_to_space(5)
end)
hs.hotkey.bind({ "cmd", "shift" }, "2", function()
	helpers.move_current_window_to_space(6)
end)
hs.hotkey.bind({ "cmd", "shift" }, "3", function()
	helpers.move_current_window_to_space(7)
end)
hs.hotkey.bind({ "cmd", "shift" }, "4", function()
	helpers.move_current_window_to_space(8)
end)
hs.hotkey.bind({ "cmd", "shift" }, "f4", function()
	helpers.move_current_window_to_space(9)
end)

-- Move focus right / left / top / bottom
hs.hotkey.bind({ "cmd" }, "right", function()
	helpers.focus_window_or_screen("east")
end)
hs.hotkey.bind({ "cmd" }, "left", function()
	helpers.focus_window_or_screen("west")
end)
hs.hotkey.bind({ "cmd" }, "up", function()
	helpers.yabai({ "-m", "window", "--focus", "north" })
end)
hs.hotkey.bind({ "cmd" }, "down", function()
	helpers.yabai({ "-m", "window", "--focus", "south" })
end)

-- Swap windows
hs.hotkey.bind({ "cmd", "shift" }, "right", function()
	helpers.yabai({ "-m", "window", "--swap", "east" })
end)
hs.hotkey.bind({ "cmd", "shift" }, "left", function()
	helpers.yabai({ "-m", "window", "--swap", "west" })
end)
hs.hotkey.bind({ "cmd", "shift" }, "up", function()
	helpers.yabai({ "-m", "window", "--swap", "north" })
end)
hs.hotkey.bind({ "cmd", "shift" }, "down", function()
	helpers.yabai({ "-m", "window", "--swap", "south" })
end)

-- Resize windows
hs.hotkey.bind({ "cmd", "alt" }, "right", function()
	helpers.resize_window("right:50:0", "left:50:0")
end)
hs.hotkey.bind({ "cmd", "alt" }, "left", function()
	helpers.resize_window("left:-50:0", "right:-50:0")
end)
hs.hotkey.bind({ "cmd", "alt" }, "up", function()
	helpers.resize_window("top:0:-50", "bottom:0:-50")
end)
hs.hotkey.bind({ "cmd", "alt" }, "down", function()
	helpers.resize_window("bottom:0:50", "top:0:50")
end)

-- Rebalance space
hs.hotkey.bind({ "cmd", "shift" }, "return", function()
	helpers.yabai({ "-m", "space", "--rebalance" })
end)
