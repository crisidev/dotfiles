local M = {}
-- local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local builtin = require "telescope.builtin"

-- beautiful default layout for telescope prompt
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

function M.get_files_opts()
    return {
        border = true,
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        layout_config = {
            prompt_position = "bottom",
        },
        file_ignore_patterns = {
            "vendor/*",
            "node_modules",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            ".git",
            ".svn",
        },
        hidden = true,
        shorten_path = false,
    }
end

-- another file string search
function M.find_string()
    local opts = M.get_files_opts()
    opts.previewer = false
    opts.layout_strategy = "flex"
    builtin.live_grep(opts)
end

function M.recent_files()
    local opts = M.get_files_opts()
    opts.previewer = false
    opts.layout_strategy = "flex"
    builtin.oldfiles(opts)
end

-- fince file browser using telescope instead of lir
function M.file_browser()
    local opts = M.get_files_opts()

    opts.attach_mappings = function(prompt_bufnr, map)
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
    end

    builtin.file_browser(opts)
end

function M.get_dropdown()
    return themes.get_dropdown {
        winblend = 10,
        layout_config = {
            prompt_position = "bottom",
            width = 80,
            height = 12,
        },
        border = {},
        previewer = false,
        shorten_path = false,
    }
end

function M.get_lsp_opts()
    return {
        layout_strategy = "vertical",
        layout_config = {
            prompt_position = "bottom",
        },
        sorting_strategy = "ascending",
        ignore_filename = false,
    }
end

-- show code actions in a fancy floating window
function M.code_actions()
    builtin.lsp_code_actions(M.get_dropdown())
end

-- show code actions in a fancy floating window
function M.codelens_actions()
    builtin.lsp_codelens_actions(M.get_dropdown())
end

-- show refrences to this using language server
function M.lsp_references()
    local pickers = require "telescope.pickers"
    local make_entry = require "telescope.make_entry"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local params = vim.lsp.util.make_position_params()
    params.context = { includeDeclaration = true }

    local results_lsp, err = vim.lsp.buf_request_sync(0, "textDocument/references", params, 10000)
    if err then
        vim.api.nvim_err_writeln("Error when finding references: " .. err)
        return
    end

    local locations = {}
    for _, server_results in pairs(results_lsp) do
        if server_results.result then
            local r = vim.lsp.util.locations_to_items(server_results.result)
            print(r)
            vim.list_extend(locations, r or {})
        end
    end

    if vim.tbl_isempty(locations) then
        return
    end

    local opts = M.get_dropdown()

    pickers.new(opts, {
        prompt_title = "LSP References",
        finder = finders.new_table {
            results = locations,
            entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
        },
        previewer = conf.qflist_previewer(opts),
        sorter = conf.generic_sorter(opts),
    }):find()
end

-- show implementations of the current thingy using language server
function M.lsp_implementations()
    builtin.lsp_implementations(M.get_lsp_opts())
end

function M.find_files()
    local opts = M.get_files_opts()
    builtin.find_files(opts)
end

-- find files in the upper directory
function M.find_updir()
    local opts = M.get_files_opts()
    opts.cwd = vim.fn.getcwd():gsub("(.*)/.*$", "%1")
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
    local opts = M.get_files_opts()
    opts.cwd = join_paths(os.getenv "LUNARVIM_RUNTIME_DIR", "site", "pack", "packer")
    builtin.find_files(opts)
end

function M.project_search()
    local opts = M.get_files_opts()
    opts.previewer = false
    opts.layout_strategy = "vertical"
    opts.cwd = require("lspconfig.util").root_pattern ".git"(vim.fn.expand "%:p")
    builtin.find_files(opts)
end

function M.git_status()
    builtin.git_status(M.get_dropdown())
end

function M.search_only_certain_files()
    local opts = M.get_files_opts()
    opts.find_command = {
        "rg",
        "--files",
        "--type",
        vim.fn.input "Type: ",
    }
    builtin.find_files(opts)
end

function M.builtin()
    builtin.builtin()
end

function M.git_files()
    local path = vim.fn.expand "%:h"
    if path == "" then
        path = nil
    end

    local width = 0.35
    if path and string.find(path, "sourcegraph.*sourcegraph", 1, false) then
        width = 0.6
    end

    local opts = M.get_dropdown()
    opts.file_ignore_patterns = {
        "^[.]vale/",
    }
    builtin.git_files(opts)
end

function M.buffers()
    builtin.buffers()
end

return M
