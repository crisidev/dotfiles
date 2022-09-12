; extends
(
 function_item
 (
  identifier
  )@function_definition
 )


(("->" @operator) (#set! conceal ""))
(("fn" @keyword.function) (#set! conceal ""))
; (("function" @keyword) (#set! conceal ""))

(("use"     @keyword) (#set! conceal ""))
(("type"    @keyword) (#set! conceal "𝑻"))
;; (("struct"  @keyword) (#set! conceal ""))
;; (("enum"    @keyword) (#set! conceal "練"))
;; (("for" @repeat) (#set! conceal ""))
;; (("where" @keyword) (#set! conceal ""))
;; (("return" @keyword) (#set! conceal ""))
;; (("break" @keyword) (#set! conceal ""))
