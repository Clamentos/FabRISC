///
#import "Macros.typ": *

///
#section(

    [Instruction List (WORK IN PROGRESS) ],

    [This section is dedicated to provide the full and extensive list of all the proposed instructions in the ISA divided into their corresponding module.],

    [Systems that don't support certain modules must generate the `INCI` fault whenever an unimplemented or incompatible instruction is fetched or attempted to be processed in any other way. The `ILLI` fault whenever a combination of all zeros, all ones or an otherwise illegal combination is fetched in order to increase safety against buffer overflows exploits or accidental accesses of uninitialized memory locations.],

    [As mentioned in previous sections, since some instructions can generate flags, they are not stored in any sort of flag register and they can be ignored unless the `EXC`, `HLPR` or both modules are implemented.],

    [Unused bits, designated with "-" or "x", must have a value of zero by default for convention.],
)

    ///.
    #subSection(

        [Computational Integer Scalar Basic (`CISB`)],

        [This module provides simple integer scalar instructions to perform a variety of arithmetic and logical operations with registers or immediate values. The `SGPRB` is mandatory for this module.],

        // ADD,SUB: should have same opcode
        // MIN,MAX: should have same opcode
        // LSH,RSH: should have same opcode
        // ADDI,SUBI: should have same opcode
        // MINI,MAXI: should have same opcode
        // LSHI,RSHI: should have same opcode

        tableWrapper([CISB instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`ABS`], [], [2R.A], [-], [*Absolute Value*: Computes the absolute value of `rb` placing the result into `ra`. This instruction doesn't raise any flags.],

            [`EXT`], [], [2R.A], [`B`], [*Sign Extend*: Computes the sign extension of `rb`, at the length specified in the class, placing the result into `ra`. This instruction doesn't raise any flags.],

            [`ADD`], [], [3R.A], [`A`], [*Addition*: Computes the sum of `rb` and `rc` placing the result into `ra`. This instruction class specifies: `00` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `01` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag.],

            [`SUB`], [], [3R.A], [`A`], [*Subtraction*: Computes the difference of `rb` and `rc` placing the result into `ra`. This instruction class specifies: `10` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `11` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag.],

            [`MIN`], [], [3R.A], [`A`], [*Minimum*: Computes the minimum of `rb` and `rc` placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode.],

            [`MAX`], [], [3R.A], [`A`], [*Maximum*: Computes the maximum of `rb` and `rc` placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode.],

            [`AND`], [], [3R.A], [`A`], [*Bitwise AND*: Computes the bitwise logical AND of `rb` and `rc` placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`OR`], [], [3R.A], [`A`], [*Bitwise OR*: Computes the bitwise logical OR of `rb` and `rc` placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`XOR`], [], [3R.A], [`A`], [*Bitwise XOR*: Computes the bitwise logical XOR of `rb` and `rc` placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `00` (`-`) and `01` (`.I`) as _inverted_ mode, which simply inverts the result.],

            [`LSH`], [], [3R.A], [`A`], [*Left Shift*: Computes the left shift of `rb` by the amount specified in `rc` placing the result into `ra`. This instruction class specifies: `00` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `01` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag.],

            [`RSH`], [], [3R.A], [`A`], [*Right Shift*: Computes the right shift of `rb` by the amount specified in `rc` placing the result into `ra`. This instruction class specifies: `10` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `11` (`.U`) as _unsigned_ mode which can raise the `CUND` flag.],

            [`SEQ`], [], [3R.A], [`A`], [*Set If Equal*: Sets `ra` to 1 or 0 depending on if `rb` and `rc` are equal or not. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`SLT`], [], [3R.A], [`A`], [*Set If Less Than*: Sets `ra` to 1 or 0 depending on if `rb` is less than `rc` or not. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`SLE`], [], [3R.A], [`A`], [*Set If Less Or Equal*: Sets `ra` to 1 or 0 depending on if `rb` is less than or equal to `rc` or not. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`CMV`], [], [3R.A], [`A`], [*Conditional Move*: Sets `ra` to the value of `rb` if `rc` matches the condition specified in the class, leaving `ra` unchanged otherwise. This instruction doesn't raise any flags and its class specifies: `00` (`.EZ`) as _equal to zero_ mode, `01` (`.NZ`) _not equal to zero_ mode, `10` (`.LTZ`) _less than zero_ mode and `11` (`.LTZU`) _less than zero unsigned_ mode.],

            [`LDI`], [], [RI.A], [`D`], [*Load Immediate*: Sets `ra` to the sign-extended immediate value. This instruction doesn't raise any flags.],

            [`HLDI`], [], [RI.A], [`D`], [*High Load Immediate*: Sets the upper `WLEN:16` bits of `ra` to the sign-extended immediate value leaving the lower 16 bits unchanged. This instruction doesn't raise any flags.],

            [`ADDIHPC`], [], [RI.A], [`D`], [*Add Immediate High To PC*: Computes the sum of the `PC` with the sign-extended and right-shifted by 16 places immediate value placing the result into `ra`. This instruction doesn't raise any flags.],

            [`ADDI`], [], [2RI.A], [`A`], [*Addition Immediate*: Computes the sum of `rb` and the immediate value placing the result into `ra`. This instruction class specifies: `00` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `01` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag. The immediate will be sign or zero extended according to the specified mode.],

            [`SUBI`], [], [2RI.A], [`A`], [*Subtraction Immediate*: Computes the difference of `rb` and the immediate value placing the result into `ra`. This instruction class specifies: `10` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `11` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag. The immediate will be sign or zero extended according to the specified mode.],

            [`MINI`], [], [2RI.A], [`A`], [*Minimum Immediate*: Computes the minimum of `rb` and the immediate value placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`MAXI`], [], [2RI.A], [`A`], [*Maximum Immediate*: Computes the maximum of `rb` and the immediate value placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode. The immediate will be sign or zero extended according to the specified mode.],

            [`ANDI`], [], [2RI.A], [`A`], [*Bitwise AND Immediate*: Computes the bitwise logical AND of `rb` and immediate value placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) _signed_ mode which sign-extends the immediate, `01` (`.U`) _unsigned_ mode which doesn't sign-extend the immediate, `10` (`.IS`) _inverted signed_ mode which inverts the result and sign-extends the immediate and `11` (`.IU`) _inverted unsigned_ which simply inverts the result.],

            [`ORI`], [], [2RI.A], [`A`], [*Bitwise OR Immediate*: Computes the bitwise logical OR of `rb` and the immediate value placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) _signed_ mode which sign-extends the immediate, `01` (`.U`) _unsigned_ mode which doesn't sign-extend the immediate, `10` (`.IS`) _inverted signed_ mode which inverts the result and sign-extends the immediate and `11` (`.IU`) _inverted unsigned_ which simply inverts the result.],

            [`XORI`], [], [2RI.A], [`A`], [*Bitwise XOR Immediate*: Computes the bitwise logical XOR of `rb` and the immediate value placing the result into `ra`. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) _signed_ mode which sign-extends the immediate, `01` (`.U`) _unsigned_ mode which doesn't sign-extend the immediate, `10` (`.IS`) _inverted signed_ mode which inverts the result and sign-extends the immediate and `11` (`.IU`) _inverted unsigned_ which simply inverts the result.],

            [`LSHI`], [], [2RI.A], [`A`], [*Left Shift Immediate*: Computes the left shift of `rb` by the amount specified by the immediate value placing the result into `ra`. This instruction class specifies: `00` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `01` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag.],

            [`RSHI`], [], [2RI.A], [`A`], [*Right Shift Immediate*: Computes the right shift of `rb` by the amount specified by the immediate value placing the result into `ra`. This instruction class specifies: `10` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `11` (`.U`) as _unsigned_ mode which can raise the `CUND` flag.],

            [`SEQI`], [], [2RI.A], [`A`], [*Set If Equal Immediate*: Sets `ra` to 1 or 0 depending on if `rb` and the sign-extended immediate value are equal or not. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`SLTI`], [], [2RI.A], [`A`], [*Set If Less Than Immediate*: Sets `ra` to 1 or 0 depending on if `rb` is less than the sign-extended immediate value or not. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`SLEI`], [], [2RI.A], [`A`], [*Set If Less Or Equal Immediate*: Sets `ra` to 1 or 0 depending on if `rb` is less than or equal to the sign-extended immediate value or not. This instruction doesn't raise any flags and its class specifies: `00` (`.S`) as _signed_ mode, `01` (`.U`) as _unsigned_ mode, `10` (`.IS`) as _inverted signed_ mode and `11` (`.IU`) as _inverted unsigned_ mode. The last two modes simply invert the checking condition.],

            [`CLDI`], [], [2RI.A], [`D`], [*Conditional Load Immediate*: Sets `ra` to the sign-extended immediate value if `rc` matches the condition specified in the class, leaving `ra` unchanged otherwise. This instruction doesn't raise any flags and its class specifies: `00` (`.EZ`) as _equal to zero_ mode, `01` (`.NZ`) _not equal to zero_ mode, `10` (`.LTZ`) _less than zero_ mode and `11` (`.LTZU`) _less than zero unsigned_ mode.]
        ))
    )

///.
    #subSection(

        [Computational Integer Scalar Advanced (`CISA`)], // TODO: complete

        [This module provides integer scalar instructions to perform more complex arithmetic and logical operations with registers or immediate values. The `SGPRB` is mandatory for this module.],

        // CZ,CLZ,CTZ: should have same opcode
        // CO,CLO,CTO: should have same opcode
        // MUL,HMUL: should have same opcode
        // DIV,REM: should have same opcode
        // LRT,RRT,BSW,BRV: should have same opcode
        // MULI,HMULI: should have same opcode
        // DIVI,REMI: should have same opcode
        // LRTI,RRTI,BSWI,BRVI: should have same opcode

        pagebreak(),
        tableWrapper([CISA Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`CZ`], [], [2R.A], [`A`], [*Count Zeros*: Computes the number of zero bits in `rb` placing the result into `ra`. This instruction doesn't raise any flags and must always have a class mode value of `00`.],

            [`CLZ`], [], [2R.A], [`A`], [*Count Leading Zeros*: Computes the number of leading zero bits in `rb` placing the result into `ra`. This instruction doesn't raise any flags and must always have a class mode value of `01`.],

            [`CTZ`], [], [2R.A], [`A`], [*Count Trailing Zeros*: Computes the number of trailing zero bits in `rb` placing the result into `ra`. This instruction doesn't raise any flags and must always have a class mode value of `10`.],

            [`CO`], [], [2R.A], [`A`], [*Count Ones*: Computes the number of one bits in `rb` placing the result into `ra`. This instruction doesn't raise any flags and must always have a class mode value of `00`.],

            [`CLO`], [], [2R.A], [`A`], [*Count Leading Ones*: Computes the number of leading one bits in `rb` placing the result into `ra`. This instruction doesn't raise any flags and must always have a class mode value of `01`.],

            [`CTO`], [], [2R.A], [`A`], [*Count Trailing Ones*: Computes the number of trailing one bits in `rb` placing the result into `ra`. This instruction doesn't raise any flags and must always have a class mode value of `10`.],

            [`MUL`], [], [3R.A], [`A`], [*Multiplication*: Computes the product of `rb` and `rc` placing the result in `ra`. This instruction only considers the least significant `WLEN` bits of the result. This instruction class specifies: `00` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `01` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag.],

            [`HMUL`], [], [3R.A], [`A`], [*High Multiplication*: Computes the product of `rb` and `rc` placing the result in `ra`. This instruction only considers the most significant `WLEN` bits of the result. This instruction class specifies: `10` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `11` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag.],

            [`DIV`], [], [3R.A], [`A`], [*Division*: Computes the quotient of `rb` by `rc` placing the result in `ra`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the `DIV0`, `INVOP` and `CUND` flags can be raised regardless of the class mode.],

            [`REM`], [], [3R.A], [`A`], [*Remainder*: Computes the remainder of `rb` by `rc` placing the result in `ra`. In signed modes, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )

            This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode and the `DIV0` and `INVOP`flags can be raised regardless of the class mode.],

            [`LRT`], [], [3R.A], [`A`], [*Left Rotate*: Computes the bitwise left rotation of `rb` by the amount specified in `rc` placing the result in `ra`. This instruction doesn't raise any flags and must always have a class mode value of `00`.],

            [`RRT`], [], [3R.A], [`A`], [*Right Rotate*: Computes the bitwise right rotation of `rb` by the amount specified in `rc` placing the result in `ra`. This instruction doesn't raise any flags and must always have a class mode value of `01`.],

            [`BSW`], [], [3R.A], [`A`], [*Bit Swap*],
            [`BRV`], [], [3R.A], [`A`], [*Bit Reverse*],

            [`CLMUL`], [], [3R.A], [-], [*Carryless Multiplication*],

            [`MAC`], [], [4R.A], [`G`], [*Multiply Accumulate*: Computes the dot product specified in the class mode:
            
                #list(tight: true,

                    [`.MA`: `ra = rb + (rc * rd)`],
                    [`.NMA`: `ra = (-rb) + (rc * rd)`],
                    [`.MS`: `ra = rb - (rc * rd)`],
                    [`.NMS`: `ra = (-rb) - (rc * rd)`]
                )

            The multiplication part only considers the least significant `WLEN` bits. This instruction can raise the `OVFLn`, `UNFLn` and `COVRn` flags regardless of the class mode.],

            [`MACU`], [], [4R.A], [`G`], [*Multiply Accumulate Unsigned*: Computes the dot product specified in the class mode:
            
                #list(tight: true,

                    [`.MA`: `ra = rb + (rc * rd)`],
                    [`.NMA`: `ra = (-rb) + (rc * rd)`],
                    [`.MS`: `ra = rb - (rc * rd)`],
                    [`.NMS`: `ra = (-rb) - (rc * rd)`]
                )

            The multiplication part only considers the least significant `WLEN` bits and all of the steps performed are unsigned. This instruction can raise the `COVRn` flag regardless of the class mode.],

            [`PER`], [], [4R.A], [`A`], [*Permute*],

            [`MULI`], [], [2RI.A], [`A`], [*Multiplication Immediate*: Computes the product of `rb` and the immediate value placing the result in `ra`. This instruction only considers the least significant `WLEN` bits of the result. This instruction class specifies: `00` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `01` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag. The immediate will be sign or zero extended according to the specified mode.],

            [`HMULI`], [], [2RI.A], [`A`], [*High Multiplication Immediate*: Computes the product of `rb` and the immediate value placing the result in `ra`. This instruction only considers the most significant `WLEN` bits of the result. This instruction class specifies: `10` (`.S`) as _signed_ mode which can raise the `OVFLn` or `UNFLn` flags and `11` (`.U`) as _unsigned_ mode which can raise the `COVRn` flag. The immediate will be sign or zero extended according to the specified mode.],

            [`DIVI`], [], [2RI.A], [`A`], [*Division Immediate*: Computes the quotient of `rb` by the immediate value placing the result in `ra`. This instruction class specifies: `00` (`.S`) as _signed_ mode and `01` (`.U`) as _unsigned_ mode and the `DIV0`, `INVOP` and `CUND` flags can be raised regardless of the class mode. The immediate will be sign or zero extended according to the specified mode.],

            [`REMI`], [], [2RI.A], [`A`], [*Remainder Immediate*: Computes the remainder of `rb` by the immediate value placing the result in `ra`. In signed modes, the instruction handles the signs in the following way:

                #list(tight: true,

                    [positive, positive: positive],
                    [negative, positive: negative],
                    [positive, negative: positive],
                    [negative, negative: negative]
                )

            This instruction class specifies: `10` (`.S`) as _signed_ mode and `11` (`.U`) as _unsigned_ mode and the `DIV0` and `INVOP`flags can be raised regardless of the class mode. The immediate will be sign or zero extended according to the specified mode.],

            [`LRTI`], [], [2RI.A], [`A`], [*Left Rotate Immediate*: Computes the bitwise left rotation of `rb` by the amount specified by the immediate value placing the result in `ra`. This instruction doesn't raise any flags and must always have a class mode value of `00`.],

            [`RRTI`], [], [2RI.A], [`A`], [*Right Rotate Immediate*: Computes the bitwise right rotation of `rb` by the amount specified by the immediate value placing the result in `ra`. This instruction doesn't raise any flags and must always have a class mode value of `01`.],

            [`BSWI`], [], [2RI.A], [`A`], [*Bit Swap Immediate*],
            [`BRVI`], [], [2RI.A], [`A`], [*Bit Reverse Immediate*],

            [`CLMULI`], [], [2RI.A], [`D`], [*Carryless Multiplication Immediate*],

            [`MACI`], [], [3RI.A], [`G`], [*Multiply Accumulate Immediate*: Computes the dot product specified in the class mode:
            
                #list(tight: true,

                    [`.MA`: `ra = rb + (rc * imm)`],
                    [`.NMA`: `ra = (-rb) + (rc * imm)`],
                    [`.MS`: `ra = rb - (rc * imm)`],
                    [`.NMS`: `ra = (-rb) - (rc * imm)`]
                )

            The multiplication part only considers the least significant `WLEN` bits and the immediate value is always sign-extended. This instruction can raise the `OVFLn`, `UNFLn` and `COVRn` flags regardless of the class mode.],

            [`MACIU`], [], [3RI.A], [`G`], [*Multiply Accumulate Immediate Unsigned*: Computes the dot product specified in the class mode:
            
                #list(tight: true,

                    [`.MA`: `ra = rb + (rc * imm)`],
                    [`.NMA`: `ra = (-rb) + (rc * imm)`],
                    [`.MS`: `ra = rb - (rc * imm)`],
                    [`.NMS`: `ra = (-rb) - (rc * imm)`]
                )

            The multiplication part only considers the least significant `WLEN` bits and, of the steps performed are unsigned and the immediate is always zero-extended. This instruction can raise the `COVRn` flag regardless of the class mode.],

            [`PERI`], [], [3RI.A], [`A`], [*Permute Immediate*]
        ))
    )

    ///.
    #subSection(

        [Computational Integer Scalar Multiword (`CISM`)],

        [This module provides integer scalar instructions to perform arithmetic and logical operations with registers or immediate values on values larger than `WLEN`. The `SGPRB` is mandatory for this module.],

        pagebreak(),
        tableWrapper([CISM Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`BADD`], [], [4.RA], [`A`], [*Big Addition*: ],
            [`BSUB`], [], [4.RA], [`A`], [*Big Subtraction*: ],
            [`BMUL`], [], [4.RA], [`A`], [*Big Multiplication*: ],
            [`BDIV`], [], [4.RA], [`A`], [*Big Division*: ],
            [`BREM`], [], [4.RA], [`A`], [*Big Remainder*: ],
            [`BLSH`], [], [4.RA], [`A`], [*Big Left Shift*: ],
            [`BRSH`], [], [4.RA], [`A`], [*Big Right Shift*: ]
        ))
    )

    ///.
    #subSection(

        [Computational Integer Vector Basic (`CIVB`)],

        [This module provides integer vector instructions to perform basic arithmetic and logical operations with registers or immediate values in a data-parallel manner. The `SGPRB` and `VGPRB` are mandatory for this module.],

        pagebreak(),
        tableWrapper([CIVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`VABS`], [], [3R.A], [`E`], [*Vector Absolute Value*: ],
            [`VADD`], [], [4R.B], [`A`], [*Vector Addition*: ],
            [`VSUB`], [], [4R.B], [`A`], [*Vector Subtraction*: ],
            [`VMIN`], [], [4R.B], [`A`], [*Vector Minimum*: ],
            [`VMAX`], [], [4R.B], [`A`], [*Vector Maximum*: ],
            [`VAND`], [], [4R.B], [`A`], [*Vector Bitwise AND*: ],
            [`VOR`], [], [4R.B], [`A`], [*Vector Bitwise OR*: ],
            [`VXOR`], [], [4R.B], [`A`], [*Vector Bitwise XOR*: ],
            [`VLSH`], [], [4R.B], [`A`], [*Vector Left Shift*: ],
            [`VRSH`], [], [4R.B], [`A`], [*Vector Right Shift*: ],
            [`VSEQ`], [], [4R.B], [`A`], [*Vector Set If Equal*: ],
            [`VSLT`], [], [4R.B], [`A`], [*Vector Set If Less Than*: ],
            [`VSLE`], [], [4R.B], [`A`], [*Vector Set If Less Or Equal*: ],
            [`VEXTR`], [], [4R.B], [`B`], [*Vector Extract*: ],
            [`VINJ`], [], [4R.B], [`B`], [*Vector Inject*: ],
            [`VADDI`], [], [3RI.B], [`A`], [*Vector Addition Immediate*: ],
            [`VSUBI`], [], [3RI.B], [`A`], [*Vector Subtraction Immediate*: ],
            [`VMINI`], [], [3RI.B], [`A`], [*Vector Minimum Immediate*: ],
            [`VMAXI`], [], [3RI.B], [`A`], [*Vector Maximum Immediate*: ],
            [`VANDI`], [], [3RI.B], [`A`], [*Vector Bitwise AND Immediate*: ],
            [`VORI`], [], [3RI.B], [`A`], [*Vector Bitwise OR Immediate*: ],
            [`VXORI`], [], [3RI.B], [`A`], [*Vector Bitwise XOR Immediate*: ],
            [`VLSHI`], [], [3RI.B], [`A`], [*Vector Left Shift Immediate*: ],
            [`VRSHI`], [], [3RI.B], [`A`], [*Vector Right Shift Immediate*: ],
            [`VSEQI`], [], [3RI.B], [`A`], [*Vector Set If Equal Immediate*: ],
            [`VSLTI`], [], [3RI.B], [`A`], [*Vector Set If Less Than Immediate*: ],
            [`VSLEI`], [], [3RI.B], [`A`], [*Vector Set If Less Or Equal Immediate*: ],
            [`VEXTRI`], [], [3RI.B], [`B`], [*Vector Extract Immediate*: ],
            [`VINJI`], [], [3RI.B], [`B`], [*Vector Inject Immediate*: ],
            [`VLDI`], [], [3RI.B], [`D`], [*Vector Load Immediate*: ]
        ))
    )

    ///.
    #subSection(

        [Computational Integer Vector Advanced (`CIVA`)],

        [This module provides integer vector instructions to perform more complex arithmetic and logical operations with registers or immediate values in a data-parallel manner. The `VGPRB` is mandatory for this module.],

        pagebreak(),
        tableWrapper([CIVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`VCZ`], [], [3R.A], [`E`], [*Vector Count Zeros*],
            [`VCLZ`], [], [3R.A], [`E`], [*Vector Count Leading Zeros*],
            [`VCTZ`], [], [3R.A], [`E`], [*Vector Count Trailing Zeros*],
            [`VCO`], [], [3R.A], [`E`], [*Vector Count Ones*],
            [`VCLO`], [], [3R.A], [`E`], [*Vector Count Leading Ones*],
            [`VCTO`], [], [3R.A], [`E`], [*Vector Count Trailing Ones*],
            [`VMUL`], [], [4R.B], [`A`], [*Vector Multiplication*],
            [`VHMUL`], [], [4R.B], [`A`], [*Vector High Multiplication*],
            [`VDIV`], [], [4R.B], [`A`], [*Vector Division*],
            [`VREM`], [], [4R.B], [`A`], [*Vector Remainder*],
            [`VLRT`], [], [4R.B], [`A`], [*Vector Left Rotate*],
            [`VRRT`], [], [4R.B], [`A`], [*Vector Right Rotate*],
            [`VBSW`], [], [4R.B], [`A`], [*Vector Bit Swap*],
            [`VBRV`], [], [4R.B], [`A`], [*Vector Bit Reverse*],
            [`VCMUL`], [], [4R.B], [`A`], [*Vector Carryless Multiplication*],
            [`VMAC`], [], [4R.B], [`G`], [*Vector Multiply Accumulate*],
            [`VMACU`], [], [4R.B], [`G`], [*Vector Multiply Accumulate Unsigned*],
            [`VPER`], [], [4R.B], [`A`], [*Vector Permute*],
            [`VMULI`], [], [3RI.B], [`A`], [*Vector Multiplication Immediate*],
            [`VHMULI`], [], [3RI.B], [`A`], [*Vector High Multiplication Immediate*],
            [`VDIVI`], [], [3RI.B], [`A`], [*Vector Division Immediate*],
            [`VREMI`], [], [3RI.B], [`A`], [*Vector Remainder Immediate*],
            [`VLRTI`], [], [3RI.B], [`A`], [*Vector Left Rotate Immediate*],
            [`VRRTI`], [], [3RI.B], [`A`], [*Vector Right Rotate Immediate*],
            [`VBSWI`], [], [3RI.B], [`A`], [*Vector Bit Swap Immediate*],
            [`VBRVI`], [], [3RI.B], [`A`], [*Vector Bit Reverse Immediate*],
            [`VCMULI`], [], [3RI.B], [`A`], [*Vector Carryless Multiplication Immediate*],
            [`VMACI`], [], [4R.B], [`G`], [*Vector Multiply Accumulate Immediate*],
            [`VMACIU`], [], [4R.B], [`G`], [*Vector Multiply Accumulate Immediate Unsigned*],
            [`VPERI`], [], [3RI.B], [`A`], [*Vector Permute Immediate*],
            [`VPCKUPCK`], [], [3RI.B], [`A`], [*Vector Pack Unpack*]
        ))
    )

    ///.
    #subSection(

        [Computational Integer Vector Reductions (`CIVR`)],

        [This module provides integer vector instructions to perform arithmetic and logical reductions operations on registers values in a data-parallel manner. The `SGPRB` and `VGPRB` are mandatory for this module.],

        pagebreak(),
        tableWrapper([CIVR Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`RADD`], [], [3R.A], [`A`], [*Reduced Addition*: ],
            [`RSUB`], [], [3R.A], [`A`], [*Reduced Subtraction*: ],
            [`RMIN`], [], [3R.A], [`A`], [*Reduced Minimum*: ],
            [`RMAX`], [], [3R.A], [`A`], [*Reduced Maximum*: ],
            [`RAND`], [], [3R.A], [`A`], [*Reduced Bitwise AND*: ],
            [`ROR`], [], [3R.A], [`A`], [*Reduced Bitwise OR*: ],
            [`RXOR`], [], [3R.A], [`A`], [*Reduced Bitwise XOR*: ]
        ))
    )

    ///.
    #subSection(

        [Computational Integer Compressed (`CIC`)],

        [This module provides integer compressed instructions to perform arithmetic and logical operations on registers and immediate values with a smaller code footprint. The `SGPRB` is mandatory for this module.],

        pagebreak(),
        tableWrapper([CIC Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`CADD`], [], [2R.B], [`F`], [*Compressed Addition*: ],
            [`CSUB`], [], [2R.B], [`F`], [*Compressed Subtraction*: ],
            [`CMOV`], [], [2R.B], [`F`], [*Compressed Move*: ],
            [`CAND`], [], [2R.B], [`F`], [*Compressed Bitwise AND*: ],
            [`CLSH`], [], [2R.B], [`F`], [*Compressed Left Shift*: ],
            [`CRSH`], [], [2R.B], [`F`], [*Compressed Right Shift*: ],
            [`CADDI`], [], [RI.B], [-], [*Compressed Addition Immediate*: ],
            [`CANDI`], [], [RI.B], [-], [*Compressed Bitwise AND Immediate*: ],
            [`CLSHI`], [], [RI.B], [-], [*Compressed Left Shift Immediate*: ],
            [`CRSHI`], [], [RI.B], [-], [*Compressed Right Shift Immediate*: ],
            [`CLDI`], [], [RI.B], [-], [*Compressed Load Immediate*: ]
        ))
    )

    ///.
    #subSection(

        [Computational FP Scalar Basic (`CFSB`)],

        [This module provides floating point instructions to perform arithmetic operations on registers and immediate values. The `SGPRB` is mandatory for this module.],

        pagebreak(),
        tableWrapper([CFSB Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`CFI`], [], [2R.A], [`B`], [*Cast FP To Integer*],
            [`CFIT`], [], [2R.A], [`B`], [*Cast FP To Integer Truncated*],
            [`CIF`], [], [2R.A], [`B`], [*Cast Integer To FP*],
            [`CFF1`], [], [2R.A], [`B`], [*Cast FP To FP1*],
            [`CFF2`], [], [2R.A], [`B`], [*Cast FP To FP2*],
            [`CFF4`], [], [2R.A], [`B`], [*Cast FP To FP4*],
            [`CFF8`], [], [2R.A], [`B`], [*Cast FP To FP8*],
            [`FADD`], [], [3R.A], [`B`], [*FP Addition*],
            [`FSUB`], [], [3R.A], [`B`], [*FP Subtraction*],
            [`FMUL`], [], [3R.A], [`B`], [*FP Multiplication*],
            [`FDIV`], [], [3R.A], [`B`], [*FP Division*],
            [`FMIN`], [], [3R.A], [`B`], [*FP Minimum*],
            [`FMAX`], [], [3R.A], [`B`], [*FP Maximum*],
            [`FSLT`], [], [3R.A], [`B`], [*FP Set If Less Than*],
            [`FSLE`], [], [3R.A], [`B`], [*FP Set If Less Or Equal*],
            [`FSGT`], [], [3R.A], [`B`], [*FP Set If Greater Than*],
            [`FSGE`], [], [3R.A], [`B`], [*FP Set If Greater Or Equal*],
            [`FMADD`], [], [4R.A], [`B`], [*FP Multiply Add*],
            [`FNMADD`], [], [4R.A], [`B`], [*FP Negative Multiply Add*],
            [`FMSUB`], [], [4R.A], [`B`], [*FP Multiply Subtract*],
            [`FNMSUB`], [], [4R.A], [`B`], [*FP Negative Multiply Subtract*],
            [`FADDI`], [], [2RI.A], [`B`], [*FP Addition Immediate*],
            [`FSUBI`], [], [2RI.A], [`B`], [*FP Subtraction Immediate*],
            [`FMULI`], [], [2RI.A], [`B`], [*FP Multiplication Immediate*],
            [`FDIVI`], [], [2RI.A], [`B`], [*FP Division Immediate*],
            [`FMINI`], [], [2RI.A], [`B`], [*FP Minimum Immediate*],
            [`FMAXI`], [], [2RI.A], [`B`], [*FP Maximum Immediate*],
            [`FSLTI`], [], [2RI.A], [`B`], [*FP Set If Less Than Immediate*],
            [`FSLEI`], [], [2RI.A], [`B`], [*FP Set If Less Or Equal Immediate*],
            [`FSGTI`], [], [2RI.A], [`B`], [*FP Set If Greater Than Immediate*],
            [`FSGEI`], [], [2RI.A], [`B`], [*FP Set If Greater Or Equal Immediate*],
            [`FMADDI`], [], [3RI.A], [`B`], [*FP Multiply Add Immediate*],
            [`FNMADDI`], [], [3RI.A], [`B`], [*FP Negative Multiply Add Immediate*],
            [`FMSUBI`], [], [3RI.A], [`B`], [*FP Multiply Subtract Immediate*],
            [`FNMSUBI`], [], [3RI.A], [`B`], [*FP Negative Multiply Subtract Immediate*]
        ))
    )

    ///.
    #subSection(

        [Computational FP Scalar Advanced (`CFSA`)],

        [This module provides floating point instructions to perform more complex arithmetic operations on registers. The `SGPRB` is mandatory for this module.],

        pagebreak(),
        tableWrapper([CFSA Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],
            [`FSQRT`], [], [2R.A], [`B`], [*FP Square Root*]
        ))
    )

    ///.
    #subSection(

        [Computational FP Vector Basic (`CFVB`)],

        [This module provides floating point vector instructions to perform basic arithmetic and logical operations with registers or immediate values in a data-parallel manner. The `SGPRB` and `VGPRB` are mandatory for this module.],

        pagebreak(),
        tableWrapper([CFVB Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`VCFI`], [], [3R.A], [`?`], [*Vector Cast FP. To Integer*],
            [`VCFIT`], [], [3R.A], [`?`], [*Vector Cast FP. To Integer Truncated*],
            [`VCIF`], [], [3R.A], [`?`], [*Vector Cast Integer To FP.*],
            [`VCFF1`], [], [3R.A], [`?`], [*Vector Cast FP. To FP. 1*],
            [`VCFF2`], [], [3R.A], [`?`], [*Vector Cast FP. To FP. 2*],
            [`VCFF4`], [], [3R.A], [`?`], [*Vector Cast FP. To FP. 4*],
            [`VCFF8`], [], [3R.A], [`?`], [*Vector Cast FP. To FP. 8*],
            [`VFADD`], [], [4R.B], [`?`], [*Vector FP. Addition*],
            [`VFSUB`], [], [4R.B], [`?`], [*Vector FP. Subtraction*],
            [`VFMUL`], [], [4R.B], [`?`], [*Vector FP. Multiplication*],
            [`VFDIV`], [], [4R.B], [`?`], [*Vector FP. Division*],
            [`VFMIN`], [], [4R.B], [`?`], [*Vector FP. Minimum*],
            [`VFMAX`], [], [4R.B], [`?`], [*Vector FP. Maximum*],
            [`VFSLT`], [], [4R.B], [`?`], [*Vector FP. Set If Less Than*],
            [`VFSLE`], [], [4R.B], [`?`], [*Vector FP. Set If Less Or Equal*],
            [`VFMAC`], [], [4R.B], [`?`], [*Vector FP. Multiply Accumulate*],
            [`VFADDI`], [], [3RI.B], [`?`], [*Vector FP. Addition Immediate*],
            [`VFSUBI`], [], [3RI.B], [`?`], [*Vector FP. Subtraction Immediate*],
            [`VFMULI`], [], [3RI.B], [`?`], [*Vector FP. Multiplication Immediate*],
            [`VFDIVI`], [], [3RI.B], [`?`], [*Vector FP. Division Immediate*],
            [`VFMINI`], [], [3RI.B], [`?`], [*Vector FP. Minimum Immediate*],
            [`VFMAXI`], [], [3RI.B], [`?`], [*Vector FP. Maximum Immediate*],
            [`VFSLTI`], [], [3RI.B], [`?`], [*Vector FP. Set If Less Than Immediate*],
            [`VFSLEI`], [], [3RI.B], [`?`], [*Vector FP. Set If Less Or Equal Immediate*],
            [`VFMACI`], [], [3RI.B], [`?`], [*Vector FP. Multiply Accumulate Immediate*]
        ))
    )

    ///.
    #subSection(

        [Computational FP Vector Advanced (`CFVA`)],

        [This module provides floating point vector instructions to perform more complex arithmetic and logical operations with registers values in a data-parallel manner. The `SGPRB` and `VGPRB` are mandatory for this module.],

        pagebreak(),
        tableWrapper([CFVA Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],
            [`VSQRT`], [], [3R.A], [`E`], [*Vector FP. Square Root*]
        ))
    )

    ///.
    #subSection(

        [Computational FP Vector Reductions (`CFVR`)],

        [This module provides integer vector instructions to perform arithmetic and logical reductions operations on registers values in a data-parallel manner. The `SGPRB` and `VGPRB` are mandatory for this module.],

        pagebreak(),
        tableWrapper([CFVR Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`RFADD`], [], [3R.A], [`E`], [*Reduced FP. Addition*],
            [`RFSUB`], [], [3R.A], [`E`], [*Reduced FP. Subtraction*],
            [`RFMUL`], [], [3R.A], [`E`], [*Reduced FP. Multiplication*],
            [`RFDIV`], [], [3R.A], [`E`], [*Reduced FP. Division*],
            [`RFMIN`], [], [3R.A], [`E`], [*Reduced FP. Minimum*],
            [`RFMAX`], [], [3R.A], [`E`], [*Reduced FP. Maximum*]
        ))
    )

    ///.
    #subSection(

        [Data Scalar Basic (`DSB`)],
        [This module provides basic scalar memory transfer operations. The `SGPRB` is mandatory for this module],

        pagebreak(),
        tableWrapper([DSB Instructions.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (left + horizon, center + horizon, center + horizon, center + horizon, left + horizon).at(x),

            [#middle([*Mnemonic*])], [#middle([*Opcode*])], [#middle([*Format*])], [#middle([*Class*])], [#middle([*Description*])],

            [`MLD`], [], [2RI.A], [`B`], [*Memory Load*],
            [`MLDU`], [], [2RI.A], [`B`], [*Memory Load Unsigned*],
            [`MST`], [], [2RI.A], [`B`], [*Memory Store*]
        ))
    )

#pagebreak()

///
