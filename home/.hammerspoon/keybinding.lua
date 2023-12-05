------------------------------------------
-- Keybindings
------------------------------------------
local module = {}
local helpers = require "helpers"
local wm = require "wm"

-- Applications
module.applications = function()
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
        hs.execute(helpers.homedir .. "/.bin/ide", true)
    end)

    -- Open finder
    hs.hotkey.bind({ "ctrl" }, "space", function()
        hs.application.launchOrFocus "Finder"
    end)
end

-- Window switcher
module.windows_switcher = function()
    -- Switch between windows
    hs.hotkey.bind({ "cmd" }, "`", function()
        wm.window_switcher:next()
    end)
    hs.hotkey.bind({ "cmd", "shift" }, "`", function()
        wm.window_switcher:previous()
    end)
end

-- Handle focus changes.
module.change_focus = function()
    -- Focus space
    hs.hotkey.bind({ "cmd" }, "escape", function()
        wm.focus_space_or_previous(1)
    end)
    hs.hotkey.bind({ "cmd" }, "f2", function()
        wm.focus_space_or_previous(2)
    end)
    hs.hotkey.bind({ "cmd" }, "f1", function()
        wm.focus_space_or_previous(3)
    end)
    hs.hotkey.bind({ "cmd" }, "f3", function()
        wm.focus_space_or_previous(4)
    end)
    hs.hotkey.bind({ "cmd" }, "f4", function()
        wm.focus_space_or_previous(5)
    end)
    hs.hotkey.bind({ "cmd" }, "1", function()
        wm.focus_space_or_previous(6)
    end)
    hs.hotkey.bind({ "cmd" }, "2", function()
        wm.focus_space_or_previous(7)
    end)
    hs.hotkey.bind({ "cmd" }, "3", function()
        wm.focus_space_or_previous(8)
    end)
    hs.hotkey.bind({ "cmd" }, "4", function()
        wm.focus_space_or_previous(9)
    end)
    hs.hotkey.bind({ "cmd" }, "5", function()
        wm.focus_space_or_previous(10)
    end)
    -- Move to left / right space
    hs.hotkey.bind({ "cmd", "option", "shift" }, "left", function()
        wm.focus_space_in_direction "left"
    end)
    hs.hotkey.bind({ "cmd", "option", "shift" }, "right", function()
        wm.focus_space_in_direction "right"
    end)
    -- Move focus right / left / top / bottom
    hs.hotkey.bind({ "cmd" }, "right", function()
        wm.focus_window_or_screen "east"
    end)
    hs.hotkey.bind({ "cmd" }, "left", function()
        wm.focus_window_or_screen "west"
    end)
    hs.hotkey.bind({ "cmd" }, "up", function()
        helpers.yabai { "-m", "window", "--focus", "north" }
    end)
    hs.hotkey.bind({ "cmd" }, "down", function()
        helpers.yabai { "-m", "window", "--focus", "south" }
    end)
end

-- Move windows to specific spaces
module.move_windows = function()
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
end

-- Swap windows
module.swap_windows = function()
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
end

-- Resize windows
module.resize_windows = function()
    hs.hotkey.bind({ "cmd", "alt" }, "right", function()
        wm.resize_window("right:50:0", "left:50:0")
    end)
    hs.hotkey.bind({ "cmd", "alt" }, "left", function()
        wm.resize_window("left:-50:0", "right:-50:0")
    end)
    hs.hotkey.bind({ "cmd", "alt" }, "up", function()
        wm.resize_window("top:0:-50", "bottom:0:-50")
    end)
    hs.hotkey.bind({ "cmd", "alt" }, "down", function()
        wm.resize_window("bottom:0:50", "top:0:50")
    end)
end

-- Miscellanea
module.misc = function()
    -- Rebalance space
    hs.hotkey.bind({ "cmd", "shift" }, "return", function()
        helpers.yabai { "-m", "space", "--balance" }
    end)
    -- Toggle window fullscreen
    hs.hotkey.bind({ "cmd", "option" }, "f", function()
        helpers.yabai { "-m", "window", "--toggle", "zoom-fullscreen" }
        os.execute(helpers.sketchybar_bin .. " --trigger window_focus")
    end)
    -- Toggle float and center window
    hs.hotkey.bind({ "cmd" }, "\\", function()
        helpers.yabai { "-m", "window", "--toggle", "float", "--grid", "4:4:1:1:2:2" }
        os.execute(helpers.sketchybar_bin .. " --trigger window_focus")
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
        wm.set_log_level "wm"
    end)

    -- Cycle all screens
    hs.hotkey.bind({ "cmd", "option" }, "m", function()
        wm.ensure_all_spaces_are_present()
    end)
    -- Ensure all screen are present
    hs.hotkey.bind({ "cmd", "option", "shift" }, "m", function()
        wm.cycle_all_spaces_mission_control()
    end)
end

module.init = function()
    module.applications()
    module.windows_switcher()
    module.change_focus()
    module.move_windows()
    module.resize_windows()
    module.swap_windows()
    module.misc()
end

return module
