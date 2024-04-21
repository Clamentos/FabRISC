///
#import "Macros.typ": *

///
#section(

    [Low level data types],

    [This section is dedicated to explain the various proposed low-level data types including integer and floating point. The smallest addressable object in FabRISC is the _byte_, that is, eight consecutive bits. Longer types are constructed from multiple bytes side by side following powers of two: one, two, four or eight bytes in _little-endian_ order. If bigger types are desired, then they can be simulated in software or primitively handled via custom defined extensions.],

    [FabRISC provides the *Word Length (WLEN)* 2-bit ISA parameter, to indicate the natural scalar word length of the processor in bits. The possible values are listed in the table below:],

    align(center, table(

        columns: (10fr, 90fr),
        inset: 8pt,
        align: (x, y) => (center, left + horizon).at(x),
        stroke: 0.75pt,
        fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

        [#align(center, [*Code*])], [#align(center, [*Value*])],

        [00], [8-bit.],
        [01], [16-bit.],
        [10], [32-bit.],
        [11], [64-bit.]
    )),

    ///.
    subSection(

        [Integer types],

        [Integers are arguably the most common data types. They can be signed or unsigned and, when they are, 2's complement notation is used. Depending on the length they can have various names and FabRISC uses the following:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Type*])], [#align(center, [*Size*])],

            [Byte ], [8-bit.],
            [Short], [16-bit.],
            [Word ], [32-bit.],
            [Long ], [64-bit.]
        )),

        [Integer types are manipulated by integer instructions which, by default, behave in a modular fashion (saturation arithmetic is not supported, but can be added as a custom extension). Edge cases, such as wraps-around or overflows can happen in particular situations depending if the operation is arithmetic or logical:],

        align(center, table(

            columns: (18fr, 82fr),
            inset: 8pt,
            align: left + horizon,
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Case*])], [#align(center, [*Description*])],

            [Carry over], [This situation arises when the absolute value (modulus) of the result is too big to fit in the desired data type. For example, the addition of the two unsigned bytes: 11111111 and 00000001 will result in a carry over: (1)00000000.],

            [Carry under], [This situation arises when the absolute value (modulus) of the result is too accurate to fit in the desired data type. For example, the right shift by one of the byte: 00000011 will result in a carry under: 00000001(1).],

            [Overflow], [This situation arises when the signed value of the result is too big to fit in the desired data type. For example, the addition of the two signed bytes: 01111111 and 00000001 will result in an overflow: 10000000.],

            [Underflow], [This situation arises when the signed value of the result is too small to fit in the desired data type. For example, the addition of the two signed bytes: 10000000 and 10000001 will result in an underflow: (1)00000001.]
        )),

        [The EXC module, presented in the previous section, is concerned about triggering exception events when arithmetic edge cases occur. The situations described in the table above are translated into a series of "ephemeral" flags that are not stored in any kind of flag register and are activated when the corresponding edge case arises, which in turn, will trigger the associated exception (see section 6 for more information). It is important to note that these flags have to be implemented if either the EXC or HLPR modules are implemented, if not, this section can be skipped. The following table shows the complete list of flags:],

        align(center, table(

            columns: (15fr, 85fr),
            inset: 8pt,
            align: left + horizon,
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Name*])], [#align(center, [*Description*])],

            [COVR1], [*Carry Over 1 Flag*: \ Activated if a carry over happened on the 1st byte. ($"WLEN" = 0, 1, 2, 3$).],
            [COVR2], [*Carry Over 2 Flag*: \ Activated if a carry over happened on the 2nd byte. ($"WLEN" = 1, 2, 3$).],
            [COVR4], [*Carry Over 4 Flag*: \ Activated if a carry over happened on the 4th byte. ($"WLEN" = 2, 3$).],
            [COVR8], [*Carry Over 8 Flag*: \ Activated if a carry over happened on the 8th byte. ($"WLEN" = 3$).],

            [CUND ], [*Carry Under Flag*: \ Activated if a carry under happened ($"WLEN" = 0, 1, 2, 3$).],

            [OVFL1], [*Overflow 1 Flag*: \ Activated if an overflow happened on the 1st byte. ($"WLEN" = 0, 1, 2, 3$).],
            [OVFL2], [*Overflow 2 Flag*: \ Activated if an overflow happened on the 2nd byte. ($"WLEN" = 1, 2, 3$).],
            [OVFL4], [*Overflow 4 Flag*: \ Activated if an overflow happened on the 4th byte. ($"WLEN" = 2, 3$).],
            [OVFL8], [*Overflow 8 Flag*: \ Activated if an overflow happened on the 8th byte. ($"WLEN" = 3$).],

            [UNFL1], [*Underflow 1 Flag*: \ Activated if an underflow happened on the 1st byte. ($"WLEN" = 0, 1, 2, 3$).],
            [UNFL2], [*Underflow 2 Flag*: \ Activated if an underflow happened on the 2nd byte. ($"WLEN" = 1, 2, 3$).],
            [UNFL4], [*Underflow 4 Flag*: \ Activated if an underflow happened on the 4th byte. ($"WLEN" = 2, 3$).],
            [UNFL8], [*Underflow 8 Flag*: \ Activated if an underflow happened on the 8th byte. ($"WLEN" = 3$).],

            [DIV0 ], [*Division by Zero Flag*: \ Activated if a division by zero happened ($"WLEN" = 0, 1, 2, 3$).]
        )),

        [Other flags can be freely added by custom modules if desired.],

        [Values that serve as pointers can be manipulated as signed 2's complement integers or as unsigned integers, with the latter being preferable when possible. Although the concept of sign doesn't make much sense for addresses, signed arithmetic can still be applied without many problems in these situations. Addition and subtraction will always yield the same exact bit pattern regardless of the interpretation of the operands. Multiplication can still produce the same pattern as well but only if the result is WLEN long, which means ignoring the upper WLEN bits. The only comparisons that do not depend on sign are equality and inequality because they simply amount to checking if each individual bit of one operand is equal or not to the ones in the other operand. Other comparisons, such as less than or greater than are risky if the object is close to or crosses the sign boundary from 0x7FFFFFFF...F to 0x80000000...0. Using unsigned operations will, of course, cause none of the above mentioned issues.]
    ),

    ///.
    subSection(

        [Floating point types],
        [_coming soon..._],
    ),

    comment([

        The low level data types are, more or less, the usual ones. Addresses can be interpreted as both signed and unsigned values, though pointer arithmetic is not something that should be heavily relied on because some operations are often deemed "illegal" such as multiplication, division, modulo and bitwise logic in many programming languages. Even if the addresses are always considered signed, the boundary on 64 bit systems can be considered a non issue since the address space is so huge that everything could fit into one of the two partitions. Systems with smaller WLEN might encounter some difficulties but some amount of pointer arithmetic can still be done without too much hassle. FabRISC, fortunately, includes unsigned operations and comparisons in the basic modules, which makes this argument moot.

        I chose to use the little-endian format since it can simplify accesses to portions of a variable without needing to change the address. For example a 64-bit memory location with the content of: $mono(5E 00 00 00 00 00 00 00)$ can be red at the same address as an 8-bit value: $mono(5E)$, 16-bit value: $mono(5E 00)$, 32-bit value: $mono(5E 00 00 00)$ or 64-bit value: $mono(5E 00 00 00 00 00 00 00)$ which are all the same value. Endianness is mostly a useless debate as the advantages or disadvantages that each type has is often just a tiny rounding error in the grand scheme of things. The reason for this decision is that i simply found the aforementioned property to be interesting to have.

        The proposed flags might seem weird and unnecessary, however they allow the detection of arithmetic edge-cases in a very granular manner. Many ISAs don't have any way of easily detecting overflows and, when present, they either provide instructions that trap or a flag register. In both cases the system will only allow the programmer to check if an overflow occurred at the word length only. FabRISC, not only provides the ability to check at all the standard lengths, but it also distinguishes overflows into two categories depending on the direction. This is useful to provide to the programmer a greater control and insight of the underlying system, as well as, enabling better backwards compatibility and emulation of CPUs with smaller word lengths.
    ])

    // fp comment
)

#pagebreak()

///
