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
    if not (
        string.find(border_contents, "Find Files")
            or string.find(border_contents, "Git Files")
            or string.find(border_contents, "Sessions")
        )
    then
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
    opts["layout_config"]["preview_width"] = 0.4
    opts["sorting_strategy"] = "descending"
    return themes.get_ivy(opts)
end

function M.layout_config()
    return {
        width = 0.9,
        height = 0.4,
        preview_cutoff = 150,
        prompt_position = "bottom",
        horizontal = {
            preview_width = 0.32,
        },
        vertical = {
            width = 0.9,
            height = 0.4,
            preview_height = 0.5,
        },
        flex = {
            horizontal = {
                preview_width = 0.4,
            },
        },
    }
end

-- another file string search
M.find_string = function()
    local opts = {
        hidden = true,
    }
    builtin.live_grep(M.get_theme(opts))
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

M.noice = function()
    local opts = M.get_theme()
    opts["previewer"] = false
    require("telescope").extensions.noice.noice(opts)
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

M.neoclip = function()
    require("telescope").extensions.neoclip.neoclip(M.get_theme())
end

M.frecency = function()
    require("telescope").extensions.frecency.frecency(M.get_theme())
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

M.find_string_visual = function()
    local visual_selection = function()
        local save_previous = vim.fn.getreg "a"
        vim.api.nvim_command 'silent! normal! "ay'
        local selection = vim.fn.trim(vim.fn.getreg "a")
        vim.fn.setreg("a", save_previous)
        local ret = vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
        return ret
    end
    local opts = M.get_theme()
    opts["default_text"] = visual_selection()
    builtin.live_grep(opts)
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

M.table_lenght = function(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

M.subrange = function(table, first, last)
    local sub = {}
    for i = first, last do
        sub[#sub + 1] = table[i]
    end
    return sub
end

M.path_display = function()
    return function(opts, path)
        local os_sep = utils.get_separator()
        local split_path = vim.split(path, os_sep)
        local path_count = M.table_lenght(split_path)
        if path_count == nil then
            return path
        end
        local start = path_count - lvim.builtin.telescope.max_path_length
        if start > 0 then
            local short_path = M.subrange(split_path, start, path_count)
            return string.format("%s", table.concat(short_path, os_sep))
        else
            return string.format("%s", path)
        end
    end
end

M.find_project_files = function(opts)
    opts = opts or {}
    if opts.cwd then
        opts.cwd = vim.fn.expand(opts.cwd)
    else
        opts.cwd = vim.loop.cwd()
    end

    local _, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)
    if ret ~= 0 then
        local in_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
        local in_bare = utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)
        if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
            builtin.find_files(M.get_theme(opts))
            return
        end
    end
    builtin.git_files(M.get_theme(opts))
end

M.config = function()
    -- Telescope
    local icons = require("user.icons").icons
    lvim.builtin.telescope.defaults.dynamic_preview_title = true
    lvim.builtin.telescope.defaults.layout_config = M.layout_config()
    lvim.builtin.telescope.defaults.path_display = M.path_display()
    lvim.builtin.telescope.defaults.prompt_prefix = icons.term .. " "
    lvim.builtin.telescope.defaults.borderchars = {
        prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    }
    lvim.builtin.telescope.defaults.selection_caret = icons.right
    lvim.builtin.telescope.defaults.cache_picker = { num_pickers = 5 }
    lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
    lvim.builtin.telescope.defaults.color_devicons = true
    lvim.builtin.telescope.defaults.mappings = {
        i = {
            ["<esc>"] = actions.close,
            ["<c-c>"] = actions.close,
            ["<c-y>"] = actions.which_key,
            ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<c-n>"] = actions.cycle_history_next,
            ["<c-p>"] = actions.cycle_history_prev,
            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<cr>"] = M.multi_selection_open,
            ["<c-v>"] = M.multi_selection_open_vsplit,
            ["<c-s>"] = M.multi_selection_open_split,
            ["<c-t>"] = M.multi_selection_open_tab,
            ["<C-d>"] = actions.delete_buffer,
            ["<C-x>"] = require("telescope.actions.layout").toggle_preview,
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
            ["<cr>"] = M.multi_selection_open,
            ["<c-v>"] = M.multi_selection_open_vsplit,
            ["<c-s>"] = M.multi_selection_open_split,
            ["<c-t>"] = M.multi_selection_open_tab,
            ["<C-x>"] = require("telescope.actions.layout").toggle_preview,
            ["dd"] = require("telescope.actions").delete_buffer,
        },
    }

    lvim.builtin.telescope.defaults.file_ignore_patterns = M.file_ignore_patterns

    local telescope_actions = require "telescope.actions.set"
    lvim.builtin.telescope.pickers.git_files = {
        hidden = true,
        show_untracked = true,
        layout_strategy = "horizontal",
    }
    lvim.builtin.telescope.pickers.live_grep = {
        only_sort_text = true,
        layout_strategy = "horizontal",
    }
    lvim.builtin.telescope.pickers.find_files = {
        layout_strategy = "horizontal",
        attach_mappings = function(_)
            telescope_actions.select:enhance {
                post = function()
                    vim.cmd ":normal! zx"
                end,
            }
            return true
        end,
        find_command = { "fd", "--type=file", "--hidden" },
    }

    lvim.builtin.telescope.on_config_done = function(telescope)
        telescope.load_extension "luasnip"
        telescope.load_extension "zoxide"
        telescope.load_extension "repo"
        telescope.load_extension "file_browser"
        telescope.load_extension "persisted"
        telescope.load_extension "neoclip"
        telescope.extensions.frecency.settings = {
            show_scores = true,
            show_unindexed = true,
            ignore_patterns = { "*.git/*", "*/tmp/*", "*/target/*" },
            workspaces = {
                ["github"] = "/home/matbigoi/github",
                ["smithy-rs"] = "/home/matbigoi/github/smithy-rs",
                ["workplace"] = "/home/matbigoi/workplace",
            },
        }
        telescope.load_extension "frecency"
    end
end

return M
