------------------------------------------
-- Variables
------------------------------------------
local homedir = os.getenv("HOME")
local M = {}

M.screen_macbook = "37D8832A-2D66-02CA-B9F7-8F30A301B230"
M.yabai_bin = "/opt/homebrew/bin/yabai"
M.sketchybar_bin = "/opt/homebrew/bin/sketchybar"
M.previous_space = 1
M.app_watchers = {}
M.windows_configuration_file = homedir .. "/.config/yabai/windows.json"
M.windows_configuration = {}
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
        hs.notify.new({ title = "Hammerspoon", informativeText = "Log level set to " .. level }):send()
        return
    end
    if M.log.getLogLevel() == 3 then
        hs.notify.new({ title = "Hammerspoon", informativeText = "Setting log level to debug" }):send()
        M.log.w("setting log level to debug")
        M.log.setLogLevel("debug")
        hs.openConsole()
    else
        hs.notify.new({ title = "Hammerspoon", informativeText = "Setting log level to info" }):send()
        M.log.w("setting log level to info")
        M.log.setLogLevel("info")
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

function M.length(set)
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
end

------------------------------------------
-- Windows management functions
------------------------------------------
-- Get the list of spaces in order, independently from screens
M.get_ordered_spaces = function()
    local ordered_spaces = {}
    local all_spaces = hs.spaces.allSpaces()
    local screen_main = hs.screen.primaryScreen():getUUID()
    M.log.vf("get_ordered_spaces(): all spaces %s", hs.inspect.inspect(all_spaces))
    M.log.vf("get_ordered_spaces(): main screen is %s, macbook screen is %s", screen_main, M.screen_macbook)
    if all_spaces then
        if screen_main ~= M.screen_macbook then
            local spaces_main = all_spaces[screen_main]
            if spaces_main then
                for _, space in pairs(spaces_main) do
                    table.insert(ordered_spaces, space)
                end
            end
        end
        local spaces_macbook = all_spaces[M.screen_macbook]
        if spaces_macbook then
            for _, space in pairs(spaces_macbook) do
                table.insert(ordered_spaces, space)
            end
        end
    end
    M.log.vf("get_ordered_spaces(): ordered spaces %s", hs.inspect.inspect(ordered_spaces))
    return ordered_spaces
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
    local space_id = M.get_ordered_spaces()[space]
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
    local ordered_spaces = M.get_ordered_spaces()
    local target_space = ordered_spaces[space]
    M.log.vf(
        "focus_space_or_previous(): ordered_spaces %s, current_space: %d, target_space: %d, previous_space: %d",
        hs.inspect.inspect(ordered_spaces),
        current_space,
        target_space,
        M.previous_space
    )
    if current_space == target_space then
        if M.is_space_already_visible(hs.spaces.activeSpaces(), ordered_spaces[M.previous_space]) then
            M.log.df("focus_space_or_previous(): current space equal to target space and target space already visible")
            M.focus_space_or_screen(M.previous_space)
        else
            M.log.df("focus_space_or_previous(): current space equal to target space")
            M.focus_space(M.previous_space)
        end
    else
        if M.is_space_already_visible(hs.spaces.activeSpaces(), ordered_spaces[space]) then
            M.log.df(
                "focus_space_or_previous(): current space not equal to target space and target space already visible"
            )
            M.focus_space_or_screen(space)
        else
            M.log.df("focus_space_or_previous(): current space not equal to target space")
            M.focus_space(space)
        end
    end
    local current_space_id = M.index_of(ordered_spaces, current_space)
    M.log.df(
        "focus_space_or_previous(): storing current space %d [%d] as previous space",
        current_space_id,
        current_space
    )
    M.previous_space = current_space_id
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
    M.log.df("focus_space_in_direction(): focusing space %d [%d] in direction %s", index, go_to, direction)
    hs.spaces.gotoSpace(go_to)
end

-- Ensure all spaces are present
M.ensure_all_spaces_are_present = function()
    -- 2 monitors
    if M.length(hs.spaces.allSpaces()) > 1 then
        local spaces_per_display = 5
        local main_spaces = hs.spaces.spacesForScreen()
        local main_spaces_len = M.length(main_spaces)
        if main_spaces then
            if spaces_per_display > main_spaces_len then
                for i = 1, spaces_per_display - main_spaces_len do
                    M.log.df(
                        "ensure_all_spaces_are_present(): %d spaces on main display is less than %d spaces, adding space to main display",
                        main_spaces_len,
                        spaces_per_display
                    )
                    hs.spaces.addSpaceToScreen(hs.screen.mainScreen(), true)
                end
            elseif spaces_per_display < main_spaces_len then
                for i = #main_spaces, 1, -1 do
                    M.log.df(
                        "ensure_all_spaces_are_present(): %d spaces on main display is more than %d spaces, removing space to main display",
                        main_spaces_len,
                        spaces_per_display
                    )
                    if i > spaces_per_display then
                        hs.spaces.removeSpace(main_spaces[i], true)
                    end
                end
            end
        end
        local macbook_spaces = hs.spaces.spacesForScreen(M.screen_macbook)
        local macbook_spaces_len = M.length(macbook_spaces)
        if macbook_spaces then
            if spaces_per_display > macbook_spaces_len then
                for _ = 1, spaces_per_display - macbook_spaces_len do
                    M.log.df(
                        "ensure_all_spaces_are_present(): %d spaces on macbook display is less than %d spaces, adding space to main display",
                        macbook_spaces_len,
                        spaces_per_display
                    )
                    hs.spaces.addSpaceToScreen(M.screen_macbook, true)
                end
            elseif spaces_per_display < macbook_spaces_len then
                for i = #macbook_spaces, 1, -1 do
                    if i > spaces_per_display then
                        M.log.df(
                            "ensure_all_spaces_are_present(): %d spaces on macbook display is more than %d spaces, removing space to main display",
                            macbook_spaces_len,
                            spaces_per_display
                        )
                        hs.spaces.removeSpace(macbook_spaces[i], true)
                    end
                end
            end
        end
        -- 1 monitor
    else
        local spaces_per_display = 10
        local main_spaces = hs.spaces.spacesForScreen()
        local main_spaces_len = M.length(main_spaces)
        if main_spaces then
            if spaces_per_display > main_spaces_len then
                for _ = 1, spaces_per_display - main_spaces_len do
                    M.log.df(
                        "ensure_all_spaces_are_present(): %d spaces on macbook display is less than %d spaces, adding space to main display",
                        main_spaces_len,
                        spaces_per_display
                    )
                    hs.spaces.addSpaceToScreen(hs.screen.mainScreen(), true)
                end
            elseif spaces_per_display < main_spaces_len then
                for i = #main_spaces, 1, -1 do
                    M.log.df(
                        "ensure_all_spaces_are_present(): %d spaces on macbook display is more than %d spaces, removing space to main display",
                        main_spaces_len,
                        spaces_per_display
                    )
                    if i > spaces_per_display then
                        hs.spaces.removeSpace(main_spaces[i], true)
                    end
                end
            end
        end
    end
end

-- Move windows to spaces
M.move_current_window_to_space = function(space)
    local win = hs.window.focusedWindow() -- current window
    local ordered_spaces = M.get_ordered_spaces()
    local space_id = ordered_spaces[space]
    M.log.df("move_current_window_to_space(): moving window %s to space %d [%d]", win:title(), space, space_id)
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
    if windows then
        local window_to_focus = #windows > 0 and windows[1] or hs.window.desktop()
        window_to_focus:focus()
    end
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

-- Focus a window or a screen based on a direction
M.focus_window_or_screen = function(direction)
    local args = { "-m", "window", "--focus", direction }
    M.log.df("focus_window_or_screen(): running yabai with arguments %s", hs.inspect.inspect(args))
    hs.task
        .new(M.yabai_bin, function(exit_code)
            if exit_code == 1 then
                if direction == "east" then
                    M.log.df("focus_window_or_screen(): reached edge of current screen, focusing next screen")
                    M.focus_screen(hs.window.focusedWindow():screen():next())
                end
                if direction == "west" then
                    M.log.df("focus_window_or_screen(): reached edge of current screen, focusing previous screen")
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
    M.log.df("resize_window(): running yabai with arguments %s", hs.inspect.inspect(args))
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
                M.log.df("handle_window_event(): found window for app %s with title %s", app_name, window_title)
                local window = element:application():focusedWindow()
                if window then
                    -- App only
                    for app, manage in pairs(M.windows_configuration.apps) do
                        if app_name and app_name == app and manage == true then
                            M.log.df("handle_window_event(): centering window for app %s", app_name)
                            window:centerOnScreen(nil, true, 0)
                            hs.execute(M.sketchybar_bin .. " --trigger window_focus", false)
                        end
                    end
                    -- Title only
                    for title, manage in pairs(M.windows_configuration.titles) do
                        if window_title and window_title == title and manage == true then
                            M.log.df(
                                "handle_window_event(): centering window for app %s, title %s",
                                app_name,
                                window_title
                            )
                            window:centerOnScreen(nil, true, 0)
                            hs.execute(M.sketchybar_bin .. " --trigger window_focus", false)
                        end
                    end
                    -- App and title
                    for app, config in pairs(M.windows_configuration.apps_and_titles) do
                        for _, title in pairs(config.titles) do
                            if
                                app
                                and window_title
                                and app_name == app
                                and window_title == title
                                and config.manage == true
                            then
                                M.log.df(
                                    "handle_window_event(): centering window for app %s, title %s",
                                    app_name,
                                    window_title
                                )
                                window:centerOnScreen(nil, true, 0)
                                hs.execute(M.sketchybar_bin .. " --trigger window_focus", false)
                            end
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

    ---@diagnostic disable-next-line: undefined-field
    watcher:start({ hs.uielement.watcher.windowCreated })
end

-- Attatch all existing apps during startup
M.attach_existing_apps = function()
    local apps = hs.application.runningApplications()
    ---@diagnostic disable-next-line: cast-local-type
    apps = hs.fnutils.filter(apps, function(app)
        return app:title() ~= "Hammerspoon"
    end)
    hs.fnutils.each(apps, function(app)
        M.watch_app(app)
    end)
end

------------------------------------------
-- Main
------------------------------------------
-- Include minimized/hidden windows, current Space only
M.window_switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter({}))
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

local ordered_spaces = M.get_ordered_spaces()
M.log.f("started hammerspoon with ordered spaces %s", hs.inspect.inspect(ordered_spaces))
M.log.f("watching for float applications and windows configuration: %s", hs.inspect.inspect(M.windows_configuration))
hs.notify
    .new({
        title = "Hammerspoon",
        informativeText = "Started hammerspoon with ordered spaces " .. hs.inspect.inspect(ordered_spaces),
    })
    :send()

return M
