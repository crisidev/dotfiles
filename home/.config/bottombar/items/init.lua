local colors = require "colors"
local homedir = os.getenv "HOME"

-- Left
local yabai = require "items.yabai"
-- require "items.spotify"
local front_app = require "items.front_app"

-- Right
os.execute(homedir .. "/.config/bottombar/items/spotify.sh")
local brew = require "items.brew"
local notify = require "items.notify"
local wifi = require "items.wifi"
local battery = require "items.battery"
require "items.volume"
require "items.mic"
sbar.add("bracket", "status", { "brew", "notify", "wifi", "battery", "volume_icon", "mic_icon" }, {
    background = {
        color = colors.bg1,
        border_color = colors.bg2,
        height = 33,
    },
})
local front_title = require "items.front_title"

-- System woke
yabai.subscribe_system_woke { battery, wifi, front_app, front_title, brew, notify }
