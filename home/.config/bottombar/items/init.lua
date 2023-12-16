
-- Left
local front_app = require "items.front_app"

-- Right
local spotify = require "items.spotify"
local brew = require "items.brew"
local notify = require "items.notify"
local wifi = require "items.wifi"
local battery = require "items.battery"
local volume = require "items.volume"
local mic = require "items.mic"
require("items.status")
local front_title = require "items.front_title"

-- System woke
front_app.subscribe_system_woke { battery, front_app, front_title, spotify, notify, brew, wifi, volume, mic }
