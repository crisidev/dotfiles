local M = {}
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local builtin = require "telescope.builtin"

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

function M.default_opts()
    local opts = {
        border = true,
        previewer = false,
        path_display = { "smart" },
        layout_strategy = "flex",
        layout_config = {
            horizontal = { width = 0.9, height = 0.8 },
            vertical = { width = 0.9, height = 0.8, preview_height = 0.75 },
        },
        file_ignore_patterns = {
            "vendor/*",
            "target/*",
            "node_modules",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
        },
    }
    return opts
end

function M.find_string()
    builtin.live_grep(M.default_opts())
end

function M.file_browser_mappings(prompt_bufnr, map)
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

function M.file_browser()
    local opts = {
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        layout_config = {
            prompt_position = "bottom",
        },
        attach_mappings = M.file_browser_mappings,
    }

    builtin.file_browser(opts)
end

function M.recent_files()
    builtin.oldfiles(M.default_opts())
end

function M.live_grep()
    builtin.live_grep(M.default_opts())
end

function M.code_actions()
    local opts = {
        border = true,
        previewer = false,
    }
    builtin.lsp_code_actions(themes.get_dropdown(opts))
end

function M.codelens_actions()
    local opts = {
        border = true,
        previewer = false,
    }
    builtin.lsp_codelens_actions(themes.get_dropdown(opts))
end

function M.lsp_references()
    builtin.lsp_references(M.default_opts())
end

function M.lsp_implementations()
    builtin.lsp_implementations(M.default_opts())
end

function M.lsp_document_diagnostics()
    builtin.lsp_document_diagnostics(M.default_opts())
end

function M.find_files()
    local opts = M.default_opts()
    opts["hidden"] = true
    opts["follow"] = true
    builtin.find_files(opts)
end

function M.buffers()
    local opts = M.default_opts()
    builtin.buffers(opts)
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
    cwd = require("nvim_lsp.util").root_pattern ".git"(vim.fn.expand "%:p"),
  }
end

function M.curbuf()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }
  builtin.current_buffer_fuzzy_find(opts)
end

function M.git_status()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
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

  local width = 0.35
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
    },
  }

  opts.file_ignore_patterns = {
    "^[.]vale/",
  }
  builtin.git_files(opts)
end

return M
