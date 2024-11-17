///
#import "Macros.typ": *

///
#section(

    [ISA Modules],

    [This section is dedicated to provide an overview of the modular capabilities of the FabRISC ISA. The list of modules and some implementation specific parameters will be presented shortly.],

    ///.
    subSection(

        [Module List],

        [Features and capabilities are packaged in modules which can be composed of instructions or other requirements such as registers, events, operating modes, etc... There are no mandatory modules in this specification in order to maximize flexibility, however, once a particular module is chosen, the hardware must provide all the features and abstractions of said module. The requirements for each and every module will be extensively explained in the upcoming sections when needed. The following is a simple table of all the existing base modules:],

        tableWrapper([Module list.], table(

            columns: (15%, 20%, 65%),
            align: (x, y) => (right + horizon, left + horizon, left + horizon).at(x),

            [#middle([*Index*])], [#middle([*Short name*])], [#middle([*Full name*])],

            [  0], [`CISB`  ], [*Computational-Integer-Scalar-Basic*: \ Provides simple scalar arithmetic and logic operations on integer values.],      // -

            [  1], [`CISA`  ], [*Computational-Integer-Scalar-Advanced*: \ Provides advanced scalar arithmetic and logic operations on integer values, such as multiplication, division, multiply-accumulate and complex bit manipulation.],   // -

            [  2], [`CISM`  ], [*Computational-Integer-Scalar-Multiword*: \ Provides dedicated instructions to improve performance on arbitrary precision scalar integer operations.],  // finish

            [  3], [`CIVB`  ], [*Computational-Integer-Vector-Basic*: \ Provides simple vector arithmetic and logic operations on integer values.],      // -

            [  4], [`CIVA`  ], [*Computational-Integer-Vector-Advanced*: \ Provides advanced vector arithmetic and logic operations on integer values, such as multiplication, division, multiply-accumulate and complex bit manipulation.],   // -

            [  5], [`CIVR`  ], [*Computational-Integer-Vector-Reductions*: \ Provides simple vector arithmetic and logic reduction operations on integer values, such as summing all the elements of a vector together.], // -

            [  6], [`CIC`   ], [*Computational-Integer-Compressed*: \ Provides simple scalar arithmetic and logic operations on integer values at a reduced code footprint.],        // -

            [  7], [`CFSB`  ], [*Computational-FP-Scalar-Basic*: \ Provides simple scalar arithmetic operations on floating-point values.],           //

            [  8], [`CFSA`  ], [*Computational-FP-Scalar-Advanced*: \ Provides advanced scalar arithmetic operations on floating-point values, such as multiply-accumulate and square root.],        //

            [  9], [`CFVB`  ], [*Computational-FP-Vector-Basic*: \ Provides simple vector arithmetic operations on floating-point values.],           //

            [ 10], [`CFVA`  ], [*Computational-FP-Vector-Advanced*: \ Provides advanced vector arithmetic operations on floating-point values, such as multiply-accumulate and square root.],        //

            [ 11], [`CFVR`  ], [*Computational-FP-Vector-Reductions*: \ Provides simple vector arithmetic and logic reduction operations on floating-point values, such as summing all the elements of a vector together.],      //

            [ 12], [`DSB`   ], [*Data-Scalar-Basic*: \ Provides scalar memory load & store operations with basic addressing modes.],                       //

            [ 13], [`DSA`   ], [*Data-Scalar-Advanced*: \ Provides scalar memory load & store operations with advanced addressing modes.],                    //

            [ 14], [`DVB`   ], [*Data-Vector-Basic*: \ Provides vector memory load & store operations with basic addressing modes.],                       //

            [ 15], [`DVA`   ], [*Data-Vector-Advanced*: \ Provides vector memory load & store operations with advanced addressing modes.],                    //

            [ 16], [`DAB`   ], [*Data-Atomic-Basic*: \ Provides basic atomic memory operations.],                       //
            [ 17], [`DAA`   ], [*Data-Atomic-Advanced*: \ Provides advanced atomic memory operations.],                    //

            [ 18], [`DB`    ], [*Data-Block*: \ Provides the ability to load & store blocks of registers.],                              //

            [ 19], [`DC`    ], [*Data-Compressed*: \ Provides scalar memory load & store operations with basic addressing modes at a reduced code footprint.],                         //

            [ 20], [`FIB`   ], [*Flow-Integer-Basic*: \ Provides basic integer control flow operations.],                      //
            [ 21], [`FIA`   ], [*Flow-Integer-Advanced*: \ Provides advanced integer control flow operations.],                   //

            [ 22], [`FIC`   ], [*Flow-Integer-Compressed*: \ Provides basic integer control flow operations. at a reduced code footprint],                 //

            [ 23], [`FFB`   ], [*Flow-FP-Basic*: \ Provides basic floating-point control flow operations.],                           //

            [ 24], [`FFA`   ], [*Flow-FP-Advanced*: \ Provides advanced floating-point control flow operations.],                        //

            [ 25], [`FIV`   ], [*Flow-Integer-Vector*: \ Provides integer vector mask manipulation operations.],                     //

            [ 26], [`FFV`   ], [*Flow-FP-Vector*: \ Provides floating-point vector mask manipulation operations.],                          //

            [ 27], [`SB`    ], [*System-Basic*: \ Provides basic system operations, such as system information, cache manipulation and halting.],                            //

            [ 28], [`SA`    ], [*System-Advanced*: \ Provides advanced system operations, such as waiting for interrupts.],                         //

            [ 29], [`VC`    ], [*Vector-Configuration*: \ Provides vector operations to manipulate vector configurations.],                     // add new instr. to do "sign extend" from old shape to new

            [ 30], [`FRMD`  ], [*FP-Rounding-Modes*: \ Provides floating-point rounding mode settings.],                        //

            [ 31], [`HLPR`  ], [*Helper-Registers*: \ Provides the helper registers.],                        //
            [ 32], [`PERFC` ], [*Performance-Counters*: \ Provides the performance counters.],                    //
            [ 33], [`FNC`   ], [*Fencing*: \ Provides memory and IO fencing operations.],                                 //

            [ 34], [`TM`    ], [*Transactional-Memory*: \ Provides hardware transactional memory operations.],                    //
            [ 35], [`EXC`   ], [*Exceptions*: \ Provides arithmetic exceptions.],
            [ 36], [`IOINT` ], [*IO-Interrupts*: \ Provides IO interrupts.],
            [ 37], [`IPCINT`], [*IPC-Interrupts*: \ Provides inter-processor interrupts.],
            [ 38], [`USER`  ], [*User-Mode*: \ Provides the user privilege mode.],                               //
            [ 39], [`DALIGN`], [*Data-Alignment*: \ Provides the unaligned data fault.],

            [ 40], [`CTXR`  ], [*Context-Reducing*: \ Provides operations to reduce the necessary register saving and restoring during context switches.],                         //

            [ 41], [-], [Reserved for future use.],
            [...], [...     ], [...                     ],
            [ 55], [-], [Reserved for future use.],

            [ 56], [-], [Reserved for custom extension.],
            [...], [...     ], [...                           ],
            [ 63], [-], [Reserved for custom extension.]

        )),

        [If the hardware designers choose to not implement any privileged capability provided by the `USER` module, then the system must always run in _machine mode_ which has complete and total control over all microarchitectural resources.]
    ),

    ///.
    subSection(

        [Implementation Specific Parameters],

        [FabRISC defines some implementation specific microarchitectural parameters to clear potential capability related issues in both the documentation, the running software, as well as making the ISA more general, flexible and extensible. These parameters, along with other information, must be physically stored in the shape of read-only registers so that programs can gather information about various characteristics of the system via dedicated operations such as the `SYSINFO` instruction. Depending on which modules are implemented, some of these parameters can be ignored and set to a default value. Some parameters are presented here as they are fundamental and mandatory, while others are declared in the following sections when appropriate. This is not an exhaustive list:],

        list(tight: false,

            [*ISA Modules* (`ISAMOD`): _This 64 bit parameter indicates the implemented instruction set modules as previously described. `ISAMOD` works as a checklist where each bit indicates the desired module: the least significant bit will be the first module, while the most significant bit will be the last module in the list (see the "index" column from the module table). The remaining most significant bits are reserved for future expansion as well as custom extensions._],

            [*ISA Version* (`ISAVER`): _This 16 bit parameter indicates the currently implemented ISA version. `ISAVER` is subdivided into two bytes with the most significant byte representing the major and the least significant byte the minor version. Minor versions are considered compatible with each other, while major versions may be not and it will depend on the actual change history made to the architecture._]
        ),

        comment([

            I consider this modular approach to be a wise idea because it allows the hardware designers to only implement what they really need with high degree of granularity and little extra. The fact that there is no explicit mandatory subset of the ISA may seem odd, but can help with specialized systems, as well as to greatly simplify the specification. With this, it becomes perfectly possible to create, for example, a floating-point only processor with very few integer instructions to alleviate overheads and extra complexities. This decision, however, makes silly and nonsensical things possible such as having no flow transfer or no memory operations. The ISA, in the end, kind of relies on the common sense of the hardware designers when it comes to realizing sensible microarchitectures.

            The miscellaneous modules also contain the `USER` module, which is responsible for giving the ISA different privilege levels by restricting access to some resources and functionalities. FabRISC currently only supports a maximum of two privilege levels: "user mode" and "machine mode".

            The `EXC`, `IOINT`, `IPCINT`, `HLPR` and `PERFC` modules allow the implementation of hardware level event-driven computation which, in conjunction with the earlier mentioned modules, is what really helps in supporting fully fledged operating systems, proper memory and process virtualization techniques as well as aiding higher-level event-driven programming.

            The purpose of the ISA parameters is to improve code compatibility by laying out in clear way all the capabilities of the specific microarchitecture. These parameters are also handy for writing a more general and broad documentation that applies to many different situations. Each particular hart must hold these parameters as read-only values organized in special purpose "configuration" registers in a separate bank from the main file. The software can then probe these registers and perform dynamic code dispatching for the specific microarchitecture.
        ])
    )
)

#pagebreak()

///
