local module = {}
local json = require "cjson"
local icons = require "icons"
local colors = require "colors"

string.startswith = function(self, str)
    return self:find("^" .. str) ~= nil
end

string.endswith = function(self, str)
    return self:find(str .. "$") ~= nil
end

module.runcmd = function(command, strip)
    local handle = io.popen(command)
    if handle then
        local result = handle:read "*a"
        handle:close()
        if result then
            local ok, t = pcall(json.decode, result)
            if ok then
                return t
            else
                if strip then
                    return result:gsub("\n", "")
                else
                    return result
                end
            end
        end
    end
    return nil
end

module.match = function(words, value)
    for _, word in ipairs(words) do
        if value:find(word) then
            return true
        end
    end
    return false
end

module.window_focus = function()
    os.execute "bottombar --trigger window_focus"
end

module.hammerspoon = function(command)
    os.execute(string.format('/opt/homebrew/bin/hs -c "return %s"', command))
end

module.hammerspoon_result = function(command, strip)
    local cmd = string.format('/opt/homebrew/bin/hs -c "return %s"', command)
    local handle = io.popen(cmd)
    if handle then
        local result = handle:read "*a"
        handle:close()
        if strip then
            return result:gsub("\r\n", "")
        else
            return result
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

module.yabai_mode = function()
    local window = module.runcmd "yabai -m query --windows --window"
    local spaces = module.runcmd "yabai -m query --spaces"
    local icon = icons.yabai.grid
    local color = colors.active_border
    if window and spaces then
        local space_mode = "bsp"
        local stack_index = window["stack-index"]
        if stack_index == nil then
            stack_index = 0
        end
        if type(spaces) == "table" then
            for _, space in pairs(spaces) do
                if space["has-focus"] == true then
                    space_mode = space["type"]
                end
            end
            if window["is-floating"] then
                icon = icons.yabai.float
                color = colors.green
            elseif window["has-fullscreen-zoom"] then
                icon = icons.yabai.fullscreen_zoom
                color = colors.orange
            elseif window["has-parent-zoom"] then
                icon = icons.yabai.parent_zoom
                color = colors.orange
            elseif stack_index > 0 then
                icon = icons.yabai.stack
                color = colors.red
            elseif space_mode == "stack" then
                icon = icons.yabai.stack
                color = colors.red
            elseif space_mode == "float" then
                icon = icons.yabai.float
                color = colors.green
            end
        end
    end
    return icon, color
end

module.dump = function(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. module.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

return module
