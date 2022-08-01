local M = {}

local function default_commands() end

M.config = function()
    local status_ok, legend = pcall(require, "legendary")
    if not status_ok then
        return
    end

    local icons = require("user.icons").icons

    legend.setup {
        select_prompt = function(kind)
            if kind == "legendary.items" then
                return icons.flash .. "Legendary " .. icons.flash
            end

            -- Convert kind to Title Case (e.g. legendary.keymaps => Legendary Keymaps)
            return icons.flash
                .. string.gsub(" " .. kind:gsub("%.", " "), "%W%l", string.upper):sub(2)
                .. " "
                .. icons.flash
        end,
    }
end

return M
