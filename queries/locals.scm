; locals.scm - Scope tracking for Move language
; Defines scopes and tracks variable/type parameter definitions and references

;; =============================================================================
;; Scopes
;; =============================================================================

;; Module scope
(module_definition) @local.scope

;; Function scope
(function_definition) @local.scope

;; Block scope
(block) @local.scope

;; Spec block scope
(spec_block) @local.scope

;; Lambda expression scope
(lambda_expression) @local.scope

;; Loop scopes
(while_expression) @local.scope
(loop_expression) @local.scope
(for_expression) @local.scope

;; Match arm scope
(match_arm) @local.scope

;; If expression scope (each branch creates a scope)
(if_expression) @local.scope

;; =============================================================================
;; Definitions
;; =============================================================================

;; Function parameters
(function_parameter
  (identifier) @local.definition.parameter)

;; Let statement bindings
(let_statement
  (bind_list
    (bind_var
      (identifier) @local.definition.variable)))

;; Let statement bindings in destructuring patterns
(let_statement
  (bind_list
    (bind_item
      (bind_var
        (identifier) @local.definition.variable))))

;; Lambda bindings
(lambda_binding
  (bind_var
    (identifier) @local.definition.parameter))

;; For loop variables
(for_expression
  (identifier) @local.definition.variable)

;; Match arm bindings
(match_arm
  (bind_list
    (bind_var
      (identifier) @local.definition.variable)))

;; Match arm bindings in destructuring
(match_arm
  (bind_list
    (bind_item
      (bind_var
        (identifier) @local.definition.variable))))

;; Quantifier bindings (forall/exists)
(quant_binding
  (identifier) @local.definition.variable)

;; Type parameters in function definitions
(function_definition
  (type_parameters
    (type_parameter
      (identifier) @local.definition.type)))

;; Type parameters in struct definitions
(struct_definition
  (type_parameters
    (type_parameter
      (identifier) @local.definition.type)))

;; Type parameters in enum definitions
(enum_definition
  (type_parameters
    (type_parameter
      (identifier) @local.definition.type)))

;; Type parameters in spec schemas
(spec_target
  (type_parameters
    (type_parameter
      (identifier) @local.definition.type)))

;; =============================================================================
;; References
;; =============================================================================

;; Variable references (simple identifiers used as expressions)
(module_access_expr
  (module_access
    (identifier) @local.reference))
