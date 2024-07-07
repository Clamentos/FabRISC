///
#import "Macros.typ": *

///
#section(

    [(WORK IN PROGRESS) Instruction list],

    [This section is dedicated to provide the full and extensive list of all the proposed instructions in the ISA divided into their corresponding module.],

    [Systems that don't support certain modules must generate the INCI fault whenever an unimplemented or incompatible instruction is fetched or attempted to be processed in any other way. The ILLI fault whenever a combination of all zeros or all ones is fetched in order to increase safety against buffer overflows exploits or accidental accesses of uninitialized memory locations.],

    [As mentioned in previous sections, since some instructions can generate flags, they are not stored in any sort of flag register and they can be ignored unless the EXC or HLPR modules are implemented.],

    [Unused bits, designated with "-" or "x", must have a value of 0 by default for convention.],
)

    ///
    #subSection(

        [Computational integer scalar basic (CISB)],

        [These are simple integer scalar instructions to perform a variety of arithmetic and logical operations with registers or immediate values. The SGPRB is mandatory for this module.],

        align(center, table(

            columns: (auto, auto, auto, auto, auto),
            inset: 8pt,
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Mnemonic*])], [#align(center, [*Opcode*])], [#align(center, [*Format*])], [#align(center, [*Class*])], [#align(center, [*Description*])],

            // ...
        ))
    )

#pagebreak()

///
