local M = {}
-- local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local builtin = require "telescope.builtin"

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

M.get_theme = function(opts)
    if not opts then
        opts = {
            layout_config = {
                prompt_position = "bottom",
            },
        }
    end
    if opts["layout_config"] ~= nil then
        opts["layout_config"]["prompt_position"] = "bottom"
    else
        opts["layout_config"] = {
            prompt_position = "bottom",
        }
    end
    opts["sorting_strategy"] = "descending"
    opts["borderchars"] = {
        prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
        results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    }
    return themes.get_ivy(opts)
end

M.preview_layout_config = function()
    if not lvim.builtin.telescope_preview then
        return {
            preview_width = 0.0,
        }
    else
        return {}
    end
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
        layout_config = M.preview_layout_config(),
    }
    builtin.find_files(M.get_theme(opts))
end

-- find only recent files
M.frecency = function()
    local opts = {
        hidden = true,
        layout_config = M.preview_layout_config(),
    }
    require("telescope").extensions.frecency.frecency(M.get_theme(opts))
end

-- find only recent files
M.recent_files = function()
    local opts = {
        hidden = true,
        layout_config = M.preview_layout_config(),
    }
    builtin.oldfiles(M.get_theme(opts))
end

M.diagnostics = function()
    builtin.diagnostics(M.get_theme())
end

-- Extensions
M.raw_grep = function()
    require("telescope").extensions.live_grep_args.live_grep_args(M.get_theme())
end

M.file_browser = function()
    require("telescope").extensions.file_browser.file_browser(M.get_theme())
end

M.projects = function()
    require("telescope").extensions.repo.list(M.get_theme())
end

M.zoxide = function()
    require("telescope").extensions.zoxide.list(M.get_theme())
end

M.tele_tabby = function()
    require("telescope").extensions.tele_tabby.list(M.get_theme())
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
    local opts = {
        layout_config = M.preview_layout_config(),
    }
    builtin.buffers(M.get_theme(opts))
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
    lvim.builtin.telescope.defaults.path_display = { shorten = 8 }
    lvim.builtin.telescope.defaults.prompt_prefix = icons.term .. " "
    lvim.builtin.telescope.defaults.borderchars = {
        prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        results = { "─", "▐", "─", "│", "╭", "▐", "▐", "╰" },
        -- results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
        preview = { " ", "│", " ", "▌", "▌", "╮", "╯", "▌" },
    }
    lvim.builtin.telescope.defaults.selection_caret = "  "
    lvim.builtin.telescope.defaults.cache_picker = { num_pickers = 3 }
    lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
    lvim.builtin.telescope.defaults.color_devicons = true
    local actions = require "telescope.actions"
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
        },
    }

    lvim.builtin.telescope.defaults.file_ignore_patterns = M.file_ignore_patterns
    local telescope_actions = require "telescope.actions.set"
    lvim.builtin.telescope.defaults.pickers.find_files = {
        attach_mappings = function(_)
            telescope_actions.select:enhance {
                post = function()
                    vim.cmd ":normal! zx"
                end,
            }
            return true
        end,
        find_command = { "fd", "--type=file", "--hidden", "--smart-case" },
    }

    lvim.builtin.telescope.on_config_done = function(telescope)
        -- lvim.builtin.telescope.extensions.frecency = {
        --     show_scores = true,
        --     show_unindexed = true,
        --     ignore_patterns = M.file_ignore_patterns,
        --     disable_devicons = false,
        --     auto_validate = false,
        --     workspaces = {
        --         ["github"] = "/home/matbigoi/github/",
        --         ["amzn"] = "/home/matbigoi/workplace/",
        --     },
        -- }
        -- telescope.load_extension "frecency"
        telescope.load_extension "luasnip"
        telescope.load_extension "ui-select"
        telescope.load_extension "zoxide"
        telescope.load_extension "repo"
        telescope.load_extension "file_browser"
        telescope.load_extension "tele_tabby"
        telescope.load_extension "gradle"
        telescope.load_extension "live_grep_args"
    end
end

return M
