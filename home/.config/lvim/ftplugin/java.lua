local ok, wk = pcall(require, "which-key")
if not ok then
    return
end
local icons = require("user.icons").icons

wk.register {
    -- Hover
    ["K"] = {
        "<cmd>lua require('user.lsp').show_documentation()<CR>",
        icons.docs .. "Show Documentation",
    },
}
