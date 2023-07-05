local M = {}

M.config = function()
    require("gitlinker").setup {
        opts = {
            -- adds current line nr in the url for normal mode
            add_current_line_on_normal_mode = true,
            -- callback for what to do with the url
            action_callback = require("gitlinker.actions").copy_to_clipboard,
            -- print the url after performing the action
            print_url = false,
            -- mapping to call url generation
            mappings = nil,
        },
        callbacks = {
            ["code.crisidev.org"] = require("gitlinker.hosts").get_gitea_type_url,
        },
    }
end

return M
