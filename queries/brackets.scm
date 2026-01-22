; brackets.scm - Bracket matching for Move language
; Defines paired delimiters for bracket matching and rainbow brackets

;; =============================================================================
;; Parentheses
;; =============================================================================

; Function parameters
(function_parameters
  "(" @opening.bracket
  ")" @closing.bracket)

; Function calls / argument lists
(arg_list
  "(" @opening.bracket
  ")" @closing.bracket)

; Tuple expressions
(tuple_expression
  "(" @opening.bracket
  ")" @closing.bracket)

; Tuple types
(tuple_type
  "(" @opening.bracket
  ")" @closing.bracket)

; If/while/for condition parentheses
(if_expression
  "(" @opening.bracket
  ")" @closing.bracket)

(while_expression
  "(" @opening.bracket
  ")" @closing.bracket)

(for_expression
  "(" @opening.bracket
  ")" @closing.bracket)

; Match expression
(match_expression
  "(" @opening.bracket
  ")" @closing.bracket)

; Positional struct fields
(positional_fields
  "(" @opening.bracket
  ")" @closing.bracket)

; Bind positional fields
(bind_positional_fields
  "(" @opening.bracket
  ")" @closing.bracket)

;; =============================================================================
;; Braces
;; =============================================================================

; Blocks
(block
  "{" @opening.bracket
  "}" @closing.bracket)

; Module definitions
(module_definition
  "{" @opening.bracket
  "}" @closing.bracket)

; Address blocks
(address_block
  "{" @opening.bracket
  "}" @closing.bracket)

; Script blocks
(script_block
  "{" @opening.bracket
  "}" @closing.bracket)

; Struct fields
(struct_fields
  "{" @opening.bracket
  "}" @closing.bracket)

; Enum definitions
(enum_definition
  "{" @opening.bracket
  "}" @closing.bracket)

; Match expression body
(match_expression
  "{" @opening.bracket
  "}" @closing.bracket)

; Bind fields
(bind_fields
  "{" @opening.bracket
  "}" @closing.bracket)

; Use groups
(use_group
  "{" @opening.bracket
  "}" @closing.bracket)

; Spec blocks
(spec_block
  "{" @opening.bracket
  "}" @closing.bracket)

;; =============================================================================
;; Square Brackets
;; =============================================================================

; Vector literals
(vector_literal
  "[" @opening.bracket
  "]" @closing.bracket)

; Vector access
(vector_access_expression
  "[" @opening.bracket
  "]" @closing.bracket)

; Attributes
(attributes
  "[" @opening.bracket
  "]" @closing.bracket)

;; =============================================================================
;; Angle Brackets (Generics)
;; =============================================================================

; Type parameters
(type_parameters
  "<" @opening.bracket
  ">" @closing.bracket)

; Type arguments
(type_arguments
  "<" @opening.bracket
  ">" @closing.bracket)

;; =============================================================================
;; Pipe Delimiters (Lambda/Function Types)
;; =============================================================================

; Lambda bindings
(lambda_bindings
  "|" @opening.bracket
  "|" @closing.bracket)

; Function types
(fun_type
  "|" @opening.bracket
  "|" @closing.bracket)
