local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local json = require "cjson"

local module = {}
local IMPORTANT_MATCHES = { "deprecat", "break", "broke", "bug" }

module.notify = sbar.add("item", "notify", {
    position = "right",
    icon = {
        string = icons.bell.default,
        font = {
            style = "Bold",
            size = 16.0,
        },
    },
    label = {
        string = icons.loading,
        highlight_color = colors.blue,
    },
    popup = {
        align = "right",
    },
    update_freq = 180,
    updates = true,
    y_offset = 1,
})

local function update_github()
    local total_notifications = 0
    local bell_red = false
    local notifications = helpers.runcmd "gh api notifications"
    if notifications and type(notifications) == "table" then
        total_notifications = total_notifications + helpers.length(notifications)
        local color = colors.blue
        for idx, notification in pairs(notifications) do
            local repo = notification.repository.name
            local title = notification.subject.title
            local icon = ""
            if repo ~= "" or title ~= "" then
                local url = notification.subject.latest_comment_url
                local type = notification.subject.type
                local open = nil
                if type == "Issue" then
                    color = colors.green
                    icon = icons.git.issue
                    local u = helpers.runcmd(string.format("gh api '%s'", url))
                    if u then
                        open = u["html_url"]
                    end
                elseif type == "Discussion" then
                    color = colors.white
                    icon = icons.git.discussion
                    open = "https://www.github.com/notifications"
                elseif type == "PullRequest" then
                    color = colors.magenta
                    icon = icons.git.pull_request
                    local u = helpers.runcmd(string.format("gh api '%s'", url))
                    if u then
                        open = u["html_url"]
                    end
                elseif type == "Commit" then
                    color = colors.white
                    icon = icons.git.commit
                    local u = helpers.runcmd(string.format("gh api '%s'", url))
                    if u then
                        open = u["html_url"]
                    end
                end
                if helpers.match(IMPORTANT_MATCHES, title) then
                    bell_red = true
                    color = colors.red
                end

                local item
                sbar.add("item", "notify.github." .. idx, {
                    label = title,
                    icon = {
                        string = string.format("%s %s %s", icons.github, repo, icon),
                        color = color,
                    },
                    position = "popup." .. module.notify.name,
                    drawing = true,
                    padding_left = 8,
                    padding_right = 15,
                    click_script = string.format(
                        "open '%s'; bottombar --set notify popup.drawing=off; sleep 5; bottombar --trigger notify_update",
                        open
                    ),
                })
            end
        end
    end
    return total_notifications, bell_red
end

local function app_notifications(app)
    local n = 0
    local result = helpers.runcmd(string.format('lsappinfo info -only StatusLabel "%s"', app))
    if result then
        local raw_data = result:gsub('"StatusLabel"=', "")
        local ok, notifications = pcall(json.decode, raw_data)
        if ok then
            n = tonumber(notifications.label)
        end
    end
    return n
end

local function app_line(name, label, color, open, icon)
    sbar.add("item", "notify.apps." .. name, {
        label = string.format("%s - %s", open, label),
        icon = {
            string = icon,
            font = {
                family = "sketchybar-app-font",
                style = "Regular",
                size = 16.0,
            },
            color = color,
        },
        position = "popup." .. module.notify.name,
        drawing = true,
        click_script = string.format(
            'open "%s"; bottombar --set notify popup.drawing=off; sleep 5; bottombar --trigger notify_update',
            open
        ),
    })
end

local function cleanup()
    os.execute "bottombar --remove '/notify.apps.*/'"
    os.execute "bottombar --remove '/notify.github.*/'"
    os.execute "bottombar --remove '/notify.gitlab.*/'"
end

local function update_apps()
    cleanup()
    local template = "unread notifications: %s"
    local teams = app_notifications "Microsoft Teams (work or school)"
    local outlook = app_notifications "Microsoft Outlook"
    local signal = app_notifications "Signal"
    local total_notifications = teams + outlook + signal
    sbar.add("item", "notify.apps.header", {
        label = "Apps notifications: " .. total_notifications,
        icon = {
            string = ":messages:",
            font = {
                family = "sketchybar-app-font",
                style = "Regular",
                size = 16.0,
            },
            color = colors.blue,
        },
        position = "popup." .. module.notify.name,
        drawing = true,
    })
    if teams > 0 then
        app_line(
            "teams",
            string.format(template, teams),
            colors.magenta,
            "Microsoft Teams (work or school)",
            ":microsoft_teams:"
        )
    end
    if outlook > 0 then
        app_line("outlook", string.format(template, outlook), colors.red, "Microsoft Outlook", ":mail:")
    end
    if signal > 0 then
        app_line("signal", string.format(template, signal), colors.orange, "Signal", ":signal:")
    end
end

module.update = function()
    cleanup()
    local bell_red = false
    local previous_count = 0
    local previous_info = sbar.query "notify"
    if previous_info then
        local prev = previous_info.label.value
        if prev and prev ~= icons.loading then
            previous_count = tonumber(prev)
        end
    end

    local total_notifications, bell_red = update_github()
    local ok, gitlab = pcall(require, "items.gitlab")
    if ok then
        local gitlab_total_notifications, gitlab_bell_red = gitlab.update()
        total_notifications = total_notifications + gitlab_total_notifications
        bell_red = bell_red or gitlab_bell_red
    end

    if total_notifications == 0 then
        sbar.add("item", "notify.github.1", {
            label = icons.bell.dot .. " No new notifications",
            position = "popup." .. module.notify.name,
            drawing = true,
            padding_left = 8,
            padding_right = 15,
        })
        module.notify:set { icon = { string = icons.bell.dot, color = colors.blue }, label = { drawing = false } }
    else
        module.notify:set {
            icon = { color = colors.blue },
            label = { string = tostring(total_notifications), drawing = true },
        }
    end
    if total_notifications > previous_count then
        sbar.animate("tanh", 15, function()
            module.notify:set { label = { y_offset = 5 } }
            module.notify:set { label = { y_offset = 0 } }
        end)
    end
    if bell_red or bell_red then
        module.notify:set { icon = { color = colors.red } }
    end
end

module.notify:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "left" then
        module.notify:set { popup = { drawing = "toggle" } }
    end
    if env.BUTTON == "right" then
        module.update()
    end
    if env.MODIFIER == "shift" then
        update_apps()
    end
end)

module.notify:subscribe("mouse.exited.global", function()
    module.notify:set { popup = { drawing = false } }
end)
module.notify:subscribe("force", module.update)
module.notify:subscribe("routine", module.update)
module.notify:subscribe("notify_update", module.update)

return module
