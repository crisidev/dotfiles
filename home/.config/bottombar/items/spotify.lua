local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local popup_script = "bottombar -m --set spotify.anchor popup.drawing=toggle"
local spotify_event = "com.spotify.client.PlaybackStateChanged"
local homedir = os.getenv "HOME"
local module = {}

os.execute("bottombar -m --add event spotify_change " .. spotify_event)

module.spotify_anchor = sbar.add("item", "spotify.anchor", {
    position = "right",
    click_script = popup_script,
    label = {
        drawing = false,
        font = { style = "Black", size = 12.0 },
    },
    icon = {
        background = {
            drawing = true,
            image = "app.com.spotify.client",
        },
    },
    popup = {
        horizontal = true,
        align = "right",
        height = 150,
    },
    drawing = true,
    y_offset = 0,
})

module.spotify_cover = sbar.add("item", "spotify.cover", {
    position = "popup." .. module.spotify_anchor.name,
    click_script = "open -a 'Spotify' && .. popup_script",
    label = {
        drawing = false,
    },
    icon = {
        drawing = false,
    },
    padding_left = 12,
    padding_right = 10,
    background = {
        image = {
            scale = 0.2,
            drawing = true,
            corner_radius = 9,
        },
        drawing = true,
    },
    shadow = true,
})

module.spotify_title = sbar.add("item", "spotify.title", {
    position = "popup." .. module.spotify_anchor.name,
    icon = { drawing = false },
    padding_left = 0,
    padding_right = 0,
    width = 0,
    label = {
        font = {
            style = "Heavy",
            size = 15.0,
        },
        max_chars = 20,
    },
    y_offset = 55,
})

module.spotify_artist = sbar.add("item", "spotify.artist", {
    position = "popup." .. module.spotify_anchor.name,
    icon = { drawing = false },
    padding_left = 0,
    padding_right = 0,
    width = 0,
    label = {
        max_chars = 20,
    },
    y_offset = 30,
})

module.spotify_album = sbar.add("item", "spotify.album", {
    position = "popup." .. module.spotify_anchor.name,
    icon = { drawing = false },
    padding_left = 0,
    padding_right = 0,
    width = 0,
    y_offset = 15,
    label = {
        max_chars = 20,
    },
})

module.spotify_state = sbar.add("slider", "spotify.state", {
    position = "popup." .. module.spotify_anchor.name,
    icon = {
        drawing = true,
        font = {
            style = "Light Italic",
            size = 10.0,
        },
        width = 35,
        string = "00:00",
    },
    label = {
        drawing = true,
        font = {
            style = "Light Italic",
            size = 10.0,
        },
        width = 35,
        string = "00:00",
    },
    padding_left = 0,
    padding_right = 0,
    y_offset = -15,
    width = 0,
    slider = {
        background = {
            height = 6,
            corner_radius = 1,
            color = colors.grey,
        },
        highlight_color = colors.green,
        percentage = 40,
        width = 115,
    },
    update_freq = 1,
    updates = "when_shown",
})

module.spotify_shuffle = sbar.add("item", "spotify.shuffle", {
    position = "popup." .. module.spotify_anchor.name,
    icon = {
        string = icons.spotify.shuffle,
        padding_left = 5,
        padding_right = 5,
        color = colors.black,
        highlight_color = colors.grey,
    },
    label = { drawing = false },
    y_offset = -45,
})

module.spotify_back = sbar.add("item", "spotify.back", {
    position = "popup." .. module.spotify_anchor.name,
    icon = {
        string = icons.spotify.back,
        padding_left = 5,
        padding_right = 5,
        color = colors.black,
    },
    label = { drawing = false },
    y_offset = -45,
})

module.spotify_play = sbar.add("item", "spotify.play", {
    position = "popup." .. module.spotify_anchor.name,
    icon = {
        string = icons.spotify.play,
        padding_left = 4,
        padding_right = 5,
    },
    background = {
        height = 40,
        corner_radius = 20,
        color = colors.popup.bg,
        border_color = colors.white,
        border_width = 0,
        drawing = true,
    },
    width = 40,
    align = "center",
    updates = true,
    label = { drawing = false },
    y_offset = -45,
})

module.spotify_next = sbar.add("item", "spotify.next", {
    position = "popup." .. module.spotify_anchor.name,
    icon = {
        string = icons.spotify.next,
        padding_left = 5,
        padding_right = 5,
        color = colors.black,
    },
    label = { drawing = false },
    y_offset = -45,
})

module.spotify_repeat = sbar.add("item", "spotify.repeat", {
    position = "popup." .. module.spotify_anchor.name,
    icon = {
        string = icons.spotify._repeat,
        padding_left = 5,
        padding_right = 10,
        color = colors.black,
        highlight_color = colors.grey,
    },
    label = { drawing = false },
    y_offset = -45,
})

module.spotify_spacer = sbar.add("item", "spotify.spacer", {
    position = "popup." .. module.spotify_anchor.name,
    width = 15,
})

module.spotify_controls = sbar.add("bracket", "spotify.controls", {
    module.spotify_back.name,
    module.spotify_next.name,
    module.spotify_play.name,
    module.spotify_repeat.name,
    module.spotify_shuffle.name,
}, {
    background = {
        color = colors.green,
        corner_radius = 11,
        drawing = true,
    },
    y_offset = -45,
})

local function play()
    os.execute "osascript -e 'tell application \"Spotify\" to playpause'"
end

local function next()
    os.execute "osascript -e 'tell application \"Spotify\" to play next track'"
end

local function prev()
    os.execute "osascript -e 'tell application \"Spotify\" to play previous track'"
end

local function repeatfn()
    local repeating = helpers.runcmd "osascript -e 'tell application \"Spotify\" to get repeating'"
    if not repeating then
        module.spotify_repeat:set { icon = { highlight = true } }
        os.execute "osascript -e 'tell application \"Spotify\" to set repeating to true'"
    else
        module.spotify_repeat:set { icon = { highlight = false } }
        os.execute "osascript -e 'tell application \"Spotify\" to set repeating to false'"
    end
end

local function shufflefn()
    local shuffling = helpers.runcmd("osascript -e 'tell application \"Spotify\" to get shuffling'", true)
    if not shuffling then
        module.spotify_shuffle:set { icon = { highlight = true } }
        os.execute "osascript -e 'tell application \"Spotify\" to set shuffling to true'"
    else
        module.spotify_shuffle:set { icon = { highlight = false } }
        os.execute "osascript -e 'tell application \"Spotify\" to set shuffling to false'"
    end
end

local function scrubbing(env)
    local duration_ms =
        helpers.runcmd("osascript -e 'tell application \"Spotify\" to get duration of current track'", true)
    local duration = tonumber(duration_ms) / 1000
    local target = duration * env.PERCENTAGE / 100
    os.execute(string.format("osascript -e 'tell application \"Spotify\" to set player position to %s'", target))
    module.spotify_state:set { slider = { percentage = env.PERCENTAGE } }
end

local function scroll(env)
    local duration_ms =
        helpers.runcmd("osascript -e 'tell application \"Spotify\" to get duration of current track'", true)
    local duration = math.floor(tonumber(duration_ms) / 1000)
    local float = helpers.runcmd("osascript -e 'tell application \"Spotify\" to get player position'", true)
    if float then
        local time = math.floor(float)
        sbar.animate("linear", 10, function()
            module.spotify_state:set {
                slider = { percentage = time * 100 / duration },
                icon = helpers.runcmd(string.format("/bin/date -r %s +'%%M:%%S'", time), true),
                label = helpers.runcmd(string.format("/bin/date -r %s +'%%M:%%S'", duration), true),
            }
        end)
    end
end

local function update_cover()
    local cover =
        helpers.runcmd("osascript -e 'tell application \"Spotify\" to get artwork url of current track'", true)
    os.execute(string.format("curl -s --max-time 20 '%s' -o /tmp/cover.jpg", cover))
end

local function update(env)
    local artist = nil
    local album = nil
    local track = nil
    if env and env.INFO["Player State"] == "Playing" then
        track = env.INFO["Name"]
        artist = env.INFO["Artist"]
        album = env.INFO["Album"]
    else
        artist = helpers.runcmd "osascript -e 'tell application \"Spotify\" to get artist of current track'"
        album = helpers.runcmd "osascript -e 'tell application \"Spotify\" to get album of current track'"
        track = helpers.runcmd "osascript -e 'tell application \"Spotify\" to get name of current track'"
    end
    local shuffle = helpers.runcmd("osascript -e 'tell application \"Spotify\" to get shuffling'", true)
    local _repeat = helpers.runcmd("osascript -e 'tell application \"Spotify\" to get repeating'", true)
    module.spotify_title:set { label = track }
    module.spotify_album:set { label = album }
    module.spotify_artist:set { label = artist }
    module.spotify_state:set { slider = { percentage = 0 } }
    module.spotify_play:set { icon = icons.spotify.play }
    module.spotify_shuffle:set { icon = { highlight = shuffle } }
    module.spotify_repeat:set { icon = { highlight = _repeat } }
    update_cover()
    module.spotify_cover:set { background = { image = "/tmp/cover.jpg", color = colors.transparent } }
    module.spotify_anchor:set { drawing = true }
end

local function click(env)
    if env.NAME == "spotify.next" then
        next()
    elseif env.NAME == "spotify.back" then
        prev()
    elseif env.NAME == "spotify.play" then
        play()
    elseif env.NAME == "spotify.shuffle" then
        shufflefn()
    elseif env.NAME == "spotify.repeat" then
        repeatfn()
    elseif env.NAME == "spotify.state" then
        scrubbing(env)
    end
end

module.update = function()
    update()
end

module.spotify_state:subscribe("routine", function(env)
    if env.NAME == "spotify.state" then
        scroll(env)
    else
        update(env)
    end
end)

module.spotify_anchor:subscribe("spotify_change", update)
module.spotify_anchor:subscribe("mouse.clicked", update)
-- module.spotify_anchor:subscribe("mouse.entered", function(env)
--     module.spotify_anchor:set { popup = { drawing = true } }
-- end)
module.spotify_anchor:subscribe("mouse.exited.global", function(env)
    module.spotify_anchor:set { popup = { drawing = false } }
end)

module.spotify_state:subscribe("mouse.clicked", click)
module.spotify_shuffle:subscribe("mouse.clicked", click)
module.spotify_repeat:subscribe("mouse.clicked", click)
module.spotify_play:subscribe("mouse.clicked", click)
module.spotify_back:subscribe("mouse.clicked", click)
module.spotify_next:subscribe("mouse.clicked", click)

return module
