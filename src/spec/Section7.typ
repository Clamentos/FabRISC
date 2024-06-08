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

            [ABS ], [_TBD_], [2R-A ], [0], [*Absolute Value*: \ This instruction computes the absolute value of the source register placing the result in the destination register: \ $"ra" = |"rb"|$. \ This instruction does not raise any flags.],

            [ADD ], [0x00000], [3R-A], [5], [*Addition*: \ This instruction computes the sum of the two source registers placing the result in the destination register: \ $"ra" = "rb" + "rc"$. \ This instruction can raise the OVFL and UNFL flags in signed mode, COVR in unsigned mode.],

            [SUB ], [_TBD_], [3R-A ], [5], [*Subtraction*: \ This instruction computes the difference of the two source registers placing the result in the destination register: \ $"ra" = "rb" - "rc"$. \ This instruction can raise the OVFL and UNFL flags in signed mode, COVR in unsigned mode.],

            [MIN ], [_TBD_], [3R-A ], [5], [*Minimum*: \ This instruction computes the minimum of the two source registers placing the result in the destination register: \ $"ra" = min("rb", "rc")$. \ This instruction does not raise any flags.],

            [MAX ], [_TBD_], [3R-A ], [5], [*Maximum*: \ This instruction computes the maximum of the two source registers placing the result in the destination register: \ $"ra" = max("rb", "rc")$. \ This instruction does not raise any flags.],

            [AND ], [_TBD_], [3R-A ], [6], [*Bitwise AND*: \ This instruction computes the bitwise AND of the two source registers placing the result in the destination register: \ $"ra" = "rb" and "rc"$. \ This instruction does not raise any flags.],

            [OR  ], [_TBD_], [3R-A ], [6], [*Bitwise OR*: \ This instruction computes the bitwise OR of the two source registers placing the result in the destination register: \ $"ra" = "rb" or "rc"$. \ This instruction does not raise any flags.],

            [XOR ], [_TBD_], [3R-A ], [6], [*Bitwise XOR*: \ This instruction computes the bitwise XOR of the two source registers placing the result in the destination register: \ $"ra" = "rb" xor "rc"$. \ This instruction does not raise any flags.],

            [IMP ], [_TBD_], [3R-A ], [6], [*Bitwise IMP*: \ This instruction computes the bitwise implication of the two source registers placing the result in the destination register: \ $"ra" = "rb" -> "rc"$. \ This instruction does not raise any flags.],

            [LSH ], [_TBD_], [3R-A ], [5], [*Left Shift*: \ This instruction computes the left shift of the two source registers placing the result in the destination register: \ $"ra" = "rb" << "rc"$. \ This instruction can raise the OVFL and UNFL flags in signed mode, COVR in unsigned mode.],

            [RSH ], [_TBD_], [3R-A ], [5], [*Right Shift*: \ This instruction computes the right shift of the two source registers placing the result in the destination register: \ $"ra" = "rb" >> "rc"$. \ This instruction can raise the UNFL flag in signed mode and the CUND in unsigned mode.],

            [SEQ ], [_TBD_], [3R-A ], [6], [*Set If Equal*: \ This instruction sets the destination register to 1 if the two source registers are equal or not equal depending on the mode, 0 otherwise: \ $"if(rb" == "rc") "then ra" = 1 "else ra" = 0$. \ This instruction does not raise any flags.],

            [SLT ], [_TBD_], [3R-A ], [5], [*Set If Less Than*: \ This instruction sets the destination register to 1 if the first source register is less than the second, 0 otherwise: \ $"if(rb" < "rc") "then ra" = 1 "else ra" = 0$. \ This instruction does not raise any flags.],

            [SLE ], [_TBD_], [3R-A ], [5], [*Set If Less Than Or Equal To*: \ This instruction sets the destination register to 1 if the first source register is less than or equal to the second, 0 otherwise: \ $"if(rb" <= "rc") "then ra" = 1 "else ra" = 0$. \ This instruction does not raise any flags.],

            [CMV ], [_TBD_], [3R-A ], [0], [*Conditional Move*: \ This instruction conditionally copies the value of the first source register into the destination register if the second source register is different than 0: \ $"if(rb" != 0) "then ra" = "rb" "else noop"$. \ This instruction does not raise any flags.],

            [LDI], [_TBD_], [RI-A], [4], [*Load Immediate*: \ This instruction writes the immediate value into the destination register: \ $"ra" 0 "imm"$. \ This instruction does not raise any flags.],

            [BLDI], [_TBD_], [RI-A], [4], [*Big Load Immediate*: \ This instruction writes the immediate value into the destination register: \ $"ra" 0 "imm"$. \ This instruction does not raise any flags.],

            [ADDIHPC], [_TBD_], [RI-A], [4], [*Addition Immediate High To PC*: \ ],

            [ADDI], [_TBD_], [2RI-B], [5], [*Addition Immediate*: \ This instruction computes the sum of the source register and an immediate constant placing the result in the destination register: \ $"ra" = "rb" + "imm"$. \ This instruction can raise the OVFL and UNFL flags in signed mode, COVR in unsigned mode.],

            [SUBI], [_TBD_], [2RI-B], [5], [*Subtraction Immediate*: \ This instruction computes the difference of the source register and an immediate value placing the result in the destination register: \ $"ra" = "rb" - "imm"$. \ This instruction can raise the OVFL and UNFL flags in signed mode, COVR in unsigned mode.],

            [MINI], [_TBD_], [2RI-B], [5], [*Minimum Immediate*: \ This instruction computes the minimum of the source register and an immediate value placing the result in the destination register: \ $"ra" = min("rb", "imm")$. \ This instruction does not raise any flags.],

            [MAXI], [_TBD_], [2RI-B], [5], [*Maximum Immediate*: \ This instruction computes the maximum of the source register and an immediate value placing the result in the destination register: \ $"ra" = max("rb", "imm")$. \ This instruction does not raise any flags.],

            [ANDI], [_TBD_], [2RI-B], [7], [*Bitwise AND Immediate*: \ This instruction computes the bitwise AND of the source register and an immediate value placing the result in the destination register: \ $"ra" = "rb" and "imm"$. \ This instruction does not raise any flags.],

            [ORI ], [_TBD_], [2RI-B], [7], [*Bitwise OR Immediate*: \ This instruction computes the bitwise OR of the source register and an immediate value placing the result in the destination register: \ $"ra" = "rb" or "imm"$. \ This instruction does not raise any flags.],

            [XORI], [_TBD_], [2RI-B], [7], [*Bitwise XOR Immediate*: \ This instruction computes the bitwise XOR of the source register and an immediate value placing the result in the destination register: \ $"ra" = "rb" xor "imm"$. \ This instruction does not raise any flags.],

            [IMPI], [_TBD_], [2RI-B], [7], [*Bitwise IMP Immediate*: \ This instruction computes the bitwise implication of the source register and an immediate value placing the result in the destination register: \ $"ra" = "rb" -> "imm"$. \ This instruction does not raise any flags.],

            [LSHI], [_TBD_], [2RI-B], [5], [*Left Shift Immediate*: \ This instruction computes the left shift of the source register and an immediate value placing the result in the destination register: \ $"ra" = "rb" << "imm"$. \ This instruction can raise the OVFL and UNFL flags in signed mode, COVR in unsigned mode.],

            [RSHI], [_TBD_], [2RI-B], [5], [*Right Shift Immediate*: \ This instruction computes the right shift of the source register and an immediate value placing the result in the destination register: \ $"ra" = "rb" >> "imm"$. \ This instruction can raise the UNFL flag in signed mode and the CUND in unsigned mode.],

            [SEQI], [_TBD_], [2RI-B], [7], [*Set If Equal Immediate*: \ This instruction sets the destination register to 1 if the source register is equal to an immediate value or not equal depending on the mode, 0 otherwise: \ $"if(rb" == "imm") "then ra" = 1 "else ra" = 0$. \ This instruction does not raise any flags.],

            [SLTI], [_TBD_], [2RI-B], [7], [*Set If Less Than Immediate*: \ This instruction sets the destination register to 1 if the first source register is less than an immediate value, 0 otherwise: \ $"if(rb" < "imm") "then ra" = 1 "else ra" = 0$. \ This instruction does not raise any flags.],

            [SLEI], [_TBD_], [2RI-B], [7], [*Set If Less Than Or Equal To Immediate*: \ This instruction sets the destination register to 1 if the first source register is less than or equal to immediate value, 0 otherwise: \ $"if(rb" <= "imm") "then ra" = 1 "else ra" = 0$. \ This instruction does not raise any flags.],

            [CLDI], [_TBD_], [2RI-B], [4], [*Conditional Load Immediate*: \ ],
            [ALN ], [_TBD_], [2RI-B], [1], [*Align*: \ ],
            [ALNU], [_TBD_], [2RI-B], [1], [*Align Unsigned*: \ ],
            [MRG ], [_TBD_], [3RI-A], [1], [*Merge*: \ ],
        ))
    )

#pagebreak()

///
