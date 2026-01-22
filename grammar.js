const PREC = {
  assign: 1,
  spec_implies: 2, // ==> <=>
  or: 3,
  and: 4,
  eq: 5, // == != < > <= >=
  range: 6, // ..
  bit_or: 7,
  bit_xor: 8,
  bit_and: 9,
  shift: 10,
  add: 11,
  mult: 12,
  cast: 13, // as / is
  unary: 14, // ! - * & move copy
  call: 15,
  field: 16,
  type_args: 17,
};

module.exports = grammar({
  name: "move",

  extras: $ => [
    /\s/,
    $.line_comment,
    $.block_comment,
  ],

  conflicts: $ => [
    [$.struct_definition, $.function_definition, $.enum_definition],
    [$.module_access],
    [$.module_access, $.vector_literal],
    [$.num_literal, $.module_access],
    [$.bind_var, $.module_access],
    [$.lambda_bindings, $.binary_expression],
    [$.lambda_bindings, $.fun_type],
    [$.lambda_expression],
    [$._statement, $.expression],
    [$.module_access_expr, $.type],
    [$.tuple_expression, $.tuple_type]
  ],

  rules: {
    source_file: $ => repeat(choice(
        $.module_definition,
        $.script_block,
        $.address_block
    )),

    // AddressBlock = "address" <LeadingNameAccess> "{" (<Attributes> <Module>)* "}"
    address_block: $ => seq(
        'address',
        $._leading_name_access,
        '{',
        repeat($.module_definition),
        '}'
    ),

    _leading_name_access: $ => choice(
        $.address_literal,
        $.identifier
    ),

    // Script =
    //    "script" "{"
    //        (<Attributes> <UseDecl>)*
    //        (<Attributes> <ConstantDecl>)*
    //        <Attributes> <DocComments> <ModuleMemberModifiers> <FunctionDecl>
    //        (<Attributes> <SpecBlock>)*
    //    "}"
    script_block: $ => seq(
        optional($.attributes),
        'script',
        '{',
        repeat($.use_declaration),
        repeat($.constant_definition),
        $.function_definition,
        repeat($.spec_block),
        '}'
    ),

    // From syntax.rs: "module" <ModuleName> "{" ... "}"
    module_definition: $ => seq(
      optional($.attributes),
      'module',
      $.module_identity,
      '{',
      repeat($._module_member),
      '}'
    ),

    _module_member: $ => choice(
      $.use_declaration,
      $.friend_declaration,
      $.constant_definition,
      $.struct_definition,
      $.enum_definition,
      $.function_definition,
      $.spec_block
    ),

    // ConstantDecl = "const" <Identifier> ":" <Type> "=" <Exp> ";"
    constant_definition: $ => seq(
        optional($.attributes),
        'const',
        $.identifier,
        ':',
        $.type,
        '=',
        $.expression,
        ';'
    ),

    // FriendDecl = "friend" <NameAccessChain> ";"
    friend_declaration: $ => seq(
        optional($.attributes),
        'friend',
        $.module_access,
        ';'
    ),

    // EnumDecl =
    //    ( "public" )? "enum" <EnumDefName> ( <TypeParameters> )?
    //    ( "has" <Ability> (, <Ability>)+ )?
    //    "{" <EnumVariants> "}"
    //    ( "has" <Ability> (, <Ability>)+ )?
    enum_definition: $ => seq(
      optional($.attributes),
      optional($.visibility_modifier),
      'enum',
      $.identifier,
      optional($.type_parameters),
      optional($.abilities),
      '{',
      commaSep($.enum_variant),
      '}',
      optional($.postfix_abilities)
    ),

    enum_variant: $ => seq(
      optional($.attributes),
      $.identifier,
      optional(choice(
        $.struct_fields,
        $.positional_fields
      ))
    ),

    // FunctionDecl =
    //    [ "inline" ] "fun"
    //    <FunctionDefName> "(" Comma<Parameter> ")"
    //    (":" <Type>)?
    //    ("acquires" <NameAccessChain> ("," <NameAccessChain>)*)?
    //    ("{" <Sequence> "}" | ";")
    function_definition: $ => seq(
        optional($.attributes),
        // Modifiers: native, visibility, entry
        optional($.native_modifier),
        optional($.visibility_modifier),
        optional($.entry_modifier),
        optional($.inline_modifier),
        'fun',
        $.identifier,
        optional($.type_parameters),
        $.function_parameters,
        optional($.ret_type),
        repeat($.access_specifier), // acquires, reads, writes, pure
        choice($.block, ';')
    ),

    native_modifier: $ => 'native',
    entry_modifier: $ => 'entry',
    inline_modifier: $ => 'inline',

    function_parameters: $ => seq(
        '(',
        commaSep($.function_parameter),
        ')'
    ),

    function_parameter: $ => seq(
        $.identifier,
        ':',
        $.type
    ),

    ret_type: $ => seq(
        ':',
        $.type
    ),

    // AccessSpecifier =
    //   "pure" | ( ( "!" )? ("acquires" | "reads" | "writes" ) <AccessSpecifierList> )
    access_specifier: $ => choice(
        'pure',
        seq(
            optional('!'),
            choice('acquires', 'reads', 'writes'),
            commaSep1($.module_access)
        )
    ),

    block: $ => seq(
        '{',
        repeat($.use_declaration),
        repeat($._statement),
        optional($.expression),
        '}'
    ),

    use_declaration: $ => seq(
        optional($.attributes),
        'use',
        choice(
            seq($.module_access, '::', '*'),
            $.module_access
        ),
        optional(choice(
            seq('as', $.identifier),
            seq('::', $.use_group)
        )),
        ';'
    ),

    use_group: $ => seq(
        '{',
        commaSep($.use_group_member),
        '}'
    ),

    use_group_member: $ => seq(
        choice($.identifier, '*'),
        optional(seq('as', $.identifier))
    ),

    _statement: $ => seq(
        choice(
            $.let_statement,
            $.expression
        ),
        ';'
    ),

    let_statement: $ => seq(
        'let',
        $.bind_list,
        optional(seq(':', $.type)),
        optional(seq('=', $.expression))
    ),

    bind_list: $ => choice(
        $.bind_var,
        seq('(', commaSep($.bind_item), ')')
    ),

    bind_item: $ => choice(
        $.bind_var,
        $.bind_unpack,
        '..'
    ),

    bind_var: $ => $.identifier,

    bind_unpack: $ => choice(
        seq($.module_access, choice($.bind_fields, $.bind_positional_fields)),
        $._module_path
    ),

    _module_path: $ => seq(
        choice(
            seq($.address_literal, '::'),
            seq($.identifier, '::')
        ),
        $.identifier,
        optional($.type_arguments)
    ),

    bind_fields: $ => seq('{', commaSep($.bind_field), '}'),
    bind_field: $ => choice(
        seq($.identifier, optional(seq(':', $.bind_item))),
        '..'
    ),
    bind_positional_fields: $ => seq('(', commaSep($.bind_item), ')'),

    expression: $ => choice(
        $.address_expression,
        $.bool_literal,
        $.byte_string_literal,
        $.vector_literal,
        $.module_access_expr,
        $.num_literal,
        $.block,
        $.tuple_expression,
        $.if_expression,
        $.while_expression,
        $.loop_expression,
        $.for_expression,
        $.return_expression,
        $.abort_expression,
        $.break_expression,
        $.continue_expression,
        $.match_expression,
        $.lambda_expression,
        $.unary_expression,
        $.dereference_expression,
        $.borrow_expression,
        $.binary_expression,
        $.assignment_expression,
        $.compound_assignment_expression,
        $.call_expression,
        $.vector_access_expression,
        $.dot_expression,
        $.cast_expression,
        $.type_test_expression,
        $.quantifier_expression,
        $.spec_block
    ),

    match_expression: $ => seq(
        'match',
        '(',
        $.expression,
        ')',
        '{',
        commaSep($.match_arm),
        '}'
    ),

    match_arm: $ => seq(
        $.bind_list,
        optional(seq('if', $.expression)),
        '=>',
        $.expression
    ),

    lambda_expression: $ => seq(
        optional(choice('move', 'copy')),
        $.lambda_bindings,
        $.expression
    ),

    lambda_bindings: $ => choice(
        seq('|', commaSep($.lambda_binding), '|'),
        '||'
    ),

    lambda_binding: $ => seq(
        $.bind_var,
        optional(seq(':', $.type))
    ),

    quantifier_expression: $ => seq(
        choice('forall', 'exists', 'choose', seq('choose', 'min')),
        commaSep1($.quant_binding),
        optional(seq('where', $.expression)),
        ':',
        $.expression
    ),

    quant_binding: $ => seq(
        $.identifier,
        choice(':', 'in'),
        $.expression
    ),

    spec_block: $ => seq(
        'spec',
        optional($.spec_target),
        '{',
        repeat($.spec_member),
        '}'
    ),

    spec_target: $ => choice(
        'module',
        $.identifier,
        seq('schema', $.identifier, optional($.type_parameters))
    ),

    spec_member: $ => choice(
        $.use_declaration,
        $.constant_definition,
        $.function_definition,
        seq(choice('invariant', 'axiom'), optional($.type_parameters), $.expression, ';'),
        seq(choice('assert', 'assume', 'ensures', 'requires', 'emits', 'aborts_if', 'aborts_with', 'succeeds_if', 'decreases', 'modifies'), $.expression, ';'),
        seq('pragma', commaSep($.spec_property), ';'),
        seq('let', optional('post'), $.identifier, '=', $.expression, ';'),
        seq(optional('global'), optional('local'), $.identifier, ':', $.type, ';'),
        seq('apply', $.expression, 'to', commaSep($._spec_apply_pattern), optional(seq('except', commaSep($._spec_apply_pattern))), ';'),
        seq('include', $.expression, ';'),
        seq('update', $.expression, ';')
    ),

    _spec_apply_pattern: $ => seq(
        optional(choice('public', 'internal')),
        choice($.identifier, '*'),
        optional($.type_parameters)
    ),

    spec_property: $ => seq(
        $.identifier,
        optional(seq('=', $.expression))
    ),

    unary_expression: $ => prec(PREC.unary, seq(
        choice('!', '-', 'copy', 'move'),
        $.expression
    )),

    dereference_expression: $ => prec(PREC.unary, seq(
        '*',
        $.expression
    )),

    borrow_expression: $ => prec(PREC.unary, seq(
        choice('&', '&mut'),
        $.expression
    )),

    binary_expression: $ => choice(
        prec.left(PREC.mult, seq($.expression, choice('*', '/', '%'), $.expression)),
        prec.left(PREC.add, seq($.expression, choice('+', '-'), $.expression)),
        prec.left(PREC.shift, seq($.expression, choice('<<', '>>'), $.expression)),
        prec.left(PREC.bit_and, seq($.expression, '&', $.expression)),
        prec.left(PREC.bit_xor, seq($.expression, '^', $.expression)),
        prec.left(PREC.bit_or, seq($.expression, '|', $.expression)),
        prec.left(PREC.range, seq($.expression, '..', $.expression)),
        prec.left(PREC.eq, seq($.expression, choice('==', '!=', '<', '>', '<=', '>='), $.expression)),
        prec.left(PREC.and, seq($.expression, '&&', $.expression)),
        prec.left(PREC.or, seq($.expression, '||', $.expression)),
        prec.right(PREC.spec_implies, seq($.expression, '==>', $.expression)),
        prec.left(PREC.spec_implies, seq($.expression, '<==>', $.expression))
    ),

    assignment_expression: $ => prec.right(PREC.assign, seq(
        $.expression,
        '=',
        $.expression
    )),

    compound_assignment_expression: $ => prec.right(PREC.assign, seq(
        $.expression,
        choice('+=', '-=', '*=', '/=', '%=', '&=', '|=', '^=', '<<=', '>>='),
        $.expression
    )),

    cast_expression: $ => prec.left(PREC.cast, seq(
        $.expression,
        'as',
        $.type
    )),

    type_test_expression: $ => prec.left(PREC.cast, seq(
        $.expression,
        'is',
        sepBy1($.type, '|')
    )),

    type_annotation_expression: $ => prec.left(PREC.cast, seq(
        $.expression,
        ':',
        $.type
    )),

    address_expression: $ => seq(
        '@',
        choice($.address_literal, $.identifier)
    ),

    call_expression: $ => prec(PREC.call, seq(
        $.module_access_expr,
        $.arg_list
    )),

    arg_list: $ => seq(
        '(',
        commaSep($.expression),
        ')'
    ),

    vector_access_expression: $ => prec(PREC.call, seq(
        $.expression,
        '[',
        $.expression,
        ']'
    )),

    dot_expression: $ => prec(PREC.field, seq(
        $.expression,
        '.',
        $.identifier
    )),

    vector_literal: $ => seq(
        'vector',
        optional($.type_arguments),
        '[',
        commaSep($.expression),
        ']'
    ),

    if_expression: $ => prec.right(seq(
        'if',
        '(',
        $.expression,
        ')',
        $.expression,
        optional(seq('else', $.expression))
    )),

    while_expression: $ => seq(
        optional(seq($.label, ':')),
        'while',
        '(',
        $.expression,
        ')',
        $.expression
    ),

    loop_expression: $ => seq(
        optional(seq($.label, ':')),
        'loop',
        $.expression
    ),

    for_expression: $ => seq(
        'for',
        '(',
        $.identifier,
        'in',
        $.expression,
        '..',
        $.expression,
        ')',
        $.expression
    ),

    return_expression: $ => prec.left(seq(
        'return',
        optional($.expression)
    )),

    abort_expression: $ => prec.left(seq(
        'abort',
        $.expression
    )),

    break_expression: $ => seq(
        'break',
        optional($.label)
    ),

    continue_expression: $ => seq(
        'continue',
        optional($.label)
    ),

    label: $ => seq("'", $.identifier),

    tuple_expression: $ => seq(
        '(',
        commaSep($.expression),
        ')'
    ),

    module_access_expr: $ => $.module_access,

    num_literal: $ => choice(
        $._hex_literal,
        seq($._hex_literal, $.num_suffix),
        /\d+(_\d+)*/,
        seq(/\d+(_\d+)*/, $.num_suffix)
    ),

    _hex_literal: $ => /0x[0-9a-fA-F]+(_[0-9a-fA-F]+)*/,

    num_suffix: $ => /u8|u16|u32|u64|u128|u256|i8|i16|i32|i64|i128|i256/,

    bool_literal: $ => choice('true', 'false'),

    byte_string_literal: $ => choice(
        /b"[^"]*"/,
        /x"[0-9a-fA-F]*"/
    ),

    address_literal: $ => $._hex_literal,

    struct_definition: $ => seq(
      optional($.attributes),
      optional($.native_modifier),
      optional($.visibility_modifier),
      'struct',
      $.identifier,
      optional($.type_parameters),
      choice(
        seq(
            optional($.abilities),
            $.struct_fields,
            optional($.postfix_abilities)
        ),
        seq(
            $.positional_fields,
            optional($.abilities),
            ';'
        ),
        seq(
            optional($.abilities),
            ';'
        )
      )
    ),

    visibility_modifier: $ => choice(
        'public',
        'public(friend)',
        'public(package)',
    ),

    struct_fields: $ => seq(
      '{',
      commaSep($.struct_field),
      '}'
    ),

    struct_field: $ => seq(
      $.identifier,
      ':',
      $.type
    ),

    positional_fields: $ => seq(
      '(',
      commaSep($.type),
      ')'
    ),

    type_parameters: $ => seq(
      '<',
      commaSep($.type_parameter),
      '>'
    ),

    type_parameter: $ => seq(
      optional('phantom'),
      $.identifier,
      optional($.type_constraint)
    ),

    type_constraint: $ => seq(
      ':',
      $.ability,
      repeat(seq('+', $.ability))
    ),

    abilities: $ => seq(
      'has',
      commaSep1($.ability)
    ),

    postfix_abilities: $ => seq(
      $.abilities,
      ';'
    ),

    ability: $ => choice(
      'copy',
      'drop',
      'store',
      'key'
    ),

    type: $ => choice(
      $.primitive_type,
      $.module_access,
      $.ref_type,
      $.fun_type,
      $.tuple_type
    ),

    ref_type: $ => seq(
      choice('&', '&mut'),
      $.type
    ),

    fun_type: $ => prec.right(seq(
      choice(
          seq('|', commaSep($.type), '|'),
          '||'
      ),
      optional(seq('has', $.ability, repeat(seq('+', $.ability)))),
      optional($.type)
    )),

    tuple_type: $ => seq(
      '(',
      commaSep($.type),
      ')'
    ),

    primitive_type: $ => choice(
      token(prec(1, 'u8')), token(prec(1, 'u16')), token(prec(1, 'u32')),
      token(prec(1, 'u64')), token(prec(1, 'u128')), token(prec(1, 'u256')),
      token(prec(1, 'i8')), token(prec(1, 'i16')), token(prec(1, 'i32')),
      token(prec(1, 'i64')), token(prec(1, 'i128')), token(prec(1, 'i256')),
      token(prec(1, 'bool')),
      token(prec(1, 'address')),
      token(prec(1, 'signer')),
      token(prec(1, 'vector'))
    ),

    module_access: $ => seq(
        optional(seq($.address_literal, '::')),
        optional(seq($.identifier, '::')),
        $.identifier,
        optional($.type_arguments)
    ),

    type_arguments: $ => seq(
        '<',
        commaSep($.type),
        '>'
    ),

    module_identity: $ => choice(
        seq($.address_literal, '::', $.identifier),
        seq($.identifier, '::', $.identifier),
        $.identifier
    ),

    attributes: $ => repeat1(seq(
        '#',
        '[',
        commaSep($.attribute),
        ']'
    )),

    attribute: $ => seq(
        $._attribute_name,
        optional(choice(
            seq('=', $.attribute_value),
            seq('(', commaSep($.attribute), ')')
        ))
    ),

    _attribute_name: $ => sepBy1($.identifier, '::'),

    attribute_value: $ => choice(
        $.bool_literal,
        $.num_literal,
        $.byte_string_literal,
        $.module_access
    ),

    identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,

    line_comment: ($) => token(seq("//", /.*/)),

    block_comment: $ => token(seq(
      '/*',
      /[^*]*\*+([^/*][^*]*\*+)*/,
      '/'
    ))
  }
});

function commaSep(rule) {
  return optional(commaSep1(rule));
}

function commaSep1(rule) {
  return seq(rule, repeat(seq(',', rule)), optional(','));
}

function sepBy1(rule, separator) {
  return seq(rule, repeat(seq(separator, rule)));
}
