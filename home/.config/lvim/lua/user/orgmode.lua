local M = {}

M.setup = function()
    local status_ok, org_mode = pcall(require, "orgmode")
    if not status_ok then
        return
    end
    org_mode.setup_ts_grammar()
    org_mode.setup {
        org_agenda_files = { "~/Documents/orgs/**/*" },
        org_default_notes_file = "~/Documents/orgs/refile.org",
        org_agenda_templates = {
            T = {
                description = "Todo",
                template = "* TODO %?\n  DEADLINE: %T",
                target = "~/Documents/orgs/todos.org",
            },
            w = {
                description = "Work todo",
                template = "* TODO %?\n  DEADLINE: %T",
                target = "~/Documents/orgs/work.org",
            },
        },
        mappings = {
            global = {
                org_agenda = "go",
                org_capture = "gC",
            },
        },
    }
end

return M
