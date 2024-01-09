local json = require "cjson"
local module = {}

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

module.now_playing = function(command)
    return module.runcmd(string.format("~/.config/bottombar/nowplaying-cli %s", command))
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

module.slider_on = function(slider, animation, speed)
    sbar.animate(animation, speed, function()
        slider:set { slider = { width = 100 } }
    end)
end

module.slider_off = function(slider, animation, speed)
    sbar.animate(animation, speed, function()
        slider:set { slider = { width = 0 } }
    end)
end

return module
