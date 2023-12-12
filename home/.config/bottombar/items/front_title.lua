local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"

local app = sbar.add("item", "front_title", {
    position = "right",
    click_script = "open -a 'Mission Control'",
    icon = {
        drawing = false,
    },
    label = {
        font = {
            style = "Regular",
            size = 12.0,
        },
    },
    padding_right = 10,
    display = "active",
    y_offset = 3,
})

app:subscribe("front_app_switched", function(env)
    local window = helpers.runcmd "yabai -m query --windows --window"
    if window and window["title"] then
        app:set { label = window.title }
    end
end)
