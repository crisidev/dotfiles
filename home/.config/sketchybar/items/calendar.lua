local module = {}
module.update_freq = 60

module.calendar = sbar.add("item", "calendar", {
    icon = {
        padding_right = 0,
        font = {
            style = "Black",
            size = 12.0,
        },
    },
    label = {
        width = 45,
        align = "right",
    },
    position = "right",
    update_freq = module.update_freq,
    padding_left = 3,
    y_offset = -3,
})

local function time_seconds(animate)
    local date = os.date "%a %d. %b"
    local time = os.date "%H:%M:%S"
    if animate then
        sbar.animate("tanh", 5, function()
            module.calendar:set { icon = date, label = { string = time, width = 65 } }
        end)
    else
        module.calendar:set { icon = date, label = { string = time, width = 65 } }
    end
end

local function time_minutes(animate)
    local date = os.date "%a %d. %b"
    local time = os.date "%H:%M"
    if animate then
        sbar.animate("tanh", 5, function()
            module.calendar:set { icon = date, label = { string = time, width = 45 } }
        end)
    else
        module.calendar:set { icon = date, label = { string = time, width = 45 } }
    end
end

local function update()
    if module.update_freq == 60 then
        time_minutes()
    else
        time_seconds()
    end
end

module.calendar:subscribe("routine", update)
module.calendar:subscribe("forced", update)

module.calendar:subscribe("mouse.clicked", function(env)
    if module.update_freq == 60 then
        module.update_freq = 1
        module.calendar:set { update_freq = module.update_freq }
        time_seconds(true)
    else
        module.update_freq = 60
        module.calendar:set { update_freq = module.update_freq }
        time_minutes(true)
    end
end)

return module
