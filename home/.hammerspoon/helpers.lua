------------------------------------------
-- Helper functions
------------------------------------------
local module = {}

module.homedir = os.getenv "HOME"
module.yabai_bin = "/opt/homebrew/bin/yabai"
module.sketchybar_bin = "/opt/homebrew/bin/sketchybar"
module.bottombar_bin = "/opt/homebrew/bin/bottombar"
module.mirror_bin = "/opt/homebrew/bin/mirror"
module.kitty_bin = "/Applications/kitty.app/Contents/MacOS/kitty"
module.log = hs.logger.new("helpers", "info")

module.file_exists = function(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

module.set_log_level = function(logger, level)
    if level then
        logger.setLogLevel(level)
        logger.wf("setting log level to %s", level)
    elseif logger.getLogLevel() == 3 then
        logger.w "setting log level to debug"
        logger.setLogLevel "debug"
    else
        logger.w "setting log level to info"
        logger.setLogLevel "info"
    end
end

module.contains = function(set, key)
    return set[key] ~= nil
end

module.index_of = function(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

module.length = function(set)
    local c = 0
    for _, _ in pairs(set) do
        c = c + 1
    end
    return c
end

-- Run a yabai command in background
module.yabai = function(args)
    module.log.df("yabai(): running yabai with arguments %s", hs.inspect.inspect(args))
    hs.task
        .new(module.yabai_bin, nil, function()
            return true
        end, args)
        :start()
        :waitUntilExit()
end

-- Toggle debug
module.toggle_debug = function()
    module.set_log_level(module.log)
    module.set_log_level(require("wm").log)
    if module.log.getLogLevel() == 3 then
        ---@diagnostic disable-next-line: undefined-field
        hs.notify.new({ title = "Hammerspoon", informativeText = "Log level set to info" }):send()
    else
        ---@diagnostic disable-next-line: undefined-field
        hs.notify.new({ title = "Hammerspoon", informativeText = "Log level set to debug" }):send()
    end
end

-- Toggle console
module.toggle_console = function()
    hs.toggleConsole()
end

-- Notify
module.notify = function(message)
    ---@diagnostic disable-next-line: undefined-field
    hs.notify.new({ title = "Hammerspoon", informativeText = message }):send()
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

return module
