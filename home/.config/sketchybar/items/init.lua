-- Left
local yabai = require "items.yabai"
local spaces = require "items.spaces"

-- Right
require "items.calendar"
require "items.stats"
local weather = require "items.weather"

yabai.subscribe_system_woke { spaces, weather }
