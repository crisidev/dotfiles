vim.cmd [[
    highlight! link FocusedSymbol LspHighlight
    highlight! SpecialComment guibg=bold guifg=#9ca0a4
    highlight! link LspCodeLens SpecialComment
    highlight! link LspDiagnosticsSignError DiagnosticError
    highlight! link LspDiagnosticsSignHint DiagnosticHint
    highlight! link LspDiagnosticsSignInfo DiagnosticInfo
    highlight! link NeoTreeDirectoryIcon NvimTreeFolderIcon
    " hi HlSearchNear guibg=None guifg=#bb9af7 gui=underline
    " hi HlSearchFloat guibg=None guifg=#bb9af7 gui=underline
    " hi HlSearchLensNear guibg=None guifg=#bb9af7 gui=italic
    " hi HlSearchLens guibg=None guifg=#bb9af7 gui=underline
    highlight! link IndentBlanklineIndent1  @comment
]]
require("user.theme").dashboard_theme()
require("user.theme").telescope_theme()
require("user.icons").define_dap_signs()
