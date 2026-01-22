; highlights.scm - Syntax highlighting for Move language
; Organized by semantic category for clarity

;; =============================================================================
;; Comments
;; =============================================================================

(line_comment) @comment.line
(block_comment) @comment.block

;; =============================================================================
;; Keywords
;; =============================================================================

;; Module/Script/Address Keywords
[
  "module"
  "script"
  "address"
] @keyword.module

;; Declaration Keywords
[
  "struct"
  "enum"
  "fun"
  "const"
  "use"
  "friend"
] @keyword.declaration

;; Control Flow Keywords
[
  "if"
  "else"
  "match"
  "while"
  "loop"
  "for"
  "return"
  "abort"
  "break"
  "continue"
] @keyword.control

;; Modifier Keywords
"phantom" @keyword.modifier

;; Ability Keywords
"has" @keyword.ability

(ability) @keyword.ability

;; Access Specifier Keywords
[
  "acquires"
  "reads"
  "writes"
  "pure"
] @keyword.access

;; Spec Language Keywords
"spec" @keyword.spec

[
  "invariant"
  "ensures"
  "requires"
  "aborts_if"
  "aborts_with"
  "succeeds_if"
  "modifies"
  "emits"
  "pragma"
  "axiom"
  "assert"
  "assume"
  "decreases"
  "apply"
  "include"
  "update"
  "schema"
] @keyword.spec

;; Quantifier Keywords
[
  "forall"
  "exists"
  "choose"
] @keyword.spec.quantifier

;; Spec Property Keywords
[
  "global"
  "local"
  "post"
] @keyword.spec.property

;; Other Keywords
[
  "let"
  "as"
  "is"
  "in"
  "move"
  "copy"
] @keyword

;; Vector keyword (special because it can also be a type)
"vector" @keyword.vector

;; =============================================================================
;; Operators
;; =============================================================================

;; Arithmetic Operators
[
  "+"
  "-"
  "*"
  "/"
  "%"
] @operator.arithmetic

;; Bitwise Operators
[
  "&"
  "|"
  "^"
  "<<"
  ">>"
] @operator.bitwise

;; Logical Operators
[
  "&&"
  "||"
  "!"
] @operator.logical

;; Comparison Operators
[
  "=="
  "!="
  "<"
  ">"
  "<="
  ">="
] @operator.comparison

;; Assignment Operators
"=" @operator.assignment

[
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "|="
  "^="
  "<<="
  ">>="
] @operator.assignment.compound

;; Spec Implication Operators
[
  "==>"
  "<==>"
] @operator.spec

;; Range Operator
".." @operator.range

;; Reference Operators
"&" @operator.reference
"&mut" @operator.reference.mutable

;; Dereference Operator
(dereference_expression "*" @operator.dereference)

;; Address Operator
(address_expression "@" @operator.address)

;; Field Access Operator
"." @operator.field

;; Type Operators
":" @operator.type

;; Module Access Operator
"::" @operator.module

;; Arrow Operator (in match expressions)
"=>" @operator.arrow

;; Negation in access specifiers
(access_specifier "!" @operator.negation)

;; =============================================================================
;; Literals
;; =============================================================================

;; Numeric Literals
(num_literal) @number

(num_suffix) @type.builtin

;; Boolean Literals
(bool_literal) @boolean

;; String Literals
(byte_string_literal) @string

;; Address Literals
(address_literal) @number.address

;; =============================================================================
;; Types
;; =============================================================================

;; Primitive Types
(primitive_type) @type.builtin

;; Reference Types
(ref_type
  [
    "&"
    "&mut"
  ] @keyword.modifier.reference)

;; Type Parameters (in definitions)
(type_parameter
  (identifier) @type.parameter)

(type_parameter
  "phantom" @keyword.modifier)

;; Type Arguments (in usage)
(type_arguments
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

(type_arguments
  (type) @type)

;; Type Constraints
(type_constraint
  (ability) @keyword.ability)

;; Module Access as Type
(type
  (module_access
    (identifier) @type))

;; Tuple Types
(tuple_type
  "(" @punctuation.bracket
  ")" @punctuation.bracket)

;; Function Types
(fun_type
  "|" @punctuation.delimiter
  (ability) @keyword.ability)

;; =============================================================================
;; Functions
;; =============================================================================

;; Function Definitions
(function_definition
  (identifier) @function.definition)

;; Function Modifiers
(native_modifier) @keyword.modifier.native
(entry_modifier) @keyword.modifier.entry
(inline_modifier) @keyword.modifier.inline

;; Visibility Modifiers
(visibility_modifier) @keyword.modifier.visibility

;; Function Parameters
(function_parameter
  (identifier) @variable.parameter)

;; Return Type
(ret_type
  (type) @type)

;; Function Calls
(call_expression
  (module_access_expr
    (module_access
      (identifier) @function.call)))

;; =============================================================================
;; Variables and Bindings
;; =============================================================================

;; Let Bindings
(let_statement
  (bind_list
    (bind_var
      (identifier) @variable)))

;; Lambda Bindings
(lambda_binding
  (bind_var
    (identifier) @variable.parameter))

;; Quantifier Bindings
(quant_binding
  (identifier) @variable.parameter)

;; For Loop Variables
(for_expression
  (identifier) @variable.parameter)

;; Match Arm Bindings
(match_arm
  (bind_list
    (bind_var
      (identifier) @variable)))

;; Bind Field Variables
(bind_field
  (identifier) @variable.member)

;; =============================================================================
;; Structs and Enums
;; =============================================================================

;; Struct Definitions
(struct_definition
  (identifier) @type.definition)

;; Struct Fields in Definition
(struct_field
  (identifier) @property)

;; Enum Definitions
(enum_definition
  (identifier) @type.definition)

;; Enum Variants
(enum_variant
  (identifier) @variant)

;; =============================================================================
;; Constants and Modules
;; =============================================================================

;; Constant Definitions
(constant_definition
  (identifier) @constant)

;; Module Definitions
(module_definition
  (module_identity
    (identifier) @namespace))

;; Module Identity with Address
(module_identity
  (address_literal) @number.address
  (identifier) @namespace)

;; Module Access Expressions
(module_access
  (address_literal)? @number.address
  (identifier) @namespace)

;; Field Access
(dot_expression
  (identifier) @property)

;; Use Declarations
(use_declaration
  (module_access
    (identifier) @namespace))

(use_declaration
  "as" @keyword
  (identifier) @namespace)

;; Friend Declarations
(friend_declaration
  (module_access
    (identifier) @namespace))

;; =============================================================================
;; Attributes
;; =============================================================================

(attributes
  "#" @punctuation.special
  "[" @punctuation.bracket
  "]" @punctuation.bracket)

(attribute
  (identifier) @attribute)

(attribute_value) @constant

;; =============================================================================
;; Spec Blocks
;; =============================================================================

;; Spec Target
(spec_target
  "module" @keyword.spec)

(spec_target
  "schema" @keyword.spec
  (identifier) @type.definition.spec)

(spec_target
  (identifier) @function)

;; Spec Properties
(spec_property
  (identifier) @property.spec)

;; =============================================================================
;; Labels
;; =============================================================================

(label
  "'" @punctuation.special
  (identifier) @label)

;; =============================================================================
;; Punctuation
;; =============================================================================

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

[
  ","
  ";"
] @punctuation.delimiter

;; =============================================================================
;; Special Constructs
;; =============================================================================

;; Vector Literals
(vector_literal
  "vector" @keyword.vector
  "[" @punctuation.bracket
  "]" @punctuation.bracket)

;; Wildcard in patterns
".." @punctuation.wildcard

;; Identifiers (fallback for any unmatched identifiers)
(identifier) @variable
