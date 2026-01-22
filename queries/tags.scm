; tags.scm - Symbol navigation for Move language
; Enables go-to-definition, outline view, and symbol search

;; =============================================================================
;; Modules
;; =============================================================================

(module_definition
  (module_identity
    (identifier) @name) @definition.module)

(module_definition
  (module_identity
    (address_literal)
    (identifier) @name) @definition.module)

;; =============================================================================
;; Functions
;; =============================================================================

(function_definition
  (identifier) @name) @definition.function

;; =============================================================================
;; Structs
;; =============================================================================

(struct_definition
  (identifier) @name) @definition.type

;; Struct fields
(struct_field
  (identifier) @name) @definition.field

;; =============================================================================
;; Enums
;; =============================================================================

(enum_definition
  (identifier) @name) @definition.type

;; Enum variants
(enum_variant
  (identifier) @name) @definition.variant

;; =============================================================================
;; Constants
;; =============================================================================

(constant_definition
  (identifier) @name) @definition.constant

;; =============================================================================
;; Spec Schemas
;; =============================================================================

(spec_target
  "schema"
  (identifier) @name) @definition.type

;; =============================================================================
;; References
;; =============================================================================

;; Function calls
(call_expression
  (module_access_expr
    (module_access
      (identifier) @name)) @reference.call)

;; Module references in use declarations
(use_declaration
  (module_access
    (identifier) @name) @reference.module)

;; Type references
(type
  (module_access
    (identifier) @name) @reference.type)
