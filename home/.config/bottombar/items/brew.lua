local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"

local brew = sbar.add("item", "brew", {
    position = "right",
    padding_right = 10,
    icon = {
        string = icons.brew,
        font = {
            style = "Bold",
            size = 16.0,
        },
    },
    label = {
        string = icons.loading,
    },
    y_offset = 1,
    -- display = "active",
})

local function update()
    brew:set { label = { string = icons.loading, color = colors.white }, icon = { color = colors.white } }
    local outdated = tonumber(helpers.runcmd "brew outdated |wc -l |tr -d ' '")
    local color = colors.red
    local label_color = colors.white
    if outdated == 0 then
        color = colors.green
        outdated = ""
        label_color = colors.green
    elseif outdated <= 10 then
        color = colors.yellow
    elseif outdated <= 20 then
        color = colors.orange
    else
        color = colors.red
    end
    brew:set { label = { string = tostring(outdated), color = label_color }, icon = { color = color } }
end

brew:subscribe("brew_update", function()
    update()
end)

update()
