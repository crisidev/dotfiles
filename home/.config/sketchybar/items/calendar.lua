local module = {}

module.calendar = sbar.add("item", "calendar", {
    icon = {
        padding_right = 0,
        font = {
            style = "Black",
            size = 12.0,
        },
    },
    label = {
        width = 65,
        align = "right",
    },
    position = "right",
    update_freq = 2,
    padding_left = 8,
    y_offset = -3,
})

local function update()
    local date = os.date "%a %d. %b"
    local time = os.date "%H:%M:%S"
    module.calendar:set { icon = date, label = time }
end

module.calendar:subscribe("routine", update)
module.calendar:subscribe("forced", update)

return module
