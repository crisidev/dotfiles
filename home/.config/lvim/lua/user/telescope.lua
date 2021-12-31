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
    ".github/",
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
        file_ignore_patterns = M.file_ignore_patterns,
    }
    builtin.live_grep(opts)
end

-- find files
function M.find_files()
    local opts = {
        hidden = true,
        file_ignore_patterns = M.file_ignore_patterns,
    }
    builtin.find_files(opts)
end

-- find only recent files
function M.recent_files()
    require("telescope").extensions.frecency.frecency()
end

-- fince file browser using telescope instead of lir
function M.file_browser()
    local opts

    opts = {
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        layout_config = {
            prompt_position = "bottom",
        },
        file_ignore_patterns = M.file_ignore_patterns,

        attach_mappings = function(prompt_bufnr, map)
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            local modify_cwd = function(new_cwd)
                current_picker.cwd = new_cwd
                current_picker:refresh(opts.new_finder(new_cwd), { reset_prompt = true })
            end

            map("i", "-", function()
                modify_cwd(current_picker.cwd .. "/..")
            end)

            map("i", "~", function()
                modify_cwd(vim.fn.expand "~")
            end)

            local modify_depth = function(mod)
                return function()
                    opts.depth = opts.depth + mod

                    local this_picker = action_state.get_current_picker(prompt_bufnr)
                    this_picker:refresh(opts.new_finder(current_picker.cwd), { reset_prompt = true })
                end
            end

            map("i", "<M-=>", modify_depth(1))
            map("i", "<M-+>", modify_depth(-1))

            map("n", "yy", function()
                local entry = action_state.get_selected_entry()
                vim.fn.setreg("+", entry.value)
            end)

            return true
        end,
    }

    builtin.file_browser(opts)
end

-- show code actions in a fancy floating window
function M.code_actions()
    local opts = {
        winblend = 15,
        layout_config = {
            prompt_position = "bottom",
            width = 80,
            height = 12,
        },
        previewer = false,
        shorten_path = false,
    }
    builtin.lsp_code_actions(themes.get_dropdown(opts))
end

function M.codelens_actions()
    local opts = {
        winblend = 15,
        layout_config = {
            prompt_position = "bottom",
            width = 80,
            height = 12,
        },
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

function M.grep_last_search(opts)
    opts = opts or {}

    -- \<getreg\>\C
    -- -> Subs out the search things
    local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

    opts.path_display = { "shorten" }
    opts.word_match = "-w"
    opts.search = register

    builtin.grep_string(opts)
end

function M.installed_plugins()
    builtin.find_files {
        cwd = join_paths(os.getenv "LUNARVIM_RUNTIME_DIR", "site", "pack", "packer"),
    }
end

function M.project_search()
    builtin.find_files {
        previewer = false,
        layout_strategy = "vertical",
        cwd = require("lspconfig/util").root_pattern ".git"(vim.fn.expand "%:p"),
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

function M.layout_config()
    return {
        width = 0.90,
        height = 0.85,
        preview_cutoff = 120,
        prompt_position = "bottom",
        horizontal = {
            preview_width = function(_, cols, _)
                if cols > 200 then
                    return math.floor(cols * 0.5)
                else
                    return math.floor(cols * 0.6)
                end
            end,
        },
        vertical = {
            width = 0.9,
            height = 0.95,
            preview_height = 0.5,
        },

        flex = {
            horizontal = {
                preview_width = 0.9,
            },
        },
    }
end

function M.config()
    -- Telescope
    lvim.builtin.telescope.defaults.path_display = { shorten = 10 }
    lvim.builtin.telescope.defaults.winblend = 6
    lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
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
    -- lvim.builtin.telescope.defaults.layout_config = M.layout_config()
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
    end
end

return M
