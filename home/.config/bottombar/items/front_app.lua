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
    padding_right = -5,
    -- display = "active",
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

module.subscribe_system_woke = function(args)
    module.front_app:subscribe("system_woke", function()
        for _, component in pairs(args) do
            component.update()
        end
    end)
end

module.front_app:subscribe("front_app_switched", module.update)

return module
