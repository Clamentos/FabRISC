///
#import "Macros.typ": *

///
#section(

    [ISA modules],

    [This section is dedicated to provide an overview of the modular capabilities of the FabRISC ISA. The list of modules and implementation-specific parameters will be presented shortly.]
)

    ///
    #subSection(

        [Module list],

        [Features and capabilities are packaged in modules which can be composed of instructions or other requirements such as registers, events, modes and more. There are no mandatory modules in this specification in order to maximize the flexibility, however, once a particular extension is chosen, the hardware must provide all the features and abstractions of said extension. The requirements for each and every module will be extensively explained in the following sections when required and some might depend on others. The following is a simple list of all modules:],

        align(center, table(

            columns: (10fr, 20fr, 70fr),
            inset: 8pt,
            align: (x, y) => (right, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Index*])], [#align(center, [*Short name*])], [#align(center, [*Full name*])],

            [ 0],  [CISB],   [Computational-integer-scalar-basic.],                 //
            [ 1],  [CISA],   [Computational-integer-scalar-advanced.],              //
            [ 2],  [CIVB],   [Computational-integer-vector-basic.],                 //
            [ 3],  [CIVA],   [Computational-integer-vector-advanced.],              //
            [ 5],  [CFSB],   [Computational-FP-scalar-basic.],                      //
            [ 6],  [CFSA],   [Computational-FP-scalar-advanced.],                   //
            [ 7],  [CFVB],   [Computational-FP-vector-basic.],                      //
            [ 8],  [CFVA],   [Computational-FP-vector-advanced.],                   //
            [ 9],  [CSIM],   [Computational-scalar-integer-multi-word.],            //
            [10],  [CCIB],   [Computational-compressed-integer-basic.],             //
            [11],  [CCFB],   [Computational-compressed-FP-basic.],                  //

            [12],  [DSB],    [Data-scalar-basic.],                                  //
            [13],  [DSA],    [Data-scalar-advanced.],                               //
            [14],  [DVB],    [Data-vector-basic.],                                  //
            [15],  [DVA],    [Data-vector-advanced.],                               //
            [16],  [DAB],    [Data-atomic-basic.],                                  //
            [17],  [DAA],    [Data-atomic-advanced.],                               //
            [18],  [DB],     [Data-block.],                                         //
            [19],  [DC],     [Data-compressed.],                                    //

            [20],  [FIB],    [Flow-integer-basic.],                                 //
            [21],  [FIA],    [Flow-integer-advanced.],                              //
            [22],  [FFB],    [Flow-FP-basic.],                                      //
            [23],  [FFA],    [Flow-FP-advanced.],                                   //
            [24],  [MVC],    [Masking-vector-and-configuration.],                   //
            [25],  [FCI],    [Flow-compressed-integer.],                            //

            [26],  [SB],     [System-basic.],                                       //
            [27],  [SA],     [System-advanced.],                                    //

            [28],  [HLPR],   [Helper-registers.],                                   //
            [29],  [PERFC],  [Performance-counters.],                               //
            [30],  [FNC],    [Fencing.],                                            //

            [31],  [TM],     [Transactional-memory.],                               //
            [32],  [EXC],    [Exceptions.],
            [33],  [FLT],    [Faults.],
            [34],  [IOINT],  [IO-interrupts.],
            [35],  [IPCINT], [IPC-interrupts.],
            [36],  [SUPER],  [Supervisor privilege.],
            [37],  [USER],   [User privilege.],
            [38],  [DALIGN], [Data-alignment.],
            [39],  [-],      [Reserved for future use.],
            [...], [...],    [...],
            [55],  [-],      [Reserved for future use.],
            [56],  [-],      [Reserved for custom extension.],
            [...], [...],    [...],
            [63],  [-],      [Reserved for custom extension.]
        )),

        [If the hardware designers choose to not implement any privileged capability (as is the case for this document), then the system must always run in _machine mode_ which has complete and total control over all architectural resources.],

        comment([
            
            I consider this modular approach to be a wise idea because it allows the hardware designers to only implement what they really want with high degree of granularity and little extra. The fact that there is no explicit mandatory subset of the ISA can help with specialized systems, as well as to simplify the specification. With this, it becomes perfectly possible to create, for example, a floating-point only processor with very few integer instructions to alleviate overheads and extra complexities. This decision, however, makes silly and nonsensical things possible such as having no flow transfer or no memory operations. This ISA, therefore, kind of relies on the common sense of the hardware designers when it comes to realizing sensible microarchitectures. The hardware can inform the software of its capabilities by transforming the above seen list into a simple checklist from the first module as the least significant bit, all the way to the last module as the most significant one. This number is then written into the ISAMOD parameter (see the next subsection below for a list of them) and the software can then read this parameter via the SYSINFO instruction (see section 7 for more information).

            The miscellaneous modules also contain the SUPER and the USER modules, which are responsible for giving the ISA different privilege levels (the supervisor mode is intended for virtualization support). The EXC, FLT, IOINT, IPCINT, HLPR and PERFC allow the implementation of event-driven computation which, in conjunction with the earlier mentioned modules, is what really helps in supporting fully fledged operating systems, proper virtualization techniques as well as event-driven programming.
        ])
    )

    ///
    #subSection(

        [Implementation specific parameters],

        [FabRISC makes use of some implementation-specific microarchitectural parameters to clear potential misunderstandings in both the documentation and the running software, as well as making the ISA more general, flexible and extensible. These parameters, along with other information, must be phisycally stored internally in the shape of read-only registers so that programs can gather information about various characteristics of the system via dedicated operations such as the SYSINFO instruction (see section 7 for more information). The parameters are the following:]
    )

        ///
        #subSubSection(

            [ISA Modules (ISAMOD)],

            [This 64-bit parameter is always mandatory and indicates the implemented instruction set modules of the processor as previously described. ISAMOD works as a checklist where each bit indicates the desired module: the least significant bit will be the first module, while the most significant bit will be the last module in the list (see the index column from the module table). The remaining most significant bits are reserved for future expansion as well as custom extensions.]
        )

        ///
        #subSubSection(

            [Unprivileged ISA Version (UISAV)],

            [This 16-bit parameter is always mandatory and indicates the currently implemented unprivileged ISA version. UISAV is subdivided into two bytes with the most significant byte representing the major and the least significant byte the minor version.]
        )

        ///
        #subSubSection(

            [Privileged ISA Version (PISAV)],

            [This 16-bit parameter indicates the currently implemented privileged ISA version. PISAV is subdivided into two bytes with the most significant byte representing the major and the least significant byte the minor version. If no privileged mode is supported (SUPER and USER modules are absent), this parameter must be set to all zeros for convention.]
        )

        ///
        #subSubSection(

            [Word Length (WLEN)],

            [This 2-bit parameter is always mandatory and indicates the natural scalar word length of the processor in bits. The possible values are listed in the table below:],

            align(center, table(

                columns: (10fr, 90fr),
                inset: 8pt,
                align: (x, y) => (center, left + horizon).at(x),
                stroke: 0.75pt,

                [#align(center, [*Code*])], [#align(center, [*Value*])],

                [00], [8-bit.],
                [01], [16-bit.],
                [10], [32-bit.],
                [11], [64-bit.]
            ))
        )

        ///
        #subSubSection(

            [Maximum Vector Length (MXVL)],

            [This 3-bit parameter indicates the maximum vector length of the processor in bits (see section 6 for more information). The default value of zero must be used if the system doesn't support any vector capability. The possible values are listed in the table below:],

            align(center, table(

                columns: (10fr, 90fr),
                inset: 8pt,
                align: (x, y) => (center, left + horizon).at(x),
                stroke: 0.75pt,

                [#align(center, [*Code*])], [#align(center, [*Value*])],

                [000], [No vector capability is supported.],
                [001], [16-bit long for 8-bit processors, WLEN must be 0.],
                [010], [32-bit long for 8 and 16-bit processors, WLEN must be 0 or 1.],
                [011], [64-bit long for 8, 16 and 32-bit processors, WLEN must be 0, 1, or 2.],
                [100], [128-bit long for 8, 16, 32 and 64-bit processors, WLEN must be 0, 1, 2 or 3.],
                [101], [256-bit long for 8, 16, 32 and 64-bit processors, WLEN must be 0, 1, 2 or 3.],
                [110], [512-bit long for 16, 32 and 64-bit processors, WLEN must be 1, 2 or 3.],
                [111], [1024-bit long for 32 and 64-bit processors, WLEN must be 2 or 3.]
            ))
        )

        ///
        #subSubSection(

            [Counter Length (CLEN)],

            [This 2-bit parameter indicates the width of the performance counters (see section 6 for more information) in bits. If the system doesn't support the PERFC module, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the table below:],

            align(center, table(

                columns: (10fr, 90fr),
                inset: 8pt,
                align: (x, y) => (center, left + horizon).at(x),
                stroke: 0.75pt,

                [#align(center, [*Code*])], [#align(center, [*Value*])],

                [00], [8-bit.],
                [01], [16-bit.],
                [10], [32-bit.],
                [11], [64-bit.]
            ))
        )

        ///
        #subSubSection(

            [Scalar Register File Size (SRFS)],

            [This 2-bit parameter indicates the number of registers of the scalar file. The default value of zero must be used if the hart doesn't support any module that necessitates of the scalar register file. Depending on the value of SRFS, the calling convention will differ slightly (see section 6 for more information). The possible values are listed in the table below:],

            align(center, table(

                columns: (10fr, 90fr),
                inset: 8pt,
                align: (x, y) => (center, left + horizon).at(x),
                stroke: 0.75pt,

                [#align(center, [*Code*])], [#align(center, [*Value*])],

                [00], [No file.],
                [01], [8 entries.],
                [10], [16 entries.],
                [11], [32 entries.]
            ))
        )

        ///
        #subSubSection(

            [Vector Register File Size (VRFS)],

            [This 2-bit parameter indicates the number of registers of the vector file. The default value of zero must be used if the system doesn't support any vector capability. The possible values are listed in the table below:],

            align(center, table(

                columns: (10fr, 90fr),
                inset: 8pt,
                align: (x, y) => (center, left + horizon).at(x),
                stroke: 0.75pt,

                [#align(center, [*Code*])], [#align(center, [*Value*])],

                [00], [No file.],
                [01], [8 entries.],
                [10], [16 entries.],
                [11], [32 entries.]
            ))
        )

        ///
        #subSubSection(

            [Helper Register File Size (HRFS)],

            [This 2-bit parameter indicates the number of registers of the helper file (see section 6 for more information). The default value of zero must be used if the hart doesn't support the HLPR module. The possible values are listed in the table below:],

            align(center, table(

                columns: (10fr, 90fr),
                inset: 8pt,
                align: (x, y) => (center, left + horizon).at(x),
                stroke: 0.75pt,

                [#align(center, [*Code*])], [#align(center, [*Value*])],

                [00], [No file.],
                [01], [8 entries.],
                [10], [16 entries.],
                [11], [32 entries.]
            ))
        )

        ///
        #subSubSection(

            [Counter Register File Size (CRFS)],

            [This 2-bit parameter indicates the number of registers of the performance counter file (see section 6 for more information). The default value of zero must be used if the hart doesn't support the PERFC module. The possible values are listed in the table below:],

            align(center, table(

                columns: (10fr, 90fr),
                inset: 8pt,
                align: (x, y) => (center, left + horizon).at(x),
                stroke: 0.75pt,

                [#align(center, [*Code*])], [#align(center, [*Value*])],

                [00], [No file.],
                [01], [8 entries.],
                [10], [16 entries.],
                [11], [32 entries.]
            ))
        )

        ///
        #subSubSection(

            [Input-output size (IOLEN)],

            [This 4-bit parameter is always mandatory and indicates the size of the memory mapped IO region in bytes (see section 5 for more information). The possible values are listed in the table below:],

            align(center, table(

                columns: (10fr, 90fr),
                inset: 8pt,
                align: (x, y) => (center, left + horizon).at(x),
                stroke: 0.75pt,

                [#align(center, [*Code*])], [#align(center, [*Value*])],

                [0000], [$2^3$ bytes for 8-bit systems ($"WLEN" = 0$).],
                [0001], [$2^4$ bytes for 8-bit systems ($"WLEN" = 0$).],
                [0010], [$2^5$ bytes for 8-bit systems ($"WLEN" = 0$).],
                [0011], [$2^6$ bytes for 8-bit systems ($"WLEN" = 0$).],

                [0100], [$2^10$ bytes for 16-bit systems ($"WLEN" = 1$).],
                [0101], [$2^11$ bytes for 16-bit systems ($"WLEN" = 1$).],
                [0110], [$2^12$ bytes for 16-bit systems ($"WLEN" = 1$).],
                [0111], [$2^13$ bytes for 16-bit systems ($"WLEN" = 1$).],

                [1000], [$2^15$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
                [1001], [$2^16$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
                [1010], [$2^20$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
                [1011], [$2^24$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],

                [1100], [$2^32$ bytes for 64-bit systems ($"WLEN" = 3$).],
                [1101], [$2^34$ bytes for 64-bit systems ($"WLEN" = 3$).],
                [1110], [$2^36$ bytes for 64-bit systems ($"WLEN" = 3$).],
                [1111], [$2^40$ bytes for 64-bit systems ($"WLEN" = 3$).],
            )),

            comment([

                This ISA allows quite large vector widths to accommodate more exotic and special microarchitectures as well as byte-level granularity. The size must be at least twice the WLEN up to a maximum of 32 times, except for 32 and 64-bit architectures which stops at 1024 bits. This is quite large even for vector-heavy specialist machines. Vector execution is also possible at low WLEN of 8 and 16-bits but it probably won't be the best idea because of the limited word length. I expect an MXVL of 128 to 256 bits to be the most used for general purpose microarchitectures such as CPUs because it gives a good boost in performance for data-independent code, without hindering other aspects of the system such as power consumption, chip area, frequency or resource usage in FPGAs too much. 512 bits will probably be the practical limit as even real commercial cpus make tradeoffs between width and frequency. For an out-of-order machine the reservation stations and the reorder buffer would already be quite sizeable at 512 bits, however, it's always possible to decouple the two pipelines in order to minimize power and resource usage if a wider MXVL, such as this, is desired.

                The purpose of the other parameters is to improve code compatibility by laying out in clear way all the capabilities of the microarchitecture. These parameters are also handy for writing a more general and broad documentation that applies to many different situations. Each particular hart must hold these parameters as read-only values organized in special purpose "configuration" registers in a separate bank from the main file (see section 6 for more information).
            ])
        )

#pagebreak()

///