///
#import "Macros.typ": *

///
#section(

    [Low Level Data Types],

    [This section is dedicated to explain the various proposed low-level data types including integer and floating point. The smallest addressable object in FabRISC is the byte, that is, eight consecutive bits. Longer types are constructed from multiple bytes side by side following powers of two: one, two, four or eight bytes in little-endian order. If bigger types are desired, then they can be handled in software or primitively supported via custom defined extensions.],

    [FabRISC provides the *Word Length* (`WLEN`) 2 bit ISA parameter, to indicate the natural scalar word length of the processor in bits. The possible values are listed in the table below:],

    tableWrapper([Scalar word lengths.], table(

        columns: (10%, 25%),
        align: (x, y) => (center + top, left + top).at(x),

        [#middle([*Code*])], [#middle([*Value*])],

        [0], [8 bits. ],
        [1], [16 bits.],
        [2], [32 bits.],
        [3], [64 bits.]
    )),

    ///.
    subSection(

        [Integer Types],

        [Integers are arguably the most common data types. They can be signed or unsigned and, when they are, 2's complement notation is used and, depending on the length, they can have various names. FabRISC uses the following nomenclature:],

        tableWrapper([Integer types.], table(

            columns: (10%, 25%),
            align: (x, y) => (left + top, left + top).at(x),

            [#middle([*Type*])], [#middle([*Size*])],

            [Byte ], [8 bits. ],
            [Short], [16 bits.],
            [Word ], [32 bits.],
            [Long ], [64 bits.]
        )),

        [Integer types are manipulated by integer instructions which, by default, behave in a modular fashion. Values that serve as pointers can be manipulated as signed 2's complement integers or as unsigned integers, with the latter being preferable when possible. Although the concept of the sign doesn't make much sense for addresses, signed arithmetic can still be applied in these situations. Addition and subtraction always yield the same exact bit pattern regardless of the interpretation of the operands. For comparisons, the only ones that do not depend on sign are equality and inequality because they simply amount to checking if each individual bit of one operand is equal or not to the ones in the other operand. Other comparisons, such as less than or greater than are risky if the object is close to or crosses the sign boundary from `0x7FFFFFFF`...`F` to `0x80000000`...`0`.],

        [Edge cases, such as wraps-around or overflows can happen in particular situations depending if the operation is arithmetic or logical and they can raise exceptions. An integer operation is said to be "silent" if the exceptions that it can raise are suppressed or disabled, otherwise the operation is said to be "signalling". The following is the list of edge cases for the integer data types:],

        tableWrapper([Integer edge cases.], table(

            columns: (auto, auto),
            align: (x, y) => (left + top, left + top).at(x),

            [#middle([*Case*])], [#middle([*Description*])],

            [Carry over], [This situation arises when the absolute value or modulus of the result is too big to fit in the desired data type. For example, the addition of the two unsigned bytes: `11111111` and `00000001` will result in a carry over: `(1)00000000`. For silent operations, no default value is defined for this edge case and the result is simply the incorrect value.],

            [Carry under], [This situation arises when the absolute value or modulus of the result is too accurate to fit in the desired data type. For example, the right shift by one place of the byte: `00000011` will result in a carry under: `00000001(1)`. For silent operations, no default value is defined for this edge case and the result is simply the incorrect value.],

            [Overflow], [This situation arises when the signed value of the result is too big to fit in the desired data type. For example, the addition of the two signed bytes: `01111111` and `00000001` will result in an overflow: `10000000`. For silent operations, no default value is defined for this edge case and the result is simply the incorrect value.],

            [Underflow], [This situation arises when the signed value of the result is too small to fit in the desired data type. For example, the addition of the two signed bytes: `10000000` and `10000001` will result in an underflow: `(1)00000001`. For silent operations, no default value is defined for this edge case and the result is simply the incorrect value.],

            [Division by zero], [This situation arises when a non zero values is divided by zero. For silent operations, the default value is zero for this edge case.],

            [Invalid operation], [This situation arises when an operation is deemed invalid or illegal and does not fall in any other of the previous cases, for example: `0/0`. For silent operations, the default value is zero for this edge case.]
        )),

        [When an arithmetic or logic operation triggers an exception, the destination variable must not be modified. This way, the old state is present at the during the execution of the exception handler.]
    ),

    ///.
    pagebreak(),
    subSection(

        [Floating Point Types],

        [Floating point data types are encoded with a modified IEEE-754 standard, which, includes all the previously mentioned sizes plus one more with the following bit patterns:],

        tableWrapper([Floating point formats.], table(

            columns: (13%, 29%, 29%, 29%),
            align: (x, y) => (left + top, center + top, center + top, center + top).at(x),

            [#middle([*Size*])], [#middle([*Mantissa*])], [#middle([*Exponent*])], [#middle([*Sign*])],

            [8 bits ], [7...3  ], [2...1 ], [0],
            [16 bits], [15...6 ], [5...1 ], [0],
            [21 bits], [20...9 ], [8...1 ], [0],
            [32 bits], [31...9 ], [8...1 ], [0],
            [64 bits], [63...12], [11...1], [0]
        )),

        [The proposed encodings are similar in shape and meaning to the IEEE-754 standard, with the main difference being the placement of the sign and exponent, which are located at the beginning instead of the end of the number. This is done to ease bit manipulation with instructions that use immediate values as one of their operands.],

        [The 21 bit variant is only used for immediate values of some instructions and should always be converted to the specified length before being used.],

        [Floating point types are manipulated via floating point instructions (prefixed with `FP`). Edge cases such as overflows, underflows can happen in the specific situations dictated by the IEEE-754 standard and can raise exceptions. A floating point operation is said to be "silent" if the exceptions that it can raise are suppressed or disabled, otherwise the operation is said to be "signalling". The following is the list of edge cases for the floating point data types:],

        tableWrapper([Floating point edge cases.], table(

            columns: (auto, auto),
            align: (x, y) => (left + top, left + top).at(x),

            [#middle([*Case*])], [#middle([*Description*])],

            [Overflow], [This situation arises when the value of the result is too big to fit in the desired data type, either positively or negatively. For silent operations, the default value is positive and negative infinity respectively for this edge case.],

            [Underflow], [This situation arises when the value of the result is too small to fit in the desired data type. For silent operations, no default value is defined for this edge case and the result is simply the incorrect value.],

            [Division by zero], [This situation arises when a non zero positive or negative values are divided by zero. For silent operations, the default value is positive and negative infinity respectively for this edge case.],

            [Invalid operation], [This situation arises when an operation is deemed invalid or illegal and does not fall in any other of the previous cases, for example: `0/0`. For silent operations, the default value is a quiet `NaN` for this edge case.]
        )),

        [`NaN` values are represented as the IEEE-754 standard dictates. Performing any arithmetic operation with a signalling `NaN` must be considered an illegal operation. If no exceptions are enabled whatsoever, a signalling `NaN` must behave the same as a regular quiet `NaN`.],

        [Quiet `NaN` values simply propagate through the various operations as dictated by the IEEE-754 standard. In both signalling and quiet cases, the least significant four bits of the mantissa is a payload that encodes the reason for the `NaN`. The `NaN` payloads must be OR-ed when they interact regardless of the operation performed since the result is always a `NaN`. The following is the list of payload bits:],

        tableWrapper([`NaN` payload vector.], table(

            columns: (10%, 40%),
            align: (x, y) => (center + top, left + top).at(x),

            [#middle([*Bit*])], [#middle([*Description*])],

            [0], [Division by zero.],
            [1], [Invalid operation.],
            [2], [Uninitialized variable.],
            [3], [Reserved for future use.]
        )),

        [The IEEE-754 standard specifies five rounding modes defined as follows:],

        tableWrapper([Floating point rounding modes.], table(

            columns: (auto, auto),
            align: (x, y) => (left + top, left + top).at(x),

            [#middle([*Name*])], [#middle([*Description*])],

            [Round to nearest even], [Rounds to the nearest value. If the number falls midway, it is rounded to the nearest value with an even least significant digit. This is also the default mode.],

            [Round to nearest away from zero.], [Rounds to the nearest value. If the number falls midway, it is rounded to the nearest value above or below for positive and negative numbers respectively.],

            [Round towards zero.], [Direct rounding towards zero, also known as "truncating".],
            [Round towards positive infinity.], [Direct rounding towards positive infinity, also known as "ceiling".],
            [Round towards negative infinity.], [Direct rounding towards negative infinity, also known as "floor".]
        )),
    ),

    ///.
    subSection(

        [Arithmetic Flags],

        [The `EXC` module, briefly presented in the previous section, is concerned about triggering exception events when arithmetic edge cases occur. The situations described in the tables above are translated into a series of "ephemeral" flags that are not stored in any kind of register and are activated when the corresponding edge case arises, which in turn, triggers the associated exception event. These flags have to be implemented if either the `EXC` or `HLPR` (or both) modules are implemented, if not, this section can be skipped and any operation is considered silent. The following table shows the proposed list of flags:],

        tableWrapper([Arithmetic flags.], table(

            columns: (auto, auto, auto, 45%),
            align: (x, y) => (left + top, left + top, left + top, left + top).at(x),

            [#middle([*Name*])], [#middle([*EXC present*])], [#middle([*HLPR present*])], [#middle([*Description*])],

            [`COVR1`], [Required if \ `WLEN = 0`], [Required if \ `WLEN >= 0`], [*Carry Over 1 Flag*: \ Activated if a carry over occurred on the $1^"st"$ byte.],

            [`COVR2`], [Required if \ `WLEN = 1`], [Required if \ `WLEN >= 1`], [*Carry Over 2 Flag*: \ Activated if a carry over occurred on the $2^"nd"$ byte.],

            [`COVR4`], [Required if \ `WLEN = 2`], [Required if \ `WLEN >= 2`], [*Carry Over 4 Flag*: \ Activated if a carry over occurred on the $4^"th"$ byte.],

            [`COVR8`], [Required if \ `WLEN = 3`], [Required if \ `WLEN = 3`], [*Carry Over 8 Flag*: \ Activated if a carry over occurred on the $8^"th"$ byte.],

            [`CUND` ], [Always required], [Always required], [*Carry Under Flag*: \ Activated if a carry under occurred.],

            [`OVFL1`], [Required if \ `WLEN = 0`], [Required if \ `WLEN >= 0`], [*Overflow 1 Flag*: \ Activated if an overflow occurred on the $1^"st"$ byte.],

            [`OVFL2`], [Required if \ `WLEN = 1`], [Required if \ `WLEN >= 1`], [*Overflow 2 Flag*: \ Activated if an overflow occurred on the $2^"nd"$ byte.],

            [`OVFL4`], [Required if \ `WLEN = 2`], [Required if \ `WLEN >= 2`], [*Overflow 4 Flag*: \ Activated if an overflow occurred on the $4^"th"$ byte.],

            [`OVFL8`], [Required if \ `WLEN = 3`], [Required if \ `WLEN = 3`], [*Overflow 8 Flag*: \ Activated if an overflow occurred on the $8^"th"$ byte.],

            [`UNFL1`], [Required if \ `WLEN = 0`], [Required if \ `WLEN >= 0`],[*Underflow 1 Flag*: \ Activated if an underflow occurred on the $1^"st"$ byte.],

            [`UNFL2`], [Required if \ `WLEN = 1`], [Required if \ `WLEN >= 1`],[*Underflow 2 Flag*: \ Activated if an underflow occurred on the $2^"nd"$ byte.],

            [`UNFL4`], [Required if \ `WLEN = 2`], [Required if \ `WLEN >= 2`],[*Underflow 4 Flag*: \ Activated if an underflow occurred on the $4^"th"$ byte.],

            [`UNFL8`], [Required if \ `WLEN = 3`], [Required if \ `WLEN = 3`],[*Underflow 8 Flag*: \ Activated if an underflow occurred on the $8^"th"$ byte.],

            [`DIV0` ], [Required if divisions can be performed], [Required if divisions can be performed], [*Division by Zero Flag*: \ Activated if a division by zero occurred.],

            [`INVOP`], [Always Required], [Always Required], [*Invalid Operation*: \ Activated if an invalid operation occurred.]
        )),

        [For the following edge cases: `COVRn`, `OVFLn`, `UNFLn`, the `EXC` module requires that the hart must trap only on "terminal" flags, that is, when $n = 2 ^ "WLEN"$. This is to avoid erroneously triggering exceptions when computing values larger than a single byte.]
    ),

    ///.
    comment([

        The low level data types are, more or less, the usual ones. Addresses can be interpreted as both signed and unsigned values, though pointer arithmetic is not something that should be heavily relied on because some operations are often deemed "illegal" such as multiplication, division, modulo and bitwise logic in many programming languages. Even if the addresses are always considered signed, the boundary on 64 bit systems can be considered a non issue since the address space is so huge that everything could fit into one of the two partitions. Systems with smaller `WLEN` might encounter some difficulties but some amount of pointer arithmetic can still be done without too much hassle. FabRISC, fortunately, includes unsigned operations and comparisons in the basic modules allowing to take advantage of the whole range, rendering this argument moot.

        I chose to use the little-endian format since it can potentially, slightly simplify accesses to portions of a variable without needing to change the address. For example a 64 bit memory location with the content of: `5E 00 00 00 00 00 00 00` can be red at the same address as an 8 bit value: `5E`, 16 bit value: `5E 00`, 32 bit value: `5E 00 00 00` or 64 bit value: `5E 00 00 00 00 00 00 00` which are all the same value. Endianness is mostly a useless debate though, as the advantages or disadvantages that each type has are often just a miniscule rounding error in the grand scheme of things.

        The proposed flags might seem weird and unnecessary, however they allow the detection of arithmetic edge cases in a very granular manner. Many ISAs don't have any way of easily detecting overflows and, when present, they either provide instructions that trap or a flag register. In both cases the system only allows the programmer to check if an overflow occurred at the word length only. FabRISC, not only provides the ability to check at all the standard lengths, but it also distinguishes overflows into two categories depending on the direction. This is useful to provide to the programmer a greater control and insight of the underlying system, as well as, potentially enabling better emulation of CPUs with smaller word lengths.

        Floating point is mostly similar to the IEEE-754 standard but with some rearrangements. The motivation behind the reordering of the sections is mainly to enable better bit manipulation. Thanks to this, the most "important" bits (sign and exponent) of the number can be easily reached with many of the bitwise immediate instructions.

        The IEEE-754 standard doesn't define the behavior of the so called "NaN payload" when two `NaN` values interact. I chose to dictate that the least significant four bits as a cause vector for the `NaN` generation, this way, the payloads can be OR-ed and this information can then be used to understand potential issues in the code or to simply redirect control flow based on the cause.
    ])
)

#pagebreak()

///
