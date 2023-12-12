------------------------------------------
-- Spoons
------------------------------------------
hs.loadSpoon "EmmyLua"
hs.loadSpoon "MicMute"

-- Clipboard
hs.loadSpoon "TextClipboardHistory"
spoon.TextClipboardHistory.show_in_menubar = false
spoon.TextClipboardHistory:start()
spoon.TextClipboardHistory:bindHotkeys { toggle_clipboard = { { "cmd", "option" }, "h" } }

-- Teams remaps
hs.loadSpoon "AppBindings"
spoon.AppBindings:bind("Microsoft Teams (work or school)", {
    { { "ctrl" }, "i", { "ctrl" }, "r" }, -- Focus input box
    { { "ctrl" }, "k", { "shift", "fn" }, "f10" }, -- Open context menu
})

------------------------------------------
-- Load configuration
------------------------------------------
require "hs.ipc"
local wm = require "wm"
wm.init()

-- Enable stackline
local stackline = require "stackline"
stackline:init {
    paths = {
        yabai = require("helpers").yabai_bin,
    },
}

hs
    .notify
    .new({
        title = "Hammerspoon",
        informativeText = "Started hammerspoon with ordered spaces " .. hs.inspect.inspect(wm.ordered_spaces),
    })
    ---@diagnostic disable-next-line: undefined-field
    :send()
