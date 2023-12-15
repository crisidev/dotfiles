local helpers = require "helpers"
local module = {}

module.front_app = sbar.add("item", "front_app", {
    position = "left",
    click_script = "open -a 'Mission Control'",
    icon = {
        background = {
            drawing = true,
        },
    },
    label = {
        font = {
            style = "Black",
            size = 12.0,
        },
    },
    display = "active",
    y_offset = -1,
})

module.update = function(env)
    if env and env["INFO"] and env["INFO"] ~= "com.microsoft.teams2.notificationcenter" then
        module.front_app:set { icon = { background = { image = "app." .. env.INFO } } }
        sbar.animate("tanh", 10, function()
            module.front_app:set { icon = { background = { image = { scale = 1.2 } } } }
            module.front_app:set { icon = { background = { image = { scale = 1.0 } } } }
        end)
    end
end

module.front_app:subscribe("front_app_switched", module.update)

return module
