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
    ".cargo/",
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

-- another file string search
function M.find_string()
    local opts = {
        hidden = true,
    }
    builtin.live_grep(opts)
end

-- find files
function M.find_files()
    local opts = {
        hidden = true,
    }
    builtin.find_files(opts)
end

-- find only recent files
function M.recent_files()
    local opts = {
        hidden = true,
    }
    builtin.oldfiles(opts)
end

-- find only recent files
function M.projects()
    require("telescope").extensions.repo.list {}
end

function M.zoxide()
    require("telescope").extensions.zoxide.list {}
end

function M.command_palette()
    require("telescope").extensions.command_palette.command_palette()
end

-- show code actions in a fancy floating window
function M.code_actions()
    local opts = {
        winblend = 0,
        layout_config = {
            prompt_position = "bottom",
            width = 80,
            height = 12,
        },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        previewer = false,
        shorten_path = false,
    }
    builtin.lsp_code_actions(themes.get_dropdown(opts))
end

function M.codelens_actions()
    local opts = {
        winblend = 0,
        layout_config = {
            prompt_position = "bottom",
            width = 80,
            height = 12,
        },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        previewer = false,
        shorten_path = false,
    }
    builtin.lsp_codelens_actions(themes.get_dropdown(opts))
end

-- show refrences to this using language server
function M.lsp_references()
    builtin.lsp_references()
end

-- show implementations of the current thingy using language server
function M.lsp_implementations()
    builtin.lsp_implementations()
end

-- find files in the upper directory
function M.find_updir()
    local up_dir = vim.fn.getcwd():gsub("(.*)/.*$", "%1")
    local opts = {
        cwd = up_dir,
    }

    builtin.find_files(opts)
end

function M.installed_plugins()
    builtin.find_files {
        cwd = join_paths(os.getenv "LUNARVIM_RUNTIME_DIR", "site", "pack", "packer"),
    }
end

function M.curbuf()
    local opts = themes.get_dropdown {
        winblend = 10,
        previewer = false,
        shorten_path = false,
        layout_config = {
            width = 0.45,
            prompt_position = "bottom",
        },
    }
    builtin.current_buffer_fuzzy_find(opts)
end

function M.git_status()
    local opts = themes.get_dropdown {
        winblend = 10,
        previewer = false,
        shorten_path = false,
        layout_config = {
            width = 0.45,
            prompt_position = "bottom",
        },
    }

    -- Can change the git icons using this.
    -- opts.git_icons = {
    --   changed = "M"
    -- }

    builtin.git_status(opts)
end

function M.search_only_certain_files()
    builtin.find_files {
        find_command = {
            "rg",
            "--files",
            "--type",
            vim.fn.input "Type: ",
        },
    }
end

function M.builtin()
    builtin.builtin()
end

function M.git_files()
    local path = vim.fn.expand "%:h"
    if path == "" then
        path = nil
    end

    local width = 0.45
    if path and string.find(path, "sourcegraph.*sourcegraph", 1, false) then
        width = 0.6
    end

    local opts = themes.get_dropdown {
        winblend = 5,
        previewer = false,
        shorten_path = false,
        cwd = path,
        layout_config = {
            width = width,
            prompt_position = "bottom",
        },
    }

    opts.file_ignore_patterns = {
        "^[.]vale/",
    }
    builtin.git_files(opts)
end

function M.grep_string_visual()
    local visual_selection = function()
        local save_previous = vim.fn.getreg "a"
        vim.api.nvim_command 'silent! normal! "ay'
        local selection = vim.fn.trim(vim.fn.getreg "a")
        vim.fn.setreg("a", save_previous)
        return vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
    end
    builtin.live_grep {
        default_text = visual_selection(),
    }
end

function M.buffers()
    builtin.buffers()
end

function M.config()
    -- Telescope
    lvim.builtin.telescope.defaults.path_display = { shorten = 10 }
    lvim.builtin.telescope.defaults.prompt_prefix = "  "
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
    lvim.builtin.telescope.defaults.use_less = true
    local actions = require "telescope.actions"
    lvim.builtin.telescope.defaults.mappings = {
        i = {
            ["<esc><esc>"] = actions.close,
            ["<c-c>"] = actions.close,
            ["<c-y>"] = actions.which_key,
            ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
            ["<c-n>"] = actions.cycle_history_next,
            ["<c-p>"] = actions.cycle_history_prev,
        },
        n = {
            ["<esc>"] = actions.close,
            ["<c-c>"] = actions.close,
            ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
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
        telescope.load_extension "command_palette"
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
