local colors = require "colors"
local homedir = os.getenv "HOME"

-- Left
require "items.yabai"
-- require "items.spotify"
require "items.front_app"

-- Right
os.execute(homedir .. "/.config/bottombar/items/spotify.sh")
require "items.brew"
require "items.notify"
require "items.wifi"
require "items.battery"
require "items.volume"
require "items.mic"
sbar.add("bracket", "status", { "brew", "notify", "wifi", "battery", "volume_icon", "mic_icon" }, {
    background = {
        color = colors.bg1,
        border_color = colors.bg2,
        height = 33,
    },
})
os.execute(homedir .. "/.config/bottombar/plugins/spotify.sh")
require "items.front_title"

-- Rest
