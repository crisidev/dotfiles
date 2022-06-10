local M = {}

local function truncate(str, max_len)
    assert(str and max_len, "string and max_len must be provided")
    return vim.api.nvim_strwidth(str) > max_len and str:sub(1, max_len) .. "…" or str
end

local function table_slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

local function render(props)
    local fmt = string.format
    local devicons = require "nvim-web-devicons"
    local bufname = vim.api.nvim_buf_get_name(props.buf)
    if bufname == "" then
        return "[No name]"
    end
    local ret = vim.api.nvim_get_hl_by_name("Directory", true)
    local directory_color = string.format("#%06x", ret["foreground"])
    local parts = vim.split(vim.fn.fnamemodify(bufname, ":."), "/")
    local result = {}
    local icon, color = devicons.get_icon_color(bufname, nil, { default = true })
    table.insert(result, { icon .. " ", guifg = color })
    for idx, part in ipairs(parts) do
        if next(parts, idx) then
            vim.list_extend(result, {
                { truncate(part, 20) },
                { fmt(" %s ", ""), guifg = directory_color },
            })
        else
            table.insert(result, { part, gui = "bold", guisp = color })
        end
    end
    local tot = #result
    if tot > 10 then
        local t = table.move(result, tot - 10, tot, 1, {})
        table.insert(t, 1, { icon .. " ", guifg = color })
        return t
    else
        return result
    end
end

M.config = function()
    local status_ok, incl = pcall(require, "incline")
    if not status_ok then
        return
    end

    incl.setup {
        window = {
            zindex = 49,
            winhighlight = {
                inactive = {
                    Normal = "Directory",
                },
            },
            width = "fit",
            padding = { left = 2, right = 1 },
            placement = { vertical = "top", horizontal = "right" },
            margin = {
                horizontal = 0,
            },
        },
        hide = {
            cursorline = false,
            focused_win = false,
            only_win = false,
        },
        render = render,
    }
end

return M
