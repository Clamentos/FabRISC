///
#import "Macros.typ": *

///
#section(

    [Instruction List],

    [This section is dedicated to provide a full and extensive list of all the proposed instructions in the ISA divided into their corresponding module.],

    [Systems that don't support certain modules must generate the `INCI` fault whenever an unimplemented or incompatible instruction is fetched or attempted to be processed in any other way. The `ILLI` fault whenever a combination of all zeros, all ones or an otherwise illegal combination is fetched in order to increase safety against buffer overflows exploits or accidental accesses of uninitialized memory locations, as well as signaling to the programmer the execution of an overall illegal action.],

    [Unused bits, often designated with "-" or "x", must have a value of zero by default for convention.]
)

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Scalar Basic (`CISB`)],

        [This module provides simple integer scalar instructions to perform a variety of arithmetic and logical operations on registers and immediate values. The `SGPRB` is required for this module.],

        tableWrapper([CISB instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`ABS`], [`0xF8600`], [2R.A], [-], [-], [*Absolute Value*: Performs `ra = (rb < 0) ? (!rb + 1) : (rb)`.],

            [`EXT`], [`0xF8601`], [2R.A], [`B`], [-], [*Sign Extend*: Performs `ra = SIGN_EXT(rb)`, that is, replicate the most significant bit from the size specified in the class mode to `WLEN`.],

            [`ADD`], [`0x7BB0`], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Addition*: Performs `ra = rb + rc`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`SUB`], [`0x7BB0`], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Subtraction*: Performs `ra = rb - rc`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`MIN`], [`0x7BB1`], [3R.A], [`A`], [-], [*Minimum*: Performs `ra = (rb < rc) ? rb : rc`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`MAX`], [`0x7BB1`], [3R.A], [`A`], [-], [*Maximum*: Performs `ra = (rb > rc) ? rb : rc`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`AND`], [`0x7BB2`], [3R.A], [`A`], [-], [*Bitwise AND*: Performs `ra = rb & rc`. This instruction class specifies: `00` (`-`) as default mode and `01` (`.N`) as negated mode, which simply negates the result.],

            [`OR`], [`0x7BB2`], [3R.A], [`A`], [-], [*Bitwise OR*: Performs `ra = rb | rc`. This instruction class specifies: `10` (`-`) as default mode and `11` (`.N`) as negated mode, which simply negates the result.],

            [`XOR`], [`0x7BB3`], [3R.A], [`A`], [-], [*Bitwise XOR*: Performs `ra = rb ^ rc`. This instruction class specifies: `00` (`-`) as default mode and `01` (`.N`) as negated mode, which simply negates the result.],

            [`IMP`], [`0x7BB3`], [3R.A], [`A`], [-], [*Bitwise IMP*: Performs `ra = !(!rb & rc)`. This instruction class specifies: `10` (`-`) as default mode and `11` (`.N`) as negated mode, which simply negates the result.],

            [`LSH`], [`0x7BB4`], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Left Shift*: Performs `ra = rb << rc`, filling the least significant bits with zeros. The shift amount in `rc` is always unsigned. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`RSH`], [`0x7BB4`], [3R.A], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Right Shift*: Performs `ra = rb >> rc`, filling the most significant bits with either zeros or the sign depending on the mode. The shift amount in `rc` is always unsigned. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`SEQ`], [`0x7BB5`], [3R.A], [`A`], [-], [*Set If Equal*: Performs `ra = (rb == rc) ? 1 : 0`. This instruction class specifies: `00` (`-`) as default mode and `01` (`.N`) as negated mode, which simply negates the checking condition.],

            [`SLT`], [`0x7BB6`], [3R.A], [`A`], [-], [*Set If Less Than*: Performs `ra = (rb < rc) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply negate the checking condition.],

            [`SLE`], [`0x7BB7`], [3R.A], [`A`], [-], [*Set If Less Than Or Equal To*: Performs `ra = (rb <= rc) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply negate the checking condition.],

            [`CMV`], [`0x7BB8`], [3R.A], [`A`], [-], [*Conditional Move*: Performs `ra = CHECK(rb) ? rc : ra`. This instruction class specifies: `00` (`.EZ`) as equal to zero mode, `01` (`.NZ`) not equal to zero mode, `10` (`.LTZ`) less than zero mode and `11` (`.LTZU`) less than zero unsigned mode for the checking condition.],

            [`LDI`], [`0x1C4`], [RI.A], [`D`], [-], [*Load Immediate*: Performs `ra = SIGN_EXT(imm)`.],

            [`HLDI`], [`0x1C5`], [RI.A], [`D`], [-], [*High Load Immediate*: Performs `ra[WLEN:18] = SIGN_EXT(imm)` leaving the lower bits of `ra` unchanged.],

            [`ADDIHPC`], [`0x1C6`], [RI.A], [`D`], [-], [*Add Immediate High To PC*: Performs `ra = PC + SIGN_EXT(imm << 18)`.],

            [`ADDI`], [`0xC0`], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Addition Immediate*: Performs `ra = rb + EXT(imm)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode.],

            [`SUBI`], [`0xC0`], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Subtraction Immediate*: Performs `ra = rb - EXT(imm)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode.],

            [`MINI`], [`0xC1`], [2RI.A], [`A`], [-], [*Minimum Immediate*: Performs `ra = (rb < EXT(imm)) ? rb : EXT(imm)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode.],

            [`MAXI`], [`0xC1`], [2RI.A], [`A`], [-], [*Maximum Immediate*: Performs `ra = (rb > EXT(imm)) ? rb : EXT(imm)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode.],

            [`ANDI`], [`0xC2`], [2RI.A], [`A`], [-], [*Bitwise AND Immediate*: Performs `ra = rb & EXT(imm)`. This instruction class specifies: `00` (`.U`) as unsigned mode, `01` (`.S`) as signed mode, `10` (`.NU`) as negated unsigned mode and `11` (`.NS`) as negated signed mode. The last two modes simply negate the result and the immediate will be sign or zero extended according to the specified mode.],

            [`ORI`], [`0xC3`], [2RI.A], [`A`], [-], [*Bitwise OR Immediate*: Performs `ra = rb | EXT(imm)`. This instruction class specifies: `00` (`.U`) as unsigned mode, `01` (`.S`) as signed mode, `10` (`.NU`) as negated unsigned mode and `11` (`.NS`) as negated signed mode. The last two modes simply negate the result and the immediate will be sign or zero extended according to the specified mode.],

            [`XORI`], [`0xC4`], [2RI.A], [`A`], [-], [*Bitwise XOR Immediate*: Performs `ra = rb ^ EXT(imm)`. This instruction class specifies: `00` (`.U`) as unsigned mode, `01` (`.S`) as signed mode, `10` (`.NU`) as negated unsigned mode and `11` (`.NS`) as negated signed mode. The last two modes simply negate the result and the immediate will be sign or zero extended according to the specified mode.],

            [`IMPI`], [`0xC5`], [2RI.A], [`A`], [-], [*Bitwise IMP Immediate*: Performs `ra = !(!rb & EXT(imm))`. This instruction class specifies: `00` (`.U`) as unsigned mode, `01` (`.S`) as signed mode, `10` (`.NU`) as negated unsigned mode and `11` (`.NS`) as negated signed mode. The last two modes simply negate the result and the immediate will be sign or zero extended according to the specified mode.],

            [`LSHI`], [`0xC6`], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Left Shift Immediate*: Performs `ra = rb << ZERO_EXT(imm)`, filling the least significant bits with zeros. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`RSHI`], [`0xC6`], [2RI.A], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Right Shift Immediate*: Performs `ra = rb >> ZERO_EXT(imm)`, filling the most significant bits with either zeros or the sign depending on the mode. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`SEQI`], [`0xC7`], [2RI.A], [`A`], [-], [*Set If Equal Immediate*: Performs `ra = (rb == EXT(imm)) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`SLTI`], [`0xC8`], [2RI.A], [`A`], [-], [*Set If Less Than Immediate*: Performs `ra = (rb < EXT(imm)) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`SLEI`], [`0xC9`], [2RI.A], [`A`], [-], [*Set If Less Than Or Equal To Immediate*: Performs `ra = (rb <= EXT(imm)) ? 1 : 0`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`CLDI`], [`0xCA`], [2RI.A], [`A`], [-], [*Conditional Load Immediate*: Performs `ra = CHECK(rb) ? EXT(imm) : ra`. This instruction class specifies: `00` (`.EZ`) as equal to zero mode, `01` (`.NZ`) not equal to zero mode, `10` (`.LTZ`) less than zero mode and `11` (`.LTZU`) less than zero unsigned mode. The immediate will be sign or zero extended according to the specified mode.]
        ))
    )
))

#page(flipped: true, textWrap(
    
    subSection(

        [Computational Integer Scalar Advanced (`CISA`)],

        [This module provides integer scalar instructions to perform more complex arithmetic and logical operations on registers and immediate values. The `SGPRB` is required for this module.],

        tableWrapper([CISA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CZ`], [`0xF8602`], [2R.A], [`A`], [-], [*Count Zeros*: Performs `ra = CZ(rb)`, that is, the total number of zero bits in `rb`. Must always have a class mode value of `00`.],

            [`CLZ`], [`0xF8602`], [2R.A], [`A`], [-], [*Count Leading Zeros*: Performs `ra = CLZ(rb)`, that is, the total number of leading zero bits in `rb`. Must always have a class mode value of `01`.],

            [`CTZ`], [`0xF8602`], [2R.A], [`A`], [-], [*Count Trailing Zeros*: Performs `ra = CTZ(rb)`, that is, the total number of trailing zero bits in `rb`. Must always have a class mode value of `10`.],

            [`CO`], [`0xF8603`], [2R.A], [`A`], [-], [*Count Ones*: Performs `ra = CO(rb)`, that is, the total number of one bits in `rb`. Must always have a class mode value of `00`.],

            [`CLO`], [`0xF8603`], [2R.A], [`A`], [-], [*Count Leading Ones*: Performs `ra = CLO(rb)`, that is, the total number of leading one bits in `rb`. Must always have a class mode value of `01`.],

            [`CTO`], [`0xF8603`], [2R.A], [`A`], [-], [*Count Trailing Ones*: Performs `ra = CTO(rb)`, that is, the total number of trailing one bits in `rb`. Must always have a class mode value of `10`.],

            [`MUL`], [`0x7BB9`], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Multiplication*: Performs `ra = rb * rc` only keeping the least significant `WLEN` bits of the result. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`HMUL`], [`0x7BB9`], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*High Multiplication*: Performs `ra = rb * rc` only keeping the most significant `WLEN` bits of the result. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`DIV`], [`0x7BBA`], [3R.A], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Division*: Performs `ra = FLOOR(rb / rc)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`REM`], [`0x7BBA`], [3R.A], [`A`], [`DIV0`, `INVOP`], [*Remainder*: Performs `ra = rb % rc`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )
            ],

            [`LRT`], [`0x7BBB`], [3R.A], [`A`], [-], [*Left Rotate*: Performs `ra = LRT(rb, rc)`, that is left shift and filling the incoming with bits with the ones that come out. Must always have a class mode value of `00`.],

            [`RRT`], [`0x7BBB`], [3R.A], [`A`], [-], [*Right Rotate*: Performs `ra = RRT(rb, rc)`, that is right shift and filling the incoming with bits with the ones that come out. Must always have a class mode value of `01`.],

            [`BSW`], [`0x7BBB`], [3R.A], [`A`], [-], [*Bit Swap*: Performs `ra = BSW(rb, rc)`, that is, swap the position of two adjacent groups of bits. The group size is determined by `rc` and follows powers of two. Must always have a class mode value of `10`.],

            [`BRV`], [`0x7BBB`], [3R.A], [`A`], [-], [*Bit Reverse*:  Performs `ra = BRV(rb, rc)`, that is, reverse the endianness of groups of bits. The group size is determined by `rc` and follows powers of two. Must always have a class mode value of `11`.],

            [`CLMUL`], [`0x7BBC`], [3R.A], [`A`], [-], [*Carryless Multiplication*: Performs `ra = rb * rc` discarding the carries at each step, that is, replacing the addition of the partial products with `XOR`. Must always have a class mode value of `00`.],

            [`PER`], [`0x7BBC`], [3R.A], [`A`], [-], [*Permute*: Performs `ra = PER(rb, rc)`, that is, move groups of four bits from `rb` according to the index specified in `rc`. Must always have a class mode value of `01`.],

            [`MAC`], [`0x3C8`], [4R.A], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Multiply Accumulate*: Performs one of the following operations depending on the class mode:
            
                #enum(tight: true, start: 0,

                    [`.MA`: `ra = rb + (rc * rd)`],
                    [`.NMA`: `ra = (-rb) + (rc * rd)`],
                    [`.MS`: `ra = rb - (rc * rd)`],
                    [`.NMS`: `ra = (-rb) - (rc * rd)`]
                )

            The multiplication part of the operation only considers the least significant `WLEN` bits.],

            [`MACU`], [`0x3C9`], [4R.A], [`G`], [`COVRn`], [*Multiply Accumulate Unsigned*: Performs one of the following operations depending on the class mode:
            
                #enum(tight: true, start: 0,

                    [`.MA`: `ra = rb + (rc * rd)`],
                    [`.NMA`: `ra = (-rb) + (rc * rd)`],
                    [`.MS`: `ra = rb - (rc * rd)`],
                    [`.NMS`: `ra = (-rb) - (rc * rd)`]
                )

            The multiplication part of the operation only considers the least significant `WLEN` bits and all of the steps performed are unsigned.],

            [`MIX`], [`0x3CA`], [4R.A], [`A`], [-], [*Mix*: Performs `ra = MIX(rb, rc, rd)`, that is, chose and move bytes from `rb` and `rc` according to the select and index bits of `rd`. Must always have a class mode value of `00`.],

            [`MULI`], [`0xCB`], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Multiplication Immediate*: Performs `ra = rb * EXT(imm)` only keeping the least significant `WLEN` bits of the result. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode and the immediate will be sign or zero extended according to the specified mode.],

            [`HMULI`], [`0xCB`], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*High Multiplication Immediate*: Performs `ra = rb * EXT(imm)` only keeping the most significant `WLEN` bits of the result. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode and the immediate will be sign or zero extended according to the specified mode.],

            [`DIVI`], [`0xCC`], [2RI.A], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Division Immediate*: Performs `ra = FLOOR(rb / EXT(imm))`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode and the immediate will be sign or zero extended according to the specified mode.],

            [`REMI`], [`0xCC`], [2RI.A], [`A`], [`DIV0`, `INVOP`], [*Remainder Immediate*: Performs `ra = rb % EXT(imm)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )

            The immediate will be sign or zero extended according to the specified mode.],

            [`LRTI`], [`0xCE`], [2RI.A], [`A`], [-], [*Left Rotate Immediate*: Performs `ra = LRT(rb, ZERO_EXT(imm))`, that is left shift and filling the incoming with bits with the ones that come out. Must always have a class mode value of `00`.],

            [`RRTI`], [`0xCE`], [2RI.A], [`A`], [-], [*Right Rotate Immediate*: Performs `ra = RRT(rb, ZERO_EXT(imm))`, that is right shift and filling the incoming with bits with the ones that come out. Must always have a class mode value of `01`.],

            [`BSWI`], [`0xCE`], [2RI.A], [`A`], [-], [*Bit Swap Immediate*: Performs `ra = BSW(rb, ZERO_EXT(imm))`, that is, swap the position of two adjacent groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. Must always have a class mode value of `10`.],

            [`BRVI`], [`0xCE`], [2RI.A], [`A`], [-], [*Bit Reverse Immediate*:  Performs `ra = BRV(rb, ZERO_EXT(imm))`, that is, reverse the endianness of groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. Must always have a class mode value of `11`.],

            [`CLMULI`], [`0xCF`], [2RI.A], [`A`], [-], [*Carryless Multiplication Immediate*: Performs `ra = rb * EXT(imm)` discarding the carries at each step. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode and the immediate will be sign or zero extended according to the specified mode.],

            [`MACI`], [`0x7BA0`], [3RI.A], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Multiply Accumulate Immediate*: Performs one of the following operations depending on the class mode:
            
                #enum(tight: true, start: 0,

                    [`.MA`: `ra = rb + (rc * SIGN_EXT(imm))`],
                    [`.NMA`: `ra = (-rb) + (rc * SIGN_EXT(imm))`],
                    [`.MS`: `ra = rb - (rc * SIGN_EXT(imm))`],
                    [`.NMS`: `ra = (-rb) - (rc * SIGN_EXT(imm))`]
                )

            The multiplication part of the operation only considers the least significant `WLEN` bits.],

            [`MACUI`], [`0x7BA1`], [3RI.A], [`G`], [`COVRn`], [*Multiply Accumulate Unsigned Immediate*: Performs one of the following depending on the class mode:

                #enum(tight: true, start: 0,

                    [`.MA`: `ra = rb + (rc * ZERO_EXT(imm))`],
                    [`.NMA`: `ra = (-rb) + (rc * ZERO_EXT(imm))`],
                    [`.MS`: `ra = rb - (rc * ZERO_EXT(imm))`],
                    [`.NMS`: `ra = (-rb) - (rc * ZERO_EXT(imm))`]
                )

            The multiplication part of the operation only considers the least significant `WLEN` bits, all of the steps performed are unsigned and the immediate is always zero extended.],
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Scalar Multiword (`CISM`)],

        [This module provides integer scalar instructions to perform arithmetic and logical operations on registers with additional operands to allow chaining, which can be employed for arbitrary-precision arithmetic. The `SGPRB` is required for this module.],

        tableWrapper([CISM Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`BADD`], [`0x3CB`], [4R.A], [`A`], [-], [*Big Addition*: Performs `ra = rb + rc + rd; rd = carry_out`. Must always have a class mode value of `00`.],

            [`BSUB`], [`0x3CB`], [4R.A], [`A`], [-], [*Big Subtraction*: Performs `ra = rb - rc - rd; rd = carry_out`. Must always have a class mode value of `10`.],

            [`BLSH`], [`0x3CC`], [4R.A], [`A`], [-], [*Big Left Shift*: Performs `ra = rb << rc (rd); rd = shifted_out`. This instruction shifts in bits from `rd` instead of zeros. The shift amount in `rc` is always unsigned. Must always have a class mode value of `00`.],

            [`BRSH`], [`0x3CD`], [4R.A], [`A`], [-], [*Big Right Shift*: Performs `ra = rb >> rc (rd); rd = shifted_out`. This instruction shifts in bits from `rd` instead of zeros. The shift amount in `rc` is always unsigned. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Vector Basic (`CIVB`)],

        [This module provides integer vector instructions to perform basic arithmetic and logical operations on registers and immediate values in a data-parallel manner. The `VGPRB` is required for this module. If neither the `FIV` or `FFV` modules are implemented the masking function must never mask any element and must act as a no operation.],

        tableWrapper([CIVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VABS`], [`0x7BBD`], [3R.A], [`E`], [-], [*Vector Absolute Value*: Performs `va = MASK(vc < 0 ? ~vc + 1 : vc, vb)`.],

            [`VADD`], [`0xF8640`], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Addition*: Performs `va = MASK(vc + vd, vb)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`VSUB`], [`0xF8640`], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Subtraction*: Performs `va = MASK(vc - vd, vb)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`VMIN`], [`0xF8641`], [4R.B], [`A`], [-], [*Vector Minimum*: Performs `va = MASK(vc < vd ? vc : vd, vb)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`VMAX`], [`0xF8641`], [4R.B], [`A`], [-], [*Vector Maximum*: Performs `va = MASK(vc > vd ? vc : vd, vb)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`VAND`], [`0xF8642`], [4R.B], [`A`], [-], [*Vector Bitwise AND*: Performs `va = MASK(vc & vd, vb)`. This instruction class specifies: `00` (`-`) as default mode and `01` (`.N`) as negated mode, which simply negates the result.],

            [`VOR`], [`0xF8642`], [4R.B], [`A`], [-], [*Vector Bitwise OR*: Performs `va = MASK(vc | vd, vb)`. This instruction class specifies: `10` (`-`) as default mode and `11` (`.N`) as negated mode, which simply negates the result.],

            [`VXOR`], [`0xF8643`], [4R.B], [`A`], [-], [*Vector Bitwise XOR*: Performs `va = MASK(vc ^ vd, vb)`. This instruction class specifies: `00` (`-`) as default mode and `01` (`.N`) as negated mode, which simply negates the result.],

            [`VIMP`], [`0xF8643`], [4R.B], [`A`], [-], [*Vector Bitwise IMP*: Performs `va = MASK(~(~vc & vd), vb)`. This instruction class specifies: `10` (`-`) as default mode and `11` (`.N`) as negated mode, which simply negates the result.],

            [`VLSH`], [`0xF8644`], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Left Shift*: Performs `va = MASK(vc << vd, vb)` filling the least significant bits with zeros. The shift amount in `vd` is always unsigned. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`VRSH`], [`0xF8644`], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Vector Right Shift*: Performs `va = MASK(vc >> vd, vb)` filling the most significant bits with either zeros or the sign depending on the mode. The shift amount in `vd` is always unsigned. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`VLDI`], [`0x7B80`], [2RI.B], [`E`], [-], [*Vector Load Immediate*: Performs `va = MASK(SIGN_EXT(imm), vb)`. This instruction broadcasts the immediate to all the configured vector elements.],

            [`VHLDI`], [`0x7B81`], [2RI.B], [`E`], [-], [*Vector High Load Immediate*: Performs `va[WLEN:21] = MASK(SIGN_EXT(imm), vb)` leaving the lower bits of `va` unchanged. This instruction broadcasts the immediate to all the configured vector elements.],

            [`VADDI`], [`0x1EC0`], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Addition Immediate*: Performs `va = MASK(vc + EXT(imm), vb)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VSUBI`], [`0x1EC0`], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Subtraction Immediate*: Performs `va = MASK(vc - EXT(imm), vb)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VMINI`], [`0x1EC1`], [3RI.B], [`A`], [-], [*Vector Minimum Immediate*: Performs `va = MASK(vc < SIGN_EXT(imm) ? vc : SIGN_EXT(imm), vb)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VMAXI`], [`0x1EC1`], [3RI.B], [`A`], [-], [*Vector Maximum Immediate*: Performs `va = MASK(vc > SIGN_EXT(imm) ? vc : SIGN_EXT(imm), vb)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VANDI`], [`0x1EC2`], [3RI.B], [`A`], [-], [*Vector Bitwise AND Immediate*: Performs `va = MASK(vc & EXT(imm), vb)`. This instruction class specifies: `00` (`.U`) as unsigned mode, `01` (`.S`) as signed mode, `10` (`.NU`) as negated unsigned mode and `11` (`.NS`) as negated signed mode. The last two modes simply negate the result and the immediate will be sign or zero extended according to the specified mode, as well as broadcasted to all the the configured vector elements.],

            [`VORI`], [`0x1EC3`], [3RI.B], [`A`], [-], [*Vector Bitwise OR Immediate*: Performs `va = MASK(vc | EXT(imm), vb)`. This instruction class specifies: `00` (`.U`) as unsigned mode, `01` (`.S`) as signed mode, `10` (`.NU`) as negated unsigned mode and `11` (`.NS`) as negated signed mode. The last two modes simply negate the result and the immediate will be sign or zero extended according to the specified mode, as well as broadcasted to all the the configured vector elements.],

            [`VXORI`], [`0x1EC4`], [3RI.B], [`A`], [-], [*Vector Bitwise XOR Immediate*: Performs `va = MASK(vc ^ EXT(imm), vb)`. This instruction class specifies: `00` (`.U`) as unsigned mode, `01` (`.S`) as signed mode, `10` (`.NU`) as negated unsigned mode and `11` (`.NS`) as negated signed mode. The last two modes simply negate the result and the immediate will be sign or zero extended according to the specified mode, as well as broadcasted to all the the configured vector elements.],

            [`VIMPI`], [`0x1EC5`], [3RI.B], [`A`], [-], [*Vector Bitwise IMP Immediate*: Performs `va = MASK(~(~vc & EXT(imm)), vb)`. This instruction class specifies: `00` (`.U`) as unsigned mode, `01` (`.S`) as signed mode, `10` (`.NU`) as negated unsigned mode and `11` (`.NS`) as negated signed mode. The last two modes simply negate the result and the immediate will be sign or zero extended according to the specified mode, as well as broadcasted to all the the configured vector elements.],

            [`VLSHI`], [`0x1EC6`], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Left Shift Immediate*: Performs `va = MASK(vc << ZERO_EXT(imm), vb)`, filling the least significant bits with zeros. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode. This instruction broadcasts the immediate to all the configured vector elements.],

            [`VRSHI`], [`0x1EC6`], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Vector Right Shift Immediate*: Performs `va = MASK(vc >> ZERO_EXT(imm), vb)`, filling the most significant bits with either zeros or the sign depending on the mode. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. This instruction broadcasts the immediate to all the configured vector elements.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Vector Advanced (`CIVA`)],

        [This module provides integer vector instructions to perform complex arithmetic and logical operations on registers or immediate values in a data-parallel manner. The `VGPRB` is required for this module. If neither the `FIV` or `FFV` modules are implemented the masking function must never mask any element and must act as a no operation.],

        tableWrapper([CIVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],          

            [`VCZ`], [`0x7BBE`], [3R.A], [`E`], [-], [*Vector Count Zeros*: Performs `va = MASK(CZ(vc), vb)`, that is, the total number of zero bits in `vc`.],

            [`VCLZ`], [`0x7BBF`], [3R.A], [`E`], [-], [*Vector Count Leading Zeros*: Performs `va = MASK(CLZ(vc), vb)`, that is, the total number of leading zero bits in `vc`.],

            [`VCTZ`], [`0x7BC0`], [3R.A], [`E`], [-], [*Vector Count Trailing Zeros*: Performs `va = MASK(CTZ(vc), vb)`, that is, the total number of trailing zero bits in `vc`.],

            [`VCO`], [`0x7BC1`], [3R.A], [`E`], [-], [*Vector Count Ones*: Performs `va = MASK(CO(vc), vb)`, that is, the total number of one bits in `vc`.],

            [`VCLO`], [`0x7BC2`], [3R.A], [`E`], [-], [*Vector Count Leading Ones*: Performs `ra = MASK(CLO(vc), vb)`, that is, the total number of leading one bits in `vc`.],

            [`VCTO`], [`0x7BC3`], [3R.A], [`E`], [-], [*Vector Count Trailing Ones*: Performs `ra = MASK(CTO(vc), vb)`, that is, the total number of trailing one bits in `vc`.],

            [`VMUL`], [`0xF8645`], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Multiplication*: Performs `va = MASK(vc * vd, vc)` only keeping the least significant half of the result. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`VHMUL`], [`0xF8645`], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector High Multiplication*: Performs `va = MASK(vc * vd), vb` only keeping the most significant half of the result. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode.],

            [`VDIV`], [`0xF8646`], [4R.B], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Vector Division*: Performs `va = MASK(FLOOR(vc / vd), vb)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode.],

            [`VREM`], [`0xF8646`], [4R.B], [`A`], [`DIV0`, `INVOP`], [*Vector Remainder*: Performs `va = MASK(vc % vd, vb)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )
            ],

            [`VLRT`], [`0xF8647`], [4R.B], [`A`], [-], [*Vector Left Rotate*: Performs `va = MASK(LRT(vc, vd), vb)`. Must always have a class mode value of `00`.],

            [`VRRT`], [`0xF8647`], [4R.B], [`A`], [-], [*Vector Right Rotate*: Performs `va = MASK(RRT(vc, vd), vb)`. Must always have a class mode value of `01`.],

            [`VBSW`], [`0xF8647`], [4R.B], [`A`], [-], [*Vector Bit Swap*: Performs `va = MASK(BSW(vc, vd), vb)`, that is, swap the position of two adjacent groups of bits. The group size is determined by `vd` and follows powers of two. Must always have a class mode value of `10`.],

            [`VBRV`], [`0xF8647`], [4R.B], [`A`], [-], [*Vector Bit Reverse*:  Performs `va = MASK(BRV(vc, vd), vb)`, that is, reverse the endianess of groups of bits. The group size is determined by `vd` and follows powers of two. Must always have a class mode value of `11`.],

            [`VCLMUL`], [`0xF8648`], [4R.B], [`A`], [-], [*Vector Carryless Multiplication*: Performs `va = MASK(vc * vd)`, discarding the carries at each step, that is, replacing the addition of the partial products with `XOR`. Must always have a class mode value of `00`.],

            [`VPER`], [`0xF8648`], [4R.B], [`A`], [-], [*Vector Permute*: Performs `va = MASK(PER(vc, vd), vb)`, that is, moves groups of four bits from `vc` according to the index specified in `vd`. Must always have a class mode value of `01`.],

            [`VMIX`], [`0xF8648`], [4R.B], [`A`], [-], [*Vector Mix*: Performs `va = MIX(vb, vc, vd)`, that is, choses and moves bytes from `vb` and `vc` according to the select and index bits of `vd`. Must always have a class mode value of `10`.],

            [`VMAC`], [`0xF8649`], [4R.B], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Vector Multiply Accumulate*: Performs one of the following depending on the class mode:

                #enum(tight: true, start: 0,

                    [`.MA`: `va = MASK(va + (vc * vd), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * vd), vb)`],
                    [`.MS`: `va = MASK(va - (vc * vd), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * vd), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result.],

            [`VMACU`], [`0xF864A`], [4R.B], [`G`], [`COVRn`], [*Vector Multiply Accumulate Unsigned*: Performs one of the following depending on the class mode:

                #enum(tight: true, start: 0,

                    [`.MA`: `va = MASK(va + (vc * vd), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * vd), vb)`],
                    [`.MS`: `va = MASK(va - (vc * vd), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * vd), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result and all of the steps performed are unsigned.],

            [`VMULI`], [`0x1EC7`], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Multiplication Immediate*: Performs `va = MASK(vc * EXT(imm), vb)` only keeping the least significant half of the result. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VHMULI`], [`0x1EC7`], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector High Multiplication Immediate*: Performs `va = MASK(vc * EXT(imm), vb)` only keeping the most significant half of the result. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VDIVI`], [`0x1EC8`], [3RI.B], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Vector Division Immediate*: Performs `va = MASK(FLOOR(vc / EXT(imm)), vb)`. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VREMI`], [`0x1EC8`], [3RI.B], [`A`], [`DIV0`, `INVOP`], [*Vector Remainder Immediate*: Performs `va = MASK(vc % EXT(imm), vb)`. This instruction class specifies: `10` (`.S`) as signed mode and `11` (`.U`) as unsigned mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )

            The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VLRTI`], [`0x1EC9`], [3RI.B], [`A`], [-], [*Vector Left Rotate Immediate*: Performs `va = MASK(LRT(vc, ZERO_EXT(imm)), vb)`. The immediate will be broadcasted to all the the configured vector elements. This instruction Must always have a class mode value of `00`.],

            [`VRRTI`], [`0x1EC9`], [3RI.B], [`A`], [-], [*Vector Right Rotate Immediate*: Performs `va = MASK(RRT(vc, ZERO_EXT(imm)), vb)`. The immediate will be broadcasted to all the the configured vector elements. This instruction Must always have a class mode value of `01`.],

            [`VBSWI`], [`0x1EC9`], [3RI.B], [`A`], [-], [*Vector Bit Swap Immediate*: Performs `va = MASK(BSW(vc, ZERO_EXT(imm)), vb)`, that is, swap the position of two adjacent groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. The immediate will be broadcasted to all the the configured vector elements. This instruction Must always have a class mode value of `10`.],
        
            [`VBRVI`], [`0x1EC9`], [3RI.B], [`A`], [-], [*Vector Bit Reverse Immediate*:  Performs `va = MASK(BRV(vc, ZERO_EXT(imm)), vb)`, that is, reverse the endianness of groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. The immediate will be broadcasted to all the the configured vector elements. This instruction Must always have a class mode value of `11`.],

            [`VCLMULI`], [`0x1ECA`], [3RI.B], [`A`], [-], [*Vector Carryless Multiplication Immediate*: Performs `va = MASK(vc * EXT(imm), vb)` discarding the carries at each step. This instruction class specifies: `00` (`.S`) as signed mode and `01` (`.U`) as unsigned mode. The immediate will be sign or zero extended according to the specified mode and will be broadcasted to all the the configured vector elements.],

            [`VMACI`], [`0x1ECB`], [3RI.B], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Vector Multiply Accumulate Immediate*: Performs one of the following depending on the class mode:

                #enum(tight: true, start: 0,

                    [`.MA`: `va = MASK(va + (vc * SIGN_EXT(imm)), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * SIGN_EXT(imm)), vb)`],
                    [`.MS`: `va = MASK(va - (vc * SIGN_EXT(imm)), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * SIGN_EXT(imm)), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result and the immediate will be broadcasted to all the the configured vector elements.],

            [`VMACUI`], [`0x1ECC`], [3RI.B], [`G`], [`COVRn`], [*Vector Multiply Accumulate Unsigned Immediate*: Performs one of the following depending on the class mode:

                #enum(tight: true, start: 0,

                    [`.MA`: `va = MASK(va + (vc * ZERO_EXT(imm)), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * ZERO_EXT(imm)), vb)`],
                    [`.MS`: `va = MASK(va - (vc * ZERO_EXT(imm)), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * ZERO_EXT(imm)), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result, all of the steps performed are unsigned and the immediate is always zero extended and will be broadcasted to all the the configured vector elements.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Vector Reductions (`CIVR`)],

        [This module provides integer vector instructions to perform arithmetic and logical reduction operations on registers in a data-parallel manner. The `VGPRB` is required for this module. If neither the `FIV` or `FFV` modules are implemented the masking function must never mask any element and must act as a no operation.],

        tableWrapper([CIVR Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`RADD`], [`0x7BC4`], [3R.A], [`E`], [`OVFLn`, `UNFLn`], [*Reduced Addition*: Performs `va = SUM(MASK(vc, vb))`, that is, sum all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RADDU`], [`0x7BC5`], [3R.A], [`E`], [`COVRn`], [*Reduced Addition Unsigned*: Performs `va = SUM(MASK(vc, vb))`, that is, sum all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RSUB`], [`0x7BC6`], [3R.A], [`E`], [`OVFLn`, `UNFLn`], [*Reduced Subtraction*: Performs `va = SUB(MASK(vc, vb))`, that is, subtract all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RSUBU`], [`0x7BC7`], [3R.A], [`E`], [`COVRn`], [*Reduced Subtraction Unsigned*: Performs `va = SUB(MASK(vc, vb))`, that is, subtract all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RMIN`], [`0x7BC8`], [3R.A], [`E`], [-], [*Reduced Minimum*: Performs `va = MIN(MASK(vc, vb))`, that is, find the minimum between all the elements of `vc` together as signed integers, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RMINU`], [`0x7BC9`], [3R.A], [`E`], [-], [*Reduced Minimum Unsigned*: Performs `va = MIN(MASK(vc, vb))`, that is, find the minimum between all the elements of `vc` together as unsigned integers, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RMAX`], [`0x7BCA`], [3R.A], [`E`], [-], [*Reduced Maximum*: Performs `va = MAX(MASK(vc, vb))`, that is, find the maximum between all the elements of `vc` together as signed integers, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RMAXU`], [`0x7BCB`], [3R.A], [`E`], [-], [*Reduced Maximum Unsigned*: Performs `va = MAX(MASK(vc, vb))`, that is, find the maximum between all the elements of `vc` together as unsigned integers, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RAND`], [`0x7BCC`], [3R.A], [`E`], [-], [*Reduced Bitwise AND*: Performs `va = AND(MASK(vc, vb))`, that is, bitwise AND all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RNAND`], [`0x7BCD`], [3R.A], [`E`], [-], [*Reduced Bitwise NAND*: Performs `va = NAND(MASK(vc, vb))`, that is, bitwise NAND all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`ROR`], [`0x7BCE`], [3R.A], [`E`], [-], [*Reduced Bitwise OR*: Performs `va = OR(MASK(vc, vb))`, that is, bitwise OR all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RNOR`], [`0x7BCF`], [3R.A], [`E`], [-], [*Reduced Bitwise NOR*: Performs `va = NOR(MASK(vc, vb))`, that is, bitwise NOR all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RXOR`], [`0x7BD0`], [3R.A], [`E`], [-], [*Reduced Bitwise XOR*: Performs `va = XOR(MASK(vc, vb))`, that is, bitwise XOR all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RXNOR`], [`0x7BD1`], [3R.A], [`E`], [-], [*Reduced Bitwise XNOR*: Performs `va = XNOR(MASK(vc, vb))`, that is, bitwise XNOR all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RIMP`], [`0x7BD2`], [3R.A], [`E`], [-], [*Reduced Bitwise IMP*: Performs `va = IMP(MASK(vc, vb))`, that is, bitwise IMP all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RNIMP`], [`0x7BD3`], [3R.A], [`E`], [-], [*Reduced Bitwise NIMP*: Performs `va = NIMP(MASK(vc, vb))`, that is, bitwise NIMP all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational Integer Compressed (`CIC`)],

        [This module provides integer compressed instructions to perform arithmetic and logical operations on registers and immediate values with a smaller code footprint. The `SGPRB` is required for this module.],

        tableWrapper([CIC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CADD`], [`0xB8`], [2R.B], [`F`], [`OVFLn`, `UNFLn`], [*Compressed Addition*: Performs `ra = ra + rc`. The operands are always considered signed.],

            [`CSUB`], [`0xB9`], [2R.B], [`F`], [`OVFLn`, `UNFLn`], [*Compressed Subtraction*: Performs `ra = ra - rc`. The operands are always considered signed.],

            [`CMOV`], [`0xBA`], [2R.B], [`F`], [-], [*Compressed Move*: Performs `ra = rb`.],
            [`CAND`], [`0xBB`], [2R.B], [`F`], [-], [*Compressed Bitwise AND*: Performs `ra = ra & rb`.],

            [`CLSH`], [`0xBC`], [2R.B], [`F`], [`OVFLn`, `UNFLn`], [*Compressed Left Shift*: Performs `ra = ra << rb`, filling the least significant bits with zeros. `ra` is always considered signed, while the shift amount in `rb` is always unsigned.],

            [`CRSH`], [`0xBD`], [2R.B], [`F`], [`OVFLn`, `UNFLn`, `CUND`], [*Compressed Right Shift*: Performs `ra = ra >> rb`, filling the most significant bits with the sign. `ra` is always considered signed, while the shift amount in `rb` is always unsigned.],

            [`CADDI`], [`0x0A`], [RI.B], [-], [`OVFLn`, `UNFLn`], [*Compressed Addition Immediate*: Performs `ra = ra + SIGN_EXT(imm)`. The operands are always considered signed.],

            [`CANDI`], [`0x0B`], [RI.B], [-], [-], [*Compressed Bitwise AND Immediate*: Performs `ra = ra & SIGN_EXT(imm)`.],

            [`CLSHI`], [`0x0C`], [RI.B], [-], [`OVFLn`, `UNFLn`], [*Compressed Left Shift Immediate*: Performs `ra = ra << ZERO_EXTEND(imm)`, filling the least significant bits with zeros. `ra` is always considered signed.],

            [`CRSHI`], [`0x0D`], [RI.B], [-], [`OVFLn`, `UNFLn`, `CUND`], [*Compressed Right Shift Immediate*: Performs `ra = ra >> imm`, filling the most significant bits with the sign. `ra` is always considered signed.],

            [`CLDI`], [`0x0E`], [RI.B], [-], [-], [*Compressed Load Immediate*: Performs `ra = SIGN_EXT(imm)`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Scalar Basic (`CFSB`)],

        [This module provides floating point instructions to perform arithmetic operations on registers and immediate values. The `SGPRB` is required for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFSB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CFI`], [`0xF8604`], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To Integer*: Performs `ra = FP_TO_INT(rb)`, that is, convert `rb` to the closest integer dictated by the rounding mode and place the result in `ra`. The length modifier is applied to all operands.],

            [`CFIT`], [`0xF8605`], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To Integer Truncated*: Performs `ra = TRUNC(rb)`, that is, truncate `rb` and place the result in `ra`. The length modifier is applied to all operands.],

            [`CIF`], [`0xF8606`], [2R.A], [`B`], [`INVOP`], [*Cast Integer To FP*: Performs `ra = INT_TO_FP(rb)`, that is, convert `rb` into floating point notation and place the result into `ra`. The length modifier is applied to all operands.],

            [`CFF1`], [`0xF8607`], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To FP1*: Performs `ra = FP_TO_FP1(rb)`, that is, cast `rb` to a one byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF2`], [`0xF8608`], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To FP2*: Performs `ra = FP_TO_FP2(rb)`, that is, cast `rb` to a two byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF4`], [`0xF8609`], [2R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*Cast FP To FP4*: Performs `ra = FP_TO_FP4(rb)`, that is, cast `rb` to a four byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF8`], [`0xF860A`], [2R.A], [`B`], [`INVOP`], [*Cast FP To FP8*: Performs `ra = FP_TO_FP8(rb)`, that is, cast `rb` to a eight byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`FADD`], [`0x7BD4`], [3R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Addition*: Performs `ra = rb + rc`. The length modifier is applied to all operands.],

            [`FSUB`], [`0x7BD5`], [3R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Subtraction*: Performs `ra = rb - rc`. The length modifier is applied to all operands.],

            [`FMUL`], [`0x7BD6`], [3R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Multiplication*: Performs `ra = rb * rc`. The length modifier is applied to all operands.],

            [`FDIV`], [`0x7BD7`], [3R.A], [`B`], [`OVFLn`, `UNFLn`, `DIV0`], [*FP Division*: Performs `ra = rb / rc`. The length modifier is applied to all operands.],

            [`FMIN`], [`0x7BD8`], [3R.A], [`B`], [`INVOP`], [*FP Minimum*: Performs `ra = rb < rc ? rb : rc`. The length modifier is applied to all operands.],

            [`FMAX`], [`0x7BD9`], [3R.A], [`B`], [`INVOP`], [*FP Maximum*: Performs `ra = rb > rc ? rb : rc`. The length modifier is applied to all operands.],

            [`FSLT`], [`0x7BDA`], [3R.A], [`B`], [`INVOP`], [*FP Set If Less Than*: Performs `ra = rb < rc ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSLE`], [`0x7BDB`], [3R.A], [`B`], [`INVOP`], [*FP Set If Less Or Equal*: Performs `ra = rb <= rc ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSGT`], [`0x7BDC`], [3R.A], [`B`], [`INVOP`], [*FP Set If Greater Than*: Performs `ra = rb > rc ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSGE`], [`0x7BDD`], [3R.A], [`B`], [`INVOP`], [*FP Set If Greater Or Equal*: Performs `ra = rb >= rc ? 1 : 0`. The length modifier is applied to all operands.],

            [`FMADD`], [`0x3CE`], [4R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Multiply Add*: Performs `ra = rb + (rc * rd)`, with only one rounding step. The length modifier is applied to all operands.],

            [`FNMADD`], [`0x3CF`], [4R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Negative Multiply Add*: Performs `ra = (-rb) + (rc * rd)`, with only one rounding step. The length modifier is applied to all operands.],

            [`FMSUB`], [`0x3D0`], [4R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Multiply Subtract*: Performs `ra = rb - (rc * rd)`, with only one rounding step. The length modifier is applied to all operands.],

            [`FNMSUB`], [`0x3D1`], [4R.A], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Negative Multiply Subtract*: Performs `ra = (-rb) - (rc * rd)`, with only one rounding step. The length modifier is applied to all operands.],

            [`FADDI`], [`0x7B82`], [2RI.B], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Addition Immediate*: Performs `ra = rb + imm`. The length modifier is applied to all operands.],

            [`FSUBI`], [`0x7B83`], [2RI.B], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Subtraction Immediate*: Performs `ra = rb - imm`. The length modifier is applied to all operands.],

            [`FMULI`], [`0x7B84`], [2RI.B], [`B`], [`OVFLn`, `UNFLn`, `INVOP`], [*FP Multiplication Immediate*: Performs `ra = rb * imm`. The length modifier is applied to all operands.],

            [`FDIVI`], [`0x7B85`], [2RI.B], [`B`], [`OVFLn`, `UNFLn`, `DIV0`, `INVOP`], [*FP Division Immediate*: Performs `ra = rb / imm`. The length modifier is applied to all operands.],

            [`FMINI`], [`0x7B86`], [2RI.B], [`B`], [`INVOP`], [*FP Minimum Immediate*: Performs `ra = rb < imm ? rb : imm`. The length modifier is applied to all operands.],

            [`FMAXI`], [`0x7B87`], [2RI.B], [`B`], [`INVOP`], [*FP Maximum Immediate*: Performs `ra = rb > imm ? rb : imm`. The length modifier is applied to all operands.],

            [`FSLTI`], [`0x7B88`], [2RI.B], [`B`], [`INVOP`], [*FP Set If Less Than Immediate*: Performs `ra = rb < imm ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSLEI`], [`0x7B89`], [2RI.B], [`B`], [`INVOP`], [*FP Set If Less Or Equal Immediate*: Performs `ra = rb <= imm ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSGTI`], [`0x7B8A`], [2RI.B], [`B`], [`INVOP`], [*FP Set If Greater Than Immediate*: Performs `ra = rb > imm ? 1 : 0`. The length modifier is applied to all operands.],

            [`FSGEI`], [`0x7B8B`], [2RI.B], [`B`], [`INVOP`], [*FP Set If Greater Or Equal Immediate*: Performs `ra = rb >= imm ? 1 : 0`. The length modifier is applied to all operands.],

            [`FMADDI`], [`0x7BA2`], [3RI.A], [`B`], [`OVFLn`, `UNFLn`,`INVOP`], [*FP Multiply Add Immediate*: Performs `ra = rb + (rc * imm)`, with only one rounding step. The length modifier is applied to all operands.],

            [`FNMADDI`], [`0x7BA3`], [3RI.A], [`B`], [`OVFLn`, `UNFLn`,`INVOP`], [*FP Negative Multiply Add Immediate*: Performs `ra = (-rb) + (rc * imm)`, with only one rounding step. The length modifier is applied to all operands.],

            [`FMSUBI`], [`0x7BA4`], [3RI.A], [`B`], [`OVFLn`, `UNFLn`,`INVOP`], [*FP Multiply Subtract Immediate*: Performs `ra = rb - (rc * imm)`, with only one rounding step. The length modifier is applied to all operands.],

            [`FNMSUBI`], [`0x7BA5`], [3RI.A], [`B`], [`OVFLn`, `UNFLn`,`INVOP`], [*FP Negative Multiply Subtract Immediate*: Performs `ra = (-rb) - (rc * imm)`, with only one rounding step. The length modifier is applied to all operands.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Scalar Advanced (`CFSA`)],

        [This module provides floating point instructions to perform more complex arithmetic operations on registers. The `SGPRB` is required for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFSA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`FSQRT`], [`0xF860B`], [2R.A], [`B`], [`UNFLn`, `INVOP`], [*FP Square Root*: Performs `ra = SQRT(rb)`. The length modifier is applied to all operands.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Vector Basic (`CFVB`)],

        [This module provides floating point vector instructions to perform basic arithmetic and logical operations on registers and immediate values in a data-parallel manner. The `VGPRB` is required for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VCFI`], [`0x7BDE`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To Integer*: Performs `va = MASK(FP_TO_INT(vc), vb)`, that is, convert `vc` to the closest integer dictated by the rounding mode and place the result in `va`.],

            [`VCFIT`], [`0x7BDF`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To Integer Truncated*: Performs `va = MASK(TRUNC(vc), vb)`, that is, truncate `vc` and place the result in `va`.],

            [`VCIF`], [`0x7BE0`], [3R.A], [`E`], [`INVOP`], [*Vector Cast Integer To FP*: Performs `va = MASK(INT_TO_FP(vc), vb)`, that is, convert `vc` into floating point notation and place the result into `va`.],

            [`VCFF1`], [`0x7BE1`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To FP 1*: Performs `va = MASK(FP_TO_FP1(vc), vb)`, that is, cast `vc` into the specified floating point type and place the result in `va`. The length of `vc` is dictated by the current vector shape and the result is compacted to the final shape.],

            [`VCFF2`], [`0x7BE2`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To FP 2*: Performs `va = MASK(FP_TO_FP2(vc), vb)`, that is, cast `vc` into the specified floating point type and place the result in `va`. The length of `vc` is dictated by the current vector shape and the result is compacted to the final shape.],

            [`VCFF4`], [`0x7BE3`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector Cast FP To FP 4*: Performs `va = MASK(FP_TO_FP4(vc), vb)`, that is, cast `vc` into the specified floating point type and place the result in `va`. The length of `vc` is dictated by the current vector shape and the result is compacted to the final shape.],

            [`VCFF8`], [`0x7BE4`], [3R.A], [`E`], [`INVOP`], [*Vector Cast FP To FP 8*: Performs `va = MASK(FP_TO_FP8(vc), vb)`, that is, cast `vc` into the specified floating point type and place the result in `va`. The length of `vc` is dictated by the current vector shape and the result is compacted to the final shape.],

            [`VFADD`], [`0xF864B`], [4R.B],[`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Addition*: Performs `va = MASK(vc + vd, vb)`. Must always have a class mode value of `00`.],

            [`VFSUB`], [`0xF864B`], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Subtraction*: Performs `va = MASK(vc - vd, vb)`. Must always have a class mode value of `01`.],

            [`VFMUL`], [`0xF864B`], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Multiplication*: Performs `va = MASK(vc * vd, vb)`. Must always have a class mode value of `10`.],

            [`VFDIV`], [`0xF864B`], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `DIV0`, `INVOP`], [*Vector FP Division*: Performs `va = MASK(vc / vd, vb)`. Must always have a class mode value of `11`.],

            [`VFMIN`], [`0xF864C`], [4R.B], [`A`], [`INVOP`], [*Vector FP Minimum*: Performs `va = MASK(vc < vd ? vc : vd, vb)`. Must always have a class mode value of `00`.],

            [`VFMAX`], [`0xF864C`], [4R.B], [`A`], [`INVOP`], [*Vector FP Maximum*: Performs `va = MASK(vc > vd ? vc : vd, vb)`. Must always have a class mode value of `01`.],

            [`VFMAC`], [`0xF864D`], [4R.B], [`G`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Multiply Accumulate*: Performs one of the following depending on the class mode with one rounding step:

                #enum(tight: true, start: 0,

                    [`.MA`: `va = MASK(va + (vc * vd), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * vd), vb)`],
                    [`.MS`: `va = MASK(va - (vc * vd), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * vd), vb)`]
                )
            ],

            [`VFADDI`], [`0x1ECD`], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Addition Immediate*: Performs `va = MASK(vc + imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `00`.],

            [`VFSUBI`], [`0x1ECD`], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Subtraction Immediate*: Performs `va = MASK(vc - imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `01`.],

            [`VFMULI`], [`0x1ECD`], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Multiplication Immediate*: Performs `va = MASK(vc * imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `10`.],

            [`VFDIVI`], [`0x1ECD`], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `DIV0`, `INVOP`], [*Vector FP Division Immediate*: Performs `va = MASK(vc / imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `11`.],

            [`VFMINI`], [`0x1ECE`], [3RI.B], [`A`], [`INVOP`], [*Vector FP Minimum Immediate*: Performs `va = MASK(vc < imm ? vc : imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `00`.],

            [`VFMAXI`], [`0x1ECE`], [3RI.B], [`A`], [`INVOP`], [*Vector FP Maximum Immediate*: Performs `va = MASK(vc < imm ? vc : imm, vb)`. The immediate is always broadcasted to all the vector elements. Must always have a class mode value of `01`.],

            [`VFMACI`], [`0x1ECF`], [3RI.B], [`G`], [`OVFLn`, `UNFLn`, `INVOP`], [*Vector FP Multiply Accumulate Immediate*: Performs one of the following depending on the class mode with one rounding step:

                #enum(tight: true, start: 0,

                    [`.MA`: `va = MASK(va + (vc * imm), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * imm), vb)`],
                    [`.MS`: `va = MASK(va - (vc * imm), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * imm), vb)`]
                )

            The immediate is always broadcasted to all the vector elements.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Vector Advanced (`CFVA`)],

        [This module provides floating point vector instructions to perform more complex arithmetic and logical operations on registers values in a data-parallel manner. The `VGPRB` is required for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VSQRT`], [`0x7BE5`], [3R.A], [`E`], [`UNFLn`, `INVOP`], [*Vector FP Square Root*: Performs `va = SQRT(vb)`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Computational FP Vector Reductions (`CFVR`)],

        [This module provides integer vector instructions to perform arithmetic and logical reductions operations on registers values in a data-parallel manner. The `VGPRB` is required for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([CFVR Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`RFADD`], [`0x7BE6`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Reduced FP Addition*: Performs `va = SUM(MASK(vc, vb))`, that is, sum all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFSUB`], [`0x7BE7`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Reduced FP Subtraction*: Performs `va = SUB(MASK(vc, vb))`, that is, subtract all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFMUL`], [`0x7BE8`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `INVOP`], [*Reduced FP Multiplication*: Performs `va = MUL(MASK(vc, vb))`, that is, multiply all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFDIV`], [`0x7BE9`], [3R.A], [`E`], [`OVFLn`, `UNFLn`, `DIV0`, `INVOP`], [*Reduced FP Division*: Performs `va = DIV(MASK(vc, vb))`, that is, divide all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFMIN`], [`0x7BEA`], [3R.A], [`E`], [`INVOP`], [*Reduced FP Minimum*: Performs `va = MIN(MASK(vc, vb))`, that is, find the minimum between all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.],

            [`RFMAX`], [`0x7BEB`], [3R.A], [`E`], [`INVOP`], [*Reduced FP Maximum*: Performs `va = MAX(MASK(vc, vb))`, that is, find the maximum between all the elements of `vc` together, considering only the ones that are not masked by `vb` and place the scalar result in `va`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Data Scalar Basic (`DSB`)],
        [This module provides basic scalar memory transfer operations. The `SGPRB` is required for this module.],

        tableWrapper([DSB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`MLD`], [`0xD0`], [2RI.A], [`B`], [-], [*Memory Load*: Performs `ra = SIGN_EXT(MEM[rb + SIGN_EXT(imm)])`. The length modifier is applied to all operands.],

            [`MLDU`], [`0xD1`], [2RI.A], [`B`], [-], [*Memory Load Unsigned*: Performs `ra = MEM[rb + SIGN_EXT(imm)]`. The length modifier is applied to all operands.],

            [`MST`], [`0xD2`], [2RI.A], [`B`], [-], [*Memory Store*: Performs `MEM[rb + SIGN_EXT(imm)] = ra`. The length modifier is applied to all operands.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Data Scalar Advanced (`DSA`)],
        [This module provides advanced scalar memory transfer operations. The `SGPRB` is required for this module.],

        tableWrapper([DSA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`MLD_PD`], [`0xD3`], [2RI.A], [`B`], [-], [*Memory Load Pre Decrement*: Performs `ra = SIGN_EXT(MEM[(--rb) + SIGN_EXT(imm)])`. The length modifier is applied to all operands.],

            [`MLDU_PD`], [`0xD4`], [2RI.A], [`B`], [-], [*Memory Load Unsigned Pre Decrement*: Performs `ra = MEM[(--rb) + SIGN_EXT(imm)]`. The length modifier is applied to all operands.],

            [`MST_PD`], [`0xD5`], [2RI.A], [`B`], [-], [*Memory Load Pre Decrement*: Performs `MEM[(--rb) + SIGN_EXT(imm)] = ra`. The length modifier is applied to all operands.],

            [`MLD_PI`], [`0xD6`], [2RI.A], [`B`], [-], [*Memory Load Post Increment*: Performs `ra = SIGN_EXT(MEM[(rb++) + SIGN_EXT(imm)])`. The length modifier is applied to all operands.],

            [`MLDU_PI`], [`0xD7`], [2RI.A], [`B`], [-], [*Memory Load Unsigned Post Increment*: Performs `ra = MEM[(rb++) + SIGN_EXT(imm)]`. The length modifier is applied to all operands.],

            [`MST_PI`], [`0xD8`], [2RI.A], [`B`], [-], [*Memory Load Post Increment*: Performs `MEM[(rb++) + SIGN_EXT(imm)] = ra`. The length modifier is applied to all operands.],

            [`IMLD`], [`0x7BA6`], [3RI.A], [`B`], [-], [*Indexed Memory Load*: Performs `ra = SIGN_EXT(MEM[rb + rc + SIGN_EXT(imm)])`. The length modifier is applied to all operands.],

            [`IMLDU`], [`0x7BA7`], [3RI.A], [`B`], [-], [*Indexed Memory Load Unsigned*: Performs `ra = MEM[rb + rc + SIGN_EXT(imm)]`. The length modifier is applied to all operands.],

            [`IMST`], [`0x7BA8`], [3RI.A], [`B`], [-], [*Indexed Memory Store*: Performs `MEM[rb + rc + SIGN_EXT(imm)] = ra`. The length modifier is applied to all operands.],

            [`SMLD`], [`0x7BA9`], [3RI.A], [`B`], [-], [*Scaled Memory Load*: Performs `ra = SIGN_EXT(MEM[rb + (rc << ZERO_EXT(imm))])`. The length modifier is applied to all operands.],

            [`SMLDU`], [`0x7BAA`], [3RI.A], [`B`], [-], [*Scaled Memory Load Unsigned*: Performs `ra = MEM[rb + (rc << ZERO_EXT(imm))]`. The length modifier is applied to all operands.],

            [`SMST`], [`0x7BAB`], [3RI.A], [`B`], [-], [*Scaled Memory Store*: Performs `MEM[rb + (rc << ZERO_EXT(imm))] = ra`. The length modifier is applied to all operands.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Data Vector Basic (`DVB`)],
        [This module provides basic vector memory transfer operations. The `SGPRB` and `VGPRB` are required for this module.],

        tableWrapper([DVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VMLD`], [`0x7B8C`], [2RI.B], [`D`], [-], [*Vector Memory Load*: Performs `va = MEM_i[rb + STRIDE(ZERO_EXT(imm))]`.],
            [`VMST`], [`0x7B8D`], [2RI.B], [`D`], [-], [*Vector Memory Store*: Performs `MEM_i[rb + STRIDE(ZERO_EXT(imm))] = va`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Data Vector Advanced (`DVA`)],
        [This module provides advanced vector memory transfer operations. The `SGPRB` and `VGPRB` are required for this module.],

        tableWrapper([DVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VGAT`], [`0x7BEC`], [3R.A], [-], [-], [*Vector Gather*: Performs `va = MEM_i[rb + vc_i]`.],
            [`VSCA`], [`0x7BED`], [3R.A], [-], [-], [*Vector Scatter*: Performs `MEM_i[rb + vc_i] = va`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Data Atomic Basic (`DAB`)],
        [This module provides basic atomic scalar memory transfer operations. The `SGPRB` is required for this module.],

        tableWrapper([DAB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CAS`], [`0x3D2`], [4R.A], [`B`], [-], [*Compare And Swap*: Performs `if(MEM[rb] != rc) then {ra = 0} else {MEM[rb] = rd; ra = 1}`, that is, write into the memory location pointed by `rb` the value in `rd` if and only if such location is equal to `rc`. The outcome of this instruction is written into `ra`. The length modifier is applied to all operands.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Data Atomic Advanced (`DAA`)],
        [This module provides advanced atomic scalar memory transfer operations. The `SGPRB` is required for this module.],

        tableWrapper([DAA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`AADD`], [`0x7BEE`], [3R.A], [`B`], [-], [*Atomic Add*: Performs: `ra = MEM[rb]; mem[rb] = ra + rc` atomically. The length modifier is applied to all operands.],

            [`ASUB`], [`0x7BEF`], [3R.A], [`B`], [-], [*Atomic Sub*: Performs: `ra = MEM[rb]; mem[rb] = ra - rc` atomically. The length modifier is applied to all operands.],

            [`AAND`], [`0x7BF0`], [3R.A], [`B`], [-], [*Atomic And*: Performs: `ra = MEM[rb]; mem[rb] = ra & rc` atomically. The length modifier is applied to all operands.],

            [`AOR`], [`0x7BF1`], [3R.A], [`B`], [-], [*Atomic Or*: Performs: `ra = MEM[rb]; mem[rb] = ra | rc` atomically. The length modifier is applied to all operands.],

            [`AMIN`], [`0x7BF2`], [3R.A], [`B`], [-], [*Atomic Minimum*: Performs: `ra = MEM[rb]; mem[rb] = ra < rc ? ra : rc` atomically. The length modifier is applied to all operands.],

            [`AMAX`], [`0x7BF3`], [3R.A], [`B`], [-], [*Atomic Maximum*: Performs: `ra = MEM[rb]; mem[rb] = ra > rc ? ra : rc` atomically. The length modifier is applied to all operands.],
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Data Block (`DB`)], // explain that the elements are considered WLEN aligned.
        [This module provides memory transfer operations acting on blocks of registers. The `SGPRB` is required for this module.],

        tableWrapper([DB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`BLDL`], [`0x1C7`], [RI.A], [`C`], [-], [*Block Load Lower*: Performs `ra{0:15} = MASK(MEM[rb], ZERO_EXT(imm))`, that is, load the first 16 registers from the memory location pointed by `rb` ignoring when `imm` has a `0` bit for that specific position.],

            [`BLDP`], [`0x1C8`], [RI.A], [`C`], [-], [*Block Load Upper*: Performs `ra{31:16} = MASK(MEM[rb], ZERO_EXT(imm))`, that is, load the last 16 registers from the memory location pointed by `rb` ignoring when `imm` has a `0` bit for that specific position.],

            [`BLDL`], [`0x1C9`], [RI.A], [`C`], [-], [*Block Store Lower*: Performs `MEM[rb] = MASK(ra{0:15}, ZERO_EXT(imm))`, that is, store the first 16 registers into the memory location pointed by `rb` ignoring when `imm` has a `0` bit for that specific position.],

            [`BLDP`], [`0x1CA`], [RI.A], [`C`], [-], [*Block Store Upper*: Performs `MEM[rb] = MASK(ra{31:16}, ZERO_EXT(imm))`, that is, store the last 16 registers into the memory location pointed by `rb` ignoring when `imm` has a `0` bit for that specific position.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Data Compressed (`DC`)],
        [This module provides memory transfer operations with a smaller code footprint. The `SGPRB` is required for this module.],

        tableWrapper([DC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CMLD`], [`0xBE`], [2R.B], [`B`], [-], [*Compressed Memory Load*: Performs `ra = MEM[rb]`. The length modifier is applied to all operands.],

            [`CMST`], [`0xBF`], [2R.B], [`B`], [-], [*Compressed Memory Store*: Performs `MEM[rb] = ra`. The length modifier is applied to all operands.],

            [`CMLID`], [`0x1`], [2RI.C], [-], [-],[*Compressed Memory Load Int Displacement*: Performs `ra = MEM[rb + SIGN_EXT(imm)]`.],
            [`CMSID`], [`0x2`], [2RI.C], [-], [-],[*Compressed Memory Store Int Displacement*: Performs `MEM[rb + SIGN_EXT(imm)] = ra`.],
            [`CMLWD`], [`0x3`], [2RI.C], [-], [-],[*Compressed Memory Load Word Displacement*: Performs `ra = MEM[rb + SIGN_EXT(imm)]`.],
            [`CMSWD`], [`0x4`], [2RI.C], [-], [-],[*Compressed Memory Store Word Displacement*: Performs `MEM[rb + SIGN_EXT(imm)] = ra`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Flow Integer Basic (`FIB`)],
        [This module provides basic scalar control transfer operations. The `SGPRB` is required for this module.],

        tableWrapper([FIB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`JMP`], [`0xE0`], [I.A], [-], [-], [*Unconditional Jump*: Performs `PC = PC + SIGN_EXT(imm << 1)`.],
            [`BJAL`], [`0xE1`], [I.A], [-], [-], [*Big Jump And Link*: Performs `S0 = PC; PC = PC + SIGN_EXT(imm << 1)`.],

            [`JMPR`], [`0x1CB`], [RI.A], [`D`], [-], [*Unconditional Jump Register*: Performs `PC = PC + ra + SIGN_EXT(imm << 1)`.],
            [`JAL`], [`0x1CC`], [RI.A], [`D`], [-], [*Jump And Link*: Performs `ra = PC; PC = PC + SIGN_EXT(imm << 1)`.],

            [`BEQ`], [`0xD9`], [2RI.A], [`D`], [-], [*Branch If Equal*: Performs `if(ra == rb) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`.],

            [`BLT`], [`0xDA`], [2RI.A], [`D`], [-], [*Branch If Less Than*: Performs `if(ra < rb) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`.],

            [`BLTU`], [`0xDB`], [2RI.A], [`D`], [-], [*Branch If Less Than Unsigned*: Performs `if(ra < rb) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`. `ra` and `rb` are considered unsigned.],

            [`BLE`], [`0xDC`], [2RI.A], [`D`], [-], [*Branch If Less Than Equal*: Performs `if(ra <= rb) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`.],

            [`BLEU`], [`0xDD`], [2RI.A], [`D`], [-], [*Branch If Less Than Equal Unsigned*: Performs `if(ra <= rb) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`. `ra` and `rb` are considered unsigned.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Flow Integer Advanced (`FIA`)],
        [This module provides advanced scalar control transfer operations. The `SGPRB` is required for this module.],

        tableWrapper([FIA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`BEQI`], [`0x1CD`], [RI.A], [`D`], [-], [*Branch If Equal Immediate*: Performs `if(ra == SIGN_EXT(imm[3:0])) then {PC = PC + SIGN_EXT(imm[17:4] << 1)} else {noop}`.],

            [`BLTI`], [`0x1CE`], [RI.A], [`D`], [-], [*Branch If Less Than Immediate*: Performs `if(ra < SIGN_EXT(imm[3:0])) then {PC = PC + SIGN_EXT(imm[17:4] << 1)} else {noop}`.],

            [`BLTIU`], [`0x1CF`], [RI.A], [`D`], [-], [*Branch If Less Than Immediate Unsigned*: Performs `if(ra < EXT(imm[3:0])) then {PC = PC + SIGN_EXT(imm[17:4] << 1)} else {noop}`. `ra` is considered unsigned.],

            [`BLEI`], [`0x1D0`], [RI.A], [`D`], [-], [*Branch If Less Than Equal Immediate*: Performs `if(ra <= SIGN_EXT(imm[3:0])) then {PC = PC + SIGN_EXT(imm[17:4] << 1)} else {noop}`.],

            [`BLEIU`], [`0x1D1`], [RI.A], [`D`], [-], [*Branch If Less Than Equal Immediate Unsigned*: Performs `if(ra <= EXT(imm[3:0])) then {PC = PC + SIGN_EXT(imm[17:4] << 1)} else {noop}`. `ra` is considered unsigned.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Flow Integer Compressed (`FIC`)],

        [This module provides compressed scalar control transfer operations with a smaller code footprint. The `SGPRB` is required for this module.],

        tableWrapper([FIC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CBEQZ`], [`0x0F`], [RI.B], [-], [-], [*Compressed Branch If Equal To Zero*: Performs `if(ra == 0) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`.],

            [`CBLTZ`], [`0x10`], [RI.B], [-], [-], [*Compressed Branch If Less Than Zero*: Performs `if(ra < 0) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`.],

            [`CBLEZ`], [`0x11`], [RI.B], [-], [-], [*Compressed Branch If Less OR Equal To Zero*: Performs `if(ra <= 0) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`.],

            [`CJALO`], [`0x12`], [RI.B], [-], [-], [*Compressed Jump And Link Offset*: Performs `S0 = PC; PC = ra + SIGN_EXT(imm << 1)`.],

            [`CJMPO`], [`0x13`], [RI.B], [-], [-], [*Compressed Jump Offset*: Performs `PC = ra + SIGN_EXT(imm << 1)`.],

            [`CJAL`], [`0x2C`], [I.B], [-], [-], [*Compressed Jump And Link*: Performs `S0 = PC; PC = PC + SIGN_EXT(imm << 1)`.],
            [`CJMP`], [`0x2D`], [I.B], [-], [-], [*Compressed Jump*: Performs `PC = PC + SIGN_EXT(imm << 1)`.],

            [`CBLE`], [`0x0`], [2RI.C], [-], [-], [*Compressed Branch If Less Or Equal Than*: Performs `if(ra <= rb) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`.],
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Flow FP Basic (`FFB`)],

        [This module provides floating point scalar control transfer operations. The `SGPRB` is required for this module. If the `FRMD` module is not implemented, the rounding mode must always be round to nearest even, unless otherwise noted.],

        tableWrapper([FFB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`FBLT`], [`0x7B8E`], [2RI.B], [`B`], [`INVOP`], [*FP Branch If Less Than*: Performs `if(ra < rb) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`. The length modifier is applied to all operands.],

            [`FBLE`], [`0x7B8F`], [2RI.B], [`B`], [`INVOP`], [*FP Branch If Less Than Or Equal*: Performs `if(ra <= rb) then {PC = PC + SIGN_EXT(imm << 1)} else {noop}`. The length modifier is applied to all operands.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Flow FP Advanced (`FFA`)],

        [This module provides advanced floating point scalar control transfer operations. The `SGPRB` is required for this module. Branches that use part of the immediate value to perform the comparison, actually indexes into a small 16 entry lookup table with the following FP values in order: `0`, `1`, `-1`, `2`, `-2`, `4`, `-4`, `8`, `-8`, `16`, `0.5`, `-0.5`, `0.25`, `-0.25`, `0.125`, `-0.125`],

        tableWrapper([FFA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`FBLTI`], [`0x1D2`], [RI.A], [`B`], [`INVOP`], [*FP Branch If Less Than Immediate*: Performs `if(ra < LOOKUP(imm[3:0])) then {PC = PC + SIGN_EXT(imm[17:4] << 1)} else {noop}`, where `LOOKUP` is the above mentioned lookup table. The length modifier is applied to `ra`.],

            [`FBLEI`], [`0x1D3`], [RI.A], [`B`], [`INVOP`], [*FP Branch If Less Than Or Equal Immediate*: Performs `if(ra <= LOOKUP(imm[3:0])) then {PC = PC + SIGN_EXT(imm[17:4] << 1)} else {noop}`, where `LOOKUP` is the above mentioned lookup table. The length modifier is applied to `ra`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Vector Moves (`VM`)],
        [This module provides operations to move between the `VGPRB` and `SGPRB`, which are both required.],

        tableWrapper([VM Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VEXTR`], [`0xF860C`], [2R.A], [`B`], [-], [*Vector Extract*: Performs `ra = vb[ZERO_EXT(imm)]`, ignoring any vector shape configuration. The element and size are dictated by `imm` and the class mode respectively. The length modifier is applied to all operands.],

            [`VINJ`], [`0xF860D`], [2R.A], [`B`], [-], [*Vector Inject*: Performs `va[ZERO_EXT(imm)] = rb`, ignoring any vector shape configuration. The element and size are dictated by `imm` and the class mode respectively. The length modifier is applied to all operands.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Flow Integer Vector (`FIV`)],
        [This module provides integer vector mask manipulation operations. The `VGPRB` is required for this module.],

        tableWrapper([VF Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VSEQ`], [`0xF864E`], [4R.B], [`A`], [-], [*Vector Set If Equal*: Performs `va = MASK(vc == vd ? 1 : 0, vb)`. This instruction class specifies: `00` (`-`) as default mode and `01` (`.N`) as negated mode, which simply negates the checking condition.],

            [`VSLT`], [`0xF864F`], [4R.B], [`A`], [-], [*Vector Set If Less Than*: : Performs `va = MASK(vc < vd ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply negate the checking condition.],

            [`VSLE`], [`0xF8650`], [4R.B], [`A`], [-], [*Vector Set If Less Or Equal*: : Performs `va = MASK(vc <= vd ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply negate the checking condition.],

            [`VSEQI`], [`0x1ED0`], [3RI.B], [`A`], [-], [*Vector Set If Equal Immediate*: Performs `va = MASK(vc == EXT(imm) ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`VSLTI`], [`0x1ED1`], [3RI.B], [`A`], [-], [*Vector Set If Less Than Immediate*: Performs `va = MASK(vc < EXT(imm) ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.],

            [`VSLEI`], [`0x1ED2`], [3RI.B], [`A`], [-], [*Vector Set If Less Or Equal Immediate*: Performs `va = MASK(vc <= EXT(imm) ? 1 : 0, vb)`. This instruction class specifies: `00` (`.S`) as signed mode, `01` (`.U`) as unsigned mode, `10` (`.NS`) as negated signed mode and `11` (`.NU`) as negated unsigned mode. The last two modes simply invert the checking condition and the immediate will be sign or zero extended according to the specified mode.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Flow FP Vector (`FFV`)],
        [This module provides floating point vector mask manipulation operations. The `VGPRB` is required for this module.],

        tableWrapper([VF Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VFSLT`], [`0xF8651`], [4R.B], [`A`], [-], [*Vector FP Set If Less Than*: Performs `va = MASK(vc < vd ? 1 : 0, vb)`. Must always have a class mode value of `00`.],

            [`VFSLE`], [`0xF8651`], [4R.B], [`A`], [-], [*Vector FP Set If Less Or Equal*: Performs `va = MASK(vc <= vd ? 1 : 0, vb)`. Must always have a class mode value of `01`.],

            [`VFSGT`], [`0xF8651`], [4R.B], [`A`], [-], [*Vector FP Set If Greater Than*: Performs `va = MASK(vc > vd ? 1 : 0, vb)`. Must always have a class mode value of `10`.],

            [`VFSGE`], [`0xF8651`], [4R.B], [`A`], [-], [*Vector FP Set If Greater Or Equal*: Performs `va = MASK(vc >= vd ? 1 : 0, vb)`. Must always have a class mode value of `11`.],

            [`VFSLTI`], [`0x1ED3`], [3RI.B], [`A`], [-], [*Vector FP Set If Less Than Immediate*:  Performs `va = MASK(vc < imm ? 1 : 0, vb)`. Must always have a class mode value of `00`.],

            [`VFSLEI`], [`0x1ED3`], [3RI.B], [`A`], [-], [*Vector FP Set If Less Or Equal Immediate*:  Performs `va = MASK(vc <= imm ? 1 : 0, vb)`. Must always have a class mode value of `01`.],

            [`VFSGTI`], [`0x1ED3`], [3RI.B], [`A`], [-], [*Vector FP Set If Greater Than Immediate*:  Performs `va = MASK(vc > imm ? 1 : 0, vb)`. Must always have a class mode value of `10`.],

            [`VFSGEI`], [`0x1ED3`], [3RI.B], [`A`], [-], [*Vector FP Set If Greater Or Equal Immediate*:  Performs `va = MASK(vc >= imm ? 1 : 0, vb)`. Must always have a class mode value of `11`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [System (`SYS`)],
        [This module provides basic system operations. The `SPRB` and `SGPRB` are required for this module.],

        tableWrapper([SYS Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`NOP`], [`0xF860E`], [2R.A], [`A`], [-], [*No Operation*: Performs nothing. The operands are not used and must always have a class mode value of `00`.],

            [`HLT`], [`0xF860E`], [2R.A], [`A`], [-], [*Halt Execution*: Performs `PWRS = ra; HALT(rb)`. The calling hart will halt for the number of cycles specified in `rb` and a value of `0` causes the hart to halt indefinitely. The second operand `rb` is not used. This instruction is privileged and must always have a class mode value of `01`.],

            [`SYSINFO`], [`0xF860F`], [2R.A], [`B`], [-], [*System Information*: Performs `ra = CFG_SEG[rb + SIGN_EXT(imm)]`, where `CFG_SEG` is the configuration segment.],

            [`LDSR`], [`0xF8610`], [2R.A], [`D`], [-], [*Load Status Register*: Performs `ra = CHUNK(SR, imm)`. The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the `SR` to consider. The second operand `rb` is not used. This instruction is privileged.],

            [`STSR`], [`0xF8611`], [2R.A], [`D`], [-], [*Store Status Register*: Performs `CHUNK(SR, imm) = ra`. The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the `SR` to consider. The second operand `rb` is not used. This instruction is privileged.],

            [`CACOP`], [`0x7B90`], [2RI.B], [`A`], [-], [*Cache Operation*: Implementation-specific privileged instruction designed to allow direct manipulation of the cache. If no caching is implemented this instruction must throw the `INCI` fault. Must always have a class mode value of `00`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Vector Configuration (`VC`)],
        [This module provides vector configuration operations. The `VGPRB`, `SGPRB` and `SPRB` are required for this module.],

        tableWrapper([VC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDVSHP`], [`0xF8612`], [2R.A], [`A`], [-], [*Load Vector Shape*: Performs: `ra = VSH`. The second operand `rb` is not used and must always have a class mode value of `00`.],

            [`STVSHP`], [`0xF8612`], [2R.A], [`A`], [-], [*Store Vector Shape*: Performs: `VSH = ra`. The second operand `rb` is not used and must always have a class mode value of `01`.],

            [`VPCKUPCK`], [`0x7B91`], [2RI.B], [`A`], [-], [*Vector Pack Unpack*: Performs `va = PACK_UNPACK(vb, imm)`, that is, packs or unpacks `vb` with the current vector shape to the one specified in the `imm`. An example of the transformation would be: `000a 000b 000c 000d <=> 000000000000abcd`. Must always have a class mode value of `00`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Floating Point Rounding Modes (`FRMD`)],

        [This module provides floating-point rounding mode configuration and manipulation operations. The `SGPRB` and `SPRB` are required for this module.],

        tableWrapper([FRMD Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDRMD`], [`0xF8613`], [2R.A], [`A`], [-], [*Load Rounding Mode*: Performs `ra = RMD`, where `RMD` are the rounding mode bits of the `SR`. The second operand `rb` is not used and must always have a class mode value of `00`.],

            [`STRMD`], [`0xF8613`], [2R.A], [`A`], [-], [*Store Rounding Mode*: Performs `RMD = ra`, where `RMD` are the rounding mode bits of the `SR`. The second operand `rb` is not used and must always have a class mode value of `01`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Helper Registers (`HR`)],

        [This module provides helper register configuration and manipulation operations. The `SGPRB`, `HLPRB` and `SPRB` are required for this module.],

        tableWrapper([HR Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDHR`], [`0xF8614`], [2R.A], [`D`], [-], [*Load Helper Register*: Performs `ra = CHUNK(HLPR)`. The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the `HLPR` to consider. The second operand `rb` is not used.],

            [`STHR`], [`0xF8615`], [2R.A], [`D`], [-], [*Store Helper Register*: Performs `CHUNK(HLPR) = ra`. The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the `HLPR` to consider. The second operand `rb` is not used.],

            [`LDHRM`], [`0xF8616`], [2R.A], [`A`], [-], [*Load Helper Register Mode*: Performs `ra = HLPR[WLEN+8:WLEN]`. The second operand `rb` is not used and must always have a class mode value of `00`.],

            [`STHRM`], [`0xF8617`], [2R.A], [`A`], [-], [*Store Helper Register Mode*: Performs `HLPR[WLEN+8:WLEN] = ra`. The second operand `rb` is not used and must always have a class mode value of `01`.],

            [`LDHLPRE`], [`0xF8618`], [2R.A], [`A`], [-], [*Load HLPRE Status*: Performs `ra = HLPRE`, where `HLPRE` are the helper enable bits of the `SR` register. The second operand `rb` is not used and must always have a class mode value of `10`.],

            [`STHLPRE`], [`0xF8619`], [2R.A], [`A`], [-], [*Store HLPRE Status*: Performs `HLPRE = ra`, where `HLPRE` are the helper enable bits of the `SR` register. The second operand `rb` is not used and must always have a class mode value of `11`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Performance Counters (`PC`)],

        [This module provides performance counter configuration and manipulation operations. The `SGPRB`, `PERFCB` and `SPRB` are required for this module.],

        tableWrapper([PC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDCR`], [`0xF861A`], [2R.A], [`D`], [-], [*Load Counter Register*: Performs `ra = CHUNK(PERFC)`. The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the `PERFC` to consider. The second operand `rb` is not used.],

            [`STCR`], [`0xF861B`], [2R.A], [`D`], [-], [*Store Counter Register*: Performs `CHUNK(PERFC) = ra`. The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the `PERFC` to consider. The second operand `rb` is not used.],

            [`LDCRM`], [`0xF861C`], [2R.A], [`A`], [-], [*Load Counter Register Mode*: Performs `ra = PERFC[CLEN+8:CLEN]`. The second operand `rb` is not used and must always have a class mode value of `00`.],

            [`STCRM`], [`0xF861C`], [2R.A], [`A`], [-], [*Store Counter Register Mode*: Performs `PERFC[CLEN+8:CLEN] = ra`. The second operand `rb` is not used and must always have a class mode value of `01`.],

            [`LDPERFCE`], [`0xF861C`], [2R.A], [`A`], [-], [*Load PERFCE Status*: Performs `ra = PERFCE`, where `PERFCE` is the performance counter enable of the `SR`. The second operand is not used and must always have a class mode value of `10`.],

            [`STPERFCE`], [`0xF861C`], [2R.A], [`A`], [-], [*Store PERFCE Status*: Performs `PERFCE = ra`, where `PERFCE` is the performance counter enable of the `SR`. The second operand is not used and must always have a class mode value of `11`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Fencing (`FNC`)],
        [This module provides fencing memory semantic operations.],

        tableWrapper([PC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`FNCL`], [`0xF861D`], [2R.A], [`A`], [-], [*Fence Loads*: See section 5. The operands are not used and must always have a class mode value of `00`],

            [`FNCS`], [`0xF861D`], [2R.A], [`A`], [-], [*Fence Stores*: See section 5. The operands are not used and must always have a class mode value of `01`],

            [`FNCLS`], [`0xF861D`], [2R.A], [`A`], [-], [*Fence Loads And Stores*: See section 5. The operands are not used and must always have a class mode value of `10`],

            [`FNCIOL`], [`0xF861E`], [2R.A], [`A`], [-], [*Fence IO Loads*: See section 5. The operands are not used and must always have a class mode value of `00`],

            [`FNCIOS`], [`0xF861E`], [2R.A], [`A`], [-], [*Fence IO Stores*: See section 5. The operands are not used and must always have a class mode value of `01`],

            [`FNCIOLS`], [`0xF861E`], [2R.A], [`A`], [-], [*Fence IO Loads and Stores*: See section 5. The operands are not used and must always have a class mode value of `10`],

            [`LDCMD`], [`0xF861F`], [2R.A], [`A`], [-], [*Load Consistency Mode*: Performs `ra = CMD`, where `CMD` is the consistency mode bit of the `SR`. The second operand `rb` is not used and must always have a class mode value of `00`.],

            [`STCMD`], [`0xF861F`], [2R.A], [`A`], [-], [*Store Consistency Mode*: Performs `CMD = ra`, where `CMD` is the consistency mode bit of the `SR`. The second operand `rb` is not used and must always have a class mode value of `01`.]

            /*
                tableWrapper([Fencing instructions.], table(

            columns: (auto, auto),
            align: left + horizon,

            [#middle([*Name*])], [#middle([*Description*])],

            [`FNCL`], [*Fence Loads*: \ This instruction forbids the hart from reordering any memory load instruction across the fence.],

            [`FNCS`], [*Fence Stores*: \ This instruction forbids the hart from reordering any memory store instruction across the fence.],

            [`FNCLS`], [*Fence Loads and Stores*: \ This instruction forbids the hart from reordering any memory load or store instruction across the fence.],

            [`FNCIOL`], [*Fence IO Loads*: \ This instruction forbids the hart from reordering any IO load instruction across the fence.],

            [`FNCIOS`], [*Fence IO Stores*: \ This instruction forbids the hart from reordering any IO store instruction across the fence.],

            [`FNCIOLS`], [*Fence IO Loads and Stores*: \ This instruction forbids the hart from reordering any IO load or store instruction across the fence.]
        )),
            */
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Transactional Memory (`TM`)],
        [This module provides transactional memory semantic operations. The `SGRPB` is required for this module.],

        tableWrapper([TM Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`TBEG`], [`0xF8620`], [2R.A], [`A`], [-], [*Transaction Begin*: Causes the hart that executed this instruction to start monitoring accesses by other harts as well as incrementing the nesting counter by one, thus starting a transaction. If the nesting counter was zero prior to executing this instruction, the hart must enter into transactional mode. This instruction will write the outcome status of its execution in `ra`. The second operand `rb` is not used and must always have a class mode of `00`.],

            [`TCOM`], [`0xF8620`], [2R.A], [`A`], [-], [*Transaction Commit*: Causes the hart that executed this instruction to stop monitoring accesses by other harts and commit the changes as well as decrementing the nesting counter by one. If the nesting counter is zero after the execution of this instruction, the hart must exit from transactional mode. This instruction will write the outcome status of its execution in `ra`. All of the updates to memory, if any, can be considered atomic and permanent after the successful completion of this instruction. The second operand `rb` is not used and must always have a class mode of `01`.],

            [`TCHK`], [`0xF8620`], [2R.A], [`A`], [-], [*Transaction Check*: Causes the hart that executed this instruction to check if it's necessary to abort the current transaction. If the check fails, this instruction will behave exactly the same as a failing `TCOM`. If the check passes, this instruction will not affect the architectural state, that is, it will behave like a no-operation. This instruction will write the outcome status of its execution in `ra`. The second operand `rb` is not used and must always have a class mode of `10`.],

            [`TABT`], [`0xF8620`], [2R.A], [`A`], [-], [*Transaction Abort*: Causes the hart that executed this instruction to stop monitoring accesses by other harts, rollback all changes, decrement the nesting counter by one and write, to `ra`, the value of the `XABT` abort code. This instruction behaves in a similar manner to a failing `TCOM`. It is important to note that this instruction will, naturally, only abort the innermost active transaction. The second operand `rb` is not used and must always have a class mode of `11`.],

            [`TABTA`], [`0xF8621`], [2R.A], [`A`], [-], [*Transaction Abort All*: Causes the hart that executed this instruction to stop monitoring accesses by other harts, discard all changes, reset the nesting counter to zero and write, to `ra`, the value of the `XABT` abort code. This instruction behaves in a similar manner to a failing `TCOM`. It is important to note that this instruction will abort all currently active transactions. The second operand `rb` is not used and must always have a class mode of `00`.],

            [`TLEV`], [`0xF8622`], [2R.A], [`A`], [-], [*Transaction Level*: Returns the current transaction nesting level count into `ra`. If no transaction is active a zero is returned. The second operand `rb` is not used and must always have a class mode of `01`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Eventing (`EVT`)],
        [This module provides event related machine-mode operations. The `SGPRB` and `SPRB` are required for this module.],

        tableWrapper([EVT Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDMER`], [`0xF8623`], [2R.A], [`D`], [-], [*Load Machine Event Register*: Performs `ra = CHUNK(MER)`, where `MER` is one of the special purpose registers prefixed with "machine event". The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the target `MER` to consider. The second operand `rb` is not used and this instruction is privileged.],

            [`STMER`], [`0xF8624`], [2R.A], [`D`], [-], [*Store Machine Event Register*: Performs `CHUNK(MER) = ra`, where `MER` is one of the special purpose registers prefixed with "machine event". The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the target `MER` to consider. The second operand `rb` is not used and this instruction is privileged.],

            [`LDIMSK`], [`0xF8625`], [2R.A], [`A`], [-], [*Load Interrupt Mask*: Performs `ra = IMSK`, where `IMSK` are the interrupt mask bits of the `SR`. The second operand `rb` is not used and must always have a class mode value of `00`. This instruction is privileged.],

            [`STIMSK`], [`0xF8625`], [2R.A], [`A`], [-], [*Store Interrupt Mask*: Performs `IMSK = ra`, where `IMSK` are the interrupt mask bits of the `SR`. The second operand `rb` is not used and must always have a class mode value of `01`. This instruction is privileged.],

            [`ERET`], [`0xF8625`], [2R.A], [`A`], [-], [*Event Return*: Performs the privileged event returning sequence, see section 7. This instruction is privileged and must always have a class mode of `10`. This instruction is privileged.],

            [`SNDINT`], [`0xF8625`], [2R.A], [`A`], [-], [*Send Interrupt*: Performs `ra = IPCINT(rb)`, that is, send an IPC-interrupt with `rb` as the event payload. This instruction writes into `ra` the execution status of the operation. This instruction is privileged, implementation specific and must always have a class modifier of `11`.],

            [`WINT`], [`0x1D4`], [RI.A], [`A`], [-], [*Wait For Interrupt*: Causes the executing hart to halt and wait for interrupt. The `ra` specifies the timeout and `rb` specifies the id of the interrupt (IO or IPC) to wait for. This instruction class specifies: `.C` (`00`) as cycles mode, `.N` (`01`) as nanoseconds mode, `.U` (`10`) as microseconds mode and `.M` (`11`) as milliseconds. This instruction is privileged.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [User Mode (`USER`)],

        [This module provides user-mode event return and user-mode system operations. The `SGPRB` and `SPRB` are required for this module.],

        tableWrapper([USER Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`SYSCL`], [`0xF8626`], [2R.A], [`A`], [-], [*System Call*: Performs `MED = SYSTEM_CALL(ra)`, where `ra` holds the call id and `rb` is not used. This instruction is privileged and must always have a class mode value of `00`.],

            [`UERET`], [`0xF8626`], [2R.A], [`A`], [-], [*User Event Return*: Performs the unprivileged event returning sequence, see section 7. Must always have a class mode of `01`.],

            [`URET`], [`0xF8626`], [2R.A], [`A`], [-], [*User Return*: Performs the user event returning sequence, see section 7. This instruction is privileged and must always have a class mode of `10`.],

            [`LDSPR`], [`0xF8627`], [2R.A], [`D`], [-], [*Load Special Purpose Register*: Performs `ra = CHUNK(SPR)`, where `SPR` is one of the following registers from the `SPRB`: `UEPC`, `UESR`, `UEC`, `UED`, `UEHP`, `UET0`, `UET1`, `PFPA`, `PID`, `TID`, `TPTR`, `WDT` in the presented order starting from `0`. The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the target `SPR` to consider. This instruction privilege level is inherited from the selected `SPR`.],

            [`STSPR`], [`0xF8628`], [2R.A], [`D`], [-], [*Store Special Purpose Register*: Performs `CHUNK(SPR) = ra`, where `SPR` is one of the following registers from the `SPRB`: `UEPC`, `UESR`, `UEC`, `UED`, `UEHP`, `UET0`, `UET1`, `PFPA`, `PID`, `TID`, `TPTR`, `WDT` in the presented order starting from `0`. The class modifier specifies a two bit immediate constant that is used to select which 8 bit portion of the target `SPR` to consider. This instruction privilege level is inherited from the selected `SPR`.],

            [`LDWDTS`], [`0xF8629`], [2R.A], [`A`], [-], [*Load Watchdog Timer Status*: Performs `ra = WDTE`, where `WDTE` is the watchdog timer enable bit of the `SR`. Must always have a class mode of `00`.],

            [`STWDTS`], [`0xF8629`], [2R.A], [`A`], [-], [*Store Watchdog Timer Status*: Performs `WDTE = ra`, where `WDTE` is the watchdog timer enable bit of the `SR`. Must always have a class mode of `01`.],

            [`MMUOP`], [`0x1D5`], [RI.A], [`A`], [-], [*Memory Management Unit Operation*: Implementation-specific privileged instruction designed to allow direct manipulation of the memory management unit. If no MMU is implemented this instruction must throw the `INCI` fault. Must always have a class mode value of `00`.],

            [`UCACOP`], [`0x7B92`], [2RI.B], [`A`], [-], [*User Cache Operation*: Implementation-specific instruction designed to allow direct manipulation of the cache. If no caching is implemented this instruction must throw the `INCI` fault. Must always have a class mode value of `00`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Exception (`EXC`)],

        [This module provides arithmetic exceptions (see section 3) and status manipulation operations. The `SGPRB` and `SPRB` are required for this module.],

        tableWrapper([EXC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDGEE`], [`0xF862A`], [2R.A], [`A`], [-], [*Load Global Exception Enable*: Performs `ra = GEE`, where `GEE` is the global exceptions enable bit of the `SR`. The second operand `rb` is not used and must always have a class mode value of `00`.],

            [`STGEE`], [`0xF862A`], [2R.A], [`A`], [-], [*Store Global Exception Enable*: Performs `GEE = ra`, where `GEE` is the global exceptions enable bit of the `SR`. The second operand `rb` is not used and must always have a class mode value of `01`.]
        ))
    )
))

#page(flipped: true, textWrap(

    subSection(

        [Power (`PWR`)],
        [This module provides power state manipulation operations. The `SGPRB` and `SPRB` are required for this module.],

        tableWrapper([EXC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+top).at(x),

            [#middle([*Name*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`LDPWRS`], [`0xF862B`], [2R.A], [`A`], [-], [*Load Power State*: Performs `ra = PWRS`, where `PWRS` are the power status bits of the `SR`. The second operand `rb` is not used and must always have a class mode value of `00`. This instruction is privileged.],

            [`STPWRS`], [`0xF862B`], [2R.A], [`A`], [-], [*Store Power State*: Performs `PWRS = ra`, where `PWRS` are the power status bits of the `SR`. The second operand `rb` is not used and must always have a class mode value of `01`. This instruction is privileged.]
        ))
    )
))

///
