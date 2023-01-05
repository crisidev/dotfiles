local M = {}

M.config = function()
    require("lsp-inlayhints").setup {
        inlay_hints = {
            parameter_hints = {
                show = true,
                prefix = "in: ",
                separator = ", ",
                remove_colon_start = false,
                remove_colon_end = true,
            },
            type_hints = {
                -- type and other hints
                show = true,
                prefix = "out",
                separator = ", ",
                remove_colon_start = false,
                remove_colon_end = false,
            },
            only_current_line = true,
            -- separator between types and parameter hints. Note that type hints are
            -- shown before parameter
            labels_separator = " | ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- highlight group
            highlight = "SpecialComment",
            -- virt_text priority
            priority = 0,
        },
        enabled_at_startup = true,
        debug_mode = false,
    }
end

return M
