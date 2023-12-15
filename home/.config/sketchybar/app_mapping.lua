local module = {}

local ICON_MAP = {
    { regex = "1Password 7", icon = ":one_password:" },
    { regex = "Affinity Designer", icon = ":affinity_designer:" },
    { regex = "Affinity Photo", icon = ":affinity_photo:" },
    { regex = "Affinity Publisher", icon = ":affinity_publisher:" },
    { regex = "Airmail", icon = ":airmail:" },
    { regex = "kitty", icon = ":terminal:" },
    { regex = "Hyper", icon = ":terminal:" },
    { regex = "iTerm2", icon = ":terminal:" },
    { regex = "Terminal", icon = ":terminal:" },
    { regex = "WezTerm", icon = ":terminal:" },
    { regex = "Alfred", icon = ":alfred:" },
    { regex = "Android Messages", icon = ":android_messages:" },
    { regex = "Android Studio", icon = ":android_studio:" },
    { regex = "App Store", icon = ":app_store:" },
    { regex = "Atom", icon = ":atom:" },
    { regex = "Audacity", icon = ":audacity:" },
    { regex = "Bear", icon = ":bear:" },
    { regex = "Bitwarden", icon = ":bit_warden:" },
    { regex = "Blender", icon = ":blender:" },
    { regex = "Brave Browser", icon = ":brave_browser:" },
    { regex = "Calendar", icon = ":calendar:" },
    { regex = "Fantastical", icon = ":calendar:" },
    { regex = "Calibre", icon = ":book:" },
    { regex = "Canary Mail", icon = ":mail:" },
    { regex = "HEY", icon = ":mail:" },
    { regex = "Mail", icon = ":mail:" },
    { regex = "Mailspring", icon = ":mail:" },
    { regex = "MailMate", icon = ":mail:" },
    { regex = "邮件", icon = ":mail:" },
    { regex = "Outlook", icon = ":mail:" },
    { regex = "Caprine", icon = ":caprine:" },
    { regex = "Chromium", icon = ":google_chrome:" },
    { regex = "Google Chrome", icon = ":google_chrome:" },
    { regex = "Google Chrome Canary", icon = ":google_chrome:" },
    { regex = "CleanMyMac X", icon = ":desktop:" },
    { regex = "ClickUp", icon = ":click_up:" },
    { regex = "Code", icon = ":code:" },
    { regex = "Code - Insiders", icon = ":code:" },
    { regex = "Color Picker", icon = ":color_picker:" },
    { regex = "DataGrip", icon = ":datagrip:" },
    { regex = "Default", icon = ":default:" },
    { regex = "DEVONthink 3", icon = ":devonthink3:" },
    { regex = "Discord", icon = ":discord:" },
    { regex = "Discord Canary", icon = ":discord:" },
    { regex = "Discord PTB", icon = ":discord:" },
    { regex = "Drafts", icon = ":drafts:" },
    { regex = "Dropbox", icon = ":dropbox:" },
    { regex = "Element", icon = ":element:" },
    { regex = "Emacs", icon = ":emacs:" },
    { regex = "Evernote Legacy", icon = ":evernote_legacy:" },
    { regex = "FaceTime", icon = ":face_time:" },
    { regex = "Figma", icon = ":figma:" },
    { regex = "Final Cut Pro", icon = ":final_cut_pro:" },
    { regex = "Finder", icon = ":finder:" },
    { regex = "访达", icon = ":finder:" },
    {
        regex = "Firefox Nightly",
        icon = ":firefox_developer_edition:",
    },
    {
        regex = "Firefox Developer Edition",
        icon = ":firefox_developer_edition:",
    },
    { regex = "Firefox", icon = ":firefox:" },
    { regex = "Folx", icon = ":folx:" },
    { regex = "GitHub Desktop", icon = ":git_hub:" },
    { regex = "Grammarly Editor", icon = ":grammarly:" },
    { regex = "GrandTotal|Receipts", icon = ":dollar:" },
    { regex = "IINA", icon = ":playing:" },
    { regex = "Insomnia", icon = ":insomnia:" },
    { regex = "IntelliJ IDEA", icon = ":idea:" },
    { regex = "Iris", icon = ":iris:" },
    { regex = "Joplin", icon = ":joplin:" },
    { regex = "Kakoune", icon = ":kakoune:" },
    { regex = "KeePassXC", icon = ":kee_pass_x_c:" },
    { regex = "Keyboard Maestro", icon = ":keyboard_maestro:" },
    { regex = "Keynote", icon = ":keynote:" },
    { regex = "League of Legends", icon = ":league_of_legends:" },
    { regex = "LibreWolf", icon = ":libre_wolf:" },
    { regex = "Linear", icon = ":linear:" },
    { regex = "Live", icon = ":ableton:" },
    { regex = "MAMP", icon = ":mamp:" },
    { regex = "MAMP PRO", icon = ":mamp:" },
    { regex = "Matlab", icon = ":matlab:" },
    { regex = "Mattermost", icon = ":mattermost:" },
    { regex = "Messages", icon = ":messages:" },
    { regex = "Microsoft Edge", icon = ":microsoft_edge:" },
    { regex = "Microsoft Excel", icon = ":microsoft_excel:" },
    { regex = "Microsoft PowerPoint", icon = ":microsoft_power_point:" },
    { regex = "Microsoft Teams", icon = ":microsoft_teams:" },
    { regex = "Microsoft To Do|Things", icon = ":things:" },
    { regex = "Microsoft Word", icon = ":microsoft_word:" },
    { regex = "Min", icon = ":min_browser:" },
    { regex = "MoneyMoney", icon = ":bank:" },
    { regex = "mpv", icon = ":mpv:" },
    { regex = "Music", icon = ":music:" },
    { regex = "neovide", icon = ":vim:" },
    { regex = "Neovide", icon = ":vim:" },
    { regex = "MacVim", icon = ":vim:" },
    { regex = "Vim", icon = ":vim:" },
    { regex = "VimR", icon = ":vim:" },
    { regex = "Notability", icon = ":notability:" },
    { regex = "Notes", icon = ":notes:" },
    { regex = "Notion", icon = ":notion:" },
    { regex = "Nova", icon = ":nova:" },
    { regex = "Numbers", icon = ":numbers:" },
    { regex = "OBS", icon = ":obsstudio:" },
    { regex = "Obsidian", icon = ":obsidian:" },
    { regex = "OmniFocus", icon = ":omni_focus:" },
    { regex = "Pages", icon = ":pages:" },
    { regex = "Parallels Desktop", icon = ":parallels:" },
    { regex = "Pi-hole Remote", icon = ":pihole:" },
    { regex = "Pine", icon = ":pine:" },
    { regex = "Podcasts", icon = ":podcasts:" },
    { regex = "PomoDone App", icon = ":pomodone:" },
    { regex = "Preview", icon = ":pdf:" },
    { regex = "Skim", icon = ":pdf:" },
    { regex = "zathura", icon = ":pdf:" },
    { regex = "qutebrowser", icon = ":qute_browser:" },
    { regex = "Reeder", icon = ":reeder5:" },
    { regex = "Reminders", icon = ":reminders:" },
    { regex = "Safari", icon = ":safari:" },
    { regex = "Safari Technology Preview", icon = ":safari:" },
    { regex = "Sequel Ace", icon = ":sequel_ace:" },
    { regex = "Sequel Pro", icon = ":sequel_pro:" },
    { regex = "Setapp", icon = ":setapp:" },
    { regex = "Signal", icon = ":signal:" },
    { regex = "Sketch", icon = ":sketch:" },
    { regex = "Skype", icon = ":skype:" },
    { regex = "Slack", icon = ":slack:" },
    { regex = "Spark", icon = ":spark:" },
    { regex = "Spotify", icon = ":spotify:" },
    { regex = "Spotlight", icon = ":spotlight:" },
    { regex = "Sublime Text", icon = ":sublime_text:" },
    { regex = "System Preferences", icon = ":gear:" },
    { regex = "System Settings", icon = ":gear:" },
    { regex = "TeamSpeak 3", icon = ":team_speak:" },
    { regex = "Telegram", icon = ":telegram:" },
    { regex = "Thunderbird", icon = ":thunderbird:" },
    { regex = "TickTick", icon = ":tick_tick:" },
    { regex = "TIDAL", icon = ":tidal:" },
    { regex = "Todoist", icon = ":todoist:" },
    { regex = "Tor Browser", icon = ":tor_browser:" },
    { regex = "Tower", icon = ":tower:" },
    { regex = "Transmit", icon = ":transmit:" },
    { regex = "Trello", icon = ":trello:" },
    { regex = "Twitter", icon = ":twitter:" },
    { regex = "Twitter", icon = ":twitter:" },
    { regex = "Typora", icon = ":text:" },
    { regex = "Vivaldi", icon = ":vivaldi:" },
    { regex = "VLC", icon = ":vlc:" },
    { regex = "VMware Fusion", icon = ":vmware_fusion:" },
    { regex = "VSCodium", icon = ":vscodium:" },
    { regex = "WebStorm", icon = ":web_storm:" },
    { regex = "WhatsApp", icon = ":whats_app:" },
    { regex = "Xcode", icon = ":xcode:" },
    { regex = "Zeplin", icon = ":zeplin:" },
    { regex = "zoom.us", icon = ":zoom:" },
    { regex = "Zotero", icon = ":zotero:" },
    { regex = "Zulip", icon = ":zulip:" },
    { regex = "微信", icon = ":wechat:" },
    { regex = "网易云音乐", icon = ":netease_music:" },
}

local SUPS = {
    ["0"] = "\u{2070}",
    ["1"] = "\u{00B9}",
    ["2"] = "\u{00B2}",
    ["3"] = "\u{00B3}",
    ["4"] = "\u{2074}",
    ["5"] = "\u{2075}",
    ["6"] = "\u{2076}",
    ["7"] = "\u{2077}",
    ["8"] = "\u{2078}",
    ["9"] = "\u{2079}",
}

local function to_sup(s)
    local result = ""
    for i = 1, #s do
        local char = s:sub(i, i)
        result = result .. (SUPS[char] or char)
    end

    return result
end

local function to_icon(app)
    for _, x in ipairs(ICON_MAP) do
        if string.match(app, x.regex) then
            return x.icon
        end
    end

    return ":default:"
end

local function to_formatted_icon(app, c)
    local cnt = c > 1 and " " .. to_sup(tostring(c)) or ""
    return to_icon(app) .. cnt
end

module.icons = function(apps)
    local formatted_icons = {}
    for app, cnt in pairs(apps) do
        table.insert(formatted_icons, to_formatted_icon(app, cnt))
    end
    return table.concat(formatted_icons, " ")
end

return module
