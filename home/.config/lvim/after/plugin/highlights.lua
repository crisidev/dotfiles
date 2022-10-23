require("user.theme").dashboard_theme()
require("user.theme").telescope_theme()
if lvim.builtin.dap.active then
    require("user.icons").define_dap_signs()
end
