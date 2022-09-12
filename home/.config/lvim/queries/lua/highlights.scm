; extends
(
 (function_call
   (identifier) @require_call
   (#match? @require_call "require")
   )
 (set! "priority" 105)
 (#set! conceal "")
)

(
 (function_call
   (identifier) @pairs
   (#match? @pairs "pairs")
   )
 (set! "priority" 105)
 )

(function_declaration
  (identifier)@function_definition
  )
(
 (function_declaration
   (dot_index_expression
     (identifier)
     (identifier)@function_definition
     )
   )
 (set! "priority" 105)
 )

(
 (assignment_statement
   (variable_list
     (identifier)@function_definition
     )
   (
    expression_list
    (function_definition)
    )
   )
 (set! "priority" 105)
 )
(
 (assignment_statement
   (variable_list
     (dot_index_expression
       (identifier)
       (identifier)@function_definition
       )
     )
   (
    expression_list
    (function_definition)
    )
   )
 (set! "priority" 105)
 )

;; (("return" @keyword) (#set! conceal ""))
;; (("local" @keyword) (#set! conceal ""))
(("function" @keyword) (#set! conceal ""))
;; (("then" @keyword) (#set! conceal ""))
;; (("do" @keyword) (#set! conceal ""))
;; (("not" @keyword) (#set! conceal ""))
;; (("for" @repeat) (#set! conceal ""))
;; (("while" @repeat) (#set! conceal "∞"))

;; (
;;   (break_statement)@keyword
;;   (#eq? @keyword  "break" )
;;   (#set! conceal "")
;; )
