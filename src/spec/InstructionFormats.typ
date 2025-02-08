///
#import "Macros.typ": *
#import "@preview/tablex:0.0.9": tablex, colspanx, rowspanx

///
    #page(flipped: true, text(size: 10pt,

        [
            #text(18pt)[#heading(level: 1, [Instruction Formats])]
            #v(14pt)

            #par(text(size: 12pt, [FabRISC organizes the instructions in 14 different formats with lengths of 2, 4 and 6 bytes and opcode lengths ranging from 4 to 20 bits. Formats that specify the "md" field are also subdivided into "classes" at the instruction level. This is because the "md" field acts as an extra modifier, such as, extra immediate bits, data type selector  and more. The following is the complete list of all the formats:]))

            #align(right, ifmt(name: `2RI-B `,

                (bits: 16, color: rgb("#eaeaea"), label: align(center, [`im`\ `15`...`0`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`rb` \ `4`...`3`])),
                (bits: 5, color: rgb("#eaeaea"), label: align(center, [`im`\ `16`...`20`])),
                (bits: 11, color: rgb("#f1f1f1"), label: align(center, [`op` \ `14`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `3RI-A `,

                (bits: 16, color: rgb("#eaeaea"), label: align(center, [`im`\ `15`...`0`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`rb` \ `4`...`3`])),
                (bits: 5, color: rgb("#dadada"), label: align(center, [`rc` \ `4`...`0`])),
                (bits: 11, color: rgb("#f1f1f1"), label: align(center, [`op` \ `14`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `4R-B `,

                (bits: 4, color: white, label: align(center, [`vm` \ `5`...`2`])),
                (bits: 12, color: rgb("#f1f1f1"), label: align(center, [`op` \ `19`...`8`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`rb` \ `4`...`3`])),
                (bits: 5, color: rgb("#dadada"), label: align(center, [`rc` \ `4`...`0`])),
                (bits: 5, color: rgb("#dadada"), label: align(center, [`rd` \ `4`...`0`])),
                (bits: 2, color: white, label: align(center, [`vm` \ `1`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `7`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `3RI-B `,

                (bits: 16, color: rgb("#eaeaea"), label: align(center, [`im`\ `15`...`0`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`rb` \ `4`...`3`])),
                (bits: 5, color: rgb("#dadada"), label: align(center, [`rc` \ `4`...`0`])),
                (bits: 2, color: white, label: `vm`),
                (bits: 9, color: rgb("#f1f1f1"), label: align(center, [`op` \ `12`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `2R-A `,

                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`rb` \ `4`...`3`])),
                (bits: 16, color: rgb("#f1f1f1"), label: align(center, [`op` \ `19`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `3R-A `,

                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`rb` \ `4`...`3`])),
                (bits: 5, color: rgb("#dadada"), label: align(center, [`rc` \ `4`...`0`])),
                (bits: 11, color: rgb("#f1f1f1"), label: align(center, [`op` \ `14`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `4R-A `,

                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`rb` \ `4`...`3`])),
                (bits: 5, color: rgb("#dadada"), label: align(center, [`rc` \ `4`...`0`])),
                (bits: 5, color: rgb("#dadada"), label: align(center, [`rd` \ `4`...`0`])),
                (bits: 6, color: rgb("#f1f1f1"), label: align(center, [`op` \ `9`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `I-A `,

                (bits: 2, color: rgb("#eaeaea"), label: align(center, [`im`\ `20`...`19`])),
                (bits: 13, color: rgb("#eaeaea"), label: align(center, [`im`\ `12`...`0`])),
                (bits: 1, color: rgb("#eaeaea"), label: align(center, [`im`\ `18`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `7`...`4`])),
                (bits: 5, color: rgb("#eaeaea"), label: align(center, [`im`\ `17`...`13`])),
                (bits: 3, color: rgb("#eaeaea"), label: align(center, [`im`\ `23`...`21`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `RI-A `,

                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 13, color: rgb("#eaeaea"), label: align(center, [`im`\ `12`...`0`])),
                (bits: 5, color: rgb("#f1f1f1"), label: align(center, [`op` \ `8`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#eaeaea"), label: align(center, [`im`\ `15`...`13`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `2RI-A `,

                (bits: 2, color: rgb("#dadada"), label: align(center, [`ra` \ `4`...`3`])),
                (bits: 2, color: rgb("#dadada"), label: align(center, [`rb` \ `4`...`3`])),
                (bits: 11, color: rgb("#eaeaea"), label: align(center, [`im`\ `10`...`0`])),
                (bits: 1, color: rgb("#eaeaea"), label: align(center, [`im`\ `11`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `7`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `2R-B `,

                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `7`...`4`])),
                (bits: 2, color: white, label: `md`),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `I-B `,

                (bits: 2, color: rgb("#eaeaea"), label: align(center, [`im`\ `1`...`0`])),
                (bits: 2, color: rgb("#f1f1f1"), label: align(center, [`op` \ `5`...`4`])),
                (bits: 2, color: rgb("#eaeaea"), label: align(center, [`im`\ `3`...`2`])),
                (bits: 3, color: rgb("#eaeaea"), label: align(center, [`im`\ `6`...`4`])),
                (bits: 3, color: rgb("#eaeaea"), label: align(center, [`im`\ `9`...`7`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `RI-B `,

                (bits: 2, color: rgb("#eaeaea"), label: align(center, [`im`\ `1`...`0`])),
                (bits: 1, color: rgb("#eaeaea"), label: align(center, [`im`\ `7`])),
                (bits: 1, color: rgb("#f1f1f1"), label: align(center, [`op` \ `4`])),
                (bits: 2, color: rgb("#eaeaea"), label: align(center, [`im`\ `3`...`2`])),
                (bits: 3, color: rgb("#eaeaea"), label: align(center, [`im`\ `6`...`4`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))

            #align(right, ifmt(name: `2RI-C `,

                (bits: 2, color: rgb("#eaeaea"), label: align(center, [`im`\ `1`...`0`])),
                (bits: 4, color: rgb("#eaeaea"), label: align(center, [`im`\ `5`...`2`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`rb` \ `2`...`0`])),
                (bits: 3, color: rgb("#dadada"), label: align(center, [`ra` \ `2`...`0`])),
                (bits: 4, color: rgb("#f1f1f1"), label: align(center, [`op` \ `3`...`0`]))
            ))
        
        ]
    ))

    #par([Formats that include the "md" field can be, depending on the specific instruction, one of the classes listed in the table. Instructions are allowed to partially utilize some modes of the chosen class if desired.])

    #tableWrapper([Instruction classes.], table(

        columns: (auto, auto, auto),
        align: (x, y) => (left + top, left + top, left + top).at(x),

        [#middle([*Class*])], [#middle([*Labels*])], [#middle([*Description*])],

        [-], [-], [Nothing. The "md" field is ignored.],
        [Class A], [instruction specific], [Function specifier: instruction specific.],
        [Class B], [`.L1`, `.L2`, \ `.L4`, `.LM `], [Data type size in bytes. `.LM` is used to signify the maximum `WLEN`.],
        [Class C], [`.SGPRB`, \ `.VGPRB`, \ `.HLPRB`, \ `.PERFCB`], [Register file selector.],
        [Class D], [-], [Extra immediate bits (always most significant).],
        [Class E], [`.UMSK`, `.MSK`, \ `.IMSK`, -], [Vector mask modes: unmasked, masked, inverted mask.],
        [Class F], [`.B0`, `.B1`, \ `.B2`, `.B3`], [Register bank specifier (currently only for compressed formats).],

        [Class G], [`.MA`, `.NMA`, \ `.MS`, `.NMS`], [Multiply-Accumulate modes: multiply-add, negative multiply-add, multiply-subtract, negative multiply-subtract.]
    ))

    #par([Vector instruction formats: `4R-B`, `3RI-B` include an additional modifier:])

    #tableWrapper([Vector modifiers.], table(

        columns: (auto, auto, auto),
        align: (x, y) => (left + top, left + top, left + top).at(x),

        [#middle([*Modifier*])], [#middle([*Labels*])], [#middle([*Description*])],

        [vm(6)], [`.VV`, `.VS`, `.MVV`, \ `.MVS`, `.IMVV`, `.IMVS`], [Vector modes and masking combinations:

            #list(tight: true,

                [vector-vector],
                [vector-scalar],
                [masked vector-vector],
                [masked vector-scalar],
                [inverted mask vector-vector],
                [inverted mask vector-scalar],
            )

        In all cases the sources and destinations are always the vector registers, unless explicitly stated otherwise.],

        [vm(2)], [`.UMSK`, `.MSK`, \ `.IMSK`, -], [Same effect as the Class E modifier.],
    ))

    #comment([

        FabRISC is provides 14 different variable length instruction formats of 2, 4 and 6 bytes in length. I chose this path because variable length encoding, if done right, can increase the code density by more than 25%, which can mean an effective increase in instruction cache capacity by that amount. The downside of this is the more complex hardware required to fetch and decode the instructions since they can now span across multiple cache lines and multiple OS pages and thus, TLB entries.

        I felt that three sizes would be sweet spot: 4 byte as the "standard" length, 2 byte as the compressed variant of the standard and the 6 byte as an extended, more niche length for larger and more complex formats. Anything else would either feel like something was missing or there was too much. With this configuration the ISA can enjoy the code density gains, while also being relatively easy to fetch and decode compared to other solutions like x86.

        To increase the expressivity and flexibility of the formats, without introducing too many of them, i included a "format class" system. Formats that have the "md" (modifier) field can be considered "polymorphic" and can be adapted to many different classes of instructions. This also helps in condensing similar instructions together by parametrizing them, thus simplifying the specification and potentially the underlying hardware.
    ])


#pagebreak()

///
