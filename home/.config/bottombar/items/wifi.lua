local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local module = {}

module.wifi = sbar.add("item", "wifi", {
    position = "right",
    icon = {
        string = icons.wifi.disconnected,
        font = {
            style = "Bold",
            size = 16.0,
        },
    },
    label = {
        string = icons.loading,
        width = 0,
    },
    popup = {
        align = "right",
    },
    y_offset = 1,
    update_freq = 180,
})

local function wifi_line(icon, label)
    return {
        icon = {
            string = icon,
            padding_left = 6,
            color = colors.blue,
            background = {
                height = 2,
                y_offset = -12,
            },
        },
        label = {
            string = label,
            padding_right = 6,
        },
        position = "popup." .. module.wifi.name,
        drawing = true,
        background = {
            corner_radius = 12,
        },
        padding_left = 8,
        padding_right = 15,
        align = "left",
        update_freq = 120,
        updates = true,
    }
end

local function get_wifi_info()
    local ssid =
        helpers.runcmd "/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: ' '/ SSID: / {print $2}'"
    local ipaddr = helpers.runcmd "ipconfig getifaddr en0"
    local icon = icons.wifi.disconnected
    if ssid then
        icon = icons.wifi.connected
    end
    return ssid, ipaddr, icon
end

local function update_details(ssid, ipaddr)
    local channel =
        helpers.runcmd "/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' channel: ' '/ channel: / { print $2 }'"
    local auth =
        helpers.runcmd "/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' link auth: ' '/ link auth: / { print $2 }'"
    local default_route = helpers.runcmd "route -n get default | awk -F ' gateway: ' '/ gateway: / { print $2 }'"
    local label = string.format("SSID: %s, channel: %s, auth: %s", ssid, channel, auth)
    os.execute "bottombar -m --remove '/wifi.line.*/'"
    local info = get_wifi_info()
    sbar.add("item", "wifi.line.1", wifi_line(icons.wifi.connected, label))

    info = get_wifi_info()
    label = string.format("IP address: %s, gateway: %s", ipaddr, default_route)
    sbar.add("item", "wifi.line.2", wifi_line("􀁞", label))

    local icon = icons.tailscale.off
    label = "Tailscale disconnected"
    if os.execute "/Applications/Tailscale.app/Contents/MacOS/Tailscale status >/dev/null 2>&1" then
        icon = icons.tailscale.on
        ipaddr = helpers.runcmd "/Applications/Tailscale.app/Contents/MacOS/Tailscale ip --4"
        label = string.format("Tailscale connected, address: %s", ipaddr)
    end
    sbar.add("item", "wifi.line.3", wifi_line(icon, label))
end

local function slide(env)
    local item = sbar.query(env.NAME)
    local width = 0
    if item.label.width == 0 then
        width = "dynamic"
    end
    sbar.animate("sin", 20.0, function()
        module.wifi:set { label = { width = width } }
    end)
end

module.update = function()
    local ssid, ipaddr, icon = get_wifi_info()
    local label = string.format("%s %s", ssid, ipaddr)
    sbar.animate("sin", 20.0, function()
        module.wifi:set { icon = icon, label = label }
    end)
    update_details(ssid, ipaddr)
end

module.wifi:subscribe("force", module.update)
module.wifi:subscribe("routine", module.update)
module.wifi:subscribe("wifi_change", function(env)
    module.update()
    slide(env)
    os.execute("sleep 1")
    slide(env)
end)

module.wifi:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "right" or env.MODIFIER == "shift" then
        module.wifi:set { popup = { drawing = "toggle" } }
    else
        module.wifi:set { popup = { drawing = false } }
        slide(env)
    end
end)
module.wifi:subscribe("mouse.exited.global", function()
    module.wifi:set { popup = { drawing = false } }
end)

return module
