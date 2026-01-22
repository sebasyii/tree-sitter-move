; indents.scm - Auto-indentation for Move language
; Defines indentation rules for automatic code formatting

;; =============================================================================
;; Indent
;; =============================================================================

; Block structures - indent their contents
[
  (block)
  (module_definition)
  (address_block)
  (script_block)
  (struct_fields)
  (spec_block)
  (use_group)
] @indent

; Function definitions - indent body
(function_definition
  (block) @indent)

; Struct and enum definitions - indent fields
(struct_definition
  (struct_fields) @indent)

(enum_definition) @indent

; Control flow expressions - indent body
[
  (if_expression)
  (while_expression)
  (loop_expression)
  (for_expression)
  (match_expression)
  (lambda_expression)
] @indent

; Match arms - indent the expression
(match_arm) @indent

; Parenthesized expressions - indent if multiline
[
  (tuple_expression)
  (arg_list)
  (function_parameters)
] @indent

; Type parameter lists
[
  (type_parameters)
  (type_arguments)
] @indent

; Vector literals
(vector_literal) @indent

; Attribute lists
(attributes) @indent

;; =============================================================================
;; Dedent
;; =============================================================================

; Closing delimiters should dedent
[
  "}"
  "]"
  ")"
] @dedent

;; =============================================================================
;; Branch (for else alignment)
;; =============================================================================

; Else should align with if
(if_expression
  "else" @branch)

;; =============================================================================
;; Align
;; =============================================================================

; Align chained method calls (if we add them)
(dot_expression) @align

;; =============================================================================
;; Ignore (for indentation purposes)
;; =============================================================================

; Comments should not affect indentation
[
  (line_comment)
  (block_comment)
] @ignore

; Certain punctuation should be ignored
[
  ","
  ";"
] @ignore
