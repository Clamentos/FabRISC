///
#import "Macros.typ": *

///
#section(

    [Instruction List],

    [This section is dedicated to provide the full and extensive list of all the proposed instructions in the ISA divided into their corresponding module.],

    [Systems that don't support certain modules must generate the `INCI` fault whenever an unimplemented or incompatible instruction is fetched or attempted to be processed in any other way. The `ILLI` fault whenever a combination of all zeros, all ones or an otherwise illegal combination is fetched in order to increase safety against buffer overflows exploits or accidental accesses of uninitialized memory locations.],

    [As mentioned in previous sections, since some instructions can generate flags, they are not stored in any sort of flag register and they can be ignored unless the `EXC`, `HLPR` or both modules are implemented.],

    [Unused bits, designated with "-" or "x", must have a value of zero by default for convention.]
)

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Scalar Basic (`CISB`)],

        [This module provides simple integer scalar instructions to perform a variety of arithmetic and logical operations on registers and immediate values. The `SGPRB` is mandatory for this module.],

        tableWrapper([CISB instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`ABS`], [], [2R.A], [-], [-], [*Absolute Value*: Performs `ra = (rb < 0) ? (~rb + 1) : (rb)`.],

            [`EXT`], [], [2R.A], [`B`], [-], [*Sign Extend*: Performs `ra = SEXT(rb)`, that is, replicate the most significant bit from the size specified by the class to `WLEN`.],

            [`ADD`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Addition*: Performs `ra = rb + rc`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`SUB`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Subtraction*: Performs `ra = rb - rc`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`MIN`], [], [3R.A], [`A`], [-], [*Minimum*: Performs `ra = (rb < rc) ? (rb) : (rc)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`MAX`], [], [3R.A], [`A`], [-], [*Maximum*: Performs `ra = (rb > rc) ? (rb) : (rc)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`AND`], [], [3R.A], [`A`], [-], [*Bitwise AND*: Performs `ra = rb & rc`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`OR`], [], [3R.A], [`A`], [-], [*Bitwise OR*: Performs `ra = rb | rc`. This instruction class specifies: `10` (`-`) as _default_ mode and `11` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`XOR`], [], [3R.A], [`A`], [-], [*Bitwise XOR*: Performs `ra = rb ^ rc`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`IMP`], [], [3R.A], [`A`], [-], [*Bitwise IMP*: Performs `ra = !(!rb & rc)`. This instruction class specifies: `10` (`-`) as _default_ mode and `11` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`LSH`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Left Shift*: Performs `ra = rb << rc` filling the least significant bits with zeros. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`RSH`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Right Shift*: Performs `ra = rb >> rc` filling the most significant bits with either zeros or the sign depending on the mode. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`SEQ`], [], [3R.A], [`A`], [-], [*Set If Equal*: Performs `ra = (rb == rc) ? 1 : 0`. This instruction class specifies: `10` (`-`) as _default_ mode and `11` (`.I`) as _inverted_ mode, which simply inverts the checking condition.],

            [`SLT`], [], [3R.A], [`A`], [-], [*Set If Less Than*: Performs `ra = (rb < rc) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`SLE`], [], [3R.A], [`A`], [-], [*Set If Less Than Or Equal To*: Performs `ra = (rb <= rc) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`CMV`], [], [3R.A], [`A`], [-], [*Conditional Move*: Performs `ra = check(rb) ? (rb) : (ra)`. This instruction class specifies: `00` (`.EZ`) as _equal to zero_ mode, `01` (`.NZ`) _not equal to zero_ mode, `10` (`.LTZ`) _less than zero_ mode and `11` (`.LTZU`) _less than zero unsigned_ mode for the checking condition.],

            [`LDI`], [], [RI.A], [`D`], [-], [*Load Immediate*: Performs `ra = SEXT(imm)`.],

            [`HLDI`], [], [RI.A], [`D`], [-], [*High Load Immediate*: Performs `ra[WLEN:18] = SEXT(imm)` leaving the lower bits of `ra` unchanged.],

            [`ADDIHPC`], [], [RI.A], [`D`], [-], [*Add Immediate High To PC*: Performs `ra = PC + SEXT(imm << 18)`],

            [`ADDI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Addition Immediate*: Performs `ra = rb + EXT(imm)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`SUBI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Subtraction Immediate*: Performs `ra = rb - EXT(imm)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`MINI`], [], [2RI.A], [`A`], [-], [*Minimum Immediate*: Performs `ra = (rb < EXT(imm)) ? (rb) : (EXT(imm))`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`MAXI`], [], [2RI.A], [`A`], [-], [*Maximum Immediate*: Performs `ra = (rb > EXT(imm)) ? (rb) : (EXT(imm))`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`ANDI`], [], [2RI.A], [`A`], [-], [*Bitwise AND Immediate*: Performs `ra = rb & EXT(imm)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`ORI`], [], [2RI.A], [`A`], [-], [*Bitwise OR Immediate*: Performs `ra = rb | EXT(imm)`. This instruction class specifies: `10` (`-`) as _default_ mode and `11` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`XORI`], [], [2RI.A], [`A`], [-], [*Bitwise XOR Immediate*: Performs `ra = rb ^ EXT(imm)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`IMPI`], [], [2RI.A], [`A`], [-], [*Bitwise IMP Immediate*: Performs `ra = !(!rb & EXT(imm))`. This instruction class specifies: `10` (`-`) as _default_ mode and `11` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`LSHI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Left Shift Immediate*: Performs `ra = rb << imm` filling the least significant bits with zeros. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`RSHI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Right Shift Immediate*: Performs `ra = rb >> imm` filling the most significant bits with either zeros or the sign depending on the mode. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`SEQI`], [], [2RI.A], [`A`], [-], [*Set If Equal Immediate*: Performs `ra = (rb == EXT(imm)) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`SLTI`], [], [2RI.A], [`A`], [-], [*Set If Less Than Immediate*: Performs `ra = (rb < EXT(imm)) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`SLEI`], [], [2RI.A], [`A`], [-], [*Set If Less Than Or Equal To Immediate*: Performs `ra = (rb <= EXT(imm)) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`CLDI`], [], [2RI.A], [`A`], [-], [*Conditional Load Immediate*: Performs `ra = check(rb) ? (EXT(imm)) : (ra)`. This instruction class specifies: `00` (`.EZ`) as _equal to zero_ mode, `01` (`.NZ`) _not equal to zero_ mode, `10` (`.LTZ`) _less than zero_ mode and `11` (`.LTZU`) _less than zero unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.]
        ))
    )
))

#page(flipped: true, textWrap(
    
    subSection(

        [Computational Integer Scalar Advanced (`CISA`)],

        [This module provides integer scalar instructions to perform more complex arithmetic and logical operations on registers and immediate values. The `SGPRB` is mandatory for this module.],

        tableWrapper([CISA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CZ`], [], [2R.A], [`A`], [-], [*Count Zeros*: Performs `ra = CZ(rb)`, that is, the total number of zero bits in `rb`. Must always have a class mode value of `00`.],

            [`CLZ`], [], [2R.A], [`A`], [-], [*Count Leading Zeros*: Performs `ra = CLZ(rb)`, that is, the total number of leading zero bits in `rb`. Must always have a class mode value of `01`.],

            [`CTZ`], [], [2R.A], [`A`], [-], [*Count Trailing Zeros*: Performs `ra = CTZ(rb)`, that is, the total number of trailing zero bits in `rb`. Must always have a class mode value of `10`.],

            [`CO`], [], [2R.A], [`A`], [-], [*Count Ones*: Performs `ra = CO(rb)`, that is, the total number of one bits in `rb`. Must always have a class mode value of `00`.],

            [`CLO`], [], [2R.A], [`A`], [-], [*Count Leading Ones*: Performs `ra = CLO(rb)`, that is, the total number of leading one bits in `rb`. Must always have a class mode value of `01`.],

            [`CTO`], [], [2R.A], [`A`], [-], [*Count Trailing Ones*: Performs `ra = CTO(rb)`, that is, the total number of trailing one bits in `rb`. Must always have a class mode value of `10`.],

            [`MUL`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Multiplication*: Performs `ra = rb * rc` only keeping the least significant `WLEN` bits of the result. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`HMUL`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*High Multiplication*: Performs `ra = rb * rc` only keeping the most significant `WLEN` bits of the result. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`DIV`], [], [3R.A], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Division*: Performs `ra = FLOOR(rb / rc)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`REM`], [], [3R.A], [`A`], [`DIV0`, `INVOP`], [*Remainder*: Performs `ra = rb % rc`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )
            ],

            [`LRT`], [], [3R.A], [`A`], [-], [*Left Rotate*: Performs `ra = LRT(rb, rc)`. Must always have a class mode value of `00`.],
            [`RRT`], [], [3R.A], [`A`], [-], [*Right Rotate*: Performs `ra = RRT(rb, rc)`. Must always have a class mode value of `01`.],

            [`BSW`], [], [3R.A], [`A`], [-], [*Bit Swap*: Performs `ra = BSW(rb, rc)`, that is, swap the position of two ajacent groups of bits. The group size is determined by `rc` and follows powers of two. Must always have a class mode value of `10`.],

            [`BRV`], [], [3R.A], [`A`], [-], [*Bit Reverse*:  Performs `ra = BRV(rb, rc)`, that is, reverse the endianess of groups of bits. The group size is determined by `rc` and follows powers of two. Must always have a class mode value of `11`.],

            [`CLMUL`], [], [3R.A], [-], [-], [*Carryless Multiplication*: Performs `ra = rb * rc` discarding the carries at each step.],

            [`MAC`], [], [4R.A], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Multiply Accumulate*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `ra = rb + (rc * rd)`],
                    [`.NMA`: `ra = (-rb) + (rc * rd)`],
                    [`.MS`: `ra = rb - (rc * rd)`],
                    [`.NMS`: `ra = (-rb) - (rc * rd)`]
                )

            The multiplication part of the operation only considers the least significant `WLEN` bits.],

            [`MACU`], [], [4R.A], [`G`], [`COVRn`], [*Multiply Accumulate Unsigned*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `ra = rb + (rc * rd)`],
                    [`.NMA`: `ra = (-rb) + (rc * rd)`],
                    [`.MS`: `ra = rb - (rc * rd)`],
                    [`.NMS`: `ra = (-rb) - (rc * rd)`]
                )

            The multiplication part of the operation only considers the least significant `WLEN` bits and all of the steps performed are unsigned.],

            [`PER`], [], [3R.A], [`A`], [-], [*Permute*: Performs `ra = PER(rb, rc)`, that is, moves groups of four bits from `rb` according to the index specified in `rc`. Must always have a class mode value of `00`.],

            [`MIX`], [], [4R.A], [`A`], [-], [*Mix*: Performs `ra = MIX(rb, rc, rd)`, that is, choses and moves bytes from `rb` and `rc` according to the select and index bits of `rd`. Must always have a class mode value of `00`.],

            [`MULI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Multiplication Immediate*: Performs `ra = rb * EXT(imm)` only keeping the least significant `WLEN` bits of the result. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.],

            [`HMULI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*High Multiplication Immediate*: Performs `ra = rb * EXT(imm)` only keeping the most significant `WLEN` bits of the result. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.],

            [`DIVI`], [], [2RI.A], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Division Immediate*: Performs `ra = FLOOR(rb / EXT(imm))`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.],

            [`REMI`], [], [2RI.A], [`A`], [`DIV0`, `INVOP`], [*Remainder Immediate*: Performs `ra = rb % EXT(imm)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )

            The immediate will be sign or zero extended according to the specified mode.],

            [`LRTI`], [], [2RI.A], [`A`], [-], [*Left Rotate Immediate*: Performs `ra = LRT(rb, imm)`. Must always have a class mode value of `00`.],

            [`RRTI`], [], [2RI.A], [`A`], [-], [*Right Rotate Immediate*: Performs `ra = RRT(rb, imm)`. Must always have a class mode value of `01`.],

            [`BSWI`], [], [2RI.A], [`A`], [-], [*Bit Swap Immediate*: Performs `ra = BSW(rb, imm)`, that is, swap the position of two ajacent groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. Must always have a class mode value of `10`.],

            [`BRVI`], [], [2RI.A], [`A`], [-], [*Bit Reverse Immediate*:  Performs `ra = BRV(rb, imm)`, that is, reverse the endianess of groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. Must always have a class mode value of `11`.],

            [`CLMULI`], [], [2RI.A], [`A`], [-], [*Carryless Multiplication Immediate*: Performs `ra = rb * EXT(imm)` discarding the carries at each step. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.],

            [`MACI`], [], [3RI.A], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Multiply Accumulate Immediate*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `ra = rb + (rc * SEXT(imm))`],
                    [`.NMA`: `ra = (-rb) + (rc * SEXT(imm))`],
                    [`.MS`: `ra = rb - (rc * SEXT(imm))`],
                    [`.NMS`: `ra = (-rb) - (rc * SEXT(imm))`]
                )

            The multiplication part of the operation only considers the least significant `WLEN` bits.],

            [`MACUI`], [], [3RI.A], [`G`], [`COVRn`], [*Multiply Accumulate Unsigned Immediate*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `ra = rb + (rc * imm)`],
                    [`.NMA`: `ra = (-rb) + (rc * imm)`],
                    [`.MS`: `ra = rb - (rc * imm)`],
                    [`.NMS`: `ra = (-rb) - (rc * imm)`]
                )

            The multiplication part of the operation only considers the least significant `WLEN` bits, all of the steps performed are unsigned and the immediate is always zero extended.],
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Scalar Multiword (`CISM`)],

        [This module provides integer scalar instructions to perform arithmetic and logical operations on registers with additional operands to allow chaining. The `SGPRB` is mandatory for this module.],

        tableWrapper([CISM Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`BADD`], [], [4.RA], [`A`], [-], [*Big Addition*: Performs `ra = rb + rc + rd; rd = carry_out`. Must always have a class mode value of `00`.],

            [`BSUB`], [], [4.RA], [`A`], [-], [*Big Subtraction*: Performs `ra = rb - rc - rd; rd = carry_out`. Must always have a class mode value of `01`.],

            [`BLSH`], [], [4.RA], [`A`], [-], [*Big Left Shift*: Performs `ra = rb << rc (rd); rd = shifted_out`. This instruction shifts in bits from `rd` instead of zeros. Must always have a class mode value of `00`.],

            [`BRSH`], [], [4.RA], [`A`], [-], [*Big Right Shift*: Performs `ra = rb >> rc (rd); rd = shifted_out`. This instruction shifts in bits from `rd` instead of zeros. Must always have a class mode value of `01`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Vector Basic (`CIVB`)],

        [This module provides integer vector instructions to perform basic arithmetic and logical operations on registers and immediate values in a data-parallel manner. The `VGPRB` is mandatory for this module. If neither the `FIV` or `FFV` modules are impelemnted the masking function must never mask any element and must act as a no operation.],

        tableWrapper([CIVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VABS`], [], [3R.A], [`E`], [-], [*Vector Absolute Value*: Performs `va = MASK((vc < 0) ? (~vc + 1) : (vc), vb)`.],

            [`VADD`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Addition*: Performs `va = MASK(vc + vd, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VSUB`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Subtraction*: Performs `va = MASK(vc - vd, vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`VMIN`], [], [4R.B], [`A`], [-], [*Vector Minimum*: Performs `va = MASK((vc < vd) ? (vc) : (vd), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VMAX`], [], [4R.B], [`A`], [-], [*Vector Maximum*: Performs `va = MASK((vc > vd) ? (vc) : (vd), vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`VAND`], [], [4R.B], [`A`], [-], [*Vector Bitwise AND*: Performs `va = MASK(vc & vd, vb)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`VOR`], [], [4R.B], [`A`], [-], [*Vector Bitwise OR*: Performs `va = MASK(vc | vd, vb)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`VXOR`], [], [4R.B], [`A`], [-], [*Vector Bitwise XOR*: Performs `va = MASK(vc ^ vd, vb)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`VIMP`], [], [4R.B], [`A`], [-], [*Vector Bitwise IMP*: Performs `va = MASK(!(!vc & vd), vb)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`VLSH`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Left Shift*: Performs `va = MASK(vc << vd, vb)` filling the least significant bits with zeros. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VRSH`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Vector Right Shift*: Performs `va = MASK(vc >> vd, vb)` filling the most significant bits with either zeros or the sign depending on the mode. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`VLDI`], [], [2RI.B], [`E`], [-], [*Vector Load Immediate*: Performs `va = MASK(SEXT(imm), vb)`. This instruction broadcasts the immediate to all the configured vector elements.],

            [`VHLDI`], [], [2RI.B], [`E`], [-], [*Vector High Load Immediate*: Performs `va[WLEN:16] = MASK(SEXT(imm), vb)` leaving the lower bits of `va` unchanged. This instruction broadcasts the immediate to all the configured vector elements.],

            [`VADDI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Addition Immediate*: Performs `va = MASK(vc + EXT(imm), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.],

            [`VSUBI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Subtraction Immediate*: Performs `va = MASK(vc - EXT(imm), vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.],

            [`VMINI`], [], [3RI.B], [`A`], [-], [*Vector Minimum Immediate*: Performs `va = MASK((vc < SEXT(imm)) ? (vc) : (SEXT(imm)), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.],

            [`VMAXI`], [], [3RI.B], [`A`], [-], [*Vector Maximum Immediate*: Performs `va = MASK((vc > SEXT(imm)) ? (vc) : (SEXT(imm)), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode.],

            [`VANDI`], [], [3RI.B], [`A`], [-], [*Vector Bitwise AND Immediate*: Performs `va = MASK(vc & EXT(imm), vb)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result and the immediate will be sign or zero extended according to the specified mode.],

            [`VORI`], [], [3RI.B], [`A`], [-], [*Vector Bitwise OR Immediate*: Performs `va = MASK(vc | EXT(imm), vb)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result and the immediate will be sign or zero extended according to the specified mode.],

            [`VXORI`], [], [3RI.B], [`A`], [-], [*Vector Bitwise XOR Immediate*: Performs `va = MASK(vc ^ EXT(imm), vb)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result and the immediate will be sign or zero extended according to the specified mode.],

            [`VIMPI`], [], [3RI.B], [`A`], [-], [*Vector Bitwise IMP Immediate*: Performs `va = MASK(!(!vc & EXT(imm)), vb)`. This instruction class specifies: `00` (`-`) as _default_ mode and `01` (`.I`) as _inverted_ mode, which simply inverts the result and the immediate will be sign or zero extended according to the specified mode.],

            [`VLSHI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Left Shift Immediate*: Performs `va = MASK(vc << imm, vb)` filling the least significant bits with zeros. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VRSHI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Vector Right Shift Immediate*: Performs `va = MASK(vc >> imm, vb)` filling the most significant bits with either zeros or the sign depending on the mode. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Vector Advanced (`CIVA`)],

        [This module provides integer vector instructions to perform complex arithmetic and logical operations on registers or immediate values in a data-parallel manner. The `VGPRB` is mandatory for this module. If neither the `FIV` or `FFV` modules are impelemnted the masking function must never mask any element and must act as a no operation.],

        tableWrapper([CIVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],          

            [`VCZ`], [], [3R.A], [`E`], [-], [*Vector Count Zeros*: Performs `va = MASK(CZ(vc), vb)`, that is, the total number of zero bits in `vc`.],

            [`VCLZ`], [], [3R.A], [`E`], [-], [*Vector Count Leading Zeros*: Performs `va = MASK(CLZ(vc), vb)`, that is, the total number of leading zero bits in `vc`.],

            [`VCTZ`], [], [3R.A], [`E`], [-], [*Vector Count Trailing Zeros*: Performs `va = MASK(CTZ(vc), vb)`, that is, the total number of trailing zero bits in `vc`.],

            [`VCO`], [], [3R.A], [`E`], [-], [*Vector Count Ones*: Performs `va = MASK(CO(vc), vb)`, that is, the total number of one bits in `vc`.],

            [`VCLO`], [], [3R.A], [`E`], [-], [*Vector Count Leading Ones*: Performs `ra = MASK(CLO(vc), vb)`, that is, the total number of leading one bits in `vc`.],

            [`VCTO`], [], [3R.A], [`E`], [-], [*Vector Count Trailing Ones*: Performs `ra = MASK(CTO(vc), vb)`, that is, the total number of trailing one bits in `vc`.],

            [`VMUL`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Multiplication*: Performs `va = MASK(vc * vd, vc)` only keeping the least significant half of the result. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VHMUL`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector High Multiplication*: Performs `va = MASK(vc * vd), vb` only keeping the most significant half of the result. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`VDIV`], [], [4R.B], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Vector Division*: Performs `va = MASK(FLOOR(vc / vd), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VREM`], [], [4R.B], [`A`], [`DIV0`, `INVOP`], [*Vector Remainder*: Performs `va = MASK(vc % vd, vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )
            ],

            [`VLRT`], [], [4R.B], [`A`], [-], [*Vector Left Rotate*: Performs `va = MASK(LRT(vc, vd), vb)`. Must always have a class mode value of `00`.],

            [`VRRT`], [], [4R.B], [`A`], [-], [*Vector Right Rotate*: Performs `va = MASK(RRT(vc, vd), vb)`. Must always have a class mode value of `01`.],

            [`VBSW`], [], [4R.B], [`A`], [-], [*Vector Bit Swap*: Performs `va = MASK(BSW(vc, vd), vb)`, that is, swap the position of two ajacent groups of bits. The group size is determined by `vd` and follows powers of two. Must always have a class mode value of `10`.],

            [`VBRV`], [], [4R.B], [`A`], [-], [*Vector Bit Reverse*:  Performs `va = MASK(BRV(vc, vd), vb)`, that is, reverse the endianess of groups of bits. The group size is determined by `vd` and follows powers of two. Must always have a class mode value of `11`.],

            [`VCLMUL`], [], [4R.B], [-], [-], [*Vector Carryless Multiplication*: Performs `va = MASK(vc * vd)` discarding the carries at each step.],

            [`VMAC`], [], [4R.B], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Vector Multiply Accumulate*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * vd), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * vd), vb)`],
                    [`.MS`: `va = MASK(va - (vc * vd), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * vd), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result.],

            [`VMACU`], [], [4R.B], [`G`], [`COVRn`], [*Vector Multiply Accumulate Unsigned*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * vd), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * vd), vb)`],
                    [`.MS`: `va = MASK(va - (vc * vd), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * vd), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result and all of the steps performed are unsigned.],

            [`VPER`], [], [4R.B], [`A`], [-], [*Vector Permute*: Performs `va = MASK(PER(vc, vd), vb)`, that is, moves groups of four bits from `vc` according to the index specified in `vd`. Must always have a class mode value of `00`.],

            [`VMIX`], [], [4R.B], [`A`], [-], [*Vector Mix*: Performs `va = MIX(vb, vc, vd)`, that is, choses and moves bytes from `vb` and `vc` according to the select and index bits of `vd`. Must always have a class mode value of `01`.],

            [`VMULI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Multiplication Immediate*: Performs `va = MASK(vc * EXT(imm), vb)` only keeping the least significant half of the result. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode and is always broadcasted to all the vector elements.],

            [`VHMULI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector High Multiplication Immediate*: Performs `va = MASK(vc * EXT(imm), vb)` only keeping the most significant half of the result. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode and is always broadcasted to all the vector elements.],

            [`VDIVI`], [], [3RI.B], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Vector Division Immediate*: Performs `va = MASK(FLOOR(vc / EXT(imm)), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode and is always broadcasted to all the vector elements.],

            [`VREMI`], [], [3RI.B], [`A`], [`DIV0`, `INVOP`], [*Vector Remainder Immediate*: Performs `va = MASK(vc % EXT(imm), vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )

            The immediate will be sign or zero extended according to the specified mode and is always broadcasted to all the vector elements.],

            [`VLRTI`], [], [3RI.B], [`A`], [-], [*Vector Left Rotate Immediate*: Performs `va = MASK(LRT(vc, imm), vb)`. The immediate is always broadcasted to all the vector elements. This instruction Must always have a class mode value of `00`.],

            [`VRRTI`], [], [3RI.B], [`A`], [-], [*Vector Right Rotate Immediate*: Performs `va = MASK(RRT(vc, imm), vb)`. The immediate is always broadcasted to all the vector elements. This instruction Must always have a class mode value of `01`.],

            [`VBSWI`], [], [3RI.B], [`A`], [-], [*Vector Bit Swap Immediate*: Performs `va = MASK(BSW(vc, imm), vb)`, that is, swap the position of two ajacent groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. The immediate is always broadcasted to all the vector elements. This instruction Must always have a class mode value of `10`.],
        
            [`VBRVI`], [], [3RI.B], [`A`], [-], [*Vector Bit Reverse Immediate*:  Performs `va = MASK(BRV(vc, imm), vb)`, that is, reverse the endianess of groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. The immediate is always broadcasted to all the vector elements. This instruction Must always have a class mode value of `11`.],

            [`VCLMULI`], [], [3RI.B], [`A`], [-], [*Vector Carryless Multiplication Immediate*: Performs `va = MASK(vc * EXT(imm), vb)` discarding the carries at each step. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the immediate will be sign or zero extended according to the specified mode and always broadcasted to all the vector elements.],

            [`VMACI`], [], [3RI.B], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Vector Multiply Accumulate Immediate*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * SEXT(imm)), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * SEXT(imm)), vb)`],
                    [`.MS`: `va = MASK(va - (vc * SEXT(imm)), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * SEXT(imm)), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result and the immediate is always broadcasted to all the vector elements.],

            [`VMACUI`], [], [3RI.B], [`G`], [`COVRn`], [*Vector Multiply Accumulate Unsigned Immediate*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * imm), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * imm), vb)`],
                    [`.MS`: `va = MASK(va - (vc * imm), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * imm), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result, all of the steps performed are unsigned and the immediate is always zero extended and broadcasted to all the vector elements.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Vector Reductions (`CIVR`)],

        [This module provides integer vector instructions to perform arithmetic and logical reduction operations on registers in a data-parallel manner. The `VGPRB` is mandatory for this module. If neither the `FIV` or `FFV` modules are impelemnted the masking function must never mask any element and must act as a no operation.],

        tableWrapper([CIVR Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`RADD`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`], [*Reduced Addition*: Performs `va = SUM(MASK(vc, vb))`, that is, sum all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RADDU`], [], [3R.A], [`E`], [`COVRn`], [*Reduced Addition Unsigned*: Performs `va = SUM(MASK(vc, vb))`, that is, sum all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RSUB`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`], [*Reduced Subtraction*: Performs `va = SUB(MASK(vc, vb))`, that is, subtract all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RSUBU`], [], [3R.A], [`E`], [`COVRn`], [*Reduced Subtraction Unsigned*: Performs `va = SUB(MASK(vc, vb))`, that is, subtract all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RMIN`], [], [3R.A], [`E`], [-], [*Reduced Minimum*: Performs `va = MIN(MASK(vc, vb))`, that is, find the minimum between all the elements of `vc` together as signed integers, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RMINU`], [], [3R.A], [`E`], [-], [*Reduced Minimum Unsigned*: Performs `va = MIN(MASK(vc, vb))`, that is, find the minimum between all the elements of `vc` together as unsigned integers, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RMAX`], [], [3R.A], [`E`], [-], [*Reduced Maximum*: Performs `va = MAX(MASK(vc, vb))`, that is, find the maximum between all the elements of `vc` together as signed integers, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RMAXU`], [], [3R.A], [`E`], [-], [*Reduced Maximum Unsigned*: Performs `va = MAX(MASK(vc, vb))`, that is, find the maximum between all the elements of `vc` together as unsigned integers, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RAND`], [], [3R.A], [`E`], [-], [*Reduced Bitwise AND*: Performs `va = AND(MASK(vc, vb))`, that is, bitwise AND all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RNAND`], [], [3R.A], [`E`], [-], [*Reduced Bitwise NAND*: Performs `va = NAND(MASK(vc, vb))`, that is, bitwise NAND all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`ROR`], [], [3R.A], [`E`], [-], [*Reduced Bitwise OR*: Performs `va = OR(MASK(vc, vb))`, that is, bitwise OR all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RNOR`], [], [3R.A], [`E`], [-], [*Reduced Bitwise NOR*: Performs `va = NOR(MASK(vc, vb))`, that is, bitwise NOR all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RXOR`], [], [3R.A], [`E`], [-], [*Reduced Bitwise XOR*: Performs `va = XOR(MASK(vc, vb))`, that is, bitwise XOR all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RXNOR`], [], [3R.A], [`E`], [-], [*Reduced Bitwise XNOR*: Performs `va = XNOR(MASK(vc, vb))`, that is, bitwise XNOR all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RIMP`], [], [3R.A], [`E`], [-], [*Reduced Bitwise IMP*: Performs `va = IMP(MASK(vc, vb))`, that is, bitwise IMP all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RNIMP`], [], [3R.A], [`E`], [-], [*Reduced Bitwise NIMP*: Performs `va = NIMP(MASK(vc, vb))`, that is, bitwise NIMP all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Compressed (`CIC`)],

        [This module provides integer compressed instructions to perform arithmetic and logical operations on registers and immediate values with a smaller code footprint. The `SGPRB` is mandatory for this module.],

        tableWrapper([CIC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CADD`], [], [2R.B], [`F`], [`OVFLn`, `UNFLn`], [*Compressed Addition*: Performs `ra = ra + rc`. The operands are always considered signed.],

            [`CSUB`], [], [2R.B], [`F`], [`OVFLn`, `UNFLn`], [*Compressed Subtraction*: Performs `ra = ra - rc`. The operands are always considered signed.],

            [`CMOV`], [], [2R.B], [`F`], [-], [*Compressed Move*: Performs `ra = rb`.],
            [`CAND`], [], [2R.B], [`F`], [-], [*Compressed Bitwise AND*: Performs `ra = ra & rb`.],

            [`CLSH`], [], [2R.B], [`F`], [`OVFLn`, `UNFLn`], [*Compressed Left Shift*: Performs `ra = ra << rb`. The operands are always considered signed.],

            [`CRSH`], [], [2R.B], [`F`], [`OVFLn`, `UNFLn`, `CUND`], [*Compressed Right Shift*: Performs `ra = ra >> rb`. The operands are always considered signed.],

            [`CADDI`], [], [RI.B], [-], [`OVFLn`, `UNFLn`], [*Compressed Addition Immediate*: Performs `ra = ra + SEXT(imm)`. The operands are always considered signed.],

            [`CANDI`], [], [RI.B], [-], [-], [*Compressed Bitwise AND Immediate*: Performs `ra = ra & SEXT(imm)`.],

            [`CLSHI`], [], [RI.B], [-], [`OVFLn`, `UNFLn`], [*Compressed Left Shift Immediate*: Performs `ra = ra << imm`. The operands are always considered signed.],

            [`CRSHI`], [], [RI.B], [-], [`OVFLn`, `UNFLn`, `CUND`], [*Compressed Right Shift Immediate*: Performs `ra = ra >> imm`. The operands are always considered signed.],

            [`CLDI`], [], [RI.B], [-], [-], [*Compressed Load Immediate*: Performs `ra = SEXT(imm)`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Scalar Basic (`CFSB`)],

        [This module provides floating point instructions to perform arithmetic operations on registers and immediate values. The `SGPRB` is mandatory for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFSB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CFI`], [], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To Integer*: Performs `ra = FP_TO_INT(rb)`, that is, convert `rb` to the closest integer dictated by the rounding mode and place the result in `ra`. The length modifier is applied to all operands.],

            [`CFIT`], [], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To Integer Truncated*: Performs `ra = TRUNC(rb)`, that is, truncate `rb` and place the result in `ra`. The length modifier is applied to all operands.],

            [`CIF`], [], [2R.A], [`B`], [`INVOP`], [*Cast Integer To FP*: Performs `ra = INT_TO_FP(rb)`, that is, convert `rb` into floating point notation and place the result into `ra`. The length modifier is applied to all operands.],

            [`CFF1`], [], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To FP1*: Performs `ra = CAST(rb)`, that is, cast `rb` to a one byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF2`], [], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To FP2*: Performs `ra = CAST(rb)`, that is, cast `rb` to a two byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF4`], [], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To FP4*: Performs `ra = CAST(rb)`, that is, cast `rb` to a four byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF8`], [], [2R.A], [`B`], [`INVOP`], [*Cast FP To FP8*: Performs `ra = CAST(rb)`, that is, cast `rb` to a eight byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`FADD`], [], [3R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Addition*: Performs `ra = rb + rc`. The length modifier is applied to all operands.],

            [`FSUB`], [], [3R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Subtraction*: Performs `ra = rb - rc`. The length modifier is applied to all operands.],

            [`FMUL`], [], [3R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Multiplication*: Performs `ra = rb * rc`. The length modifier is applied to all operands.],

            [`FDIV`], [], [3R.A], [`B`], [`OVFLn`, `UNFLn`, `DIV0`], [*FP Division*: Performs `ra = rb / rc`. The length modifier is applied to all operands.],

            [`FMIN`], [], [3R.A], [`B`], [`INVOP`], [*FP Minimum*: Performs `ra = (rb < rc) ? (rb) : (rc)`. The length modifier is applied to all operands.],

            [`FMAX`], [], [3R.A], [`B`], [`INVOP`], [*FP Maximum*: Performs `ra = (rb > rc) ? (rb) : (rc)`. The length modifier is applied to all operands.],

            [`FSLT`], [], [3R.A], [`B`], [`INVOP`], [*FP Set If Less Than*: Performs `ra = (rb < rc) ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSLE`], [], [3R.A], [`B`], [`INVOP`], [*FP Set If Less Or Equal*: Performs `ra = (rb <= rc) ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSGT`], [], [3R.A], [`B`], [`INVOP`], [*FP Set If Greater Than*: Performs `ra = (rb > rc) ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSGE`], [], [3R.A], [`B`], [`INVOP`], [*FP Set If Greater Or Equal*: Performs `ra = (rb >= rc) ? 1 : 0`. The length modifier is applied to all operands.],

            [`FMADD`], [], [4R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Multiply Add*: Performs `ra = rb + (rc * rd)` with only one rounding step. The length modifier is applied to all operands.],

            [`FNMADD`], [], [4R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Negative Multiply Add*: Performs `ra = (-rb) + (rc * rd)` with only one rounding step. The length modifier is applied to all operands.],

            [`FMSUB`], [], [4R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Multiply Subtract*: Performs `ra = rb - (rc * rd)` with only one rounding step. The length modifier is applied to all operands.],

            [`FNMSUB`], [], [4R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Negative Multiply Subtract*: Performs `ra = (-rb) - (rc * rd)` with only one rounding step. The length modifier is applied to all operands.],

            [`FADDI`], [], [2RI.B], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Addition Immediate*: Performs `ra = rb + imm`. The length modifier is applied to all operands.],

            [`FSUBI`], [], [2RI.B], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Subtraction Immediate*: Performs `ra = rb - imm`. The length modifier is applied to all operands.],

            [`FMULI`], [], [2RI.B], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Multiplication Immediate*: Performs `ra = rb * imm`. The length modifier is applied to all operands.],

            [`FDIVI`], [], [2RI.B], [`B`], [`OVFLn`, `UNFLn`, `DIV0`, `INVOP`], [*FP Division Immediate*: Performs `ra = rb / imm`. The length modifier is applied to all operands.],

            [`FMINI`], [], [2RI.B], [`B`], [`INVOP`], [*FP Minimum Immediate*: Performs `ra = (rb < imm) ? (rb) : (imm)`. The length modifier is applied to all operands.],

            [`FMAXI`], [], [2RI.B], [`B`], [`INVOP`], [*FP Maximum Immediate*: Performs `ra = (rb > imm) ? (rb) : (imm)`. The length modifier is applied to all operands.],

            [`FSLTI`], [], [2RI.B], [`B`], [`INVOP`], [*FP Set If Less Than Immediate*: Performs `ra = (rb < imm) ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSLEI`], [], [2RI.B], [`B`], [`INVOP`], [*FP Set If Less Or Equal Immediate*: Performs `ra = (rb <= imm) ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSGTI`], [], [2RI.B], [`B`], [`INVOP`], [*FP Set If Greater Than Immediate*: Performs `ra = (rb > imm) ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSGEI`], [], [2RI.B], [`B`], [`INVOP`], [*FP Set If Greater Or Equal Immediate*: Performs `ra = (rb >= imm) ? 1 : 0`. The length modifier is applied to all operands.],

            [`FMADDI`], [], [3RI.A], [`B`], [`OVFLn`, `UNFLn`,`INVOP`], [*FP Multiply Add Immediate*: Performs `ra = rb + (rc * imm)` with only one rounding step. The length modifier is applied to all operands.],

            [`FNMADDI`], [], [3RI.A], [`B`], [`OVFLn`, `UNFLn`,`INVOP`], [*FP Negative Multiply Add Immediate*: Performs `ra = (-rb) + (rc * imm)` with only one rounding step. The length modifier is applied to all operands.],

            [`FMSUBI`], [], [3RI.A], [`B`], [`OVFLn`, `UNFLn`,`INVOP`], [*FP Multiply Subtract Immediate*: Performs `ra = rb - (rc * imm)` with only one rounding step. The length modifier is applied to all operands.],

            [`FNMSUBI`], [], [3RI.A], [`B`], [`OVFLn`, `UNFLn`,`INVOP`], [*FP Negative Multiply Subtract Immediate*: Performs `ra = (-rb) - (rc * imm)` with only one rounding step. The length modifier is applied to all operands.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Scalar Advanced (`CFSA`)],

        [This module provides floating point instructions to perform more complex arithmetic operations on registers. The `SGPRB` is mandatory for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFSA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`FSQRT`], [], [2R.A], [`B`], [`UNFLn`, `INVOP`], [*FP Square Root*: Performs `ra = SQRT(rb)`. The length modifier is applied to all operands.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Vector Basic (`CFVB`)],

        [This module provides floating point vector instructions to perform basic arithmetic and logical operations on registers and immediate values in a data-parallel manner. The `VGPRB` is mandatory for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VCFI`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To Integer*: Performs `va = MASK(FP_TO_INT(vc), vb)`, that is, convert `vc` to the closest integer dictated by the rounding mode and place the result in `va`.],

            [`VCFIT`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To Integer Truncated*: Performs `va = MASK(TRUNC(vc), vb)`, that is, truncate `vc` and place the result in `va`.],

            [`VCIF`], [], [3R.A], [`E`], [`INVOP`], [*Vector Cast Integer To FP*: Performs `va = MASK(INT_TO_FP(vc), vb)`, that is, convert `vc` into floating point notation and place the result into `va`.],

            [`VCFF1`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To FP 1*: Perfoms `va = MASK(CAST1(vc), vb)`, that is, cast `vc` into the specified floating point type and place the result in `va`. The length of `vc` is dictated by the cuent vector shape and the result is compactified to the final shape.],

            [`VCFF2`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To FP 2*: Perfoms `va = MASK(CAST2(vc), vb)`, that is, cast `vc` into the specified floating point type and place the result in `va`. The length of `vc` is dictated by the cuent vector shape and the result is compactified to the final shape.],

            [`VCFF4`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To FP 4*: Perfoms `va = MASK(CAST4(vc), vb)`, that is, cast `vc` into the specified floating point type and place the result in `va`. The length of `vc` is dictated by the cuent vector shape and the result is compactified to the final shape.],

            [`VCFF8`], [], [3R.A], [`E`], [`INVOP`], [*Vector Cast FP To FP 8*: Perfoms `va = MASK(CAST8(vc), vb)`, that is, cast `vc` into the specified floating point type and place the result in `va`. The length of `vc` is dictated by the cuent vector shape and the result is compactified to the final shape.],

            [`VFADD`], [], [4R.B],[`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Addition*: Performs `va = MASK(vc + vd, vb)`. Must always have a class mode value of `00`.],

            [`VFSUB`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Subtraction*: Performs `va = MASK(vc - vd, vb)`. Must always have a class mode value of `01`.],

            [`VFMUL`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Multiplication*: Performs `va = MASK(vc * vd, vb)`. Must always have a class mode value of `10`.],

            [`VFDIV`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `DIV0`, `INVOP`], [*Vector FP Division*: Performs `va = MASK(vc / vd, vb)`. Must always have a class mode value of `11`.],

            [`VFMIN`], [], [4R.B], [`A`], [`INVOP`], [*Vector FP Minimum*: Performs `va = MASK((vc < vd) ? (vc) : (vd), vb)`. Must always have a class mode value of `00`.],

            [`VFMAX`], [], [4R.B], [`A`], [`INVOP`], [*Vector FP Maximum*: Performs `va = MASK((vc > vd) ? (vc) : (vd), vb)`. Must always have a class mode value of `01`.],

            [`VFMAC`], [], [4R.B], [`G`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Multiply Accumulate*: Performs one of the following depending on the class mode with one rounding step:

                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * vd), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * vd), vb)`],
                    [`.MS`: `va = MASK(va - (vc * vd), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * vd), vb)`]
                )
            ],

            [`VFADDI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Addition Immediate*: Performs `va = MASK(vc + imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `00`.],

            [`VFSUBI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Subtraction Immediate*: Performs `va = MASK(vc - imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `01`.],

            [`VFMULI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Multiplication Immediate*: Performs `va = MASK(vc * imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `10`.],

            [`VFDIVI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `DIV0`, `INVOP`], [*Vector FP Division Immediate*: Performs `va = MASK(vc / imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `11`.],

            [`VFMINI`], [], [3RI.B], [`A`], [`INVOP`], [*Vector FP Minimum Immediate*: Performs `va = MASK((vc < imm) ? (vc) : (imm), vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `00`.],

            [`VFMAXI`], [], [3RI.B], [`A`], [`INVOP`], [*Vector FP Maximum Immediate*: Performs `va = MASK((vc < imm) ? (vc) : (imm), vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `01`.],

            [`VFMACI`], [], [3RI.B], [`G`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Multiply Accumulate Immediate*: Performs one of the following depending on the class mode with one rounding step:

                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * imm), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * imm), vb)`],
                    [`.MS`: `va = MASK(va - (vc * imm), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * imm), vb)`]
                )

            The immediate is always broadcasted to all the vector elements.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Vector Advanced (`CFVA`)],

        [This module provides floating point vector instructions to perform more complex arithmetic and logical operations on registers values in a data-parallel manner. The `VGPRB` is mandatory for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VSQRT`], [], [3R.A], [`E`], [`UNFLn`, `INVOP`], [*Vector FP Square Root*: Performs `va = SQRT(vb)`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Vector Reductions (`CFVR`)],

        [This module provides integer vector instructions to perform arithmetic and logical reductions operations on registers values in a data-parallel manner. The `VGPRB` is mandatory for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFVR Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`RFADD`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Reduced FP Addition*: Performs `va = SUM(MASK(vc, vb))`, that is, sum all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFSUB`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Reduced FP Subtraction*: Performs `va = SUB(MASK(vc, vb))`, that is, subtract all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFMUL`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Reduced FP Multiplication*: Performs `va = MUL(MASK(vc, vb))`, that is, multiply all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFDIV`], [], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `DIV0`, `INVOP`], [*Reduced FP Division*: Performs `va = DIV(MASK(vc, vb))`, that is, divide all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFMIN`], [], [3R.A], [`E`], [`INVOP`], [*Reduced FP Minimum*: Performs `va = MIN(MASK(vc, vb))`, that is, find the minimum between all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFMAX`], [], [3R.A], [`E`], [`INVOP`], [*Reduced FP Maximum*: Performs `va = MAX(MASK(vc, vb))`, that is, find the maximum between all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Data Scalar Basic (`DSB`)],
        [This module provides basic scalar memory transfer operations. The `SGPRB` is mandatory for this module.],

        tableWrapper([DSB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`MLD`], [], [2RI.A], [`B`], [-], [*Memory Load*: Performs `ra = SEXT(MEM[rb + SEXT(imm)])`. The length modifier is applied to all operands.],

            [`MLDU`], [], [2RI.A], [`B`], [-], [*Memory Load Unsigned*: Performs `ra = MEM[rb + SEXT(imm)]`. The length modifier is applied to all operands.],

            [`MST`], [], [2RI.A], [`B`], [-], [*Memory Store*: Performs `MEM[rb + SEXT(imm)] = ra`. The length modifier is applied to all operands.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Data Scalar Advanced (`DSA`)],
        [This module provides advanced scalar memory transfer operations. The `SGPRB` is mandatory for this module.],

        tableWrapper([DSA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`MLD_PD`], [], [2RI.A], [`B`], [-], [*Memory Load Pre Decrement*: Performs `ra = SEXT(MEM[(--rb) + SEXT(imm)])`. The length modifier is applied to all operands.],

            [`MLDU_PD`], [], [2RI.A], [`B`], [-], [*Memory Load Unsigned Pre Decrement*: Performs `ra = MEM[(--rb) + SEXT(imm)]`. The length modifier is applied to all operands.],

            [`MST_PD`], [], [2RI.A], [`B`], [-], [*Memory Load Pre Decrement*: Performs `MEM[(--rb) + SEXT(imm)] = ra`. The length modifier is applied to all operands.],

            [`MLD_PI`], [], [2RI.A], [`B`], [-], [*Memory Load Post Increment*: Performs `ra = SEXT(MEM[(rb++) + SEXT(imm)])`. The length modifier is applied to all operands.],

            [`MLDU_PI`], [], [2RI.A], [`B`], [-], [*Memory Load Unsigned Post Increment*: Performs `ra = MEM[(rb++) + SEXT(imm)]`. The length modifier is applied to all operands.],

            [`MST_PI`], [], [2RI.A], [`B`], [-], [*Memory Load Post Increment*: Performs `MEM[(rb++) + SEXT(imm)] = ra`. The length modifier is applied to all operands.],

            [`IMLD`], [], [3RI.A], [`B`], [-], [*Indexed Memory Load*: Performs `ra = SEXT(MEM[rb + rc + SEXT(imm)])`. The length modifier is applied to all operands.],

            [`IMLDU`], [], [3RI.A], [`B`], [-], [*Indexed Memory Load Unsigned*: Performs `ra = MEM[rb + rc + SEXT(imm)]`. The length modifier is applied to all operands.],

            [`IMST`], [], [3RI.A], [`B`], [-], [*Indexed Memory Store*: Performs `MEM[rb + rc + SEXT(imm)] = ra`. The length modifier is applied to all operands.],

            [`SMLD`], [], [3RI.A], [`B`], [-], [*Scaled Memory Load*: Performs `ra = SEXT(MEM[rb << imm])`. The length modifier is applied to all operands.],

            [`SMLDU`], [], [3RI.A], [`B`], [-], [*Scaled Memory Load Unsigned*: Performs `ra = MEM[rb << imm]`. The length modifier is applied to all operands.],

            [`SMST`], [], [3RI.A], [`B`], [-], [*Scaled Memory Store*: Performs `MEM[rb << imm] = ra`. The length modifier is applied to all operands.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Data Vector Basic (`DVB`)],
        [This module provides basic vector memory transfer operations. The `SGPRB` and `VGPRB` are mandatory for this module.],

        tableWrapper([DVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VMLD`], [], [2RI.B], [`D`], [-], [*Vector Memory Load*: Performs `va = MEM_i[rb + STRIDE(imm)]`.],
            [`VMST`], [], [2RI.B], [`D`], [-], [*Vector Memory Store*: Performs `MEM_i[rb + STRIDE(imm)] = va`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Data Vector Advanced (`DVA`)],
        [This module provides advanced vector memory transfer operations. The `SGPRB` and `VGPRB` are mandatory for this module.],

        tableWrapper([DVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VGAT`], [], [3R.A], [-], [-], [*Vector Gather*: Performs `va = MEM_i[rb + vc_i]`.],
            [`VSCA`], [], [3R.A], [-], [-], [*Vector Scatter*: Performs `MEM_i[rb + vc_i] = va`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Data Atomic Basic (`DAB`)],
        [This module provides basic atomic scalar memory transfer operations. The `SGPRB` is mandatory for this module.],

        tableWrapper([DAB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CAS`], [], [4R.A], [`B`], [-], [*Compare And Swap*: Performs `if(MEM[rb] != rc) then {ra = 0} else {MEM[rb] = rd; ra = 1}`, that is, write into the memory location pointed by `rb` the value in `rd` if and only if such location is equal to `rc`. The outcome of this instruction is written into `ra`. The length modifier is applied to all operands.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Data Atomic Advanced (`DAA`)],
        [This module provides advanced atomic scalar memory transfer operations. The `SGPRB` is mandatory for this module.],

        tableWrapper([DAA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`AADD`], [], [3R.A], [`B`], [-], [*Atomic Add*: Performs: `MEM[rb] += ra` atomically. The length modifier is applied to all operands.],

            [`ASUB`], [], [3R.A], [`B`], [-], [*Atomic Sub*: Performs: `MEM[rb] -= ra` atomically. The length modifier is applied to all operands.],

            [`AAND`], [], [3R.A], [`B`], [-], [*Atomic And*: Performs: `MEM[rb] &= ra` atomically. The length modifier is applied to all operands.],

            [`AOR`], [], [3R.A], [`B`], [-], [*Atomic Or*: Performs: `MEM[rb] |= ra` atomically. The length modifier is applied to all operands.],

            [`AADDI`], [], [2RI.B], [`B`], [-], [*Atomic Add Immediate*: Performs: `MEM[rb] += SEXT(imm)` atomically. The length modifier is applied to all operands.],

            [`ASUBI`], [], [2RI.B], [`B`], [-], [*Atomic Sub Immediate*: Performs: `MEM[rb] -= SEXT(imm)` atomically. The length modifier is applied to all operands.],

            [`AANDI`], [], [2RI.B], [`B`], [-], [*Atomic And Immediate*: Performs: `MEM[rb] &= SEXT(imm)` atomically. The length modifier is applied to all operands.],

            [`AORI`], [], [2RI.B], [`B`], [-], [*Atomic Or Immediate*: Performs: `MEM[rb] |= SEXT(imm)` atomically. The length modifier is applied to all operands.]
        )),
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Data Block (`DB`)],
        [This module provides memory transfer operations acting on blocks of registers. The `SGPRB` is mandatory for this module.],

        tableWrapper([DB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`BLDL`], [], [RI.A], [`C`], [-], [*Block Load Lower*: Performs `ra_l16 = MASK(MEM[rb], imm)`, that is, load the first 16 registers from the memory location pointed by `rb` ignoring when `imm` has a 0 bit for that specific position.],

            [`BLDP`], [], [RI.A], [`C`], [-], [*Block Load Upper*: Performs `ra_h16 = MASK(MEM[rb], imm)`, that is, load the last 16 registers from the memory location pointed by `rb` ignoring when `imm` has a 0 bit for that specific position.],

            [`BLDL`], [], [RI.A], [`C`], [-], [*Block Store Lower*: Performs `MEM[rb] = MASK(ra_l16, imm)`, that is, store the first 16 registers into the memory location pointed by `rb` ignoring when `imm` has a 0 bit for that specific position.],

            [`BLDP`], [], [RI.A], [`C`], [-], [*Block Store Upper*: Performs `MEM[rb] = MASK(ra_h16, imm)`, that is, store the last 16 registers into the memory location pointed by `rb` ignoring when `imm` has a 0 bit for that specific position.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Data Compressed (`DC`)],
        [This module provides memory transfer operations with a smaller code footprint. The `SGPRB` is mandatory for this module.],

        tableWrapper([DC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CMLD`], [], [2R.B], [`B`], [-], [*Compressed Memory Load*: Performs `ra = MEM[rb]`. The length modifier is applied to all operands.],

            [`CMST`], [], [2R.B], [`B`], [-], [*Compressed Memory Store*: Performs `MEM[rb] = ra`. The length modifier is applied to all operands.],

            [`CMLID`], [], [2RI.C], [-], [-],[*Compressed Memory Load Int Displacement*: Performs `ra = MEM[rb + SEXT(imm)]`.],
            [`CMSID`], [], [2RI.C], [-], [-],[*Compressed Memory Store Int Displacement*: Performs `MEM[rb + SEXT(imm)] = ra`.],
            [`CMLWD`], [], [2RI.C], [-], [-],[*Compressed Memory Load Word Displacement*: Performs `ra = MEM[rb + SEXT(imm)]`.],
            [`CMSWD`], [], [2RI.C], [-], [-],[*Compressed Memory Store Word Displacement*: Performs `MEM[rb + SEXT(imm)] = ra`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Flow Integer Basic (`FIB`)],
        [This module provides basic scalar control transfer operations. The `SGPRB` is mandatory for this module.],

        tableWrapper([FIB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`JMP`], [], [I.A], [-], [-], [*Unconditional Jump*: Performs `PC = PC + SEXT(imm << 1)`.],
            [`BJAL`], [], [I.A], [-], [-], [*Big Jump And Link*: Performs `S0 = PC; PC = PC + SEXT(imm << 1)`.],

            [`JMPR`], [], [RI.A], [`D`], [-], [*Unconditional Jump Register*: Performs `PC = ra + SEXT(imm << 1)`.],
            [`JAL`], [], [RI.A], [`D`], [-], [*Jump And Link*: Performs `ra = PC; PC = PC + SEXT(imm << 1)`.],

            [`BEQ`], [], [2RI.A], [`D`], [-], [*Branch If Equal*: Performs `if(ra == rb) then {PC = PC + SEXT(imm << 1)} else {noop}`.],

            [`BLT`], [], [2RI.A], [`D`], [-], [*Branch If Less Than*: Performs `if(ra < rb) then {PC = PC + SEXT(imm << 1)} else {noop}`.],

            [`BLTU`], [], [2RI.A], [`D`], [-], [*Branch If Less Than Unsigned*: Performs `if(ra < rb) then {PC = PC + SEXT(imm << 1)} else {noop}`. `ra` and `rb` are considered unsigned.],

            [`BLE`], [], [2RI.A], [`D`], [-], [*Branch If Less Than Equal*: Performs `if(ra <= rb) then {PC = PC + SEXT(imm << 1)} else {noop}`.],

            [`BLEU`], [], [2RI.A], [`D`], [-], [*Branch If Less Than Equal Unsigned*: Performs `if(ra <= rb) then {PC = PC + SEXT(imm << 1)} else {noop}`. `ra` and `rb` are considered unsigned.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Flow Integer Advanced (`FIA`)],
        [This module provides advanced scalar control transfer operations. The `SGPRB` is mandatory for this module.],

        tableWrapper([FIA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`BEQI`], [], [RI.A], [`D`], [-], [*Branch If Equal Immediate*: Performs `if(ra == SEXT(imm[3:0])) then {PC = PC + SEXT(imm[17:4] << 1)} else {noop}`.],

            [`BLTI`], [], [RI.A], [`D`], [-], [*Branch If Less Than Immediate*: Performs `if(ra < SEXT(imm[3:0])) then {PC = PC + SEXT(imm[17:4] << 1)} else {noop}`.],

            [`BLTIU`], [], [RI.A], [`D`], [-], [*Branch If Less Than Immediate Unsigned*: Performs `if(ra < EXT(imm[3:0])) then {PC = PC + SEXT(imm[17:4] << 1)} else {noop}`. `ra` is considered unsigned.],

            [`BLEI`], [], [RI.A], [`D`], [-], [*Branch If Less Than Equal Immediate*: Performs `if(ra <= SEXT(imm[3:0])) then {PC = PC + SEXT(imm[17:4] << 1)} else {noop}`.],

            [`BLEIU`], [], [RI.A], [`D`], [-], [*Branch If Less Than Equal Immediate Unsigned*: Performs `if(ra <= EXT(imm[3:0])) then {PC = PC + SEXT(imm[17:4] << 1)} else {noop}`. `ra` is considered unsigned.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Flow Integer Compressed (`FIC`)],

        [This module provides compressed scalar control transfer operations with a smaller code footprint. The `SGPRB` is mandatory for this module.],

        tableWrapper([FIC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CBEQZ`], [], [RI.B], [-], [-], [*Compressed Branch If Equal To Zero*: Performs `if(ra == 0) then {PC = PC + SEXT(imm << 1)} else {noop}`.],

            [`CBLTZ`], [], [RI.B], [-], [-], [*Compressed Branch If Less Than Zero*: Performs `if(ra < 0) then {PC = PC + SEXT(imm << 1)} else {noop}`.],

            [`CBLEZ`], [], [RI.B], [-], [-], [*Compressed Branch If Less OR Equal To Zero*: Performs `if(ra <= 0) then {PC = PC + SEXT(imm << 1)} else {noop}`.],

            [`CJALO`], [], [RI.B], [-], [-], [*Compressed Jump And Link Offset*: Performs `S0 = PC; PC = ra + SEXT(imm << 1)`.],
            [`CJMPO`], [], [RI.B], [-], [-], [*Compressed Jump Offset*: Performs `PC = ra + SEXT(imm << 1)`.],

            [`CJAL`], [], [I.B], [-], [-], [*Compressed Jump And Link*: Performs `S0 = PC; PC = PC + SEXT(imm << 1)`.],
            [`CJMP`], [], [I.B], [-], [-], [*Compressed Jump*: Performs `PC = PC + SEXT(imm << 1)`.],

            [`CBLE`], [], [2RI.C], [-], [-], [*Compressed Branch If Less Or Equal Than*: Performs `if(ra <= rb) then {PC = PC + SEXT(imm << 1)} else {noop}`.],
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Flow FP Basic (`FFB`)],

        [This module provides floating point scalar control transfer operations. The `SGPRB` is mandatory for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([FFB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`FBLT`], [], [2RI.B], [`B`], [`INVOP`], [*FP Branch If Less Than*: Performs `if(ra < rb) then {PC = PC + SEXT(imm << 1)} else {noop}`. The length modifier is applied to all operands.],

            [`FBLE`], [], [2RI.B], [`B`], [`INVOP`], [*FP Branch If Less Than Or Equal*: Performs `if(ra <= rb) then {PC = PC + SEXT(imm << 1)} else {noop}`. The length modifier is applied to all operands.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Flow FP Advanced (`FFA`)],

        [This module provides advanced floating point scalar control transfer operations. The `SGPRB` is mandatory for this module. Branches that use part of the immediate value to perform the comparison, actually indexes into a small 16 entry lookup table with the following FP values in order: _0, 1, -1, 2, -2, 4, -4, 8, -8, 16, 0.5, -0.5, 0.25, -0.25, 0.125, -0.125_],

        tableWrapper([FFA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`FBLTI`], [], [RI.A], [`B`], [`INVOP`], [*FP Branch If Less Than Immediate*: Performs `if(ra < LOOKUP(imm[3:0])) then {PC = PC + SEXT(imm[17:4] << 1)} else {noop}`, where `LOOKUP` is the above mentioned lookup table. The length modifier is applied to `ra`.],

            [`FBLEI`], [], [RI.A], [`B`], [`INVOP`], [*FP Branch If Less Than Or Equal Immediate*: Performs `if(ra <= LOOKUP(imm[3:0])) then {PC = PC + SEXT(imm[17:4] << 1)} else {noop}`, where `LOOKUP` is the above mentioned lookup table. The length modifier is applied to `ra`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Vector Moves (`VM`)],
        [This module provides operations to move between the `VGPRB` and `SGPRB`, which are both mandatory.],

        tableWrapper([VM Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VEXTR`], [], [2R.A], [`B`], [-], [*Vector Extract*: Performs `ra = vb[imm]` ignoring any vector shape configuration. The element and size are dictated by `imm` and the class mode respectively. The length modifier is applied to all operands.],

            [`VINJ`], [], [2R.A], [`B`], [-], [*Vector Inject*: Performs `va[imm] = rb` ignoring any vector shape configuration. The element and size are dictated by `imm` and the class mode respectively. The length modifier is applied to all operands.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Flow Integer Vector (`FIV`)],
        [This module provides integer vector mask manipulation operations. The `VGPRB` is mandatory for this module.],

        tableWrapper([VF Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VSEQ`], [], [4R.B], [`A`], [-], [*Vector Set If Equal*: Performs `va = MASK((vc == vd) ? 1 : 0, vb)`. This instruction class specifies: `10` (`-`) as _default_ mode and `11` (`.I`) as _inverted_ mode, which simply inverts the checking condition.],

            [`VSLT`], [], [4R.B], [`A`], [-], [*Vector Set If Less Than*: : Performs `va = MASK((vc < vd) ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`VSLE`], [], [4R.B], [`A`], [-], [*Vector Set If Less Or Equal*: : Performs `va = MASK((vc <= vd) ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`VSEQI`], [], [3RI.B], [`A`], [-], [*Vector Set If Equal Immediate*: Performs `va = MASK((vc == EXT(imm)) ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`VSLTI`], [], [3RI.B], [`A`], [-], [*Vector Set If Less Than Immediate*: Performs `va = MASK((vc < EXT(imm)) ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`VSLEI`], [], [3RI.B], [`A`], [-], [*Vector Set If Less Or Equal Immediate*: Performs `va = MASK((vc <= EXT(imm)) ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Flow FP Vector (`FFV`)],
        [This module provides floating point vector mask manipulation operations. The `VGPRB` is mandatory for this module.],

        tableWrapper([VF Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VFSLT`], [], [4R.B], [`A`], [-], [*Vector FP Set If Less Than*: Performs `va = MASK((vc < vd) ? 1 : 0, vb)`. Must always have a class mode value of `00`.],

            [`VFSLE`], [], [4R.B], [`A`], [-], [*Vector FP Set If Less Or Equal*: Performs `va = MASK((vc <= vd) ? 1 : 0, vb)`. Must always have a class mode value of `01`.],

            [`VFSGT`], [], [4R.B], [`A`], [-], [*Vector FP Set If Greater Than*: Performs `va = MASK((vc > vd) ? 1 : 0, vb)`. Must always have a class mode value of `10`.],

            [`VFSGE`], [], [4R.B], [`A`], [-], [*Vector FP Set If Greater Or Equal*: Performs `va = MASK((vc >= vd) ? 1 : 0, vb)`. Must always have a class mode value of `11`.],

            [`VFSLTI`], [], [3RI.B], [`A`], [-], [*Vector FP Set If Less Than Immediate*:  Performs `va = MASK((vc < imm) ? 1 : 0, vb)`. Must always have a class mode value of `00`.],

            [`VFSLEI`], [], [3RI.B], [`A`], [-], [*Vector FP Set If Less Or Equal Immediate*:  Performs `va = MASK((vc <= imm) ? 1 : 0, vb)`. Must always have a class mode value of `01`.],

            [`VFSGTI`], [], [3RI.B], [`A`], [-], [*Vector FP Set If Greater Than Immediate*:  Performs `va = MASK((vc > imm) ? 1 : 0, vb)`. Must always have a class mode value of `10`.],

            [`VFSGEI`], [], [3RI.B], [`A`], [-], [*Vector FP Set If Greater Or Equal Immediate*:  Performs `va = MASK((vc >= imm) ? 1 : 0, vb)`. Must always have a class mode value of `11`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [System (`SYS`)],
        [This module provides basic system operations. The `SPRB` and `SGPRB` are mandatory for this module.],

        tableWrapper([SYS Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`NOP`], [], [2R.A], [`A`], [-], [*No Operation*: Performs nothing. The operands are not used and ust always have a class mode value of `00`.],

            [`HLT`], [], [2R.A], [`A`], [-], [*Halt Execution*: Performs `PWR = ra; HALT(rb)`. The calling hart will halt for the number of cycles specified in `rb`. A value of `0` causes the hart to halt indefinetly. This instruction is privileged and must always have a class mode value of `01`.],

            [`SYSINFO`], [], [2R.A], [`B`], [-], [*System Information*: Performs `ra = CFG_SEG[rb + SEXT(imm)]`, where `CFG_SEG` is the configuration segment.],

            [`CACOP`], [], [2RI.B], [`A`], [-], [*Cache Operation*: Implementation-specific privileged instruction designed to allow direct manipulation of the cache. If no caching is implemented this instruction must throw the `INCI` fault. Must always have a class mode value of `00`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Vector Configuration (`VC`)],
        [This module provides vector configuration operations. The `VGPRB`, `SGPRB` and `SPRB` are mandatory for this module.],

        tableWrapper([VC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDVSHP`], [], [2R.A], [`A`], [-], [*Load Vector Shape*: Performs: `VSH = ra`. The second operand is not used and must always have a class mode value of `00`.],

            [`STVSHP`], [], [2R.A], [`A`], [-], [*Store Vector Shape*: Performs: `ra = VSH`. The second operand is not used and must always have a class mode value of `01`.],

            [`VPCKUPCK`], [], [2RI.B], [`A`], [-], [*Vector Pack Unpack*: Performs `va = PCKUPCK(vb, imm)`, that is, packs or unpacks `vb` with the current vector shape to the one specified in the `imm`. An example of the transformation would be: `000a 000b 000c 000d <=> 000000000000abcd`. Must always have a class mode value of `00`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Floating Point Rounding Modes (`FRMD`)],

        [This module provides floating-point rounding mode configuration and manipulation operations. The `SGPRB` and `SPRB` are mandatory for this module.],

        tableWrapper([FRMD Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDRMD`], [], [2R.A], [`A`], [-], [*Load Rounding Mode*: Performs `RMD = ra`, where `RMD` is a section of the `SR`. The second operand is not used and must always have a class mode value of `00`.],

            [`STRMD`], [], [2R.A], [`A`], [-], [*Store Rounding Mode*: Performs `ra = RMD`, where `RMD` is a section of the `SR`. The second operand is not used and must always have a class mode value of `01`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Helper Registers (`HR`)],

        [This module provides helper register configuration and manipulation operations. The `SGPRB`, `HLPRB` and `SPRB` are mandatory for this module.],

        tableWrapper([HR Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDHR`], [], [2R.A], [`B`], [-], [*Load Helper Register*: Performs `HLPR = ra`. The second operand is not used.],
            [`STHR`], [], [2R.A], [`B`], [-], [*Store Helper Register*: Performs `ra = HLPR`. The second operand is not used.],

            [`LDHRM`], [], [2R.A], [`A`], [-], [*Load Helper Register Mode*: Performs `HLPR_md = ra`, where `_md` is the mode section of the associated `HLPR` register. The second operand is not used and must always have a class mode value of `00`.],

            [`STHRM`], [], [2R.A], [`A`], [-], [*Store Helper Register Mode*: Performs `ra = HLPR_md`, where `_md` is the mode section of the associated `HLPR` register. The second operand is not used and must always have a class mode value of `01`.],

            [`LDHLPRE`], [], [2R.A], [`A`], [-], [*Load HLPRE Status*: Performs `ra = HLPRE`, where `HLPRE` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `10`.],

            [`STHLPRE`], [], [2R.A], [`A`], [-], [*Store HLPRE Status*: Performs `HLPRE = ra`, where `HLPRE` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `11`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Performance Counters (`PC`)],

        [This module provides performance counter configuration and manipulation operations. The `SGPRB`, `PERFCB` and `SPRB` are mandatory for this module.],

        tableWrapper([PC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDCR`], [], [2R.A], [`B`], [-], [*Load Counter Register*: Performs `PERFC = ra`. The second operand is not used.],
            [`STCR`], [], [2R.A], [`B`], [-], [*Store Counter Register*: Performs `ra = PERFC`. The second operand is not used.],

            [`LDCRM`], [], [2R.A], [`A`], [-], [*Load Counter Register Mode*: Performs `PERFC_md = ra`, where `_md` is the mode section of the associated `PERFC` register. The second operand is not used and must always have a class mode value of `00`.],

            [`STCRM`], [], [2R.A], [`A`], [-], [*Store Counter Register Mode*: Performs `ra = PERFC_md`, where `_md` is the mode section of the associated `PERFC` register. The second operand is not used and must always have a class mode value of `01`.],

            [`LDPERFCE`], [], [2R.A], [`A`], [-], [*Load PERFCE Status*: Performs `ra = PERFCE`, where `PERFCE` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `10`.],

            [`STPERFCE`], [], [2R.A], [`A`], [-], [*Store PERFCE Status*: Performs `PERFCE = ra`, where `PERFCE` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `11`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Fencing (`FNC`)],
        [This module provides fencing memory semantic operations.],

        tableWrapper([PC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`FNCL`], [], [2R.A], [`A`], [-], [*Fence Loads*: See section 4. The operands are not used and must always have a class mode value of `00`],

            [`FNCS`], [], [2R.A], [`A`], [-], [*Fence Stores*: See section 4. The operands are not used and must always have a class mode value of `01`],

            [`FNCLS`], [], [2R.A], [`A`], [-], [*Fence Loads And Stores*: See section 4. The operands are not used and must always have a class mode value of `10`],

            [`FNCIOL`], [], [2R.A], [`A`], [-], [*Fence IO Loads*: See section 4. The operands are not used and must always have a class mode value of `00`],

            [`FNCIOS`], [], [2R.A], [`A`], [-], [*Fence IO Stores*: See section 4. The operands are not used and must always have a class mode value of `01`],

            [`FNCIOLS`], [], [2R.A], [`A`], [-], [*Fence IO Loads and Stores*: See section 4. The operands are not used and must always have a class mode value of `10`],

            [`FNCI`], [], [2R.A], [`A`], [-], [*Fence Instructions*: See section 4. The operands are not used and must always have a class mode value of `00`],

            [`LDCMD`], [], [2R.A], [`A`], [-], [*Load Consistency Mode*: Performs `ra = CMD`, where `CMD` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `00`.],

            [`STCMD`], [], [2R.A], [`A`], [-], [*Store Consistency Mode*: Performs `CMD = ra`, where `CMD` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `01`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Transactional Memory (`TM`)],
        [This module provides transactional memory semantic operations. The `SGRPB` is mandatory for this module.],

        tableWrapper([TM Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`TBEG`], [], [2R.A], [`A`], [-], [*Transaction Begin*: See section 4. The outcome is written into `ra` and the second operand is not used. Must aways have a class mode of `00`.],

            [`TCOM`], [], [2R.A], [`A`], [-], [*Transaction Commit*: See section 4. The outcome is written into `ra` and the second operand is not used. Must aways have a class mode of `01`.],

            [`TCHK`], [], [2R.A], [`A`], [-], [*Transaction Check*: See section 4. The outcome is written into `ra` and the second operand is not used. Must aways have a class mode of `10`.],

            [`TABT`], [], [2R.A], [`A`], [-], [*Transaction Abort*: See section 4. The outcome is written into `ra` and the second operand is not used. Must aways have a class mode of `11`.],

            [`TABTA`], [], [2R.A], [`A`], [-], [*Transaction Abort All*: See section 4. The outcome is written into `ra` and the second operand is not used. Must aways have a class mode of `00`.],

            [`TLEV`], [], [2R.A], [`A`], [-], [*Transaction Level*: See section 4. The outcome is written into `ra` and the second operand is not used. Must aways have a class mode of `01`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Eventing (`EVT`)],
        [This module provides event related machine-mode operations. The `SGPRB` and `SPRB` are mandatory for this module.],

        tableWrapper([EVT Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDMER`], [], [2R.A], [`D`], [-], [*Load Machine Event Register*: Performs `ra = MER`, where `MER` is one of the special purpose registers prefixed with "machine event". The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`STMER`], [], [2R.A], [`D`], [-], [*Store Machine Event Register*: Performs `MER = ra`, where `MER` is one of the special purpose registers prefixed with "machine event". The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`LDIMSK`], [], [2R.A], [`A`], [-], [*Load Interrupt Mask*: Performs `ra = IMSK`, where `IMSK` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `00`. This instruction is privileged.],

            [`STIMSK`], [], [2R.A], [`A`], [-], [*Store Interrupt Mask*: Performs `IMSK = ra`, where `IMSK` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `01`. This instruction is privileged.],

            [`ERET`], [], [2R.A], [`A`], [-], [*Event Return*: Performs the privileged event returning sequence, see section 6. This instruction is privileged and must always have a class mode of `10`.],

            [`WINT`], [], [RI.A], [`A`], [-], [*Wait For Interrupt*: Causes the executing hart to halt and wait for interrupt. The `ra` specifies the timeout and `rb` specifies the id of the interrupt (IO or IPC) to wait for. This instruction class specifies: `.C` (`00`) as _cycles_ mode, `.N` (`01`) as _nanoseconds_ mode, `.U` (`10`) as _microseconds_ mode and `.M` (`11`) as _milliseconds_. This instruction is privileged.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [User Mode (`USER`)],

        [This module provides user-mode event return and user-mode system operations. The `SGPRB` and `SPRB` are mandatory for this module.],

        tableWrapper([USER Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`SYSCL`], [], [2R.A], [`A`], [-], [*System Call*: Perform `SYSCL(ra)`, where `ra` holds the call id and `rb` is not used. This instruction is privileged and must always have a class mode value of `00`.],

            [`UERET`], [], [2R.A], [`A`], [-], [*User Event Return*: Performs the unprivileged event returning sequence, see section 6. Must always have a class mode of `01`.],

            [`URET`], [], [2R.A], [`A`], [-], [*User Return*: Performs the user event returning sequence, see section 6. This instruction is privileged and must always have a class mode of `10`.],

            [`LDUER`], [], [2R.A], [`D`], [-], [*Load User Event Register*: Performs `ra = UER`, where `UER` is one of the special purpose registers prefixed with "user event". The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`STUER`], [], [2R.A], [`D`], [-], [*Store User Event Register*: Performs `UER = ra`, where `UER` is one of the special purpose registers prefixed with "user event". The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`LDPID`], [], [2R.A], [`D`], [-], [*Load Process ID*: Performs `ra = PID`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`STPID`], [], [2R.A], [`D`], [-], [*Store Process ID*: Performs `PID = ra`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`LDTID`], [], [2R.A], [`D`], [-], [*Load Thread ID*: Performs `ra = TID`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`STTID`], [], [2R.A], [`D`], [-], [*Store Thread ID*: Performs `TID = ra`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`LDTPTR`], [], [2R.A], [`D`], [-], [*Load Thread Pointer*: Performs `ra = TPTR`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`STTPTR`], [], [2R.A], [`D`], [-], [*Store Thread Pointer*: Performs `TPTR = ra`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`LDPFPA`], [], [2R.A], [`D`], [-], [*Load Page Fault Physical Address*: Performs `ra = PFPA`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`STPFPA`], [], [2R.A], [`D`], [-], [*Store Page Fault Physical Address*: Performs `PFPA = ra`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`LDWDT`], [], [2R.A], [`D`], [-], [*Load Watchdog Timer*: Performs `ra = WDT`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`STWDT`], [], [2R.A], [`D`], [-], [*Store Watchdog Timer*: Performs `WDT = ra`. The class modifier specifies two immediate bits that indicate which quarter of the register to operate on.],

            [`LDWDTS`], [], [2R.A], [`A`], [-], [*Load Watchdog Timer Status*: Performs `ra = WDTE`, where `WDTE` is a section of the `SR` register. Must always have a class mode of `00`.],

            [`STWDTS`], [], [2R.A], [`A`], [-], [*Store Watchdog Timer Status*: Performs `EWDT = ra`, where `WDTE` is a section of the `SR` register. Must always have a class mode of `01`.],

            [`MMUOP`], [], [RI.A], [`A`], [-], [*Memory Management Unit Operation*: Implementation-specific privileged instruction designed to allow direct manipulation of the memory management unit. If no MMU is implemented this instruction must throw the `INCI` fault. Must always have a class mode value of `00`.],

            [`UCACOP`], [], [2RI.B], [`A`], [-], [*User Cache Operation*: Implementation-specific instruction designed to allow direct manipulation of the cache. If no caching is implemented this instruction must throw the `INCI` fault. Must always have a class mode value of `00`.]
        ))
    ),
))

#page(flipped: true, textWrap(

    subSection(

        [Exception (`EXC`)],

        [This module provides arithmetic exceptions (see section 3) and status manipulation operations. The `SGPRB` and `SPRB` are mandatory for this module.],

        tableWrapper([EXC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDGEE`], [], [2R.A], [`A`], [-], [*Load Global Exception Enable*: Performs `ra = GEE`, where `GEE` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `00`. This instruction is privileged.],

            [`STGEE`], [], [2R.A], [`A`], [-], [*Store Global Exception Enable*: Performs `GEE = ra`, where `GEE` is a section of the `SR` register. The second operand is not used and must always have a class mode value of `01`. This instruction is privileged.]
        ))
    )
))

///
