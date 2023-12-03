------------------------------------------
-- Variables
------------------------------------------
local homedir = os.getenv "HOME"
local M = {}

M.yabai_bin = "/opt/homebrew/bin/yabai"
M.sketchybar_bin = "/opt/homebrew/bin/sketchybar"
M.mirror_bin = "/opt/homebrew/bin/mirror"
M.kitty_bin = "/Applications/kitty.app/Contents/MacOS/kitty"
M.previous_space = 1
M.app_watchers = {}
M.windows_configuration_file = homedir .. "/.config/yabai/windows.json"
M.windows_configuration = {}
M.focused_screen_for_floating_windows = nil
M.all_spaces = hs.spaces.allSpaces()
M.all_spaces_length = 0
M.ordered_spaces = {}
M.screen_main = hs.screen.primaryScreen():getUUID()
M.screen_other = nil
M.log = hs.logger.new("helpers", "info")

------------------------------------------
-- Helper functions
------------------------------------------
M.file_exists = function(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

M.set_log_level = function(level)
    if level then
        M.log.setLogLevel(level)
        ---@diagnostic disable-next-line: undefined-field
        hs.notify.new({ title = "Hammerspoon", informativeText = "Log level set to " .. level }):send()
        return
    end
    if M.log.getLogLevel() == 3 then
        ---@diagnostic disable-next-line: undefined-field
        hs.notify.new({ title = "Hammerspoon", informativeText = "Setting log level to debug" }):send()
        M.log.w "setting log level to debug"
        M.log.setLogLevel "debug"
        hs.openConsole()
    else
        ---@diagnostic disable-next-line: undefined-field
        hs.notify.new({ title = "Hammerspoon", informativeText = "Setting log level to info" }):send()
        M.log.w "setting log level to info"
        M.log.setLogLevel "info"
        hs.closeConsole()
    end
end

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

M.length = function(set)
    local c = 0
    for _, _ in pairs(set) do
        c = c + 1
    end
    return c
end

-- Run a yabai command in background
M.yabai = function(args)
    M.log.df("yabai(): running yabai with arguments %s", hs.inspect.inspect(args))
    hs.task
        .new(M.yabai_bin, nil, function()
            return true
        end, args)
        :start()
        :waitUntilExit()
end

------------------------------------------
-- Windows management functions
------------------------------------------
-- Get the list of spaces in order, independently from screens
M.get_ordered_spaces = function()
    local ordered_spaces = {}
    M.log.vf("get_ordered_spaces(): all spaces %s", hs.inspect.inspect(M.all_spaces))
    if M.all_spaces then
        -- Main screen first
        local spaces_main = M.all_spaces[M.screen_main]
        if spaces_main then
            for _, space in pairs(spaces_main) do
                table.insert(ordered_spaces, space)
            end
        end
        for screen, spaces in pairs(M.all_spaces) do
            if screen ~= M.screen_main then
                for _, space in pairs(spaces) do
                    table.insert(ordered_spaces, space)
                end
            end
        end
    end
    M.log.vf("get_ordered_spaces(): ordered spaces %s", hs.inspect.inspect(ordered_spaces))
    return ordered_spaces
end

-- Find the secondary screen.
M.find_other_screen = function()
    if M.all_spaces_length > 1 then
        for screen, _ in pairs(M.all_spaces) do
            if screen ~= M.screen_main then
                return screen
            end
        end
        return nil
    else
        return nil
    end
end

-- Update the cached objects
M.update_cache = function()
    M.all_spaces = hs.spaces.allSpaces()
    M.all_spaces_length = M.length(M.all_spaces)
    M.ordered_spaces = M.get_ordered_spaces()
    M.ordered_spaces_length = M.length(M.ordered_spaces)
    M.screen_main = hs.screen.primaryScreen():getUUID()
    M.screen_other = M.find_other_screen()
end

-- Check if a space is already visible
M.is_space_already_visible = function(active_spaces, space)
    for _, value in pairs(active_spaces) do
        if value == space then
            M.log.df("is_space_already_visible(): mission control space id %d is already visible", space)
            return true
        end
    end
    M.log.df("is_space_already_visible(): mission control space id %d is not already visible", space)
    return false
end

-- Focus a space
M.focus_space = function(space)
    local space_id = M.ordered_spaces[space]
    M.log.df("focus_space(): focusing space %d [%d] using mission control keybinds", space, space_id)
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
    local target_space = M.ordered_spaces[space]
    M.log.vf(
        "focus_space_or_previous(): ordered_spaces %s, current_space: %d, target_space: %d, previous_space: %d",
        hs.inspect.inspect(M.ordered_spaces),
        current_space,
        target_space,
        M.previous_space
    )
    if current_space == target_space then
        if M.is_space_already_visible(hs.spaces.activeSpaces(), M.ordered_spaces[M.previous_space]) then
            M.log.df "focus_space_or_previous(): current space equal to target space and target space already visible"
            M.focus_space_or_screen(M.previous_space)
        else
            M.log.df "focus_space_or_previous(): current space equal to target space"
            M.focus_space(M.previous_space)
        end
    else
        if M.is_space_already_visible(hs.spaces.activeSpaces(), M.ordered_spaces[space]) then
            M.log.df "focus_space_or_previous(): current space not equal to target space and target space already visible"
            M.focus_space_or_screen(space)
        else
            M.log.df "focus_space_or_previous(): current space not equal to target space"
            M.focus_space(space)
        end
    end
    local current_space_id = M.index_of(M.ordered_spaces, current_space)
    M.log.df(
        "focus_space_or_previous(): storing current space %d [%d] as previous space",
        current_space_id,
        current_space
    )
    M.previous_space = current_space_id
end

-- Focus a space in a specific direction
M.focus_space_in_direction = function(direction)
    local current_space = hs.spaces.focusedSpace()
    local index = M.index_of(M.ordered_spaces, current_space)
    local go_to = 1
    if direction == "left" then
        if index - 1 < 1 then
            go_to = M.ordered_spaces[M.ordered_spaces_length]
        else
            go_to = M.ordered_spaces[index - 1]
        end
    elseif direction == "right" then
        if index + 1 > M.ordered_spaces_length then
            go_to = M.ordered_spaces[1]
        else
            go_to = M.ordered_spaces[index + 1]
        end
    end
    M.log.df("focus_space_in_direction(): focusing space %d [%d] in direction %s", index, go_to, direction)
    hs.spaces.gotoSpace(go_to)
end

-- Helper function to add or remove spaces
M.add_or_remove_spaces = function(spaces, spaces_per_display, screen)
    if spaces then
        local spaces_len = M.length(spaces)
        if spaces_per_display > spaces_len then
            for _ = 1, spaces_per_display - spaces_len do
                M.log.df(
                    "add_or_remove_spaces(): %d spaces on main display is less than %d spaces, adding space to display %s",
                    spaces_len,
                    spaces_per_display,
                    screen
                )
                hs.spaces.addSpaceToScreen(screen, true)
            end
        elseif spaces_per_display < spaces_len then
            for i = #spaces, 1, -1 do
                M.log.df(
                    "add_or_remove_spaces(): %d spaces on main display is more than %d spaces, removing space from display %s",
                    spaces_len,
                    spaces_per_display,
                    screen
                )
                if i > spaces_per_display then
                    hs.spaces.removeSpace(spaces[i], true)
                end
            end
        end
    end
end

-- Ensure all spaces are present
M.ensure_all_spaces_are_present = function()
    M.update_cache()
    -- 2 monitors
    if M.all_spaces_length > 1 then
        local spaces_per_display = 5
        local main_spaces = M.all_spaces[M.screen_main]
        if main_spaces then
            M.add_or_remove_spaces(main_spaces, spaces_per_display, M.screen_main)
        end
        for screen, spaces in pairs(M.all_spaces) do
            if screen ~= M.screen_main then
                M.add_or_remove_spaces(spaces, spaces_per_display, screen)
            end
        end
    else
        local spaces_per_display = 10
        local main_spaces = hs.spaces.spacesForScreen()
        M.add_or_remove_spaces(main_spaces, spaces_per_display, hs.screen.mainScreen():getUUID())
    end
    M.update_cache()
    os.execute(M.sketchybar_bin .. " --reload")
end

-- Cycle all mission control spaces
M.cycle_all_spaces_mission_control = function()
    local current_space = hs.spaces.focusedSpace()
    for i = 1, 10 do
        M.focus_space(i)
        os.execute "sleep 0.3"
    end
    M.focus_space(M.index_of(M.ordered_spaces, current_space))
end

-- Checks if a window belongs to a screen
M.is_in_screen = function(screen, win)
    return win:screen() == screen
end

-- Moves focus to a specific screen
M.focus_screen = function(screen)
    local windows = hs.fnutils.filter(hs.window.orderedWindows(), hs.fnutils.partial(M.is_in_screen, screen))
    if windows then
        local window_to_focus = #windows > 0 and windows[1] or hs.window.desktop()
        window_to_focus:focus()
    end
end

-- Focus a specific screen if the space is already visible
M.focus_space_or_screen = function(space)
    if M.all_spaces_length then
        local other_screen = M.find_other_screen()
        local other_space_mission_control_id = hs.spaces.activeSpaceOnScreen(other_screen)
        local other_space = M.index_of(M.ordered_spaces, other_space_mission_control_id)
        M.log.df("focus_space_or_screen(): target space %d, other space %d", space, other_space)
        if space == other_space then
            M.yabai { "-m", "display", "--focus", "2" }
        else
            M.yabai { "-m", "display", "--focus", "1" }
        end
    end
end

-- Focus a window or a screen based on a direction
M.focus_window_or_screen = function(direction)
    local args = { "-m", "window", "--focus", direction }
    M.log.df("focus_window_or_screen(): running yabai with arguments %s", hs.inspect.inspect(args))
    hs.task
        .new(M.yabai_bin, function(exit_code)
            if exit_code == 1 then
                if direction == "east" then
                    M.log.df "focus_window_or_screen(): reached edge of current screen, focusing next screen"
                    if M.all_spaces_length > 1 then
                        M.focus_screen(hs.window.focusedWindow():screen():next())
                    else
                        M.focus_space_in_direction "right"
                    end
                end
                if direction == "west" then
                    M.log.df "focus_window_or_screen(): reached edge of current screen, focusing previous screen"
                    if M.all_spaces_length > 1 then
                        M.focus_screen(hs.window.focusedWindow():screen():previous())
                    else
                        M.focus_space_in_direction "left"
                    end
                end
            end
        end, function()
            return true
        end, args)
        :start()
        :waitUntilExit()
end

-- Focus a window or a screen based on a direction
M.resize_window = function(direction1, direction2)
    local args = { "-m", "window", "--resize", direction1 }
    M.log.df("resize_window(): running yabai with arguments %s", hs.inspect.inspect(args))
    hs.task
        .new(M.yabai_bin, function(exit_code)
            if exit_code == 1 then
                M.yabai { "-m", "window", "--resize", direction2 }
            end
        end, function()
            return true
        end, args)
        :start()
        :waitUntilExit()
end

------------------------------------------
-- Float windows handling
------------------------------------------
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
    ---@diagnostic disable-next-line: undefined-field
    if hs.uielement.watcher.windowCreated then
        if element and element["application"] then
            local application = element:application()
            M.log.df("handle_window_event(): found application %s", application)
            if application then
                local app_name = application:title()
                local window_title = element:title()
                M.log.df(
                    "handle_window_event(): found window for app %s with title %s, id: %s",
                    app_name,
                    window_title,
                    element:id()
                )
                -- Handle Outlook reminders
                if app_name == "Microsoft Outlook" and window_title:find " Reminder" then
                    M.log.df "handle_window_event(): outlook reminder window created, focusing it now"
                    M.yabai { "-m", "window", "--focus", tostring(element:id()) }
                    return
                end
                local window = element:application():focusedWindow()
                if window then
                    -- App only
                    for app, manage in pairs(M.windows_configuration.apps) do
                        if app_name and app_name == app and manage == true then
                            M.log.df("handle_window_event(): centering window for app %s", app_name)
                            window:centerOnScreen(M.focused_screen_for_floating_windows, true, 0)
                            os.execute(M.sketchybar_bin .. " --trigger window_focus")
                            return
                        end
                    end
                    -- Title only
                    for title, manage in pairs(M.windows_configuration.titles) do
                        if window_title and (window_title == title or window_title:find(title)) and manage == true then
                            M.log.df(
                                "handle_window_event(): centering window for app %s, title %s",
                                app_name,
                                window_title
                            )
                            window:centerOnScreen(M.focused_screen_for_floating_windows, true, 0)
                            os.execute(M.sketchybar_bin .. " --trigger window_focus")
                            return
                        end
                    end
                    -- App and title
                    for app, config in pairs(M.windows_configuration.apps_and_titles) do
                        for _, title in pairs(config.titles) do
                            if
                                app
                                and window_title
                                and app_name == app
                                and (window_title == title or window_title:find(title))
                                and config.manage == true
                            then
                                M.log.df(
                                    "handle_window_event(): centering window for app %s, title %s",
                                    app_name,
                                    window_title
                                )
                                window:centerOnScreen(M.focused_screen_for_floating_windows, true, 0)
                                os.execute(M.sketchybar_bin .. " --trigger window_focus")
                                return
                            end
                        end
                    end
                end
            end
        end
        M.focused_screen_for_floating_windows = nil
    end
end

M.set_focused_screen_for_floating_windows_to_current_screen = function()
    M.focused_screen_for_floating_windows = hs.screen.mainScreen()
end

-- Add a watcher for a new app
M.watch_app = function(app)
    if M.app_watchers[app:pid()] or app:name() == "Microsoft Outlook Web Content" or app:kind() ~= 1 then
        return
    end

    M.log.df("watch_app(): starting application watcher for %s, kind: %s", app:name(), app:kind())
    local watcher = app:newWatcher(M.handle_window_event)
    M.app_watchers[app:pid()] = {
        watcher = watcher,
    }

    ---@diagnostic disable-next-line: undefined-field
    watcher:start { hs.uielement.watcher.windowCreated }
    M.log.df("watch_app(): application whatcher for %s started", app:name())
end

-- Attatch all existing apps during startup
M.attach_existing_apps = function()
    local apps = hs.application.runningApplications()
    ---@diagnostic disable-next-line: cast-local-type
    hs.fnutils.each(apps, function(app)
        M.watch_app(app)
    end)
end

------------------------------------------
-- Beachballers
------------------------------------------
-- Find any application causing Hammerspoon to beachball
M.find_beachballers = function()
    ---@diagnostic disable-next-line: undefined-field
    local timed_apps = hs.window._timed_allWindows()
    for name, time in pairs(timed_apps) do
        if time > 1.0 then
            M.log.ef("application %s is slow: %f", name, time)
            hs
                .notify
                .new({ title = "Hammerspoon", informativeText = "Found beachballing application: " .. name })
                ---@diagnostic disable-next-line: undefined-field
                :send()
        end
    end
end

------------------------------------------
-- Main
------------------------------------------
-- Setup mission control wait time
hs.spaces.MCwaitTime = 0.3

-- Include minimized/hidden windows, current Space only
M.window_switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter {})
M.window_switcher.ui.showTitles = false
M.window_switcher.ui.showThumbnails = false
M.window_switcher.ui.showSelectedThumbnail = false
M.window_switcher.ui.showSelectedTitle = false

-- Watch for application events
if M.file_exists(M.windows_configuration_file) then
    M.windows_configuration = hs.json.read(M.windows_configuration_file)
    M.app_watcher = hs.application.watcher.new(M.handle_global_event):start()
    M.attach_existing_apps()
end

-- Update cache on startup
M.update_cache()
M.log.f("started hammerspoon with ordered spaces %s", hs.inspect.inspect(M.ordered_spaces))
M.log.f("watching for float applications and windows configuration: %s", hs.inspect.inspect(M.windows_configuration))
M.log.f("there are %s application watchers", M.length(M.app_watchers))
hs
    .notify
    .new({
        title = "Hammerspoon",
        informativeText = "Started hammerspoon with ordered spaces " .. hs.inspect.inspect(M.ordered_spaces),
    })
    ---@diagnostic disable-next-line: undefined-field
    :send()

return M
