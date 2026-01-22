// Comprehensive Move language example
// Demonstrates syntax highlighting for all major constructs

module 0x1::Example {
    use std::vector;
    use std::option;

    friend 0x1::OtherModule;

    // Constants
    const ERROR_CODE: u64 = 100;
    const MAX_VALUE: u128 = 1000000u128;

    // Struct with abilities
    public struct Coin<phantom T> has key, store {
        value: u64
    }

    // Enum with variants
    public enum Status has copy, drop {
        Pending,
        Active { value: u64 },
        Done
    }

    // Native function
    native public fun native_function(x: u64): u64;

    // Entry function with modifiers
    public entry fun transfer<T>(account: &signer, amount: u64) acquires Coin {
        let coin = borrow_global_mut<Coin<T>>(@0x1);
        coin.value = amount;
    }

    // Inline function
    public inline fun add(a: u64, b: u64): u64 {
        a + b
    }

    // Function with type constraints
    fun generic_function<T: copy + drop + store>(x: T): T {
        copy x
    }

    // Control flow
    fun control_flow(n: u64): u64 {
        let result = n;

        // If expression
        if (result > 10) {
            result = result * 2
        } else {
            result = result + 1
        };

        // While loop with label
        'outer: while (result < 100) {
            result = result + 1;
            if (result == 50) {
                break 'outer
            };
        };

        // Loop
        loop {
            if (result > 200) break;
            result = result + 10;
        };

        // For loop
        for (i in 0..10) {
            result = result + i;
        };

        result
    }

    // Match expression (simplified)
    fun match_example(x: u64): u64 {
        if (x == 0) {
            10
        } else if (x == 1) {
            20
        } else {
            x
        }
    }

    // Lambda expressions
    fun lambda_examples() {
        let simple = || 42;
        let with_param = |x: u64| x * 2;
        let move_lambda = move |x| x + 1;
    }

    // All operators
    fun operators(a: u64, b: u64): bool {
        // Arithmetic
        let _ = a + b;
        let _ = a - b;
        let _ = a * b;
        let _ = a / b;
        let _ = a % b;

        // Bitwise
        let _ = a & b;
        let _ = a | b;
        let _ = a ^ b;
        let _ = a << 2;
        let _ = a >> 1;

        // Comparison
        let _ = a == b;
        let _ = a != b;
        let _ = a < b;
        let _ = a > b;
        let _ = a <= b;
        let _ = a >= b;

        // Logical
        (a > 0) && (b > 0) || false
    }

    // Types and references
    fun types_demo() {
        // Primitive types
        let u8_val: u8 = 255u8;
        let u64_val: u64 = 0xFFFFu64;
        let u256_val: u256 = 100u256;
        let bool_val: bool = true;
        let addr: address = @0x1;

        // References
        let ref1 = &u8_val;
        let ref2 = &mut u64_val;

        // Dereference
        let _ = *ref1;

        // Borrow
        let _ = &u8_val;
        let _ = &mut u64_val;

        // Move and copy
        let _ = move u8_val;
        let _ = copy bool_val;

        // Vector
        let vec = vector[1, 2, 3];
        let _ = vec[0];

        // Tuple
        let tuple = (42, true, @0x1);
        let (x, y, z) = tuple;
    }

    // Literals
    fun literals() {
        let dec = 1234567890;
        let hex = 0xABCDEF;
        let with_underscores = 1_000_000;
        let bool_true = true;
        let bool_false = false;
        let byte_str = b"Hello";
        let hex_str = x"DEADBEEF";
        let addr = @0x123;
    }

    // Spec blocks
    spec transfer {
        requires amount > 0;
        ensures result > 0;
        aborts_if amount == 0;
    }

    spec module {
        invariant true;
    }

    // Attributes
    #[test]
    fun test_example() {
        let _ = 1 + 1;
    }

    #[test_only]
    fun test_helper(): u64 {
        42
    }
}

script {
    use std::debug;

    fun main(account: signer) {
        debug::print(&b"Hello!");
    }
}
