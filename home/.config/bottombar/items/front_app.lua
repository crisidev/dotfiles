local helpers = require "helpers"

local app = sbar.add("item", "front_app", {
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

local function update(env)
    if env.INFO ~= "com.microsoft.teams2.notificationcenter" then
        app:set { icon = { background = { image = "app." .. env.INFO } } }
        sbar.animate("tanh", 10, function()
            app:set { icon = { background = { image = { scale = 1.2 } } } }
            app:set { icon = { background = { image = { scale = 1.0 } } } }
        end)
    end
end

app:subscribe("front_app_switched", update)
