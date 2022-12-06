; extends
(
 function_item
 (
  identifier
  )@function_definition
 )

(("->" @operator) (#set! conceal ""))
(("fn" @keyword.function) (#set! conceal ""))
(("use" @keyword) (#set! conceal ""))
; (("crate" @keyword) (#set! conceal ""))
; (("type" @keyword) (#set! conceal "𝑻"))
; (("enum" @keyword) (#set! conceal ""))
; (("struct" @keyword) (#set! conceal ""))
