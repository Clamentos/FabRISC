///
#import "Macros.typ": *

///
#section(

    [ISA Compatibility],

    [This section is dedicated to provide a high level overview of the modular structure capabilities of the FabRISC ISA. The list of modules and some implementation specific parameters is presented shortly.],

    ///.
    subSection(

        [Module List],

        [Features and capabilities are packaged in modules which can be composed of instructions or other requirements such as registers, events, operating modes, etc.... There are no mandatory modules in this specification in order to maximize flexibility, however, once a particular module is chosen, the hardware must provide all the features and abstractions of said module. The requirements for each and every module are extensively explained throughout the document when appropriate. The following is a simple table of all the existing base modules:],

        tableWrapper([Module list.], table(

            columns: (auto, auto, auto),
            align: (x, y) => (right + top, left + top, left + top).at(x),

            [#middle([*Index*])], [#middle([*Mnemonic*])], [#middle([*Full name*])],

            [  0], [`CISB`  ], [*Computational-Integer-Scalar-Basic*: \ Provides simple scalar arithmetic and logic operations on integer values.],

            [  1], [`CISA`  ], [*Computational-Integer-Scalar-Advanced*: \ Provides advanced scalar arithmetic and logic operations on integer values, such as multiplication, division, multiply-accumulate and complex bit manipulation.],

            [  2], [`CISM`  ], [*Computational-Integer-Scalar-Multiword*: \ Provides dedicated instructions to improve performance on some arbitrary precision scalar integer operations.],

            [  3], [`CIVB`  ], [*Computational-Integer-Vector-Basic*: \ Provides simple vector arithmetic and logic operations on integer values.],

            [  4], [`CIVA`  ], [*Computational-Integer-Vector-Advanced*: \ Provides advanced vector arithmetic and logic operations on integer values, such as multiplication, division, multiply-accumulate and complex bit manipulation.],

            [  5], [`CIVR`  ], [*Computational-Integer-Vector-Reductions*: \ Provides vector arithmetic and logic reduction operations on integer values, such as summing all the elements of a vector together.],

            [  6], [`CIC`   ], [*Computational-Integer-Compressed*: \ Provides some scalar arithmetic and logic operations on integer values at a reduced code footprint.],

            [  7], [`CFSB`  ], [*Computational-FP-Scalar-Basic*: \ Provides simple scalar arithmetic operations on floating-point values.],

            [  8], [`CFSA`  ], [*Computational-FP-Scalar-Advanced*: \ Provides advanced scalar arithmetic operations on floating-point values, such as multiply-accumulate and square root.],

            [  9], [`CFVB`  ], [*Computational-FP-Vector-Basic*: \ Provides simple vector arithmetic operations on floating-point values.],

            [ 10], [`CFVA`  ], [*Computational-FP-Vector-Advanced*: \ Provides advanced vector arithmetic operations on floating-point values, such as multiply-accumulate and square root.],

            [ 11], [`CFVR`  ], [*Computational-FP-Vector-Reductions*: \ Provides vector arithmetic and logic reduction operations on floating-point values, such as summing all the elements of a vector together.],

            [ 12], [`DSB`   ], [*Data-Scalar-Basic*: \ Provides scalar memory load and store operations with basic addressing modes.],

            [ 13], [`DSA`   ], [*Data-Scalar-Advanced*: \ Provides scalar memory load and store operations with advanced addressing modes.],

            [ 14], [`DVB`   ], [*Data-Vector-Basic*: \ Provides vector memory load and store operations with basic addressing modes.],

            [ 15], [`DVA`   ], [*Data-Vector-Advanced*: \ Provides vector memory load and store operations with advanced addressing modes.],

            [ 16], [`VM`    ], [*Vector-Moves*: \ Provides the ability to move vector registers to and from the scalar registers.],

            [ 17], [`DC`    ], [*Data-Compressed*: \ Provides some scalar memory load & store operations with basic addressing modes at a reduced code footprint.],

            [ 18], [`DB`    ], [*Data-Block*: \ Provides the ability to load and store blocks of registers at once.],
            [ 19], [`DAB`   ], [*Data-Atomic-Basic*: \ Provides basic atomic memory operations.],
            [ 20], [`DAA`   ], [*Data-Atomic-Advanced*: \ Provides advanced atomic memory operations.],
            [ 21], [`FNC`   ], [*Fencing*: \ Provides memory and IO fencing operations.],
            [ 22], [`TM`    ], [*Transactional-Memory*: \ Provides hardware transactional memory operations.],
            [ 23], [`FIB`   ], [*Flow-Integer-Basic*: \ Provides basic integer control flow operations.],
            [ 24], [`FIA`   ], [*Flow-Integer-Advanced*: \ Provides advanced integer control flow operations.],
            [ 25], [`FIV`   ], [*Flow-Integer-Vector*: \ Provides integer vector mask manipulation operations.],

            [ 26], [`FIC`   ], [*Flow-Integer-Compressed*: \ Provides some basic integer control flow operations. at a reduced code footprint],

            [ 27], [`FFB`   ], [*Flow-FP-Basic*: \ Provides basic floating-point control flow operations.],
            [ 28], [`FFA`   ], [*Flow-FP-Advanced*: \ Provides advanced floating-point control flow operations.],
            [ 29], [`FFV`   ], [*Flow-FP-Vector*: \ Provides floating-point vector mask manipulation operations.],
            [ 30], [`VC`    ], [*Vector-Configuration*: \ Provides operations to configure the vector shape.],
            [ 31], [`FRMD`  ], [*FP-Rounding-Modes*: \ Provides operations to manipulate the floating-point rounding modes.],
            [ 32], [`PWR`   ], [*Power*: \ Provides power management state and the associated configuration instructions.],
            [ 33], [`HLPR`  ], [*Helper-Registers*: \ Provides the helper registers and the associated configuration instructions.],

            [ 34], [`PERFC` ], [*Performance-Counters*: \ Provides the performance counters and the associated configuration instructions.],

            [ 35], [`SYS`   ], [*System*: \ Provides system operations, such as system information, cache manipulation and halting.],
            [ 36], [`USER`  ], [*User-Mode*: \ Provides the user privilege mode and the associated configuration instructions.],
            [ 37], [`EXC`   ], [*Exceptions*: \ Provides arithmetic exceptions and the associated configuration instructions.],
            [ 38], [`IOINT` ], [*IO-Interrupts*: \ Provides IO interrupts.],
            [ 39], [`IPCINT`], [*IPC-Interrupts*: \ Provides inter-processor interrupts.],
            [ 40], [`DALIGN`], [*Data-Alignment*: \ Provides the unaligned data fault.],

            [ 41], [-],   [Reserved for future use.],
            [...], [...], [...],
            [ 55], [-],   [Reserved for future use.],

            [ 56], [-],   [Available for custom extension.],
            [...], [...], [...],
            [ 63], [-],   [Available for custom extension.]

        ))
    ),

    ///.
    subSection(

        [Implementation Specific Parameters],

        [FabRISC defines some implementation specific microarchitectural parameters to clear potential capability related issues in both the documentation, the running software, as well as making the ISA more general, flexible and extensible. These parameters, along with other information, must be physically stored in the shape of read-only registers so that programs can gather information about various characteristics of the system via the `SYSINFO` instruction. This can used for compatibility checks or to perform dynamic code dispatching. Depending on which modules are implemented, some of these parameters can be ignored and set to a default value. The following list is not exhaustive and presents only some of the fundamental and mandatory parameters:],

        list(tight: false,

            [*ISA Modules* (`ISAMOD`): _This 64 bit parameter indicates the implemented instruction set modules previously described. `ISAMOD` is a checklist where each bit indicates the desired module: the least significant bit is the first module, while the most significant bit is the last module in the list by using the "index" column from the module table. The remaining bits are reserved for future expansion as well as custom extensions._],

            [*ISA Version* (`ISAVER`): _This 16 bit parameter indicates the implemented ISA version by the hardware. `ISAVER` is subdivided into two bytes with the most significant byte representing the major and the least significant byte the minor version. Minor versions are considered compatible with each other, while major versions may be not and it will depend on the actual change history made to the architecture._]
        ),

        comment([

            I consider this modular approach to be a wise idea because it allows the hardware designers to only implement what they really need with high degree of granularity and little extra. Another advantage is that it's easier to add and remove pieces from the specification in a cleaner way. The fact that there is no explicit mandatory subset of the ISA may seem odd, but it can help with specialized systems, as well as to greatly simplify the specification. With this, it becomes perfectly possible to create, for example, a floating-point only processor with very few integer instructions to alleviate overheads and extra complexities. This decision, however, makes silly and nonsensical things possible such as having no flow transfer or no memory operations. The ISA, in the end, kind of relies on the common sense of the hardware designers when it comes to realizing sensible microarchitectures.

            The miscellaneous modules also contain the `USER` module, which is responsible for giving the ISA different privilege levels by restricting access to some critical resources and functionalities. FabRISC currently only supports a maximum of two privilege levels: "user mode" and "machine mode". I wanted and tried to include a third "supervisor mode" since it could have been useful for easing virtualization, but i decided not to for the sake of simplicity.

            The `EXC`, `IOINT`, `IPCINT` and `HLPR` modules allow the implementation of hardware level event-driven computation which, in conjunction with the earlier mentioned modules, is what really helps in supporting fully fledged operating systems, proper memory and process virtualization techniques as well as aiding higher-level event-driven programming.

            The `PERFC` module is an attempt at laying out a foundation for something that is extremely dependant on the microarchitecture, but also important as hardware complexity grows. Performance counters are a must-have on implementations that lean towards performance, because locating bottlenecks within complex logic without them can become a nightmare.

            The purpose of the ISA parameters is to improve code compatibility by laying out in clear way all the capabilities of the specific microarchitecture. The idea and implementation is heavily influenced by RISC-V and it tries to solve a difficult problem: finding a standardized way to layout all the various characteristics of a microarchitecture and expose them to the software.
        ])
    )
)

#pagebreak()

///
