lvim.lang.go.formatters = {
  {
    exe = "goimports",
    -- args = {},
  },
}

if lvim.builtin.dap.active then
  local dap_install = require "dap-install"
  dap_install.config("go_delve", {})
end
