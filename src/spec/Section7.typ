///
#import "Macros.typ": *

///
#page(flipped: true, section(

    [Instruction List (WORK IN PROGRESS) ],

    [This section is dedicated to provide the full and extensive list of all the proposed instructions in the ISA divided into their corresponding module.],

    [Systems that don't support certain modules must generate the `INCI` fault whenever an unimplemented or incompatible instruction is fetched or attempted to be processed in any other way. The `ILLI` fault whenever a combination of all zeros, all ones or an otherwise illegal combination is fetched in order to increase safety against buffer overflows exploits or accidental accesses of uninitialized memory locations.],

    [As mentioned in previous sections, since some instructions can generate flags, they are not stored in any sort of flag register and they can be ignored unless the `EXC`, `HLPR` or both modules are implemented.],

    [Unused bits, designated with "-" or "x", must have a value of zero by default for convention.],

    subSection(

        [Computational Integer Scalar Basic (`CISB`)],

        [This module provides simple integer scalar instructions to perform a variety of arithmetic and logical operations with registers or immediate values. The `SGPRB` is mandatory for this module.],

        tableWrapper([CISB instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`ABS`], [], [2R.A], [-], [-], [*Absolute Value*: Performs `ra = ABS(rb)`.],
            [`EXT`], [], [2R.A], [`B`], [-], [*Sign Extend*: Performs `ra = SEXT(rb)` from the size specified by the class to `WLEN`.],

            [`ADD`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Addition*: Performs `ra = rb + rc`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`SUB`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Subtraction*: Performs `ra = rb - rc`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`MIN`], [], [3R.A], [`A`], [-], [*Minimum*: Performs `ra = MAX(rb, rc)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`MAX`], [], [3R.A], [`A`], [-], [*Maximum*: Performs `ra = MIN(rb, rc)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`AND`], [], [3R.A], [`A`], [-], [*Bitwise AND*: Performs `ra = rb & rc`. This instruction class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`OR`], [], [3R.A], [`A`], [-], [*Bitwise OR*: Performs `ra = rb | rc`. This instruction class specifies: `10` (`-`) and `11` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`XOR`], [], [3R.A], [`A`], [-], [*Bitwise XOR*: Performs `ra = rb ^ rc`. This instruction class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`IMP`], [], [3R.A], [`A`], [-], [*Bitwise IMP*: Performs `ra = !(!rb & rc)`. This instruction class specifies: `10` (`-`) and `11` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`LSH`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Left Shift*: Performs `ra = rb << rc`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`RSH`], [], [3R.A], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Right Shift*: Performs `ra = rb >> rc`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`SEQ`], [], [3R.A], [`A`], [-], [*Set If Equal*: Performs `if(rb == rc) ra = 1; else ra = 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`SLT`], [], [3R.A], [`A`], [-], [*Set If Less Than*: Performs `if(rb < rc) ra = 1; else ra = 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`SLE`], [], [3R.A], [`A`], [-], [*Set If Less Than Or Equal*: Performs `if(rb <= rc) ra = 1; else ra = 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`CMV`], [], [3R.A], [`A`], [-], [*Conditional Move*: Performs `if(check(rb)) ra = rc; else noop`. This instruction class specifies: `00` (`.EZ`) as _equal to zero_ mode, `01` (`.NZ`) _not equal to zero_ mode, `10` (`.LTZ`) _less than zero_ mode and `11` (`.LTZU`) _less than zero unsigned_ mode.],

            [`LDI`], [], [RI.A], [`D`], [-], [*Load Immediate*: Performs `ra = SEXT(imm)`.],

            [`HLDI`], [], [RI.A], [-], [-], [*High Load Immediate*: Performs `ra[WLEN:16] = SEXT(imm)` leaving the lower bits of `ra` unchanged.],

            [`ADDIHPC`], [], [RI.A], [-], [-], [*Add Immediate High To PC*: Performs `ra = PC + SEXT(imm << 16)`],

            [`ADDI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Addition Immediate*: Performs `ra = rb + EXT(imm)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`SUBI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Subtraction Immediate*: Performs `ra = rb - EXT(imm)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`MINI`], [], [2RI.A], [`A`], [-], [*Minimum Immediate*: Performs `ra = MIN(rb, EXT(imm))`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`MAXI`], [], [2RI.A], [`A`], [-], [*Maximum Immediate*: Performs `ra = MAX(rb, EXT(imm))`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`ANDI`], [], [2RI.A], [`A`], [-], [*Bitwise AND Immediate*: Performs `ra = rb & EXT(imm)`. This instruction class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`ORI`], [], [2RI.A], [`A`], [-], [*Bitwise OR Immediate*: Performs `ra = rb | EXT(imm)`. This instruction class specifies: `10` (`-`) and `11` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`XORI`], [], [2RI.A], [`A`], [-], [*Bitwise XOR Immediate*: Performs `ra = rb ^ EXT(imm)`. This instruction class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`IMPI`], [], [2RI.A], [`A`], [-], [*Bitwise IMP Immediate*: Performs `ra = !(!rb & EXT(imm))`. This instruction class specifies: `10` (`-`) and `11` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`LSHI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Left Shift Immediate*: Performs `ra = rb << imm`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`RSHI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Right Shift Immediate*: Performs `ra = rb >> imm`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`SEQI`], [], [2RI.A], [`A`], [-], [*Set If Equal Immediate*: Performs `if(rb == EXT(imm)) ra = 1; else ra = 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition. The immediate will be sign or zero extended according to the specified mode.],

            [`SLTI`], [], [2RI.A], [`A`], [-], [*Set If Less Than Immediate*: Performs `if(rb < EXT(imm)) ra = 1; else ra = 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition. The immediate will be sign or zero extended according to the specified mode.],

            [`SLEI`], [], [2RI.A], [`A`], [-], [*Set If Less Than Or Equal Immediate*: Performs `if(rb <= EXT(imm)) ra = 1; else ra = 0`. This instruction class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition. The immediate will be sign or zero extended according to the specified mode.],

            [`CLDI`], [], [2RI.A], [`A`], [-], [*Conditional Load Immediate*: Performs `if(check(rb)) ra = EXT(imm); else noop`. This instruction class specifies: `00` (`.EZ`) as _equal to zero_ mode, `01` (`.NZ`) _not equal to zero_ mode, `10` (`.LTZ`) _less than zero_ mode and `11` (`.LTZU`) _less than zero unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.]
        ))

        // ADD,SUB: should have same opcode
        // MIN,MAX: should have same opcode
        // AND, OR: should have same opcode
        // XOR, IMP: should have same opcode
        // LSH,RSH: should have same opcode
        // ADDI,SUBI: should have same opcode
        // MINI,MAXI: should have same opcode
        // LSHI,RSHI: should have same opcode
        // ANDI, ORI: should have same opcode
        // XORI, IMPI: should have same opcode
    ),

    subSection(

        [Computational Integer Scalar Advanced (`CISA`)],

        [This module provides integer scalar instructions to perform more complex arithmetic and logical operations with registers or immediate values. The `SGPRB` is mandatory for this module.],

        tableWrapper([CISA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

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

            [`MIX`], [], [4R.A], [`A`], [-], [*Mix*: Performs `ra = MIX(rb, rc, rd)`, that is, choses and moves bytes from `rb` and `rc` according to the select and index bits of `rd`. Must always have a class mode value of `01`.],

            [`MULI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Multiplication Immediate*: Performs `ra = rb * EXT(imm)` only keeping the least significant `WLEN` bits of the result. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`HMULI`], [], [2RI.A], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*High Multiplication Immediate*: Performs `ra = rb * EXT(imm)` only keeping the most significant `WLEN` bits of the result. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`DIVI`], [], [2RI.A], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Division Immediate*: Performs `ra = FLOOR(rb / EXT(imm))`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

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

            [`CLMULI`], [], [2RI.A], [-], [-], [*Carryless Multiplication Immediate*: Performs `ra = rb * imm` discarding the carries at each step. The immediate is always zero extended.],

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

        // CZ,CLZ,CTZ: should have same opcode
        // CO,CLO,CTO: should have same opcode
        // MUL,HMUL: should have same opcode
        // DIV,REM: should have same opcode
        // LRT,RRT,BSW,BRV: should have same opcode
        // PER, MIX: should have same opcode
        // MULI,HMULI: should have same opcode
        // DIVI,REMI: should have same opcode
        // LRTI,RRTI,BSWI,BRVI: should have same opcode
    ),

    subSection(

        // BADD, BSUB: same opcode
        // BDIV, BREM: ^^
        // BLSH, BRSH: ^^

        [Computational Integer Scalar Multiword (`CISM`)],

        [This module provides integer scalar instructions to perform arithmetic and logical operations with registers or immediate values with additional operands to allow chaining. The `SGPRB` is mandatory for this module.],

        tableWrapper([CISM Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`BADD`], [], [4.RA], [`A`], [-], [*Big Addition*: Performs `ra = rb + rc + rd; rd = carry_out`. Must always have a class mode value of `00`.],

            [`BSUB`], [], [4.RA], [`A`], [-], [*Big Subtraction*: Performs `ra = rb - rc - rd; rd = carry_out`. Must always have a class mode value of `01`.],

            [`BMUL`], [], [4.RA], [ - ], [-], [*Big Multiplication*: ],
            [`BDIV`], [], [4.RA], [`A`], [-], [*Big Division*: ],
            [`BREM`], [], [4.RA], [`A`], [-], [*Big Remainder*: ],

            [`BLSH`], [], [4.RA], [`A`], [-], [*Big Left Shift*: Performs `ra = rb << rc (rd); rd = shifted_out`. This instruction shifts in bits from `rd` instead of zeros. Must always have a class mode value of `00`.],

            [`BRSH`], [], [4.RA], [`A`], [-], [*Big Right Shift*: Performs `ra = rb >> rc (rd); rd = shifted_out`. This instruction shifts in bits from `rd` instead of zeros. Must always have a class mode value of `01`.]
        ))
    ),

    subSection(

        [Computational Integer Vector Basic (`CIVB`)],

        [This module provides integer vector instructions to perform basic arithmetic and logical operations with registers or immediate values in a data-parallel manner. The `VGPRB` is mandatory for this module.],

        tableWrapper([CIVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`VABS`], [], [3R.A], [`E`], [-], [*Vector Absolute Value*: Performs `va = MASK(ABS(vc), vb)`.],

            [`VADD`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Addition*: Performs `va = MASK(vc + vd, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VSUB`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Subtraction*: Performs `va = MASK(vc - vd, vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`VMIN`], [], [4R.B], [`A`], [-], [*Vector Minimum*: Performs `va = MASK(MAX(vc, vd), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VMAX`], [], [4R.B], [`A`], [-], [*Vector Maximum*: Performs `va = MASK(MIN(vc, vd), vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`VAND`], [], [4R.B], [`A`], [-], [*Vector Bitwise AND*: Performs `va = MASK(vc & vd, vb)`. This instruction class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`VOR`], [], [4R.B], [`A`], [-], [*Vector Bitwise OR*: Performs `va = MASK(vc | vd, vb)`. This instruction class specifies: `10` (`-`) and `11` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`VXOR`], [], [4R.B], [`A`], [-], [*Vector Bitwise XOR*: Performs `va = MASK(vc ^ vd, vb)`. This instruction class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`VIMP`], [], [4R.B], [`A`], [-], [*Vector Bitwise IMP*: Performs `va = MASK(!(!vc & vd), vb)`. This instruction class specifies: `10` (`-`) and `11` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`VLSH`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Left Shift*: Performs `va = MASK(vc << vd, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VRSH`], [], [4R.B], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Vector Right Shift*: Performs `va = MASK(vc >> vd, vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`VLDI`], [], [2RI.B], [`E`], [-], [*Vector Load Immediate*: Performs `va = MASK(SEXT(imm), vb)`. This instruction broadcasts the immediate to all the configured vector elements.],

            [`VHLDI`], [], [2RI.B], [`E`], [-], [*Vector High Load Immediate*: Performs `va[WLEN:16] = MASK(SEXT(imm), vb)` leaving the lower bits of `va` unchanged. This instruction broadcasts the immediate to all the configured vector elements.],

            [`VADDI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Addition Immediate*: Performs `va = MASK(vc + EXT(imm), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`VSUBI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Subtraction Immediate*: Performs `va = MASK(vc - EXT(imm), vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`VMINI`], [], [3RI.B], [`A`], [-], [*Vector Minimum Immediate*: Performs `va = MASK(MIN(vc, EXT(imm)), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`VMAXI`], [], [3RI.B], [`A`], [-], [*Vector Maximum Immediate*: Performs `va = MASK(MAX(vc, EXT(imm)), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`VANDI`], [], [3RI.B], [`A`], [-], [*Vector Bitwise AND Immediate*: Performs `va = MASK(vc & EXT(imm), vb)`. This instruction class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`VORI`], [], [3RI.B], [`A`], [-], [*Vector Bitwise OR Immediate*: Performs `va = MASK(vc | EXT(imm), vb)`. This instruction class specifies: `10` (`-`) and `11` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`VXORI`], [], [3RI.B], [`A`], [-], [*Vector Bitwise XOR Immediate*: Performs `va = MASK(vc ^ EXT(imm), vb)`. This instruction class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`VIMPI`], [], [3RI.B], [`A`], [-], [*Vector Bitwise IMP Immediate*: Performs `va = MASK(!(!vc & EXT(imm)), vb)`. This instruction class specifies: `10` (`-`) and `11` (`.I`) as _inverted_ mode, which simply inverts the result. The immediate will be sign or zero extended according to the specified mode.],

            [`VLSHI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Left Shift Immediate*: Performs `va = MASK(vc << imm, vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`VRSHI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn`, `CUND` in `.S` mode \ `CUND` in `.U` mode], [*Vector Right Shift Immediate*: Performs `va = MASK(vc >> imm, vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.]
        ))

        // VADD,VSUB: should have same opcode
        // VMIN,VMAX: should have same opcode
        // VAND, VOR: should have same opcode
        // VXOR, VIMP: should have same opcode
        // VLSH,VRSH: should have same opcode
        // VADDI,VSUBI: should have same opcode
        // VMINI,VMAXI: should have same opcode
        // VLSHI,VRSHI: should have same opcode
        // VANDI, VORI: should have same opcode
        // VXORI, VIMPI: should have same opcode
    ),

    subSection(

        [Computational Integer Vector Advanced (`CIVA`)],

        [This module provides integer vector instructions to perform more complex arithmetic and logical operations with registers or immediate values in a data-parallel manner. The `SGPR` and `VGPRB` are mandatory for this module.],

        tableWrapper([CIVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],          

            [`VCZ`], [], [3R.A], [`E`], [-], [*Vector Count Zeros*: Performs `va = MASK(CZ(vc), vb)`, that is, the total number of zero bits in `vc`. Must always have a class mode value of `00`.],

            [`VCLZ`], [], [3R.A], [`E`], [-], [*Vector Count Leading Zeros*: Performs `va = MASK(CLZ(vc), vb)`, that is, the total number of leading zero bits in `vc`. Must always have a class mode value of `01`.],

            [`VCTZ`], [], [3R.A], [`E`], [-], [*Vector Count Trailing Zeros*: Performs `va = MASK(CTZ(vc), vb)`, that is, the total number of trailing zero bits in `vc`. Must always have a class mode value of `10`.],

            [`VCO`], [], [3R.A], [`E`], [-], [*Vector Count Ones*: Performs `va = MASK(CO(vc), vb)`, that is, the total number of one bits in `vc`. Must always have a class mode value of `00`.],

            [`VCLO`], [], [3R.A], [`E`], [-], [*Vector Count Leading Ones*: Performs `ra = MASK(CLO(vc), vb)`, that is, the total number of leading one bits in `vc`. Must always have a class mode value of `01`.],

            [`VCTO`], [], [3R.A], [`E`], [-], [*Vector Count Trailing Ones*: Performs `ra = MASK(CTO(vc), vb)`, that is, the total number of trailing one bits in `vc`. Must always have a class mode value of `10`.],

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

                    [`.MA`: `va = MASK(va + (vc * vc), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * vd), vb)`],
                    [`.MS`: `va = MASK(va - (vc * vd), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * vd), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result.],

            [`VMACU`], [], [4R.B], [`G`], [`COVRn`], [*Vector Multiply Accumulate Unsigned*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * vc), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * vd), vb)`],
                    [`.MS`: `va = MASK(va - (vc * vd), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * vd), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result and all of the steps performed are unsigned.],

            [`VPER`], [], [4R.B], [`A`], [-], [*Vector Permute*: Performs `va = MASK(PER(vc, vd), vb)`, that is, moves groups of four bits from `vc` according to the index specified in `vd`. Must always have a class mode value of `00`.],

            [`VMIX`], [], [4R.B], [`A`], [-], [*Mix*: Performs `va = MIX(vb, vc, vd)`, that is, choses and moves bytes from `vb` and `vc` according to the select and index bits of `vd`. Must always have a class mode value of `01`.],

            [`VEXTR`], [], [2R.A], [`B`], [-], [*Vector Extract*: Performs `ra = vb[imm]` ignoring any vector shape configuration. The element and size are dictated by `imm` and the class mode respectively.],

            [`VINJ`], [], [2R.A], [`B`], [-], [*Vector Inject*: Performs `va[imm] = rb` ignoring any vector shape configuration. The element and size are dictated by `imm` and the class mode respectively.],

            [`VMULI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector Multiplication Immediate*: Performs `va = MASK(vc * EXT(imm), vb)` only keeping the least significant half of the result. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode and is always broadcasted to all the vector elements.],

            [`VHMULI`], [], [3RI.B], [`A`], [`OVFLn`, `UNFLn` in `.S` mode \ `COVRn` in `.U` mode], [*Vector High Multiplication Immediate*: Performs `va = MASK(vc * EXT(imm), vb)` only keeping the most significant half of the result. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode and is always broadcasted to all the vector elements.],

            [`VDIVI`], [], [3RI.B], [`A`], [`DIV0`, `INVOP`, `CUND`], [*Vector Division Immediate*: Performs `va = MASK(FLOOR(vc / EXT(imm)), vb)`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode and is always broadcasted to all the vector elements.],

            [`VREMI`], [], [3RI.B], [`A`], [`DIV0`, `INVOP`], [*Vector Remainder Immediate*: Performs `va = MASK(vc % EXT(imm), vb)`. This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. In signed mode, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )

            The immediate will be sign or zero extended according to the specified mode and is always broadcasted to all the vector elements.],

            [`VLRTI`], [], [3RI.B], [`A`], [-], [*Left Rotate Immediate*: Performs `va = MASK(LRT(vc, imm), vb)`. The immediate is always broadcasted to all the vector elements. This instruction Must always have a class mode value of `00`.],

            [`VRRTI`], [], [3RI.B], [`A`], [-], [*Right Rotate Immediate*: Performs `va = MASK(RRT(vc, imm), vb)`. The immediate is always broadcasted to all the vector elements. This instruction Must always have a class mode value of `01`.],

            [`VBSWI`], [], [3RI.B], [`A`], [-], [*Bit Swap Immediate*: Performs `va = MASK(BSW(vc, imm), vb)`, that is, swap the position of two ajacent groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. The immediate is always broadcasted to all the vector elements. This instruction Must always have a class mode value of `10`.],
        
            [`VBRVI`], [], [3RI.B], [`A`], [-], [*Vector Bit Reverse Immediate*:  Performs `va = MASK(BRV(vc, imm), vb)`, that is, reverse the endianess of groups of bits. This instruction only modifies the least significant sixteen bits and the group size is determined by `imm` and follows powers of two. The immediate is always broadcasted to all the vector elements. This instruction Must always have a class mode value of `11`.],

            [`VCLMULI`], [], [3RI.B], [-], [-], [*Vector Carryless Multiplication Immediate*: Performs `va = MASK(vc * imm, vb)` discarding the carries at each step. The immediate is always zero extended and is always broadcasted to all the vector elements.],

            [`VMACI`], [], [3RI.B], [`G`], [`OVFLn`, `UNFLn`, `COVRn`], [*Vector Multiply Accumulate Immediate*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * SEXT(imm)), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * SEXT(imm)), vb)`],
                    [`.MS`: `va = MASK(va - (vc * SEXT(imm)), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * SEXT(imm)), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result and the immediate is always broadcasted to all the vector elements..],

            [`VMACUI`], [], [3RI.B], [`G`], [`COVRn`], [*Vector Multiply Accumulate Unsigned Immediate*: Performs one of the following depending on the class mode:
            
                #list(tight: true,

                    [`.MA`: `va = MASK(va + (vc * imm), vb)`],
                    [`.NMA`: `va = MASK((-va) + (vc * imm), vb)`],
                    [`.MS`: `va = MASK(va - (vc * imm), vb)`],
                    [`.NMS`: `va = MASK((-va) - (vc * imm), vb)`]
                )

            The multiplication part of the operation only considers the least significant half of the result, all of the steps performed are unsigned and the immediate is always zero extended and broadcasted to all the vector elements.],

            [`VPCKUPCK`], [], [2RI.B], [-], [-], [*Vector Pack Unpack*: Performs `va = PCKUPCK(vb, imm)`, that is, packs or unpacks `vb` with the current vector shape to the one specified in the `imm`. An example of the transformation would be: `000a 000b 000c 000d <=> 000000000000abcd`.]
        ))
    ),

    subSection(

        [Computational Integer Vector Reductions (`CIVR`)],

        [This module provides integer vector instructions to perform arithmetic and logical reductions operations on registers values in a data-parallel manner. The `SGPRB` and `VGPRB` are mandatory for this module.],

        tableWrapper([CIVR Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

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

    subSection(

        [Computational Integer Compressed (`CIC`)],

        [This module provides integer compressed instructions to perform arithmetic and logical operations on registers and immediate values with a smaller code footprint. The `SGPRB` is mandatory for this module.],

        tableWrapper([CIC Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

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

    subSection(

        [Computational FP Scalar Basic (`CFSB`)],

        [This module provides floating point instructions to perform arithmetic operations on registers and immediate values. The `SGPRB` is mandatory for this module.],

        tableWrapper([CFSB Instructions.], table(

            columns: (auto, auto, auto, auto, auto, auto),
            align: (x, y) => (left+horizon, center+horizon, center+horizon, center+horizon, left+horizon, left+horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Flags*])], [#middle([*Description*])],

            [`CFI`], [], [2R.A], [`B`], [-], [*Cast FP To Integer*: Performs `ra = FP_TO_INT(rb)`, that is, convert `rb` to the closest integer dictated by the rounding mode and place the result in `ra`. The length modifier is applied to all operands.],

            [`CFIT`], [], [2R.A], [`B`], [-], [*Cast FP To Integer Truncated*: Performs `ra = TRUNC(rb)`, that is, truncate `rb` and place the result in `ra`. The length modifier is applied to all operands.],

            [`CIF`], [], [2R.A], [`B`], [-], [*Cast Integer To FP*: Perform `ra = INT_TO_FP(rb)`, that is, convert `rb` into floating point notation and place the result into `ra`. The length modifier is applied to all operands.],

            [`CFF1`], [], [2R.A], [`B`], [???], [*Cast FP To FP1*: Perform `ra = CAST(rb)`, that is, cast `rb` to a one byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF2`], [], [2R.A], [`B`], [???], [*Cast FP To FP2*: Perform `ra = CAST(rb)`, that is, cast `rb` to a two byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF4`], [], [2R.A], [`B`], [???], [*Cast FP To FP4*: Perform `ra = CAST(rb)`, that is, cast `rb` to a four byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`CFF8`], [], [2R.A], [`B`], [???], [*Cast FP To FP8*: Perform `ra = CAST(rb)`, that is, cast `rb` to a eight byte sized floating point number and place the result in `ra`. The length modifier is applied on `rb`.],

            [`FADD`], [], [3R.A], [`B`], [???], [*FP Addition*: Perform `ra = rb + rc`. The length modifier is applied to all operands.],

            [`FSUB`], [], [3R.A], [`B`], [???], [*FP Subtraction*: Perform `ra = rb - rc`. The length modifier is applied to all operands.],

            [`FMUL`], [], [3R.A], [`B`], [???], [*FP Multiplication*: Perform `ra = rb * rc`. The length modifier is applied to all operands.],

            [`FDIV`], [], [3R.A], [`B`], [???], [*FP Division*: Perform `ra = rb / rc`. The length modifier is applied to all operands.],

            [`FMIN`], [], [3R.A], [`B`], [???], [*FP Minimum*: Perform `ra = MIN(rb, rc)`. The length modifier is applied to all operands.],

            [`FMAX`], [], [3R.A], [`B`], [???], [*FP Maximum*: Perform `ra = MAX(rb, rc)`. The length modifier is applied to all operands.],

            [`FSLT`], [], [3R.A], [`B`], [], [*FP Set If Less Than*],
            [`FSLE`], [], [3R.A], [`B`], [], [*FP Set If Less Or Equal*],
            [`FMADD`], [], [4R.A], [`B`], [], [*FP Multiply Add*],
            [`FNMADD`], [], [4R.A], [`B`], [], [*FP Negative Multiply Add*],
            [`FMSUB`], [], [4R.A], [`B`], [], [*FP Multiply Subtract*],
            [`FNMSUB`], [], [4R.A], [`B`], [], [*FP Negative Multiply Subtract*],
            [`FADDI`], [], [2RI.A], [`B`], [], [*FP Addition Immediate*],
            [`FSUBI`], [], [2RI.A], [`B`], [], [*FP Subtraction Immediate*],
            [`FMULI`], [], [2RI.A], [`B`], [], [*FP Multiplication Immediate*],
            [`FDIVI`], [], [2RI.A], [`B`], [], [*FP Division Immediate*],
            [`FMINI`], [], [2RI.A], [`B`], [], [*FP Minimum Immediate*],
            [`FMAXI`], [], [2RI.A], [`B`], [], [*FP Maximum Immediate*],
            [`FSLTI`], [], [2RI.A], [`B`], [], [*FP Set If Less Than Immediate*],
            [`FSLEI`], [], [2RI.A], [`B`], [], [*FP Set If Less Or Equal Immediate*],
            [`FMADDI`], [], [3RI.A], [`B`], [], [*FP Multiply Add Immediate*],
            [`FNMADDI`], [], [3RI.A], [`B`], [], [*FP Negative Multiply Add Immediate*],
            [`FMSUBI`], [], [3RI.A], [`B`], [], [*FP Multiply Subtract Immediate*],
            [`FNMSUBI`], [], [3RI.A], [`B`], [], [*FP Negative Multiply Subtract Immediate*]
        ))
    )
))

///
