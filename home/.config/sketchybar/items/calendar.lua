local calendar = sbar.add("item", "calendar", {
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
    update_freq = 1,
    padding_left = 8,
    y_offset = -3,
})

local function update()
    local date = os.date "%a %d. %b"
    local time = os.date "%H:%M:%S"
    calendar:set { icon = date, label = time }
end

calendar:subscribe("routine", update)
calendar:subscribe("forced", update)
