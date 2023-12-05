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
require("wm").init()
require("keybinding").init()
