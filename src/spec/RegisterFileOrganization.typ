///
#import "Macros.typ": *

///
#section(

    [Register File Organization],

    [In this section the various register file banks, calling convention and the configuration segment of the FabRISC architecture are presented.],

    ///.
    subSection(

        [Register File Banks],

        [Depending on which modules are chosen as well as the ISA parameter values, the register file can be composed of up to five different banks of variable width registers, along with extra special purpose ones mainly used for status and configuration. Some registers are considered _hart-private_, that is, each hart must hold its own copy of such registers. The banks are briefly described in the following table:],

        tableWrapper([Register file banks.], table(

            columns: (auto, auto),
            align: left + horizon,

            [#middle([*Name*])], [#middle([*Description*])],

            [`SGPRB`], [*Scalar General Purpose Register Bank*: \ This bank is composed of `SRFS` number of registers which can be used to hold data during program execution. The registers are all `WLEN` bits wide and are used by scalar integer and floating point instructions together. These registers are not privileged, private for each hart and must always be implemented.],

            [`VGPRB`], [*Vector General Purpose Register Bank*: \ This bank is composed of `VRFS` number of registers which can be used to hold data during program execution. The registers are all `MXVL` bits wide and are used by vector integer and floating point instructions together. These registers are not privileged, private for each hart and are only needed when the system implements any vector related module.],

            [`HLPRB`], [*Helper Register Bank*: \ This bank is composed of `HRFS` number of registers which can be used for debugging, automatic address boundary checking as well as triggering exceptions in precise occasions. These registers are all $"WLEN" + 8$ bits wide, not privileged, private for each hart and are only needed when the system implements the `HLPR` module.],

            [`PERFCB`], [*Performance Counters Bank*: \ This bank is composed of `CRFS` number of registers which can be used for performance diagnostic, timers and counters. These registers are all $"CLEN" + 8$ bits wide, not privileged, private for each hart and are only needed when the system implements the `PERFC` module.],

            [`SPRB`], [*Special Purpose Register Bank*: \ This bank is composed of various special purpose registers used to keep track of the system status and operation. The number of these registers as well as their width can vary depending on which modules are chosen. Privileges are defined for each individual register later in this section.]
        )),

        [FabRISC provides the *Scalar Register File Size* (`SRFS`) 2 bit ISA parameter, to indicate the number of registers of the scalar file. Depending on the value of this parameter, the calling convention will differ slightly. The possible values are listed in the following table:],

        tableWrapper([Scalar register file sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [00], [8 entries. ],
            [01], [16 entries.],
            [10], [32 entries.],
            [11], [Reserved for future uses.]
        )),

        [FabRISC provides the *Vector Register File Size* (`VRFS`) 2 bit ISA parameter, to indicate the number of registers of the vector file. If the system doesn't support any module that necessitates the vector register file, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the table below:],

        tableWrapper([Vector register file sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [00], [8 entries. ],
            [01], [16 entries.],
            [10], [32 entries.],
            [11], [Reserved for future uses.]
        )),

        [FabRISC provides the *Maximum Vector Length* (`MXVL`) 3 bit ISA parameter, to indicate the maximum vector length in bits. If the system doesn't support any vector capability, then this parameter must be set to zero for convention. The possible values are listed in the following table:],

        pagebreak(),
        tableWrapper([Maximum vector length sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [000], [No vector capabilities present.],
            [001], [16 bit long for 8 bit machines ($"WLEN" = 0$).],
            [010], [32 bit long for 8 and 16 bit machines ($"WLEN" = 0, 1$).],
            [011], [64 bit long for 8, 16 and 32 bit machines ($"WLEN" = 0, 1, 2$).],
            [100], [128 bit long for 8, 16, 32 and 64 bit machines ($"WLEN" = 1, 2, 3$).],
            [101], [256 bit long for 8, 16, 32 and 64 bit machines ($"WLEN" = 2, 3$).],
            [110], [512 bit long for 16, 32 and 64 bit machines ($"WLEN" = 3$).],
            [111], [Reserved for future uses.],
        )),

        [FabRISC provides the *Helper Register File Size* (`HRFS`) 2 bit ISA parameter, to indicate the number of registers of the helper file. If the system doesn't support the `HLPR` module, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the table below:],

        tableWrapper([Helper register file sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [00], [8 entries. ],
            [01], [16 entries.],
            [10], [32 entries.],
            [11], [Reserved for future uses.]
        )),

        [FabRISC provides the *Counter Register File Size* (`CRFS`) 2 bit ISA parameter, to indicate the number of registers of the performance counter file. If the system doesn't support the `PERFC` module, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the table below:],

        tableWrapper([Counter register file sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [00], [8 entries. ],
            [01], [16 entries.],
            [10], [32 entries.],
            [11], [Reserved for future uses.]
        )),

        comment([

            Five banks of several registers might seem overkill, but thanks to FabRISC flexibility the hardware designers can choose only what they desire and how much. The `SGPRB` and `VGPRB` are standard across many ISAs and are the classic scalar general purpose and vector files. I decided to not split integer and floating point further into separate files because i wanted to allow easy bit manipulation on floating point data without having to move back and forth between files, as well as for simplicity and lower amount state. This can increase the register pressure in some situations but the ISA provides instructions that allow efficient data packing and unpacking, thus reclaiming some of the pressure. Another issue could potentially be a higher number of structural hazards as both integer and floating point instructions will read and write to the same bank.

            The `HLPRB` and `PERFCB` are a "nice to have" features for more advanced systems allowing a very granular amount of control over arithmetic edge cases, memory boundary checking, debugging, as well as performance monitoring. Performance counters are a standard feature among modern high performance processors because they are essential in determine what causes stalls and bottlenecks, thus allowing for proper software profiling at the lowest possible level. It is not recommended to perform register renaming on these registers as they are mostly a "set and forget" kind of resources. Instructions that modify these banks should have fence-like semantics.

            The `SPRB` mainly holds privileged registers and flag bits that dictate the behavior of the system while it's running. This bank also holds several registers that are essential for events and other modules to work, as well as privileged resources. It is not recommended to perform register renaming on these registers since they will be modified less often. Instructions that modify this bank should have fence-like semantics.

            This ISA also allows quite large vector widths to accommodate more exotic and special microarchitectures as well as byte-level granularity. The size must be at least twice the `WLEN` up to a maximum of 8 times, except for 32 and 64 bit architectures which stops at 512 bits. This is quite large even for vector heavy specialist machines. Vector execution is also possible at low `WLEN` of 8 and 16 bits but it probably won't be the best idea because of the limited word length. I expect an `MXVL` of 128 to 256 bits to be the most used for general purpose microarchitectures such as CPUs because it gives a good boost in performance for data-independent code, without hindering other aspects of the system such as power consumption, chip area, frequency or resource usage in FPGAs too much. 512 bits will probably be the practical limit as even real commercial CPUs make tradeoffs between width and frequency. For an out-of-order machine the reservation stations and the reorder buffer would already be quite sizeable at 512 bits, however, it's always possible to decouple the two pipelines in order to minimize power and resource usage if a wide `MXVL` is desired.
        ])
    ),

    ///.
    pagebreak(),
    subSection(

        [Application Binary Interface],

        [FabRISC specifies an ABI for the `SGPRB` and `VGPRB`. It is important to note that this is just a suggestion on how the general purpose registers should be used in order to increase code compatibility. As far as the processor is concerned, all general purpose registers are equal and behave in the same way. The register convention for `SGPRB` is the following:],

        tableWrapper([`SGPRB` application binary interface.], table(

            columns: (auto, auto),
            align: (x, y) => (center + horizon, left + horizon).at(x),

            [#middle([*Marker*])], [#middle([*Description*])],

            [$P_i$], [*Parameter Registers*: \ These registers are used for parameter passing and returning to and from function calls. Parameters are stored in these registers starting from the top-down $P_0 -> P_n$, while returning values are stored starting from the bottom-up $P_n -> P_0$. Functions must not modify the value of any unused parameter register.],

            [$S_i$], [*Persistent Registers*: \ These registers are "persistent", that is, registers whose value should be retained across function calls. This implies a "callee-save" calling convention.],

            [$N_i$], [*Volatile Registers*: \ These registers are "volatile" or simply "non-persistent", that is, registers whose value may not be retained across function calls. This implies a "caller-save" calling convention.],

            [SP], [*Stack Pointer*: \ This register is used as a pointer to the top of the call-stack. The calling convention for this register is callee-save.],

            [FP], [*Frame Pointer*: \ This register is used as a pointer to the base of the currently active call-stack frame. The calling convention for this register is callee-save.],

            [GP], [*Global Pointer*: \ This register is used to point to the global variable area and is always accessible across calls. There is no calling convention for this register since it should be a static value for the most part. If modifying is absolutely necessary the responsibility is on the callee to save and restore the old value.],

            [RA], [*Return Address*: \ This register is used to hold the return address for the currently executing function. The calling convention for this register is caller-save.]
        )),

        [Depending on the `SRFS` parameter, the layout of the `SGPRB` will be different. In order to maintain compatibility across different `SRFS` values, the registers are placed at strategic points:],

        tableWrapper([`SGPRB` ABI sizes.], table(

            columns: (auto, auto, auto),
            align: center + horizon,

            [#middle([*SRFS = 0*])], [#middle([*SRFS = 1*])], [#middle([*SRFS = 2*])],

            [`P0`], [`P0`], [`P0` ],
            [`P1`], [`P1`], [`P1` ],
            [`P2`], [`P2`], [`P2` ],
            [`P3`], [`P3`], [`P3` ],
            [`S0`], [`S0`], [`S0` ],
            [`S1`], [`S1`], [`S1` ],
            [`SP`], [`SP`], [`SP` ],
            [`RA`], [`RA`], [`RA` ],
            [-], [`P4`], [`P4` ],
            [-], [`P5`], [`P5` ],
            [-], [`S2`], [`S2` ],
            [-], [`S3`], [`S3` ],
            [-], [`S4`], [`S4` ],
            [-], [`N0`], [`N0` ],
            [-], [`N1`], [`N1` ],
            [-], [`FP`], [`FP` ],
            [-], [-], [`P6` ],
            [-], [-], [`P7` ],
            [-], [-], [`S5` ],
            [-], [-], [`S6` ],
            [-], [-], [`S7` ],
            [-], [-], [`S8` ],
            [-], [-], [`S9` ],
            [-], [-], [`S10`],
            [-], [-], [`S11`],
            [-], [-], [`S12`],
            [-], [-], [`S13`],
            [-], [-], [`S14`],
            [-], [-], [`S15`],
            [-], [-], [`N2` ],
            [-], [-], [`N3` ],
            [-], [-], [`GP` ]
        )),

        [Vector registers are all considered volatile, which means that the caller-save scheme must be utilized since it's assumed that their value won't be retained across function calls. Special instructions are also provided to move these registers, or part of them, to and from the `SGPRB`.],

        [Some compressed instructions are limited in the number of registers that they can address due to their reduced size. The specifiers are 3 bits long allowing the top eight registers to be addressed only. The proposed ABI already accounts for this by placing the most important eight registers at the top of the bank.],

        comment([

            FabRISC is a flexible ISA that offers different amounts of entries in the scalar and vector general purpose register banks. This necessitates of an ABI for each possible size of the bank. The other constraint is the fact that compressed instructions can only address eight registers due to their shorter size. The proposed ABIs have the most important eight registers at the top, in order to make compressed instructions work seamlessly. The ABI for the 16-entry variant is a superset of the 8-entry one and the 32-entry ABI is a superset of all. This allows for complete forwards compatibility between processors with different sizes of the `SGPRB`.
        ])
    ),

    ///.
    subSection(

        [Helper Register Bank],

        [This bank houses the helper registers which, as mentioned earlier, can be used for debugging, address range checks and triggering exceptions. These registers are all `WLEN` bits wide and their operating mode can be programmed via an additional 8 bits attached to each of them. The `HLPR` module requires the implementation of this bank, some special instructions and some exception events. It is important to note that these registers are considered "global" and are not scoped, that is, they are visible to any process at any time regardless of the privilege, however, they are hart private. The operating modes are the following:],

        tableWrapper([Helper register modes.], table(

            columns: (auto, auto),
            align: (x, y) => (right + horizon, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Description*])],

            [  0], [*Disabled*: \ This mode doesn't do anything. Helper registers that are in this mode can still be red and written and utilized at any moment with a caller-save scheme, which simply means, that they are considered volatile.],

            [  1], [*Trigger on read address*: \ This mode will cause the corresponding helper register to generate the `RDT` exception as soon as the hart tries to read data from the specified address.],

            [  2], [*Trigger on write address*: \ This mode will cause the corresponding helper register to generate the `WRT` exception as soon as the hart tries to write data to the specified address.],

            [  3], [*Trigger on execute address*: \ This mode will cause the corresponding helper register to generate the `EXT` exception as soon as the hart tries to fetch the instruction at the specified address.],

            [  4], [*Trigger on read or write address*: \ This mode will cause the corresponding helper register to generate the `RWT` exception as soon as the hart tries to read or write data at the specified address.],

            [  5], [*Trigger on read or write or execute address*: \ This mode will cause the corresponding helper register to generate the `RWET` exception as soon as the hart tries to read, write data or fetch the instruction at the specified address.],

            [  6], [*Trigger on read range*: \ This mode will cause the corresponding helper register to generate the `RDT` exception as soon as the hart tries to read data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the helper register immediately after the specified one and its mode will be set to 255.],

            [  7], [*Trigger on write range*: \ This mode will cause the corresponding helper register to generate the `WRT` exception as soon as the hart tries to write data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the helper register immediately after the specified one and its mode will be set to 255.],

            [  8], [*Trigger on execute range*: \ This mode will cause the corresponding helper register to generate the `EXT` exception as soon as the hart tries to fetch an instruction outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the helper register immediately after the specified one and its mode will be set to 255.],

            [  9], [*Trigger on read or write range*: \ This mode will cause the corresponding helper register to generate the `RWT` exception as soon as the hart tries to read or write data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the helper register immediately after the specified one and its mode will be set to 255.],

            [ 10], [*Trigger on read or write or execute range*: \ This mode will cause the corresponding helper register to generate the `RWET` exception as soon as the hart tries to read, write data or fetch an instruction outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the helper register immediately after the specified one and its mode will be set to 255.],

            [ 11], [*Trigger on COVR1 flag*: \ This mode will cause the corresponding helper register to generate the `COVR1T` exception as soon as the `COVR1` flag is raised at the instruction address held in the current register.],

            [ 12], [*Trigger on COVR2 flag*: \ This mode will cause the corresponding helper register to generate the `COVR2T` exception as soon as the `COVR2` flag is raised at the instruction address held in the current register.],

            [ 13], [*Trigger on COVR4 flag*: \ This mode will cause the corresponding helper register to generate the `COVR4T` exception as soon as the `COVR4` flag is raised at the instruction address held in the current register.],

            [ 14], [*Trigger on COVR8 flag*: \ This mode will cause the corresponding helper register to generate the `COVR8T` exception as soon as the `COVR8` flag is raised at the instruction address held in the current register.],

            [ 15], [*Trigger on CUND flag*: \ This mode will cause the corresponding helper register to generate the `CUNDT` exception as soon as the `CUND` flag is raised at the instruction address held in the current register.],

            [ 16], [*Trigger on OVFL1 flag*: \ This mode will cause the corresponding helper register to generate the `OVFL1T` exception as soon as the `OVFL1` flag is raised at the instruction address held in the current register.],

            [ 17], [*Trigger on OVFL2 flag*: \ This mode will cause the corresponding helper register to generate the `OVFL2T` exception as soon as the `OVFL2` flag is raised at the instruction address held in the current register.],

            [ 18], [*Trigger on OVFL4 flag*: \ This mode will cause the corresponding helper register to generate the `OVFL4T` exception as soon as the `OVFL4` flag is raised at the instruction address held in the current register.],

            [ 19], [*Trigger on OVFL8 flag*: \ This mode will cause the corresponding helper register to generate the `OVFL8T` exception as soon as the `OVFL8` flag is raised at the instruction address held in the current register.],

            [ 20], [*Trigger on UNFL1 flag*: \ This mode will cause the corresponding helper register to generate the `UNFL1T` exception as soon as the `UNFL1` flag is raised at the instruction address held in the current register.],

            [ 21], [*Trigger on UNFL2 flag*: \ This mode will cause the corresponding helper register to generate the `UNFL2T` exception as soon as the `UNFL2` flag is raised at the instruction address held in the current register.],

            [ 22], [*Trigger on UNFL4 flag*: \ This mode will cause the corresponding helper register to generate the `UNFL4T` exception as soon as the `UNFL4` flag is raised at the instruction address held in the current register.],

            [ 23], [*Trigger on UNFL8 flag*: \ This mode will cause the corresponding helper register to generate the `UNFL8T` exception as soon as the `UNFL8` flag is raised at the instruction address held in the current register.],

            [ 24], [*Trigger on DIV0 flag*: \ This mode will cause the corresponding helper register to generate the `DIV0T` exception as soon as the `DIV0` flag is raised at the instruction address held in the current register.],

            [ 25], [*Trigger on INVOP flag*: \ This mode will cause the corresponding helper register to generate the `INVOPT` exception as soon as the `INVOP` flag is raised at the instruction address held in the current register.],

            [ 26], [Reserved for future uses.],
            [...], [...],
            [127], [Reserved for future uses.],

            [128], [Left as a free slot for implementation specific features.],
            [...], [...],
            [254], [Left as a free slot for implementation specific features.],

            [255], [*Range end*: \ This mode simply signifies that the corresponding register value is the end of an address range started by the previous register. If the previous register does not specify an address range, then this mode will behave in the same way as mode 0.]
        )),

        [If multiple helper registers specify ranges, those ranges must be AND-ed together in order to allow proper automatic boundary checking.],

        [If multiple same events are triggered in the same cycle, then they must be queued to avoid loss of information. The ordering convention, in case multiple events are generated for the same instruction address, gives the $"HLPR"_0$ the highest priority and $"HLPR"_n$ the lowest.],

        [It is important to note that the `COVRnT`, `CUNDT`, `OVFLnT` and `UNFLnT` events must overwrite the `COVRE`, `CUNDE`, `OVFLE`, `UNFLE` and `DIV0E` arithmetic exceptions of the `EXC` module if present, where $n = 1/8 dot 2^"WLEN"$. This means that the listed events take precedence and suppress the standard arithmetic exceptions when both are triggered.],

        comment([

            This bank can be used to aid the programmer in a variety of situations. A big one is memory safety: by specifying address ranges on instruction fetch, loads and stores, the system can automatically throw the appropriate exception / traps when the constraint is violated without explicitly checking with a branch each time. This is helpful to avoid unintentionally overwriting portions of memory, thus reducing chances of exploits and increase memory safety with no performance hit. The triggered events can be caught in order to execute handling / recovery code without needing to invoke the operative system.

            Another situation is debugging: by placing the desired breakpoints in the desired spots of the program, exceptions can be triggered and handled to perform things like memory / state dumping, or any other action that might help the programmer understand what is going on in the system. All of this can be achieved with near zero performance penalty and interference with the actual code.

            One final application can be in handling unavoidable arithmetic edge cases without performance penalties, enabling safer arithmetic as well as aiding arbitrary precision data types.

            Additionally, these registers can also be used as an extra `SGPRB`.
        ])
    ),

    ///.
    pagebreak(),
    subSection(

        [Performance Counters Bank],

        [This bank houses the performance counters which, as mentioned earlier, can be used for performance diagnostic, timers and counters. These registers are all `CLEN` bits wide and their operating mode can be programmed via an extra 8 bits attached to each of them. The `PERFC` module requires the implementation of this bank and some special instructions. It is important to note that if a counter reaches its maximum value, it will silently overflow. These registers are considered "global" and are not scoped, that is, they are visible to any process at any time regardless of the privilege, however, they are hart private. The operating modes are the following:],

        tableWrapper([Performance counter modes.], table(

            columns: (auto, auto),
            align: (x, y) => (right + horizon, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Description*])],

            [  0], [*Disabled*: \ This mode doesn't do anything. Performance counters that are in this mode can still be red and written and utilized at any moment with a caller-save scheme, which simply means, that they are considered volatile.],

            [  1], [*Instruction counter*: \ This mode is a simple instruction counter that increments with each executed instruction.],

            [  2], [*Memory load counter*: \ This mode is a simple instruction counter that increments with each executed memory load instruction.],

            [  3], [*Memory store counter*: \ This mode is a simple instruction counter that increments with each executed memory store instruction.],

            [  4], [*Taken branch counter*: \ This mode, is a simple instruction counter that increments with each taken conditional branch.],

            [  5], [*Non taken branch counter*: \ This mode is a simple instruction counter that increments with each non-taken conditional branch.],

            [  6], [*Stalled cycles counter*: \ This mode is a simple counter that increments with each clock cycle in which the cpu was stalled.],

            [  7], [*Time counter*: \ This mode is a simple timer that counts thread-time seconds.],

            [  8], [*Time counter*: \ This mode is a simple timer that counts thread-time milliseconds. The `ILLI` fault must be thrown if the system is not capable of ticking counters with speeds of 1KHz.],

            [  9], [*Time counter*: \ This mode is a simple timer that counts thread-time microseconds. The `ILLI` fault must be thrown if the system is not capable of ticking counters with speeds of 1MHz.],

            [ 10], [*Time counter*: \ This mode is a simple timer that counts thread-time nanoseconds. The `ILLI` fault must be thrown if the system is not capable of ticking counters with speeds of 1GHz.],

            [ 11], [*Clock counter*: \ This mode is a simple clock cycle counter. Sixteen codes are reserved and each subsequent code will divide the frequency of the previous mode by two before triggering the counter.],

            [ 27], [Reserved for future uses.],
            [...], [...],
            [127], [Reserved for future uses.],

            [128], [Left as a free slot for implementation specific features.],
            [...], [...],
            [255], [Left as a free slot for implementation specific features.]
        )),

        [FabRISC provides the *Counter Length* (`CLEN`) 2 bit ISA parameter, indicates the bit width of the performance counters in bits. If the system doesn't support the `PERFC` module, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the following table:],

        tableWrapper([`PERFCB` sizes.], table(

            columns: (15%, 20%),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [00], [8 bits. ],
            [01], [16 bits.],
            [10], [32 bits.],
            [11], [64 bits.]
        )),

        pagebreak(),
        comment([

            This bank is a very powerful tool when it comes to performance diagnostics and monitoring. Once configured, the counters will keep track of the desired metrics throughout the lifetime of the program. Common statistics, beyond the basic ones mentioned in the table, are often cache hits / misses, TLB hits / misses, BTB hits / misses, branch misspredictions, stalls and many others.

            I wanted to leave as much freedom to the hardware designers as possible here as it can depend a lot on how the microarchitecture is implemented.
        ])
    ),

    ///.
    subSection(

        [Special Purpose Bank],

        [In this subsection the special purpose registers are discussed. Some of these registers are unprivileged, that is, accessible to any process at any time regardless of the privilege, while others are machine mode only and the `ILLI` fault must be triggered if an access is performed in user mode to those resources. These registers are also hart private. The special purpose registers are the following:],

        tableWrapper([`SPRB` layout.], table(

            columns: (auto, auto, auto),
            align: (x, y) => (left + horizon, left + horizon, left + horizon, left + horizon).at(x),

            [#middle([*Short*])], [#middle([*Size*])], [#middle([*Description*])],

            [`PC`], [`WLEN`], [*Program Counter*: \ This register points to the currently executing instruction. This register is not privileged and is always mandatory.],

            [`SR`], [32 bits], [*Status Register*: \ This register holds several flags that keep track of the current status of the processor. This register is semi-privileged and is always mandatory. Depending on which modules are implemented, only certain bits must be present while the others can be ignored and set to zero as a default. The precise bit layout and privileges will be discussed in the next section.],

            [`VSH`], [8 bits], [*Vector Shape*: \ This register specifies the current vector configuration and is divided into two parts: the most significant two bits specify the size of the singular element, while the remaining least significant bits specify the number of active elements. Illegal configurations must generate the `ILLI` fault. This register is not privileged and is only needed when the system implements the `VC` module, otherwise the default vector shape must always dictate the maximum number of `WLEN` sized elements.],

            [`UEPC`], [`WLEN`], [*User Event PC*: \ This register holds the `PC` of the last instruction before the user event handler, which can then be used to return back from it. This register has the same privilege as the `PC` and is needed if the system implements the `USER` module.],

            [`UESR`], [32 bits], [*User Event Status Register*: \ This register holds the latest `SR` just before the user event handler, which can then be used to restore the `SR` when returning from it. This register has the same privilege as the `SR` and is only needed when the system implements the `USER` module.],

            [`UEC`], [16 bits], [*User Event Cause*: \ This register holds the id of which event caused the current hart to trap in the least significant 9 bits, as well as some optional extra information in the remaining bits (event specific). This register is not privileged and is only needed when the system implements the `USER` module.],

            [`UED`], [`WLEN`], [*User Event Data*: \ This register holds the event data (event specific). This register is not privileged and is only needed when the system implements the `USER` module.],

            [`UEHP`], [`WLEN`], [*User Event Handler Pointer*: \ This register holds the address of the user event handler. The handler must always be one for all events. A switch statement with the help of the event id can then be used to jump to the specific handler. This register is not privileged and is only needed when the system implements the `USER` module.],

            [`UET0`], [`WLEN`], [*User Event Temporary 0*: \ This register can be used as a temporary general purpose register during event handling, often for saving and restoring the various banks. This register is not privileged and is only needed when the system implements the `USER` module.],

            [`UET1`], [`WLEN`], [*User Event Temporary 1*: \ This register can be used as a temporary general purpose register during event handling, often for saving and restoring the various banks. This register is not privileged and is only needed when the system implements the `USER` module.],

            [`MEPC`], [`WLEN`], [*Machine Event PC*: \ This register holds the `PC` of the last instruction before the machine event handler, which can then be used to return back from it. This register is privileged and is only needed when the system implements one or more of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MESR`], [32 bits], [*Machine Event SR*: \ This register holds the latest `SR` before the machine event handler, which can then be used to restore the `SR` when returning from it. This register is privileged and is only needed when the system implements one or more of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MEC`], [16 bits], [*Machine Event Cause*: \ This register holds the id of which event caused the current hart to trap in the least significant 9 bits, as well as some extra information in the remaining bits (event specific). This register is privileged and is only needed when the system implements one or more of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MED`], [`WLEN`], [*Machine Event Data*: \ This register holds the event data (event specific). This register is privileged and is only needed when the system implements one or more of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MEHP`], [`WLEN`], [*Machine Event Handler Pointer*: \ This register holds the address of the machine event handler. The handler must always be one for all events. A switch statement with the help of the event id can then be used to jump to the specific handler. This register is privileged and is only needed when the system implements one or more of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MET0`], [`WLEN`], [*Machine Event Temporary 0*: \ This register can be used as a temporary register during event handling, often for saving and restoring the various banks. This register is privileged and is only needed when the system implements one or more of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MET1`], [`WLEN`], [*Machine Event Temporary 1*: \ This register can be used as a temporary register during event handling, often for saving and restoring the various banks. This register is privileged and is only needed when the system implements one or more of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`PFPA`], [`WLEN`], [*Page Fault Physical Address*: \ This register holds the page table physical address of the currently running process. This register is privileged and is only needed when the system implements the `USER` module.],

            [`PID`], [32 bit], [*Process ID*: \ This register holds the id of the currently running process. This register is privileged and is only needed when the system implements the `USER` module.],

            [`TID`], [32 bit], [*Thread ID*: \ This register holds the id of the currently running process thread. This register is privileged and is only needed when the system implements the `USER` module.],

            [`TPTR`], [`WLEN`], [*Thread Pointer*: \ This register holds the pointer to the currently running software thread. This register is privileged and is only needed when the system implements the `USER` module.],

            [`WDT`], [32 bit], [*Watchdog Timer*: \ This register is a counter that periodically count down and triggers the `TQE` event when it reaches zero. This register is privileged and is only needed when the system implements the `USER` module.]

            // 10 free slots remaining
        )),

        [FabRISC dictates the implementation of some mandatory fault events, such as: `MISI`, `INCI`, `ILLI` and others which require the presence of the machine event special purpose registers. Such registers are, however, not necessary if the system implements the said faults by simply halting the machine. This relaxes the constraint on simple implementations that don't support events or don't want to handle them.],

        comment([

            This bank houses a variety of registers used to alter and change the behavior of the system while it operates. Many of the modules will require the presence of some special purpose registers in order to function such as vector extensions, transaction module, helper registers, performance counters and others.

            The registers prefixed with "User Event" or "Machine Event" hold the so called "critical state" of the hart, that is, state that is particularly delicate for event handling in privileged and non privileged implementations. Access to privileged resources in user mode is forbidden and blocked in order to protect the operating system from exploits, as well as ensuring that the ISA remains classically virtualizable.

            Hardware designers are free to perform renaming of these registers if they so wish. Alternatively, a write to any special register must hold fence-like semantics, that is, the hart must hold execution of all subsequent instructions until the write is complete. This allows any modification to this bank to be visible by the rest of the system.
        ])
    ),

    ///.
    pagebreak(),
    subSection(

        [Status Register Bit Layout],

        [In this section the Status Register bit layout is discussed. The `SR` contains several flags and status bits of different privilege levels and the bits that the system must implement depend on which modules are chosen. It is important to note that when some bits are not needed and or are fixed values, any write operation to those bits should be silently discarded and should not produce any visible architectural and microarchitectural changes. The possible bits are explained in the following table:],

        tableWrapper([`SR` bit layout.], table(

            columns: (auto, auto, auto),
            align: (x, y) => (left + horizon, left + horizon, left + horizon, left + horizon).at(x),

            [#middle([*Short*])], [#middle([*Size*])], [#middle([*Description*])],

            [`RMD`], [3 bits], [*FP Rounding Mode*: \ Dictates the current floating point rounding mode. `RMD` is not privileged, only needed when the system implements the `FRMD` module and, if not present, the default mode must always be _round to nearest even_. The possible modes are IEEE-754 compliant and are:

                #enum(tight: false,

                    [_Round to nearest even._],
                    [_Round to nearest away from zero._],
                    [_Round towards zero._],
                    [_Round towards negative infinity._],
                    [_Round towards positive infinity._],
                    [_Reserved for future use._],
                    [_Reserved for future use._],
                    [_Reserved for future use._]
                )
            ],

            [`CMD`], [1 bit], [*Consistency Mode*: \ Dictates the current memory consistency model: zero for relaxed and one for sequential. `CMD` is not privileged and is only needed when the system implements the `FNC` module, otherwise the default must always be _sequential consistency_.],

            [`GEE`], [2 bit], [*Global Arithmetic Exceptions Enable*: \ Enables or disables immediate traps on arithmetic exceptions.  The arithmetic flags must always be generated if the `HLPR` module is implemented, regardless of the value of these bits. `GEE` is not privileged and is only needed when the `EXC` module is implemented, otherwise the default value must always be _all disabled_. The enable modes are:

                #enum(tight: false,

                    [_All disabled._],
                    [_Enable integer arithmetic exceptions._],
                    [_Enable FP arithmetic exceptions._],
                    [_Enable integer and FP arithmetic exceptions._],
                )
            ],

            [`HLPRE`], [4 bits], [*HLPR Enable*: \ Enables or disables portions the `HLPRB` in chunks of eight registers. `HLPRE` is not privileged and only needed when the system implements the `HLPR` module, otherwise the default value must always be zero.],

            [`PERFCE`], [1 bit], [*PERFC Enable*: \ Enables or disables the `PERFCB`. `PERFCE` is not privileged and only needed when the system implements the `PERFC` module, otherwise the default value must always be zero.],

            [`IM`], [4 bits], [*Interrupt Mask*: \ Masks the interrupts: the first two bits mask _IO-interrupts_ and the last two bits mask _IPC-interrupts_. Each bit masks chunks of 16 interrupts. `IM` is privileged and only needed when the system implements the `IOINT`, `IPCINT` or both, otherwise the default value must always be zero.],

            [`PMOD`], [2 bits], [*Privilege Mode*: \ Dictates the current hart privilege level. `PMOD` is privileged and only needed when the system implements the `USER` module, otherwise the default value must always be zero. The possible modes are:

                #enum(tight: false,

                    [_Machine mode._],
                    [_User mode._],
                    [_Reserved for future use._],
                    [_Reserved for future use._]
                )
            ],

            [`WDTE`], [1 bit], [*Watchdog Timer Enable*: \ Enables or disables the `WDT` register. `WDTE` is privileged and only needed when the system implements the `USER` module, otherwise the default value must always be zero.],

            [`PWRS`], [4 bit], [*Power State*: \ Holds the current hart power state. The actual possible values are implementation specific and left to the hardware designers to define. `PWRS` is privileged and only needed when the system implements the `SA` module, otherwise the default value must always be zero.],

            [`HLTS`], [3 bit], [*Halt State*: \ Holds the current hart halting state. `HLTS` is privileged, always mandatory and can only be changed via the `HLT`, `WINT` instructions or via interrupts. The possible states are:

                #enum(tight: false,

                    [_Not halted._],
                    [_Explicit halt: the halt was caused by the HLT instruction._],
                    [_Waiting for interrupt._],
                    [_Double event halt: the halt was caused by the "double event" situation._],
                    [_Too many events halt: the halt was caused by the filling of the synchronous event queues._],
                    [_Reserved for future use._],
                    [_Reserved for future use._],
                    [_Reserved for future use._]
                )
            ]

            // 7 bits left
        ))
    ),

    ///.
    //pagebreak(),
    subSection(

        [Configuration Segment],

        [In previous sections, this document introduced several different configuration constants, which describe the features, that any system must have in order to be considered compliant to the FabRISC architecture. These parameters must be stored in a dedicated static, read-only memory-like region that is byte addressable. Some of these parameters are global for all harts, while others are private. The parameters are all unprivileged and are listed in the following table:],

        tableWrapper([Configuration segment.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (right + horizon, right + horizon, left + horizon, left + horizon, left + horizon).at(x),

            [#middle([*Start*])], [#middle([*End*])], [#middle([*Parameter*])], [#middle([*Visibility*])], [#middle([*Description*])],

            [   0], [   1], [`HID`     ], [Private], [Unique identifier of the current hart.],
            [   2], [   9], [`ISAMOD`  ], [Private], [See section 2 for more information.],
            [  10], [  11], [`ISAVER`  ], [Private], [See section 2 for more information.],
            [  12], [  12], [`WLEN`    ], [Private], [See section 6 for more information.],
            [  13], [  13], [`MXVL`    ], [Private], [See section 6 for more information.],
            [  14], [  14], [`CLEN`    ], [Private], [See section 6 for more information.],
            [  15], [  15], [`SRFS`    ], [Private], [See section 6 for more information.],
            [  16], [  16], [`VRFS`    ], [Private], [See section 6 for more information.],
            [  17], [  17], [`HRFS`    ], [Private], [See section 6 for more information.],
            [  18], [  18], [`CRFS`    ], [Private], [See section 6 for more information.],

            [  19], [  26], [`CPUID`   ], [Global ], [Unique CPU identifier.],
            [  27], [  34], [`CPUVID`  ], [Global ], [Unique CPU vendor identifier.],
            [  35], [ 162], [`CPUNAME` ], [Global ], [CPU name.],
            [ 163], [ 164], [`NCORES`  ], [Global ], [Number of physical CPU cores.],
            [ 165], [ 166], [`NTHREADS`], [Global ], [Number of logical CPU cores per physical core (hardware threads or harts).],
            [ 167], [ 167], [`IOS`     ], [Global ], [See section 5 for more information.],
            [ 168], [ 168], [`DMAMOD`  ], [Global ], [See section 5 for more information.],
            [ 169], [ 169], [`DMAS`    ], [Global ], [See section 5 for more information.],

            [ 170], [ 255], [-], [-], [Reserved for future uses.],
            [ 256], [1023], [-], [-], [Left as implementation specific.],
        )),

        comment([

            These read-only parameters describe the hardware configuration and capabilities. Some have already been explained in earlier sections, while others are new. Global parameters are the same for all harts in the system, while private parameters depends on which hart is targeted.

            The majority of this region is left as implementation specific since it can be used to write information about the specific microarchitecture, such as cache, TLB organizations and other internal structures.

            Presenting this information in a clear way is a very powerful tool that allows to dynamically dispatch specific machine code for the specific target microarchitecture, improving performance and efficiency.
        ])
    )
)

#pagebreak()

///
