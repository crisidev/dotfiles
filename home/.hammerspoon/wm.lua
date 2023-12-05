------------------------------------------
-- Windows management
------------------------------------------
local helpers = require("helpers")
local module = {}

module.previous_space = 1
module.app_watchers = {}
module.windows_configuration_file = helpers.homedir .. "/.config/yabai/windows.json"
module.windows_configuration = {}
module.focused_screen_for_floating_windows = nil
module.all_spaces = hs.spaces.allSpaces()
module.all_spaces_length = 0
module.ordered_spaces = {}
module.screen_main = hs.screen.primaryScreen():getUUID()
module.screen_other = nil
module.log = hs.logger.new("wm", "info")

-- Get the list of spaces in order, independently from screens
module.get_ordered_spaces = function()
    local ordered_spaces = {}
    module.log.vf("get_ordered_spaces(): all spaces %s", hs.inspect.inspect(module.all_spaces))
    if module.all_spaces then
        -- Main screen first
        local spaces_main = module.all_spaces[module.screen_main]
        if spaces_main then
            for _, space in pairs(spaces_main) do
                table.insert(ordered_spaces, space)
            end
        end
        for screen, spaces in pairs(module.all_spaces) do
            if screen ~= module.screen_main then
                for _, space in pairs(spaces) do
                    table.insert(ordered_spaces, space)
                end
            end
        end
    end
    module.log.vf("get_ordered_spaces(): ordered spaces %s", hs.inspect.inspect(ordered_spaces))
    return ordered_spaces
end

-- Find the secondary screen.
module.find_other_screen = function()
    if module.all_spaces_length > 1 then
        for screen, _ in pairs(module.all_spaces) do
            if screen ~= module.screen_main then
                return screen
            end
        end
        return nil
    else
        return nil
    end
end

-- Update the cached objects
module.update_cache = function()
    module.all_spaces = hs.spaces.allSpaces()
    module.all_spaces_length = helpers.length(module.all_spaces)
    module.ordered_spaces = module.get_ordered_spaces()
    module.ordered_spaces_length = helpers.length(module.ordered_spaces)
    module.screen_main = hs.screen.primaryScreen():getUUID()
    module.screen_other = module.find_other_screen()
end

-- Check if a space is already visible
module.is_space_already_visible = function(active_spaces, space)
    for _, value in pairs(active_spaces) do
        if value == space then
            module.log.df("is_space_already_visible(): mission control space id %d is already visible", space)
            return true
        end
    end
    module.log.df("is_space_already_visible(): mission control space id %d is not already visible", space)
    return false
end

-- Focus a space
module.focus_space = function(space)
    local space_id = module.ordered_spaces[space]
    module.log.df("focus_space(): focusing space %d [%d] using mission control keybinds", space, space_id)
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
module.focus_space_or_previous = function(space)
    local current_space = hs.spaces.focusedSpace()
    local target_space = module.ordered_spaces[space]
    module.log.vf(
        "focus_space_or_previous(): ordered_spaces %s, current_space: %d, target_space: %d, previous_space: %d",
        hs.inspect.inspect(module.ordered_spaces),
        current_space,
        target_space,
        module.previous_space
    )
    if current_space == target_space then
        if module.is_space_already_visible(hs.spaces.activeSpaces(), module.ordered_spaces[module.previous_space]) then
            module.log.df "focus_space_or_previous(): current space equal to target space and target space already visible"
            module.focus_space_or_screen(module.previous_space)
        else
            module.log.df "focus_space_or_previous(): current space equal to target space"
            module.focus_space(module.previous_space)
        end
    else
        if module.is_space_already_visible(hs.spaces.activeSpaces(), module.ordered_spaces[space]) then
            module.log.df "focus_space_or_previous(): current space not equal to target space and target space already visible"
            module.focus_space_or_screen(space)
        else
            module.log.df "focus_space_or_previous(): current space not equal to target space"
            module.focus_space(space)
        end
    end
    local current_space_id = helpers.index_of(module.ordered_spaces, current_space)
    module.log.df(
        "focus_space_or_previous(): storing current space %d [%d] as previous space",
        current_space_id,
        current_space
    )
    module.previous_space = current_space_id
end

-- Focus a space in a specific direction
module.focus_space_in_direction = function(direction)
    local current_space = hs.spaces.focusedSpace()
    local index = helpers.index_of(module.ordered_spaces, current_space)
    local go_to = 1
    if direction == "left" then
        if index - 1 < 1 then
            go_to = module.ordered_spaces[module.ordered_spaces_length]
        else
            go_to = module.ordered_spaces[index - 1]
        end
    elseif direction == "right" then
        if index + 1 > module.ordered_spaces_length then
            go_to = module.ordered_spaces[1]
        else
            go_to = module.ordered_spaces[index + 1]
        end
    end
    module.log.df("focus_space_in_direction(): focusing space %d [%d] in direction %s", index, go_to, direction)
    hs.spaces.gotoSpace(go_to)
end

-- Helper function to add or remove spaces
module.add_or_remove_spaces = function(spaces, spaces_per_display, screen)
    if spaces then
        local spaces_len = module.length(spaces)
        if spaces_per_display > spaces_len then
            for _ = 1, spaces_per_display - spaces_len do
                module.log.df(
                    "add_or_remove_spaces(): %d spaces on main display is less than %d spaces, adding space to display %s",
                    spaces_len,
                    spaces_per_display,
                    screen
                )
                hs.spaces.addSpaceToScreen(screen, true)
            end
        elseif spaces_per_display < spaces_len then
            for i = #spaces, 1, -1 do
                module.log.df(
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
module.ensure_all_spaces_are_present = function()
    module.update_cache()
    -- 2 monitors
    if module.all_spaces_length > 1 then
        local spaces_per_display = 5
        local main_spaces = module.all_spaces[module.screen_main]
        if main_spaces then
            module.add_or_remove_spaces(main_spaces, spaces_per_display, module.screen_main)
        end
        for screen, spaces in pairs(module.all_spaces) do
            if screen ~= module.screen_main then
                module.add_or_remove_spaces(spaces, spaces_per_display, screen)
            end
        end
    else
        local spaces_per_display = 10
        local main_spaces = hs.spaces.spacesForScreen()
        module.add_or_remove_spaces(main_spaces, spaces_per_display, hs.screen.mainScreen():getUUID())
    end
    module.update_cache()
    os.execute(helpers.sketchybar_bin .. " --reload")
end

-- Cycle all mission control spaces
module.cycle_all_spaces_mission_control = function()
    local main_space = hs.spaces.activeSpaceOnScreen(module.screen_main)
    local other_space = nil
    if module.all_spaces_length > 1 then
        other_space = hs.spaces.activeSpaceOnScreen(module.screen_other)
    end
    for i = 1, 10 do
        module.focus_space(i)
        os.execute "sleep 0.3"
    end
    if module.all_spaces_length > 1 and other_space then
        module.focus_space(helpers.index_of(module.ordered_spaces, other_space))
        os.execute "sleep 0.3"
    end
    module.focus_space(helpers.index_of(module.ordered_spaces, main_space))
end

-- Checks if a window belongs to a screen
module.is_in_screen = function(screen, win)
    return win:screen() == screen
end

-- Moves focus to a specific screen
module.focus_screen = function(screen)
    local windows = hs.fnutils.filter(hs.window.orderedWindows(), hs.fnutils.partial(module.is_in_screen, screen))
    if windows then
        local window_to_focus = #windows > 0 and windows[1] or hs.window.desktop()
        window_to_focus:focus()
    end
end

-- Focus a specific screen if the space is already visible
module.focus_space_or_screen = function(space)
    if module.all_spaces_length then
        local other_screen = module.find_other_screen()
        local other_space_mission_control_id = hs.spaces.activeSpaceOnScreen(other_screen)
        local other_space = helpers.index_of(module.ordered_spaces, other_space_mission_control_id)
        module.log.df("focus_space_or_screen(): target space %d, other space %d", space, other_space)
        if space == other_space then
            module.focus_screen(hs.window.focusedWindow():screen():previous())
        else
            module.focus_screen(hs.window.focusedWindow():screen():next())
        end
    end
end

-- Focus a window or a screen based on a direction
module.focus_window_or_screen = function(direction)
    local args = { "-m", "window", "--focus", direction }
    module.log.df("focus_window_or_screen(): running yabai with arguments %s", hs.inspect.inspect(args))
    hs.task
        .new(helpers.yabai_bin, function(exit_code)
            if exit_code == 1 then
                if direction == "east" then
                    module.log.df "focus_window_or_screen(): reached edge of current screen, focusing next screen"
                    if module.all_spaces_length > 1 then
                        module.focus_screen(hs.window.focusedWindow():screen():next())
                    else
                        module.focus_space_in_direction "right"
                    end
                end
                if direction == "west" then
                    module.log.df "focus_window_or_screen(): reached edge of current screen, focusing previous screen"
                    if module.all_spaces_length > 1 then
                        module.focus_screen(hs.window.focusedWindow():screen():previous())
                    else
                        module.focus_space_in_direction "left"
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
module.resize_window = function(direction1, direction2)
    local args = { "-m", "window", "--resize", direction1 }
    module.log.df("resize_window(): running yabai with arguments %s", hs.inspect.inspect(args))
    hs.task
        .new(helpers.yabai_bin, function(exit_code)
            if exit_code == 1 then
                helpers.yabai { "-m", "window", "--resize", direction2 }
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
module.handle_global_event = function(_, event, app)
    if event == hs.application.watcher.launched then
        module.watch_app(app)
    elseif event == hs.application.watcher.terminated then
        -- Clean up
        local app_watcher = module.app_watchers[app:pid()]
        if app_watcher then
            app_watcher.watcher:stop()
            local windows = app_watcher.windows
            if windows then
                for _, watcher in pairs(app_watcher.windows) do
                    watcher:stop()
                end
            end
            module.app_watchers[app:pid()] = nil
        end
    end
end

-- Cheap and dirty hack to move the Teams call window to a specific desk.
-- It requires a C helper to be compiled, which can be found in the Hammerspoon
-- config directory and need to be moved to ~/.hammerspoon/yellowdot.
-- The helper checks if the microphone is currently being recorded.
module.handle_teams_video_call = function(app_name, window_title, window_id)
    if app_name:find "Microsoft Teams" then
        if
            not window_title:find "Activity |"
            or not window_title:find "Chat |"
            or not window_title:find "Teams and Channels |"
            or window_title ~= "Calendar | Microsoft Teams"
            or window_title ~= "Files | Microsoft Teams"
            or window_title ~= "Calls | Microsoft Teams"
            or window_title ~= "Apps | Microsoft Teams"
            or window_title ~= "Okta | Microsoft Teams"
            or window_title ~= "Kadence | Microsoft Teams"
        then
            local _, _, _, rc = hs.execute(helpers.homedir .. "/.hammerspoon/yellowdot", false)
            -- Not yet in a call, move the window
            if rc == 1 then
                module.log.df(
                    "Teams is on a call, move window with title '%s' to desktop 5, window id: %s",
                    window_title,
                    window_id
                )
                helpers.yabai { "-m", "window", tostring(window_id), "--space", "5", "--focus" }
                return true
            end
        end
    end
    return false
end

-- Handle any window event
module.handle_window_event = function(element, _, _, _)
    ---@diagnostic disable-next-line: undefined-field
    if hs.uielement.watcher.windowCreated then
        if element and element["application"] then
            local application = element:application()
            module.log.df("handle_window_event(): found application %s", application)
            if application then
                local app_name = application:title()
                local window_title = element:title()
                module.log.df(
                    "handle_window_event(): found window for app %s with title %s, id: %s",
                    app_name,
                    window_title,
                    element:id()
                )
                -- Handle Outlook reminders
                if app_name == "Microsoft Outlook" and window_title:find " Reminder" then
                    module.log.df "handle_window_event(): outlook reminder window created, focusing it now"
                    helpers.yabai { "-m", "window", "--focus", tostring(element:id()) }
                    return
                end
                local window = element:application():focusedWindow()
                if module.handle_teams_video_call(app_name, window_title, window:id()) then
                    return
                end
                if window then
                    -- App only
                    for app, manage in pairs(module.windows_configuration.apps) do
                        if app_name and app_name == app and manage == true then
                            module.log.df("handle_window_event(): centering window for app %s", app_name)
                            window:centerOnScreen(module.focused_screen_for_floating_windows, true, 0)
                            os.execute(helpers.sketchybar_bin .. " --trigger window_focus")
                            return
                        end
                    end
                    -- Title only
                    for title, manage in pairs(module.windows_configuration.titles) do
                        if window_title and (window_title == title or window_title:find(title)) and manage == true then
                            module.log.df(
                                "handle_window_event(): centering window for app %s, title %s",
                                app_name,
                                window_title
                            )
                            window:centerOnScreen(module.focused_screen_for_floating_windows, true, 0)
                            os.execute(helpers.sketchybar_bin .. " --trigger window_focus")
                            return
                        end
                    end
                    -- App and title
                    for app, config in pairs(module.windows_configuration.apps_and_titles) do
                        for _, title in pairs(config.titles) do
                            if
                                app
                                and window_title
                                and app_name == app
                                and (window_title == title or window_title:find(title))
                                and config.manage == true
                            then
                                module.log.df(
                                    "handle_window_event(): centering window for app %s, title %s",
                                    app_name,
                                    window_title
                                )
                                window:centerOnScreen(module.focused_screen_for_floating_windows, true, 0)
                                os.execute(helpers.sketchybar_bin .. " --trigger window_focus")
                                return
                            end
                        end
                    end
                end
            end
        end
        module.focused_screen_for_floating_windows = nil
    end
end

module.set_focused_screen_for_floating_windows_to_current_screen = function()
    module.focused_screen_for_floating_windows = hs.screen.mainScreen()
end

-- Add a watcher for a new app
module.watch_app = function(app)
    if module.app_watchers[app:pid()] or app:name() == "Microsoft Outlook Web Content" or app:kind() ~= 1 then
        return
    end

    module.log.df("watch_app(): starting application watcher for %s, kind: %s", app:name(), app:kind())
    local watcher = app:newWatcher(module.handle_window_event)
    module.app_watchers[app:pid()] = {
        watcher = watcher,
    }

    ---@diagnostic disable-next-line: undefined-field
    watcher:start { hs.uielement.watcher.windowCreated }
    module.log.df("watch_app(): application whatcher for %s started", app:name())
end

-- Attatch all existing apps during startup
module.attach_existing_apps = function()
    local apps = hs.application.runningApplications()
    ---@diagnostic disable-next-line: cast-local-type
    hs.fnutils.each(apps, function(app)
        module.watch_app(app)
    end)
end

------------------------------------------
-- Beachballers
------------------------------------------
-- Find any application causing Hammerspoon to beachball
module.find_beachballers = function()
    ---@diagnostic disable-next-line: undefined-field
    local timed_apps = hs.window._timed_allWindows()
    for name, time in pairs(timed_apps) do
        if time > 1.0 then
            module.log.ef("application %s is slow: %f", name, time)
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
module.init = function()
    -- Setup mission control wait time
    hs.spaces.MCwaitTime = 0.3

    -- Include minimized/hidden windows, current Space only
    module.window_switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter {})
    module.window_switcher.ui.showTitles = false
    module.window_switcher.ui.showThumbnails = false
    module.window_switcher.ui.showSelectedThumbnail = false
    module.window_switcher.ui.showSelectedTitle = false

    -- Watch for application events
    if helpers.file_exists(module.windows_configuration_file) then
        module.windows_configuration = hs.json.read(module.windows_configuration_file)
        module.app_watcher = hs.application.watcher.new(module.handle_global_event):start()
        module.attach_existing_apps()
    end

    -- Update cache on startup
    module.update_cache()
    module.log.f("started hammerspoon with ordered spaces %s", hs.inspect.inspect(module.ordered_spaces))
    module.log.f(
        "watching for float applications and windows configuration: %s",
        hs.inspect.inspect(module.windows_configuration)
    )
    module.log.f("there are %s application watchers", helpers.length(module.app_watchers))
    hs
        .notify
        .new({
            title = "Hammerspoon",
            informativeText = "Started hammerspoon with ordered spaces " .. hs.inspect.inspect(module.ordered_spaces),
        })
        ---@diagnostic disable-next-line: undefined-field
        :send()
    hs["wm"] = module
end

return module
