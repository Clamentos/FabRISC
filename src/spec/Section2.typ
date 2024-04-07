///
#import "Macros.typ": *

///
#section(

    [ISA modules],

    [This section is dedicated to provide an overview of the modular capabilities of the FabRISC ISA. The list of modules and implementation specific parameters will be presented shortly.],

    ///.
    subSection(

        [Module list],

        [Features and capabilities are packaged in modules which can be composed of instructions or other requirements such as registers, events, operating modes and more. There are no mandatory modules in this specification in order to maximize the flexibility, however, once a particular extension is chosen, the hardware must provide all the features and abstractions of said extension. The requirements for each and every module will be extensively explained in the upcoming sections when required. The following is a simple table of all the existing modules:],

        align(center, table(

            columns: (10fr, 20fr, 70fr),
            inset: 8pt,
            align: (x, y) => (right, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Index*])], [#align(center, [*Short name*])], [#align(center, [*Full name*])],

            [  0], [CISB  ], [Computational-Integer-Scalar-Basic.],
            [  1], [CISA  ], [Computational-Integer-Scalar-Advanced.],
            [  2], [CISM  ], [Computational-Integer-Scalar-Multiword.],
            [  3], [CIVB  ], [Computational-Integer-Vector-Basic.],
            [  4], [CIVA  ], [Computational-Integer-Vector-Advanced.],
            [  5], [CIVR  ], [Computational-Integer-Vector-Reductions.],
            [  6], [CIC   ], [Computational-Integer-Compressed.],
            [  7], [CFSB  ], [Computational-FP-Scalar-Basic.],
            [  8], [CFSA  ], [Computational-FP-Scalar-Advanced.],
            [  9], [CFVB  ], [Computational-FP-Vector-Basic.],
            [ 10], [CFVA  ], [Computational-FP-Vector-Advanced.],
            [ 11], [CFVR  ], [Computational-FP-Vector-Reductions.],
            [ 12], [CFC   ], [Computational-FP-Compressed.],

            [ 13], [DSB   ], [Data-Scalar-Basic.],
            [ 14], [DSA   ], [Data-Scalar-Advanced.],
            [ 15], [DVB   ], [Data-Vector-Basic.],
            [ 16], [DVA   ], [Data-Vector-Advanced.],
            [ 17], [DAB   ], [Data-Atomic-Basic.],
            [ 18], [DAA   ], [Data-Atomic-Advanced.],
            [ 19], [DB    ], [Data-Block.],
            [ 20], [DC    ], [Data-Compressed.],

            [ 21], [FIB   ], [Flow-Integer-Basic.],
            [ 22], [FIA   ], [Flow-Integer-Advanced.],
            [ 23], [FIC   ], [Flow-Integer-Compressed.],
            [ 24], [FFB   ], [Flow-FP-Basic.],
            [ 25], [FFA   ], [Flow-FP-Advanced.],
            [ 26], [FV    ], [Flow-Vector.],

            [ 27], [SB    ], [System-Basic.],
            [ 28], [SA    ], [System-Advanced.],

            [ 29], [VC    ], [Vector-Configuration],
            [ 30], [FRMD  ], [FP-Rounding-Modes],

            [ 31], [HLPR  ], [Helper-Registers.],
            [ 32], [PERFC ], [Performance-Counters.],
            [ 33], [FNC   ], [Fencing.],

            [ 34], [TM    ], [Transactional-Memory.],
            [ 35], [EXC   ], [Exceptions.],
            [ 36], [IOINT ], [IO-Interrupts.],
            [ 37], [IPCINT], [IPC-Interrupts.],
            [ 38], [USER  ], [User-Mode.],
            [ 39], [DALIGN], [Data-Alignment.],
            [ 40], [CTXR  ], [Context-Reducer],

            [ 41], [-], [Reserved for future use.],
            [...], [...   ], [...],
            [ 55], [-], [Reserved for future use.],

            [ 56], [-], [Reserved for custom extension.],
            [...], [...   ], [...],
            [ 63], [-], [Reserved for custom extension.]
        )),

        [If the hardware designers choose to not implement any privileged capability provided by the USER module, then the system must always run in _machine mode_ which has complete and total control over all architectural resources.]
    ),

    ///.
    subSection(

        [Implementation specific parameters],

        [FabRISC makes use of some implementation specific microarchitectural parameters to clear potential misunderstandings in both the documentation and the running software, as well as making the ISA more general, flexible and extensible. These parameters, along with other information, must be physically stored internally in the shape of read-only registers so that programs can gather information about various characteristics of the system via dedicated operations such as the SYSINFO instruction (see section 6 and 7 for more information). Depending on which modules are implemented, some of these parameters can be ignored and set to a default value. Some parameters are presented here as they are fundamental, while others are declared in the following sections when appropriate. This is not an exhaustive list.],

        list(tight: false,

            [*ISA Modules (ISAMOD)* _This 64-bit parameter indicates the implemented instruction set modules of the processor as previously described. ISAMOD works as a checklist where each bit indicates the desired module: the least significant bit will be the first module, while the most significant bit will be the last module in the list (see the "index" column from the module table). The remaining most significant bits are reserved for future expansion as well as custom extensions._],

            [*ISA Version (ISAVER)* _This 16-bit parameter indicates the currently implemented ISA version. ISAVER is subdivided into two bytes with the most significant byte representing the major and the least significant byte the minor version. Minor versions are considered compatible with each other, while major versions may be not and it will depend on the actual change history made to the architecture._]
        ),

        ///..
        comment([

            I consider this modular approach to be a wise idea because it allows the hardware designers to only implement what they really want with high degree of granularity and little extra. The fact that there is no explicit mandatory subset of the ISA can help with specialized systems, as well as to simplify the specification. With this, it becomes perfectly possible to create, for example, a floating-point only processor with very few integer instructions to alleviate overheads and extra complexities. This decision, however, makes silly and nonsensical things possible such as having no flow transfer or no memory operations. The ISA, in the end, kind of relies on the common sense of the hardware designers when it comes to realizing sensible microarchitectures.
            
            The hardware can inform the software of its capabilities by transforming the above seen list into a simple checklist from the first module as the least significant bit, all the way to the last module as the most significant one. This number is then written into the ISAMOD parameter (see the next subsection below for more information) and the software can then read this parameter via the SYSINFO instruction (see section 6 and 7 for more information).

            The miscellaneous modules also contain the USER module, which is responsible for giving the ISA different privilege levels by restricting access to some resources and functionalities. FabRISC only supports a maximum of two privilege levels: user mode and machine mode.

            The EXC, IOINT, IPCINT, HLPR and PERFC allow the implementation of hardware-level event-driven computation which, in conjunction with the earlier mentioned modules, is what really helps in supporting fully fledged operating systems, proper memory and process virtualization techniques as well as aiding higher-level event-driven programming.

            The purpose of the ISA parameters is to improve code compatibility by laying out in clear way all the capabilities of the microarchitecture. These parameters are also handy for writing a more general and broad documentation that applies to many different situations (see the following sections for more information). Each particular hart must hold these parameters as read-only values organized in special purpose "configuration" registers in a separate bank from the main file (see section 6 for more information).
        ])
    )
)

#pagebreak()

///
