///
#import "Macros.typ": *
#import "@preview/tablex:0.0.9": tablex, colspanx, rowspanx

///
    // TODO: 3RI.B with 16 bit immediate
    #page(flipped: true, text(size: 10pt,

        [

            #text(18pt)[#heading(level: 1, [Instruction Formats])]
            #v(14pt)

            #par(text(size: 12pt, [FabRISC organizes the instructions in 14 different formats with lengths of 2, 4 and 6 bytes and opcode lengths ranging from 4 to 20 bits. Formats that specify the "md" field are also subdivided into "classes" at the instruction level. This is because the _md_ field acts as an extra modifier, such as, extra immediate bits, data type selector  and more. The following is the complete list of all the formats:]))
            
            #tableWrapper([6 byte instruction formats.], tablex(

                columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),

                align: center + horizon,
                stroke: 0.75pt, inset: 8pt, fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

                [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],

                [`2RI-B`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(11)[op \ 14...4], colspanx(5)[im \ 18...16], colspanx(2)[md \ 1...0], colspanx(16)[im \ 15...0],

                [`3RI-A`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(11)[op \ 14...4], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0], colspanx(16)[im \ 15...0],

                [`4R-B`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(6)[op \ 9...4], colspanx(5)[rd \ 4...0], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0], colspanx(2)[vm \ 1...0], colspanx(10)[op \ 19...10], colspanx(4)[vm \ 5...2],

                [`3RI-B`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(9)[op \ 12...4], colspanx(2)[im \ 15...14], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0], colspanx(2)[vm \ 1...0], colspanx(14)[im \ 13...0]
            )
        )

        #tableWrapper([4 byte instruction formats.], tablex(

            columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),

            align: center + horizon,
            stroke: 0.75pt, inset: 8pt, fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],

            [`2R-A`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(16)[op \ 19...4], colspanx(2)[md \ 1...0],

            [`3R-A`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(11)[op \ 14...4], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0],

            [`4R-A`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(6)[op \ 9...4], colspanx(5)[rd \ 4...0], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0],

            [`I-A`], colspanx(4)[op \ 3...0], colspanx(5)[im \ 23...19], colspanx(5)[ra \ 15...11], colspanx(4)[op \ 7...4], colspanx(1)[im \ 18], colspanx(11)[im \ 10...0], colspanx(2)[im \ 17...16],

            [`RI-A`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[ra \ 15...11], colspanx(5)[op \ 8...4], colspanx(11)[im \ 10...0], colspanx(2)[md \ 1...0],

            [`2RI-A`], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(4)[op \ 7...4], colspanx(12)[im \ 11...0], colspanx(2)[md \ 1...0]
        ))

        #tableWrapper([2 byte (compressed) instruction formats.], tablex(

            columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
            align: center + horizon,
            stroke: 0.75pt, inset: 8pt, fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],

            [`2R-B`], colspanx(4)[op \ 3...0], colspanx(2)[md \ 1...0], colspanx(3)[ra \ 2...0], colspanx(2)[op \ 5...4], colspanx(3)[rb \ 2...0], colspanx(2)[op \ 7...6],

            [`I-B`], colspanx(4)[op \ 3...0], colspanx(2)[im \ 3...2], colspanx(3)[im \ 9...7], colspanx(2)[op \ 5...4], colspanx(3)[im \ 6...4], colspanx(2)[im \ 1...0],

            [`RI-B`], colspanx(4)[op \ 3...0], colspanx(2)[im \ 3...2], colspanx(3)[ra \ 2...0], colspanx(1)[op \ 4], colspanx(1)[im \ 7], colspanx(3)[im \ 6...4], colspanx(2)[im \ 1...0],

            [`2RI-C`], colspanx(4)[op \ 3...0], colspanx(2)[im \ 3...2], colspanx(3)[ra \ 2...0], colspanx(2)[im \ 5...4], colspanx(3)[rb \ 2...0], colspanx(2)[im \ 1...0]
        ))
    ]))

    #par([Formats that include the "md" field can be, depending on the specific instruction, one of the classes listed in the table. Instructions are allowed to partially utilize some modes of the chosen class if desired.])

    #tableWrapper([Instruction classes.], table(

        columns: (auto, auto, auto),
        align: (x, y) => (left + horizon, left + horizon, left + horizon).at(x),

        [#middle([*Class*])], [#middle([*Labels*])], [#middle([*Description*])],

        [-], [-], [Nothing. The _md_ field is ignored.],

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
        align: (x, y) => (left + horizon, left + horizon, left + horizon).at(x),

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
