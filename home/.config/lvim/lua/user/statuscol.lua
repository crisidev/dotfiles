local M = {}

M.config = function()
    local builtin = require "statuscol.builtin"
    require("statuscol").setup {
        setopt = true,
        relculright = true,
        segments = {
            {
                text = { "", builtin.foldfunc, " " },
                condition = { builtin.not_empty, true, builtin.not_empty },
                click = "v:lua.ScFa",
            },
            { text = { "%s" }, click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.CcLa" },
        },
    }
end

return M
