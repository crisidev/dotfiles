local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local math = require "math"
local module = {}

module.brew = sbar.add("item", "brew", {
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
})

module.update = function()
    module.brew:set { label = { string = icons.loading, color = colors.white }, icon = { color = colors.white } }
    local outdated_num = 0
    local outdated = helpers.runcmd "brew outdated |wc -l |tr -d ' '"
    if outdated then
        outdated_num = math.floor(outdated)
    end
    outdated = tostring(outdated_num)
    local color = colors.red
    local label_color = colors.white
    if outdated_num == 0 then
        color = colors.green
        outdated = icons.ok
        label_color = colors.green
    elseif outdated_num <= 10 then
        color = colors.yellow
    elseif outdated_num <= 20 then
        color = colors.orange
    else
        color = colors.red
    end
    module.brew:set { label = { string = outdated, color = label_color }, icon = { color = color } }
end

module.brew:subscribe("brew_update", module.update)

return module
