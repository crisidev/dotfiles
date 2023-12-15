local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local module = {}

module.front_title = sbar.add("item", "front_title", {
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

module.update = function(_)
    local window = helpers.runcmd "yabai -m query --windows --window"
    if window and window["title"] then
        module.front_title:set { label = window.title }
    end
end

module.front_title:subscribe("window_focus", module.update)

return module
