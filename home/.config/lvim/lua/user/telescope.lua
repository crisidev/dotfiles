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
    "%.jpg",
    "%.jpeg",
    "%.png",
    "%.svg",
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
    "gradle/",
    "node_modules/",
    "target/",
    "%.pdb",
    "%.dll",
    "%.class",
    "%.exe",
    "%.cache",
    "%.ico",
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

-- another file string search
M.find_string = function()
    local opts = {
        hidden = true,
        shorten_path = false,
    }
    builtin.live_grep(M.get_theme(opts))
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
M.raw_grep = function()
    require("telescope").extensions.live_grep_raw.live_grep_raw(M.get_theme())
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

M.file_create = function()
    require("telescope").extensions.file_create.file_create(M.get_theme())
end

-- show code actions in a fancy floating window
M.code_actions = function()
    builtin.lsp_code_actions(M.get_theme {
        layout_config = {
            height = 12,
        },
    })
end

-- show refrences to this using language server
M.codelens_actions = function()
    builtin.lsp_codelens_actions(M.get_theme {
        layout_config = {
            height = 12,
        },
    })
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
    builtin.git_status(M.get_theme(opts))
end

M.search_only_certain_files = function()
    builtin.find_files {
        M.get_theme {
            find_command = {
                "rg",
                "--files",
                "--type",
                vim.fn.input "Type: ",
            },
        },
    }
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
    local icons = require("user.lsp").icons
    lvim.builtin.telescope.defaults.dynamic_preview_title = true
    lvim.builtin.telescope.defaults.path_display = { shorten = 10 }
    lvim.builtin.telescope.defaults.prompt_prefix = icons.codelens .. " "
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
        telescope.load_extension "luasnip"
        telescope.load_extension "ui-select"
        telescope.load_extension "file_create"
        telescope.load_extension "zoxide"
        telescope.load_extension "repo"
        if lvim.builtin.file_browser.active then
            telescope.load_extension "file_browser"
        end
    end
end

return M
