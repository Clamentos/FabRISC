///
#import "Macros.typ": *

///
#section(

    [(WORK IN PROGRESS) Instruction list],

    [This section is dedicated to provide a full and extensive list of all the proposed instructions in the ISA divided into their corresponding module.],
    
    [Some instructions can generate flags but, since they are not stored in any sort of flag register, they must be ignored unless the GEE special purpose register is set in order to automatically trigger computational exceptions. Unused bits, designated with "-" or "x", must have a value of 0 by default for convention.]
)

    ///
    #subSection(

        [Computational integer scalar basic (CISB)],

        [These are simple integer scalar instructions to perform a variety of arithmetic and logical operations with registers or immediate values. The scalar register file is mandatory for this module.],

        align(center, table(

            columns: (auto, auto, auto, auto),
            inset: 8pt,
            align: (x, y) => (left + horizon, center + horizon, center + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Mnemonic*])], [#align(center, [*Opcode*])], [#align(center, [*Format*])], [#align(center, [*Description*])],

            [ADD], [0x00000], [3R-A.xx], [*Addition*: \ This instruction performs simple signed binary addition between three operands: $"ra" = "rb" + "rc"$. This instruction can raise the OVFL and UNFL flags.],

            [ADDU], [0x00000], [3R-A.xx], [*Addition Unsigned*: \ This instruction performs simple unsigned binary addition between three operands: $"ra" = "rb" + "rc"$. This instruction can raise the COVR flag.],

            [...], [...], [...], [...]
        ))
    )

///