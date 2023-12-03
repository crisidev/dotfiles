local homedir = os.getenv "HOME"
------------------------------------------
-- Spoons
------------------------------------------
hs.loadSpoon "EmmyLua"
hs.loadSpoon "MicMute"

-- Clipboard
hs.loadSpoon "TextClipboardHistory"
spoon.TextClipboardHistory.show_in_menubar = false
spoon.TextClipboardHistory:start()
spoon.TextClipboardHistory:bindHotkeys { toggle_clipboard = { { "cmd", "option" }, "h" } }

-- Teams remaps
hs.loadSpoon "AppBindings"
spoon.AppBindings:bind("Microsoft Teams (work or school)", {
    { { "ctrl" }, "i", { "ctrl" }, "r" }, -- Focus input box
    { { "ctrl" }, "k", { "shift", "fn" }, "f10" }, -- Open context menu
})

------------------------------------------
-- Variables
------------------------------------------
require "hs.ipc"
local helpers = require "helpers"
hs["helpers"] = helpers

------------------------------------------
-- Keybindings
------------------------------------------
-- Open terminals
hs.hotkey.bind({ "cmd" }, "return", function()
    os.execute(helpers.kitty_bin .. " --single-instance --instance-group=1 -d ~ &")
end)
hs.hotkey.bind({ "cmd", "option" }, "return", function()
    helpers.set_focused_screen_for_floating_windows_to_current_screen()
    os.execute(helpers.kitty_bin .. " --single-instance --instance-group=1 --title=float-term -d ~ &")
end)

-- Open neovide
hs.hotkey.bind({ "cmd", "shift" }, "e", function()
    hs.execute(homedir .. "/.bin/ide", true)
end)

-- Open finder
hs.hotkey.bind({ "ctrl" }, "space", function()
    hs.application.launchOrFocus "Finder"
end)

-- Lock screen
hs.hotkey.bind({ "cmd", "option" }, "l", function()
    hs.caffeinate.lockScreen()
end)

-- Toggle display mirror
hs.hotkey.bind({ "cmd", "shift" }, "m", function()
    os.execute(helpers.mirror_bin)
    os.execute(helpers.sketchybar_bin .. " --reload")
end)

-- Toggle mic mute
hs.hotkey.bind({ "fn" }, "f10", function()
    spoon.MicMute:toggleMicMute()
    os.execute(helpers.sketchybar_bin .. " --trigger mic_update")
end)

-- Restart yabai
hs.hotkey.bind({ "cmd", "option" }, "y", function()
    ---@diagnostic disable-next-line: undefined-field
    hs.notify.new({ title = "Hammerspoon", informativeText = "Restarting yabai" }):send()
    os.execute(helpers.yabai_bin .. " --restart-service")
end)

-- Restart hammerspoon
hs.hotkey.bind({ "cmd", "option" }, "s", function()
    ---@diagnostic disable-next-line: undefined-field
    hs.notify.new({ title = "Hammerspoon", informativeText = "Restarting hammerspoon" }):send()
    hs.reload()
end)

-- Go to sleep
hs.hotkey.bind({ "cmd", "option" }, "n", function()
    ---@diagnostic disable-next-line: undefined-field
    hs.notify.new({ title = "Hammerspoon", informativeText = "Going to sleep" }):send()
    os.execute "sleep 1"
    hs.osascript.applescript 'tell app "System Events" to sleep'
end)

-- Toggle hammerspoon debug
hs.hotkey.bind({ "cmd", "option" }, "d", function()
    helpers.set_log_level()
end)

-- Cycle all screens
hs.hotkey.bind({ "cmd", "option" }, "m", function()
    helpers.cycle_all_spaces_mission_control()
end)
-- Ensure all screen are present
hs.hotkey.bind({ "cmd", "option", "shift" }, "m", function()
    helpers.ensure_all_spaces_are_present()
end)

-- Switch between windows
hs.hotkey.bind({ "cmd" }, "`", function()
    helpers.window_switcher:next()
end)
hs.hotkey.bind({ "cmd", "shift" }, "`", function()
    helpers.window_switcher:previous()
end)

-- Toggle window fullscreen
hs.hotkey.bind({ "cmd", "shift" }, "f", function()
    helpers.yabai { "-m", "window", "--toggle", "zoom-fullscreen" }
    os.execute(helpers.sketchybar_bin .. " --trigger window_focus")
end)
-- Toggle float and center window
hs.hotkey.bind({ "cmd" }, "\\", function()
    helpers.yabai { "-m", "window", "--toggle", "float", "--grid", "4:4:1:1:2:2" }
    os.execute(helpers.sketchybar_bin .. " --trigger window_focus")
end)

-- Focus space
hs.hotkey.bind({ "cmd" }, "escape", function()
    helpers.focus_space_or_previous(1)
end)
hs.hotkey.bind({ "cmd" }, "f2", function()
    helpers.focus_space_or_previous(2)
end)
hs.hotkey.bind({ "cmd" }, "f1", function()
    helpers.focus_space_or_previous(3)
end)
hs.hotkey.bind({ "cmd" }, "f3", function()
    helpers.focus_space_or_previous(4)
end)
hs.hotkey.bind({ "cmd" }, "f4", function()
    helpers.focus_space_or_previous(5)
end)
hs.hotkey.bind({ "cmd" }, "1", function()
    helpers.focus_space_or_previous(6)
end)
hs.hotkey.bind({ "cmd" }, "2", function()
    helpers.focus_space_or_previous(7)
end)
hs.hotkey.bind({ "cmd" }, "3", function()
    helpers.focus_space_or_previous(8)
end)
hs.hotkey.bind({ "cmd" }, "4", function()
    helpers.focus_space_or_previous(9)
end)
hs.hotkey.bind({ "cmd" }, "5", function()
    helpers.focus_space_or_previous(10)
end)
-- Move to left / right space
hs.hotkey.bind({ "cmd", "ctrl" }, "left", function()
    helpers.focus_space_in_direction "left"
end)
hs.hotkey.bind({ "cmd", "ctrl" }, "right", function()
    helpers.focus_space_in_direction "right"
end)

-- Move windows to specific spaces
hs.hotkey.bind({ "cmd", "shift" }, "escape", function()
    helpers.yabai { "-m", "window", "--space", "1", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "f2", function()
    helpers.yabai { "-m", "window", "--space", "2", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "f1", function()
    helpers.yabai { "-m", "window", "--space", "3", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "f3", function()
    helpers.yabai { "-m", "window", "--space", "4", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "f4", function()
    helpers.yabai { "-m", "window", "--space", "5", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "1", function()
    helpers.yabai { "-m", "window", "--space", "6", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "2", function()
    helpers.yabai { "-m", "window", "--space", "7", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "3", function()
    helpers.yabai { "-m", "window", "--space", "8", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "4", function()
    helpers.yabai { "-m", "window", "--space", "9", "--focus" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "5", function()
    helpers.yabai { "-m", "window", "--space", "10", "--focus" }
end)

-- Move focus right / left / top / bottom
hs.hotkey.bind({ "cmd" }, "right", function()
    helpers.focus_window_or_screen "east"
end)
hs.hotkey.bind({ "cmd" }, "left", function()
    helpers.focus_window_or_screen "west"
end)
hs.hotkey.bind({ "cmd" }, "up", function()
    helpers.yabai { "-m", "window", "--focus", "north" }
end)
hs.hotkey.bind({ "cmd" }, "down", function()
    helpers.yabai { "-m", "window", "--focus", "south" }
end)

-- Swap windows
hs.hotkey.bind({ "cmd", "shift" }, "right", function()
    helpers.yabai { "-m", "window", "--swap", "east" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "left", function()
    helpers.yabai { "-m", "window", "--swap", "west" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "up", function()
    helpers.yabai { "-m", "window", "--swap", "north" }
end)
hs.hotkey.bind({ "cmd", "shift" }, "down", function()
    helpers.yabai { "-m", "window", "--swap", "south" }
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
    helpers.yabai { "-m", "space", "--balance" }
end)
