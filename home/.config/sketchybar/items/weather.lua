local helpers = require "helpers"

local module = {}
module.weather = sbar.add("item", "weather", {
    label = {
        align = "center",
    },
    padding_right = -3,
    position = "right",
    update_freq = 1800,
    y_offset = -3,
})

module.update = function()
    sbar.animate("tanh", 10, function()
        local w = helpers.runcmd('curl -s "https://wttr.in/?format=1"', true)
        if w then
            module.weather:set { drawing = true, label = w, click_script = "open /System/Applications/Weather.app" }
        else
            module.weather:set { drawing = false }
        end
    end)
end

module.weather:subscribe("routine", module.update)
module.weather:subscribe("forced", module.update)

return module
