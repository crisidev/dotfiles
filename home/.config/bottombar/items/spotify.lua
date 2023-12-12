local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local plugin = os.getenv "HOME" .. "/.config/bottombar/plugins/spotify.sh"
local popup_script = "bottombar -m --set spotify.anchor popup.drawing=toggle"
local spotify_event = "com.spotify.client.PlaybackStateChanged"

local spotify_anchor = sbar.add("item", "spotify.anchor", {
    position = "left",
    script = plugin,
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
        align = "left",
        height = 150,
    },
    drawing = false,
    y_offset = 0,
})

local spotify_cover = sbar.add("item", "spotify.cover", {
    position = "popup." .. spotify_anchor.name,
    script = plugin,
    click_script = "open -a 'Spotify'; " .. popup_script,
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

local spotify_title = sbar.add("item", "spotify.title", {
    position = "popup." .. spotify_anchor.name,
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

local spotify_artist = sbar.add("item", "spotify.artist", {
    position = "popup." .. spotify_anchor.name,
    icon = { drawing = false },
    padding_left = 0,
    padding_right = 0,
    width = 0,
    label = {
        max_chars = 20,
    },
    y_offset = 30,
})

local spotify_album = sbar.add("item", "spotify.album", {
    position = "popup." .. spotify_anchor.name,
    icon = { drawing = false },
    padding_left = 0,
    padding_right = 0,
    width = 0,
    y_offset = 30,
    label = {
        max_chars = 20,
    },
})

local spotify_state = sbar.add("slider", "spotify.state", {
    position = "popup." .. spotify_anchor.name,
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
    script = plugin,
    update_freq = 1,
    updates = "when_shown",
})

local spotify_shuffle = sbar.add("item", "spotify.shuffle", {
    position = "popup." .. spotify_anchor.name,
    icon = {
        string = icons.spotify.shuffle,
        padding_left = 5,
        padding_right = 5,
        color = colors.black,
        highlight_color = colors.black,
    },
    label = { drawing = false },
    script = plugin,
    y_offset = -45,
})

local spotify_back = sbar.add("item", "spotify.back", {
    position = "popup." .. spotify_anchor.name,
    icon = {
        string = icons.spotify.back,
        padding_left = 5,
        padding_right = 5,
        color = colors.black,
    },
    label = { drawing = false },
    script = plugin,
    y_offset = -45,
})

local spotify_play = sbar.add("item", "spotify.play", {
    position = "popup." .. spotify_anchor.name,
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
    script = plugin,
    y_offset = -45,
})

local spotify_next = sbar.add("item", "spotify.next", {
    position = "popup." .. spotify_anchor.name,
    icon = {
        string = icons.spotify.next,
        padding_left = 5,
        padding_right = 5,
        color = colors.black,
    },
    label = { drawing = false },
    script = plugin,
    y_offset = -45,
})

local spotify_repeat = sbar.add("item", "spotify.repeat", {
    position = "popup." .. spotify_anchor.name,
    icon = {
        string = icons.spotify._repeat,
        padding_left = 5,
        padding_right = 10,
        color = colors.black,
        highlight_color = colors.black,
    },
    label = { drawing = false },
    script = plugin,
    y_offset = -45,
})

local spotify_spaces = sbar.add("item", "spotify.spacer", {
    position = "popup." .. spotify_anchor.name,
    width = 5,
})

local spotify_controls = sbar.add("bracket", "spotify.controls", {
    spotify_back.name,
    spotify_next.name,
    spotify_play.name,
    spotify_repeat.name,
    spotify_shuffle.name,
}, {
    -- position = "popup." .. spotify_anchor.name,
    background = {
        color = colors.green,
        corner_radius = 11,
        drawing = true,
    },
    y_offset = -45,
})

os.execute("bottombar -m --add event spotify_change " .. spotify_event)
-- os.execute "bottombar -m --set spotify.state --subscribe mouse.clicked"
