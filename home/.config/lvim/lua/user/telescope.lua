local M = {}
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local builtin = require "telescope.builtin"
local actions = require "telescope.actions"
local utils = require "telescope.utils"

M.file_ignore_patterns = {
    "vendor/*",
    "%.lock",
    "__pycache__/*",
    "%.sqlite3",
    "%.ipynb",
    "node_modules/*",
    "%.otf",
    "%.ttf",
    ".git/",
    "%.webp",
    ".dart_tool/",
    ".gradle/",
    ".idea/",
    ".settings/",
    ".vscode/",
    "__pycache__/",
    "build/",
    "env/",
    "target/",
    "%.pdb",
    "%.dll",
    "%.class",
    "%.exe",
    "%.cache",
    "%.pdf",
    "%.dylib",
    "%.jar",
    "%.docx",
    "%.met",
    "smalljre_*/*",
}

function M._multiopen(prompt_bufnr, open_cmd)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())
    local border_contents = picker.prompt_border.contents[1]
    if not (string.find(border_contents, "Find Files") or string.find(border_contents, "Git Files")) then
        actions.select_default(prompt_bufnr)
        return
    end
    if num_selections > 1 then
        vim.cmd "bw!"
        for _, entry in ipairs(picker:get_multi_selection()) do
            vim.cmd(string.format("%s %s", open_cmd, entry.value))
        end
        vim.cmd "stopinsert"
    else
        if open_cmd == "vsplit" then
            actions.file_vsplit(prompt_bufnr)
        elseif open_cmd == "split" then
            actions.file_split(prompt_bufnr)
        elseif open_cmd == "tabe" then
            actions.file_tab(prompt_bufnr)
        else
            actions.file_edit(prompt_bufnr)
        end
    end
end

function M.multi_selection_open_vsplit(prompt_bufnr)
    M._multiopen(prompt_bufnr, "vsplit")
end

function M.multi_selection_open_split(prompt_bufnr)
    M._multiopen(prompt_bufnr, "split")
end

function M.multi_selection_open_tab(prompt_bufnr)
    M._multiopen(prompt_bufnr, "tabe")
end

function M.multi_selection_open(prompt_bufnr)
    M._multiopen(prompt_bufnr, "edit")
end

M.get_theme = function(opts)
    if not opts then
        opts = {}
    end
    opts["layout_config"] = M.layout_config()
    opts["sorting_strategy"] = "descending"
    opts["borderchars"] = {
        prompt = { "???", "???", " ", "???", "???", "???", "???", "???" },
        results = { "???", "???", "???", "???", "???", "???", "???", "???" },
        preview = { "???", "???", "???", "???", "???", "???", "???", "???" },
    }
    return themes.get_ivy(opts)
end

function M.layout_config()
    return {
        width = 0.90,
        height = 0.4,
        preview_cutoff = 100,
        prompt_position = "bottom",
        horizontal = {
            preview_width = function(_, cols, _)
                return math.floor(cols * 0.6)
            end,
        },
        vertical = {
            width = 0.9,
            height = 0.4,
            preview_height = 0.5,
        },

        flex = {
            horizontal = {
                preview_width = 0.9,
            },
        },
    }
end

-- another file string search
M.find_string = function()
    local opts = {
        hidden = true,
    }
    -- builtin.live_grep(M.get_theme(opts))
    require("telescope").extensions.live_grep_args.live_grep_args(M.get_theme(opts))
end

-- another file string search
M.find_identifier = function()
    local opts = {
        hidden = true,
    }
    builtin.grep_string(M.get_theme(opts))
end
-- find files
M.find_files = function()
    local opts = {
        hidden = true,
    }
    builtin.find_files(M.get_theme(opts))
end

-- find only recent files
M.recent_files = function()
    local opts = {
        hidden = true,
    }
    builtin.oldfiles(M.get_theme(opts))
end

M.diagnostics = function()
    builtin.diagnostics(M.get_theme())
end

-- Extensions
M.file_browser = function()
    require("telescope").extensions.file_browser.file_browser(M.get_theme())
end

M.projects = function()
    require("telescope").extensions.repo.list(M.get_theme())
end

M.zoxide = function()
    require("telescope").extensions.zoxide.list(M.get_theme())
end

M.persisted = function()
    require("telescope").extensions.persisted.persisted(M.get_theme())
end

-- show refrences to this using language server
M.lsp_references = function()
    builtin.lsp_references(M.get_theme())
end

-- show implementations of the current thingy using language server
M.lsp_implementations = function()
    builtin.lsp_implementations(M.get_theme())
end

-- find files in the upper directory
M.find_updir = function()
    local up_dir = vim.fn.getcwd():gsub("(.*)/.*$", "%1")
    local opts = {
        cwd = up_dir,
    }

    builtin.find_files(M.get_theme(opts))
end

M.git_status = function()
    builtin.git_status(M.get_theme())
end

M.search_only_certain_files = function()
    local opts = {
        find_command = {
            "rg",
            "--files",
            "--type",
            vim.fn.input "Type: ",
        },
    }
    builtin.find_files(M.get_theme(opts))
end

M.builtin = function()
    builtin.builtin()
end

M.git_files = function()
    local path = vim.fn.expand "%:h"
    if path == "" then
        path = nil
    end

    local opts = {
        cwd = path,
        file_ignore_patterns = {
            "^[.]vale/",
        },
    }

    builtin.git_files(M.get_theme(opts))
end

M.grep_string_visual = function()
    local visual_selection = function()
        local save_previous = vim.fn.getreg "a"
        vim.api.nvim_command 'silent! normal! "ay'
        local selection = vim.fn.trim(vim.fn.getreg "a")
        vim.fn.setreg("a", save_previous)
        return vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
    end
    builtin.live_grep {
        M.get_theme {
            default_text = visual_selection(),
        },
    }
end

M.buffers = function()
    builtin.buffers(M.get_theme())
end

M.resume = function()
    builtin.resume(M.get_theme())
end

M.spell_suggest = function()
    builtin.spell_suggest(M.get_theme())
end

M.config = function()
    -- Telescope
    local icons = require("user.icons").icons
    lvim.builtin.telescope.defaults.dynamic_preview_title = true
    lvim.builtin.telescope.defaults.layout_config = M.layout_config()
    lvim.builtin.telescope.defaults.path_display = function(opts, path)
        local function table_lenght(table)
            local count = 0
            for _ in pairs(table) do
                count = count + 1
            end
            return count
        end

        local function subrange(t, first, last)
            local sub = {}
            for i = first, last do
                sub[#sub + 1] = t[i]
            end
            return sub
        end

        local os_sep = utils.get_separator()
        local split_path = vim.split(path, os_sep)
        local path_count = table_lenght(split_path)
        if path_count == nil then
            return path
        end
        local start = path_count - lvim.builtin.telescope.max_path_length
        if start > 0 then
            local short_path = subrange(split_path, start, path_count)
            return string.format("%s", table.concat(short_path, os_sep))
        else
            return string.format("%s", path)
        end
    end
    lvim.builtin.telescope.defaults.prompt_prefix = icons.term .. " "
    lvim.builtin.telescope.defaults.borderchars = {
        prompt = { "???", "???", "???", "???", "???", "???", "???", "???" },
        results = { "???", "???", "???", "???", "???", "???", "???", "???" },
        preview = { " ", "???", " ", "???", "???", "???", "???", "???" },
    }
    lvim.builtin.telescope.defaults.selection_caret = "  "
    lvim.builtin.telescope.defaults.cache_picker = { num_pickers = 3 }
    lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
    lvim.builtin.telescope.defaults.color_devicons = true
    local user_telescope = require "user.telescope"
    lvim.builtin.telescope.defaults.mappings = {
        i = {
            ["<esc><esc>"] = actions.close,
            ["<c-c>"] = actions.close,
            ["<c-y>"] = actions.which_key,
            ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<c-n>"] = actions.cycle_history_next,
            ["<c-p>"] = actions.cycle_history_prev,
            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<cr>"] = user_telescope.multi_selection_open,
            ["<c-v>"] = user_telescope.multi_selection_open_vsplit,
            ["<c-s>"] = user_telescope.multi_selection_open_split,
            ["<c-t>"] = user_telescope.multi_selection_open_tab,
        },
        n = {
            ["<esc>"] = actions.close,
            ["<c-c>"] = actions.close,
            ["<c-y>"] = actions.which_key,
            ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<c-n>"] = actions.cycle_history_next,
            ["<c-p>"] = actions.cycle_history_prev,
            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<cr>"] = user_telescope.multi_selection_open,
            ["<c-v>"] = user_telescope.multi_selection_open_vsplit,
            ["<c-s>"] = user_telescope.multi_selection_open_split,
            ["<c-t>"] = user_telescope.multi_selection_open_tab,
        },
    }

    lvim.builtin.telescope.defaults.file_ignore_patterns = M.file_ignore_patterns

    lvim.builtin.telescope.on_config_done = function(telescope)
        telescope.load_extension "luasnip"
        telescope.load_extension "zoxide"
        telescope.load_extension "repo"
        telescope.load_extension "file_browser"
        telescope.load_extension "live_grep_args"
        telescope.load_extension "persisted"
    end
end

return M
