-- Left
local apple = require "items.apple"
local spaces = require "items.spaces"

-- Right
require "items.calendar"
require "items.stats"
local weather = require "items.weather"

apple.subscribe_system_woke { spaces, weather }
