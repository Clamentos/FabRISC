///
#import "Macros.typ": *
#import "@preview/tablex:0.0.5": tablex, colspanx, rowspanx

///
#section(

    [ISA specification],

    [In this section the register file organization, vector model, operating modes, events, privileged resources and instruction formats of the FabRISC architecture are presented.],

    ///.
    subSection(

        [Register file],

        [Depending on which modules are chosen as well as the ISA parameter values, the register file can be composed of up to five different banks of variable width registers, along with extra special purpose ones mainly used for status and configuration. The banks are briefly described in the following table:],

        align(center, table(

            columns: (16fr, 84fr),
            inset: 8pt,
            align: left + horizon,
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Name*])], [#align(center, [*Description*])],

            [SGPRB], [*Scalar General Purpose Register Bank*: \ This bank is composed of SRFS number of registers which can be used to hold data during program execution. The registers are all WLEN bits wide and are used by scalar integer and floating point instructions together. These registers are not privileged, private for each hart and must always be implemented.],

            [VGPRB], [*Vector general purpose register bank*: \ This bank is composed of VRFS number of registers which can be used to hold data during program execution. The registers are all MXVL bits wide and are used by vector integer and floating point instructions together. These registers are not privileged, private for each hart and are only needed when the system implements any vector related module.],

            [HLPRB], [*Helper register bank*: \ This bank is composed of HRFS number of registers which can be used for debugging, automatic address boundary checking as well as triggering exceptions in precise occasions. These registers are all $"WLEN" + 8$ bits wide, not privileged, private for each hart and are only needed when the system implements the HLPR module.],

            [PERFCB], [*Performance counter bank*: \ This bank is composed of CRFS number of registers which can be used for performance diagnostic, timers and counters. These registers are all $"CLEN" + 8$ bits wide, not privileged, private for each hart and are only needed when the system implements the PERFC module.],

            [SPRB], [*Special purpose register bank*: \ This bank is composed of various special purpose registers used to keep track of the system status and operation. The number of these registers as well as their width can vary depending on which modules are chosen plus some are privileged, while others are not.]
        )),

        [FabRISC provides the *Scalar Register File Size (SRFS)* 2-bit ISA parameter, to indicate the number of registers of the scalar file. Depending on the value of this parameter, the calling convention will differ slightly. The possible values are listed in the following table:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [00], [8 entries.],
            [01], [16 entries.],
            [10], [32 entries.],
            [11], [Reserved for future uses.]
        )),

        [FabRISC provides the *Vector Register File Size (VRFS)* 2-bit ISA parameter, to indicate the number of registers of the vector file. If the system doesn't support any module that necessitates the vector register file, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the table below:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [00], [8 entries.],
            [01], [16 entries.],
            [10], [32 entries.],
            [11], [Reserved for future uses.]
        )),

        [FabRISC provides the *Maximum Vector Length (MXVL)* 3-bit ISA parameter, to indicate the maximum vector length in bits. If the system doesn't support any vector capability, then this parameter must be set to zero for convention. The possible values are listed in the following table:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [000], [No vector capabilities present.],
            [001], [16-bit long for 8-bit processors ($"WLEN" = 0$).],
            [010], [32-bit long for 8 and 16-bit processors ($"WLEN" = 0, 1$).],
            [011], [64-bit long for 8, 16 and 32-bit processors ($"WLEN" = 0, 1, 2$).],
            [100], [128-bit long for 8, 16, 32 and 64-bit processors ($"WLEN" = 1, 2, 3$).],
            [101], [256-bit long for 8, 16, 32 and 64-bit processors ($"WLEN" = 2, 3$).],
            [110], [512-bit long for 16, 32 and 64-bit processors ($"WLEN" = 3$).],
            [111], [Reserved for future uses.],
        )),

        [FabRISC provides the *Helper Register File Size (HRFS)* 2-bit ISA parameter, to indicate the number of registers of the helper file. If the system doesn't support the HLPR module, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the table below:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [00], [8 entries.],
            [01], [16 entries.],
            [10], [32 entries.],
            [11], [Reserved for future uses.]
        )),

        [FabRISC provides the *Counter Register File Size (CRFS)* 2-bit ISA parameter, to indicate the number of registers of the performance counter file. If the system doesn't support the PERFC module, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the table below:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [00], [8 entries.],
            [01], [16 entries.],
            [10], [32 entries.],
            [11], [Reserved for future uses.]
        )),

        comment([

            Five banks of several registers might seem overkill, but thanks to FabRISC flexibility the hardware designers can choose only what they desire and how much. The SGPRB and VGPRB are standard across many ISAs and are the classic scalar general purpose and vector files. I decided to not split integer and floating point further into separate files because i wanted to allow easy bit fiddling on floating point data without having to move back and forth between files, as well as for simplicity and lower amount state. This can increase the register pressure in some situations but the ISA provides instructions that allow efficient data packing and unpacking, thus reclaiming some, if not all, of the pressure. Another issue could potentially be a higher number of structural hazards as both integer and floating point instructions will read and write to the same bank.

            The HLPRB and PERFCB are a "nice to have" features for more advanced systems allowing a very granular amount of control over arithmetic edge cases, memory boundary checking, debugging, as well as performance monitoring. Performance counters are a standard feature among modern high performance processors because they are essential in determine what causes stalls and bottlenecks, thus allowing for proper software profiling. It is not recommended to perform register renaming on these registers as they are mostly a "set and forget" kind of resources. Instructions that modify these banks should behave in a similar manner to fences (see section 7 for more information).

            The SPRB mainly holds privileged registers and flag bits that dictate the behavior of the system while it's running. This bank also holds several registers that are essential for events and other modules to work, as well as privileged resources. It is not recommended to perform register renaming on these registers since they will be modified less often. Instructions that modify these banks should behave in a similar manner to fences (see section 7 for more information).

            This ISA also allows quite large vector widths to accommodate more exotic and special microarchitectures as well as byte-level granularity. The size must be at least twice the WLEN up to a maximum of 8 times, except for 32 and 64-bit architectures which stops at 512 bits. This is quite large even for vector-heavy specialist machines. Vector execution is also possible at low WLEN of 8 and 16-bits but it probably won't be the best idea because of the limited word length. I expect an MXVL of 128 to 256 bits to be the most used for general purpose microarchitectures such as CPUs because it gives a good boost in performance for data-independent code, without hindering other aspects of the system such as power consumption, chip area, frequency or resource usage in FPGAs too much. 512 bits will probably be the practical limit as even real commercial CPUs make tradeoffs between width and frequency. For an out-of-order machine the reservation stations and the reorder buffer would already be quite sizeable at 512 bits, however, it's always possible to decouple the two pipelines in order to minimize power and resource usage if a wide MXVL, such as this, is desired.
        ])
    ),

    ///.
    subSection(

        [Register ABI],

        [FabRISC specifies an ABI (application binary interface) for the SGPRB and VGPRB. It is important to note that this is just a suggestion on how the general purpose registers should be used in order to increase code compatibility. As far as the processor is concerned, all general purpose registers are equal and behave in the same way. The register convention for SGPRB is the following:],

        align(center, table(

            columns: (15fr, 85fr),
            inset: 8pt,
            align: (x, y) => (center + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Marker*])], [#align(center, [*Description*])],

            [$P_i$], [*Parameter registers*: \ These registers are used for parameter passing and returning to and from function calls. Parameters are stored in these registers starting from the top-down $P_0 -> P_n$, while returning values are stored starting from the bottom-up $P_n -> P_0$. Functions must not modify the value of any unused parameter register.],

            [$S_i$], [*Persistent registers*: \ These registers are "persistent", that is, registers whose value should be retained across function calls. This implies a "callee-save" calling convention.],

            [$N_i$], [*Volatile registers*: \ These registers are "volatile" or simply "non-persistent", that is, registers whose value may not be retained across function calls. This implies a "caller-save" calling convention.],

            [SP], [*Stack pointer*: \ This register is used as a pointer to the top of the call-stack. The calling convention for this register is callee-save.],

            [FP], [*Frame pointer*: \ This register is used as a pointer to the base of the currently active call-stack frame. The calling convention for this register is callee-save.],

            [GP], [*Global pointer*: \ This register is used to point to the global variable area and is always accessible across calls. There is no calling convention for this register since it should be a static value for the most part. If modifying is absolutely necessary the responsibility is on the callee to save and restore the old value.],

            [RA], [*Return address*: \ This register is used to hold the return address for the currently executing function. The calling convention for this register is caller-save.]
        )),

        [Depending on the SRFS parameter, the layout of the SGPRB will be different. In order to maintain compatibility across different SRFS values, the registers are placed at strategic points:],

        align(center, table(

            columns: (33fr, 33fr, 33fr),
            inset: 8pt,
            align: center + horizon,
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*SRFS = 0*])], [#align(center, [*SRFS = 1*])], [#align(center, [*SRFS = 2*])],

            [P0], [P0], [P0 ],
            [P1], [P1], [P1 ],
            [P2], [P2], [P2 ],
            [P3], [P3], [P3 ],
            [S0], [S0], [S0 ],
            [S1], [S1], [S1 ],
            [SP], [SP], [SP ],
            [RA], [RA], [RA ],
            [ -], [P4], [P4 ],
            [ -], [P5], [P5 ],
            [ -], [S2], [S2 ],
            [ -], [S3], [S3 ],
            [ -], [S4], [S4 ],
            [ -], [N0], [N0 ],
            [ -], [N1], [N1 ],
            [ -], [FP], [FP ],
            [ -], [ -], [P6 ],
            [ -], [ -], [P7 ],
            [ -], [ -], [S5 ],
            [ -], [ -], [S6 ],
            [ -], [ -], [S7 ],
            [ -], [ -], [S8 ],
            [ -], [ -], [S9 ],
            [ -], [ -], [S10],
            [ -], [ -], [S11],
            [ -], [ -], [S12],
            [ -], [ -], [S13],
            [ -], [ -], [S14],
            [ -], [ -], [S15],
            [ -], [ -], [N2 ],
            [ -], [ -], [N3 ],
            [ -], [ -], [GP ]
        )),

        [Vector registers are all considered volatile, which means that the caller-save scheme must be utilized since it's assumed that their value won't be retained across function calls. Special instructions are also provided to move these registers, or part of them, to and from the SGPRB (see section 7 for more information).],

        [Some compressed instructions are limited in the number of registers that they can address due to their reduced size. The specifiers are 3-bit long allowing the top eight registers to be addressed only. The proposed ABI already accounts for this by placing the most important eight registers at the top of the bank.],

        comment([

            FabRISC is a flexible ISA that offers different amounts of entries in the scalar and vector general purpose register banks. This necessitates of an ABI for each possible size of the bank. The other constraint is the fact that compressed instructions can only address eight registers due to their shorter size. The proposed ABIs have the most important eight registers at the top, in order to make compressed instructions work seamlessly. The ABI for the 16-entry variant is a superset of the 8-entry one and the 32-entry ABI is a superset of all. This allows for complete forwards compatibility between processors with different sizes of the SGPRB.
        ])
    ),

    ///.
    subSection(

        [Helper register bank],

        [This bank houses the helper registers which, as mentioned earlier, can be used for debugging, address range checks and triggering exceptions. These registers are all WLEN bits wide and their operating mode can be programmed via an additional 8-bits attached to each of them. The HLPR module requires the implementation of this bank, some special instructions (see section 7 for more information) and some exception events. It is important to note that these registers are considered "global" and are not scoped, that is, they are visible to any process at any time regardless of the privilege, however, they are hart private. The operating modes are the following:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (right + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Description*])],

            [  0], [*Disabled*: \ This mode doesn't do anything. Helper registers that are in this mode can still be red and written and utilized at any moment with a caller-save scheme, which simply means, that they are considered volatile.],

            [  1], [*Trigger on read address*: \ This mode will cause the corresponding helper register to generate the RDT exception as soon as the hart tries to read data from the specified address.],

            [  2], [*Trigger on write address*: \ This mode will cause the corresponding helper register to generate the WRT exception as soon as the hart tries to write data to the specified address.],

            [  3], [*Trigger on execute address*: \ This mode will cause the corresponding helper register to generate the EXT exception as soon as the hart tries to fetch the instruction at the specified address.],

            [  4], [*Trigger on read or write address*: \ This mode will cause the corresponding helper register to generate the RWT exception as soon as the hart tries to read or write data at the specified address.],

            [  5], [*Trigger on read or write or execute address*: \ This mode will cause the corresponding helper register to generate the RWET exception as soon as the hart tries to read, write data or fetch the instruction at the specified address.],

            [  6], [*Trigger on read range*: \ This mode will cause the corresponding helper register to generate the RDT exception as soon as the hart tries to read data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be set to 255.],

            [  7], [*Trigger on write range*: \ This mode will cause the corresponding helper register to generate the WRT exception as soon as the hart tries to write data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be set to 255.],

            [  8], [*Trigger on execute range*: \ This mode will cause the corresponding helper register to generate the EXT exception as soon as the hart tries to fetch an instruction outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be set to 255.],

            [  9], [*Trigger on read or write range*: \ This mode will cause the corresponding helper register to generate the RWT exception as soon as the hart tries to read or write data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be set to 255.],

            [ 10], [*Trigger on read or write or execute range*: \ This mode will cause the corresponding helper register to generate the RWET exception as soon as the hart tries to read, write data or fetch an instruction outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be set to 255.],

            [ 11], [*Trigger on COVR1 flag*: \ This mode will cause the corresponding helper register to generate the COVR1T exception as soon as the COVR1 flag is raised at the instruction address held in the current register.],

            [ 12], [*Trigger on COVR2 flag*: \ This mode will cause the corresponding helper register to generate the COVR2T exception as soon as the COVR2 flag is raised at the instruction address held in the current register.],

            [ 13], [*Trigger on COVR4 flag*: \ This mode will cause the corresponding helper register to generate the COVR4T exception as soon as the COVR4 flag is raised at the instruction address held in the current register.],

            [ 14], [*Trigger on COVR8 flag*: \ This mode will cause the corresponding helper register to generate the COVR8T exception as soon as the COVR8 flag is raised at the instruction address held in the current register.],

            [ 15], [*Trigger on CUND flag*: \ This mode will cause the corresponding helper register to generate the CUNDT exception as soon as the CUND flag is raised at the instruction address held in the current register.],

            [ 16], [*Trigger on OVFL1 flag*: \ This mode will cause the corresponding helper register to generate the OVFL1T exception as soon as the OVFL1 flag is raised at the instruction address held in the current register.],

            [ 17], [*Trigger on OVFL2 flag*: \ This mode will cause the corresponding helper register to generate the OVFL2T exception as soon as the OVFL2 flag is raised at the instruction address held in the current register.],

            [ 18], [*Trigger on OVFL4 flag*: \ This mode will cause the corresponding helper register to generate the OVFL4T exception as soon as the OVFL4 flag is raised at the instruction address held in the current register.],

            [ 19], [*Trigger on OVFL8 flag*: \ This mode will cause the corresponding helper register to generate the OVFL8T exception as soon as the OVFL8 flag is raised at the instruction address held in the current register.],

            [ 20], [*Trigger on UNFL1 flag*: \ This mode will cause the corresponding helper register to generate the UNFL1T exception as soon as the UNFL1 flag is raised at the instruction address held in the current register.],

            [ 21], [*Trigger on UNFL2 flag*: \ This mode will cause the corresponding helper register to generate the UNFL2T exception as soon as the UNFL2 flag is raised at the instruction address held in the current register.],

            [ 22], [*Trigger on UNFL4 flag*: \ This mode will cause the corresponding helper register to generate the UNFL4T exception as soon as the UNFL4 flag is raised at the instruction address held in the current register.],

            [ 23], [*Trigger on UNFL8 flag*: \ This mode will cause the corresponding helper register to generate the UNFL8T exception as soon as the UNFL8 flag is raised at the instruction address held in the current register.],

            [ 24], [*Trigger on DIV0 flag*: \ This mode will cause the corresponding helper register to generate the DIV0T exception as soon as the DIV0 flag is raised at the instruction address held in the current register.],

            [ 25], [Reserved for future uses.],
            [...], [...],
            [127], [Reserved for future uses.],

            [128], [Left as a free slot for implementation specific features.],
            [...], [...],
            [254], [Left as a free slot for implementation specific features.],

            [255], [*Range end*: \ This mode simply signifies that the corresponding register value is the end of an address range started by the previous register. If the previous register does not specify an address range, then this mode will behave in the same way as mode 0.]
        )),

        [If multiple helper registers specify ranges, those ranges must be AND-ed together in order to allow proper automatic boundary checking.],

        [If multiple same events are triggered in the same cycle, then they must be queued to avoid loss of information. In order to avoid any ambiguity when such situations arise. The ordering convention, in case multiple events are generated for the same instruction address, gives the $"HLPR"_0$ the highest priority and $"HLPR"_n$ the lowest.],

        [It is important to note that the COVRnT, CUNDT, OVFLnT and UNFLnT events must overwrite the COVRE, CUNDE, OVFLE, UNFLE and DIV0E arithmetic exceptions (see section 3 and the subsections below for more information) of the EXC module if present, where $n = 1/8 dot 2^"WLEN"$.],

        comment([

            This bank can be used to aid the programmer in a variety of situations. A big one is memory safety: by specifying address ranges on instruction fetch, loads and stores, the system can automatically throw the appropriate exception when the constraint is violated without explicitly checking with a branch each time. This is helpful to avoid unintentionally overwriting portions of memory, thus reducing chances of exploits and increase memory safety. The triggered exceptions can be caught in order to execute handling / recovery code without needing to invoke the operative system.

            Another situation is debugging: by placing the desired breakpoints in the desired spots of the program, exceptions can be triggered and handled to perform things like memory / state dumping, or any other action that might help the programmer understand what is going on in the system. All of this can be achieved with near zero performance penalty and interference with the actual code.

            One final application can be in handling unavoidable arithmetic edge cases without performance penalties, enabling safer arithmetic as well as aiding arbitrary precision data types.
        ])
    ),

    ///.
    subSection(

        [Performance counter bank],

        [This bank houses the performance counters which, as mentioned earlier, can be used for performance diagnostic, timers and counters. These registers are all CLEN bits wide and their operating mode can be programmed via an extra 8-bits attached to each of them. The PERFC module requires the implementation of this bank, some special instructions (see section 7 for more information) and some exception events. It is important to note that if a counter reaches its maximum value, it will silently overflow. These registers are considered "global" and are not scoped, that is, they are visible to any process at any time regardless of the privilege, however, they are hart private. The operating modes are the following:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (right + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Description*])],

            [  0], [*Disabled*: \ This mode doesn't do anything.],
            [  1], [*Instruction counter*: \ This mode is a simple instruction counter that increments with each retired instruction.],

            [  2], [*Memory load counter*: \ This mode is a simple instruction counter that increments with each executed memory load instruction.],

            [  3], [*Memory store counter*: \ This mode is a simple instruction counter that increments with each executed memory store instruction.],

            [  4], [*Taken branch counter*: \ This mode, is a simple instruction counter that increments with each taken conditional branch.],

            [  5], [*Non taken branch counter*: \ This mode is a simple instruction counter that increments with each non-taken conditional branch.],

            [  6], [*Stalled cycles counter*: \ This mode is a simple counter that increments with each clock cycle in which the cpu was stalled.],

            [  7], [*Time counter*: \ This mode is a simple timer that counts the passed units of time (configurable via the CNTU bits in the Special Purpose register).],

            [  8], [*Clock counter*: \ This mode is a simple clock cycle counter. Eight codes are reserved and each subsequent code will divide the frequency by 10 before triggering the counter.],

            [ 16], [Reserved for future uses.],
            [...], [...],
            [127], [Reserved for future uses.],

            [128], [Left as a free slot for implementation specific features.],
            [...], [...],
            [255], [Left as a free slot for implementation specific features.]
        )),

        [FabRISC provides the *Counter Length (CLEN)* 2-bit ISA parameter, indicates the bit width of the performance counters in bits (see section 6 and 7 for more information). If the system doesn't support the PERFC module, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the following table:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [00], [8-bit.],
            [01], [16-bit.],
            [10], [32-bit.],
            [11], [64-bit.]
        )),

        comment([

            This bank is a very powerful tool when it comes to performance diagnostics and monitoring. Once configured, the counters will keep track of the desired metrics throughout the lifetime of the program. Common statistics, beyond the basic ones mentioned in the table, are often cache hits / misses, TLB hits / misses, BTB hits / misses, branch misspredictions, stalls and many others. I wanted to leave as much freedom to the hardware designers as possible here as it can depend a lot on how the microarchitecture is implemented.
        ])
    ),

    ///.
    subSection(

        [Special purpose bank],

        [In this subsection the special purpose registers are discussed. Some of these registers are unprivileged, that is, accessible to any process at any time regardless of the privilege, while others are machine mode only and the ILLI fault must be triggered if an access is performed in user mode to those resources. These registers are also _hart private_, which means that, each hart must hold its own copy of these registers.],

        align(center, table(

            columns: (auto, auto, auto),
            inset: 8pt,
            align: (x, y) => (left + horizon, left + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Short*])], [#align(center, [*Size*])], [#align(center, [*Description*])],

            [PC], [WLEN], [*Program Counter*: \ This register points to the currently executing instruction. This register is not privileged and is always mandatory.],

            [SR], [32-bit], [*Status Register*: \ This register holds several flags that keep track of the current status of the processor. This register is semi-privileged and is always mandatory. Depending on which modules are implemented, only certain bits must be present while the others can be ignored and set to 0 as a default. The precise bit layout will be discussed in the next section.],

            [VSH], [8-bit], [*Vector shape*: \ This register specifies the current vector configuration and is divided into two parts: the most significant two bits specify the size of the singular element, while the remaining least significant bits specify the number of active elements. Illegal configurations must generate the ILLI fault. This register is not privileged and is only needed when the system implements the VC module, otherwise the default vector shape must always dictate the maximum number of WLEN sized elements.],

            [VM1], [$1/8 "MXVL"$], [*Vector mask 1*: \ This register is the vector mask number 1. Each bit maps to a byte in the vector register bank. This register is not privileged and is only needed when the system implements the VF module.],

            [VM2], [$1/8 "MXVL"$], [*Vector mask 2*: \ This register is the vector mask number 2. Each bit maps to a byte in the vector register bank. This register is not privileged and is only needed when the system implements the VF module.],
            
            [VM3], [$1/8 "MXVL"$], [*Vector mask 3*: \ This register is the vector mask number 3. Each bit maps to a byte in the vector register bank. This register is not privileged and is only needed when the system implements the VF module.],

            [UEPC], [WLEN], [*User event PC*: \ This register holds the PC of the last instruction before the user event handler, which can then be used to return back from it. This register has the same privilege as the PC and is needed if the system implements the USER module.],

            [UESR], [32-bit], [*User Event Status Register*: \ This register holds the latest SR before the user event handler, which can then be used to restore the SR when returning from it. This register has the same privilege as the SR and is only needed when the system implements the USER module.],

            [UEC], [16-bit], [*User event cause*: \ This register holds the id of which event caused the current hart to trap in the least significant 9 bits, as well as some extra information in the remaining bits (event specific). This register is not privileged and is only needed when the system implements the USER module.],

            [UED], [WLEN], [*User Event Data*: \ This register holds the event data (event specific). This register is not privileged and is only needed when the system implements the USER module.],

            [UEHP], [WLEN], [*User event handler pointer*: \ This register holds the address of the user event handler. The handler must always be one for all events. A switch statement with the help of the event id can then be used to jump to the specific handler. This register is not privileged and is only needed when the system implements the USER module.],

            [UET0], [WLEN], [*User event temporary 0*: \ This register can be used as a temporary register during event handling, often for saving and restoring the various banks. This register is not privileged and is only needed when the system implements the USER module.],

            [UET1], [WLEN], [*User event temporary 1*: \ This register can be used as a temporary register during event handling, often for saving and restoring the various banks. This register is not privileged and is only needed when the system implements the USER module.],

            [MEPC], [WLEN], [*Machine Event PC*: \ This register holds the PC of the last instruction before the machine event handler, which can then be used to return back from it. This register is privileged and is only needed when the system implements one ore more of the following modules: EXC, IOINT, IPCINT, USER.],

            [MESR], [32-bit], [*Machine Event SR*: \ This register holds the latest SR before the machine event handler, which can then be used to restore the SR when returning from it. This register is privileged and is only needed when the system implements one ore more of the following modules: EXC, IOINT, IPCINT, USER.],

            [MEC], [16-bit], [*Machine Event Cause*: \ This register holds the id of which event caused the current hart to trap in the least significant 9 bits, as well as some extra information in the remaining bits (event specific). This register is privileged and is only needed when the system implements one ore more of the following modules: EXC, IOINT, IPCINT, USER.],

            [MED], [WLEN], [*Machine Event Data*: \ This register holds the event data (event specific). This register is privileged and is only needed when the system implements one ore more of the following modules: EXC, IOINT, IPCINT, USER.],

            [MEHP], [WLEN], [*Machine Event Handler Pointer*: \ This register holds the address of the machine event handler. The handler must always be one for all events. A switch statement with the help of the event id can then be used to jump to the specific handler. This register is privileged and is only needed when the system implements one ore more of the following modules: EXC, IOINT, IPCINT, USER.],

            [MET0], [WLEN], [*Machine Event Temporary 0*: \ This register can be used as a temporary register during event handling, often for saving and restoring the various banks. This register is privileged and is only needed when the system implements one ore more of the following modules: EXC, IOINT, IPCINT, USER.],

            [MET1], [WLEN], [*Machine Event Temporary 1*: \ This register can be used as a temporary register during event handling, often for saving and restoring the various banks. This register is privileged and is only needed when the system implements one ore more of the following modules: EXC, IOINT, IPCINT, USER.],

            [PFPA], [WLEN], [*Page Fault Physical Address*: \ This register holds the page table physical address of the currently running process. This register is privileged and is only needed when the system implements the USER module.],

            [SGPRBU], [SRFS], [*SGPRB Usage*: \ This register keeps track of which registers of the SGPRB have been written by associating each bit to the corresponding register in the SGPRB, thus helping to reduce the amount of state that needs to be saved and restored during context switches. This register is privileged and is only needed when the system implements the USER and CTXR modules],

            [VGPRBU], [VRFS], [*VGPRB Usage*: \ This register keeps track of which registers of the VGPRB have been written by associating each bit to the corresponding register in the VGPRB, thus helping to reduce the amount of state that needs to be saved and restored during context switches. This register is privileged and is only needed when the system implements the USER and CTXR modules and the VGPRB is present.],

            [HLPRBU], [HRFS], [*HLPRB Usage*: \ This register keeps track of which registers of the HLPRB have been written by associating each bit to the corresponding register in the HLPRB, thus helping to reduce the amount of state that needs to be saved and restored during context switches. This register is privileged and is only needed when the system implements the USER and CTXR modules and the HLPRB is present.],

            [PERFCBU], [CRFS], [*PERFCB Usage*: \ This register keeps track of which registers of the PERFCB have been written by associating each bit to the corresponding register in the PERFCB, thus helping to reduce the amount of state that needs to be saved and restored during context switches. This register is privileged and is only needed when the system implements the USER and CTXR modules and the PERFCB is present.],

            [PID], [32-bit], [*Process ID*: \ This register holds the id of the currently running process. This register is privileged and is only needed when the system implements the USER module.],

            [TID], [32-bit], [*Thread ID*: \ This register holds the id of the currently running process thread. This register is privileged and is only needed when the system implements the USER module.],

            [HPID], [32-bit], [*Hypervisor PID*: \ This register holds the id of the supervisor associated to the currently running process. This register is privileged and is only needed when the system implements the USER module.],

            [TPTR], [WLEN], [*Thread Pointer*: \ This register holds the pointer to the currently running software thread. This register is privileged and is only needed when the system implements the USER module.],

            [WDT], [32-bit], [*Watchdog Timer*: \ This register is a counter that periodically count down and triggers the TQE event when it reaches zero. This register is privileged and is only needed when the system implements the USER module.]
        )),

        comment([

            This bank houses a variety of registers used to alter and change the behavior of the system while it operates. Many of the modules will require the presence of some special purpose registers in order to function such as vector extensions, transaction module, helper registers, performance counters and others.

            The registers prefixed with "User Event" or "Machine Event" hold the "critical state" of the hart, that is, state that is particularly delicate for event handling in privileged implementations. Access to privileged resources in user mode is forbidden and blocked in order to protect the operating system from exploits, as well as ensuring that the ISA remains classically virtualizable.

            Special "usage" registers are also provided if the CTXR module is implemented which allow to reduce the average number of registers that must be saved and restored during context switches. This is achieved by setting the corresponding bit to one whenever a register in the covered banks is written. This can then be used by special instructions to only write to memory the registers with the corresponding usage bit to one.

            Hardware designers are free to include any of these registers in the renamer if they so wish. Alternatively, a write to any special register must hold fence-like semantics, that is, the hart must hold execution of all subsequent instructions until the write is complete. This allows any modification to this bank to be visible by the rest of the system.
        ])
    ),

    ///.
    subSection(

        [Status Register bit layout],

        [In this section the Status Register bit layout is discussed. The SR contains several flags and status bits of different privilege levels. The bits that the system must implement depend on which modules are chosen. The possible bits are explained in the following table:],

        align(center, table(

            columns: (15fr, 15fr, 70fr),
            inset: 8pt,
            align: (x, y) => (left + horizon, left + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Short*])], [#align(center, [*Size*])], [#align(center, [*Description*])],

            [RMD], [2-bit], [*FP Rounding Mode*: \ Dictates the current floating point rounding mode. These bits are not privileged, only needed when the system implements the FRMD module and, if not present, the default rounding mode must always be _round to nearest even_. The possible mode are:

                #enum(tight: false,

                    [_Round to nearest even._],
                    [_Round towards zero._],
                    [_Round towards negative infinity._],
                    [_Round towards positive infinity._],
                )
            ],

            [TND], [8-bit], [*Transaction Nesting Depth*: \ Holds the current transaction nesting depth. A value of zero indicates that the hart is not in transactional mode. These bits are not privileged and only needed when the system implements the TM module.],

            [CMD], [1-bit], [*Consistency Mode*: \ Dictates the current memory consistency model: zero for relaxed and one for sequential. This bit is not privileged, only needed when the system implements the FNC module and, if not present, the default consistency model must always be _sequential consistency._],

            [GEE], [1-bit], [*Global Arithmetic Exceptions Enable*: \ Enables or disables immediate trap on any arithmetic exception. If this bit is one, then any arithmetic flag will trap the hart. If this bit is zero, the hart will not be trapped unconditionally, but the flags must still be generated if the HLPR module is implemented. This bit is not privileged and only needed when the EXC module is implemented.],

            [HLPRE], [4-bit], [*HLPR Enable*: \ Enables or disables portions the HLPRB and each bit affects 8 registers at a time. These bits are not privileged and only needed when the system implements the HLPR module.],

            [PERFCE], [1-bit], [*PERFC Enable*: \ Enables or disables the PERFCB. This bit is not privileged and only needed when the system implements the PERFC module.],

            [CNTU], [2-bit], [*PERFC Time Unit*: \ Dictates the time unit of the PERFC when they are in _time counter_ mode. This bit is not privileged and only needed when the system implements the PERFC module. The possible modes are:

                #enum(tight: false,

                    [_Seconds._],
                    [_Milliseconds._],
                    [_Microseconds._],
                    [_Nanoseconds._]
                )
            ],

            [IM], [2-bit], [*Interrupt Mask*: \ Masks the interrupts: the first bit masks _IO interrupts_ and the second masks _IPC interrupts_. This bit is privileged and only needed when the system implements any of the following modules: IOINT, IPCINT.],

            [PMOD], [1-bit], [*Privilege Mode*: \ Dictates the current hart privilege level: zero for machine mode and one for user mode. This bit is privileged and only needed when the system implements the USER module.],

            [WDTE], [1-bit], [*Watchdog Timer Enable*: \ Enables or disables the WDT register. This bit is privileged and only needed when the system implements the USER module.],

            [PWRS], [4-bit], [*Power State*: \ Holds the current hart power state. The actual possible values are implementation specific and left to the hardware designers to define. These bits are privileged and only needed when the system implements the SA module.],

            [HLTS], [3-bit], [*Halt State*: \ Holds the current hart halting state. These bits are privileged and always mandatory. The possible states are:

                #enum(tight: false,

                    [_Not halted._],
                    [_Explicit halt: the halt was caused by the HLT instruction._],
                    [_Catastrophic halt: the halt was caused by the "double event" situation._]
                )
            ]
        )),

        [It is important to note that when some bits are not needed, any write operation to those should be silently discarded and should not produce any visible architectural changes.]
    ),

    ///.
    subSection(

        [Events],

        [In this subsection, all the possible events are defined. In general, the term "event" is used to refer to any extraordinary situation that may happen at any time and should be handled as soon as possible. Events can be "promoting" or "non promoting", that is, elevate the trapped hart to a higher privilege level or not. If the USER module is not implemented, then this distinction is not needed since the system always runs at the highest possible privilege level: machine mode. Events also have _global priority_ and _local priority_ which together define a deterministic handling order (lower numbers signify higher priority). Global priority dictates the priority for classes of events, while local priority defines the level for each event within each group. Higher values mean higher priority and, for some groups of events, local priority is not defined since they should be handled in program order.],

        [The following is the event taxonomy:],

        list(tight: false,

            [*Synchronous: * _Synchronous events are deterministic and can be triggered by an instruction, for example a division by zero, or by other sources such as helper registers. This category is further subdivided in two subcategories:_
            
                #list(tight: false, marker: [--],

                    [*Exceptions:* _Exceptions are low severity events and are non-promoting._],
                    [*Faults:* _Faults are high severity events and are promoting._]
                )
            ],

            [*Asynchronous:* _Asynchronous events are non-deterministic and can be triggered by other harts or any external IO device. This category is further divided into two subcategories, both promoting:_

                #list(tight: false, marker: [--],

                    [*IO Interrupts:* _These events are triggered by external IO devices._],
                    [*IPC Interrupts:* _These events are triggered by other harts and are sometimes referred as "notifications"._]
                )
            ]
        ),

        [The following is a list of all events that are supported by the specification:],

        page(flipped: true, align(center, table(

            columns: (auto, auto, auto, auto, auto, auto, auto),
            inset: 6pt,
            align: (x, y) => (right + horizon, left + horizon, left + horizon, center + horizon, left + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Code*])], [#align(center, [*Short*])], [#align(center, [*Module*])], [#align(center, [*GP*])], [#align(center, [*LP*])], [#align(center, [*Type*])], [#align(center, [*Description*])],

            // Mandatory
            [   1], [MISI], [Mandatory], [0], [Program order], [Fault], [*Misaligned Instruction*: \ Triggered when the hart tries to fetch a misaligned instruction. This event doesn't carry any extra information.],

            [   2], [INCI], [Mandatory], [0], [Program order], [Fault], [*Incompatible Instruction*: \ Triggered when the hart fetches a non supported instruction. Even if a particular opcode is supported, not all operands might be legal. This event doesn't carry any extra information.],

            [   3], [ILLI], [Mandatory], [0], [Program order], [Fault], [*Illegal Instruction*: \ Triggered when the hart tries fetch an instruction that is all zeros, all ones or otherwise deemed as illegal. This event doesn't carry any extra information.],

            [   4], [-],   [-], [-],   [-],   [-], [Reserved for future uses.],
            [ ...], [...], [...], [...], [...], [...], [...],
            [  16], [-],   [-],   [-],   [-],   [-], [Reserved for future uses.],

            // IOINT module
            [  17], [IOINT_0], [IOINT], [1], [0], [IO Interrupt], [*IO Interrupt 0*: \ Generic IO interrupt. This event doesn't carry any extra information.],

            [ ...], [...], [...], [...], [...], [...], [...],

            [  48], [IOINT_31], [IOINT], [1], [31], [IO Interrupt], [*IO Interrupt 31*: \ Generic IO interrupt. This event doesn't carry any extra information.],

            // IPCINT module
            [  49], [IPCINT_0], [IPCINT], [2], [1], [IPC Interrupt], [*IPC Interrupt 0*: \ Generic IPC interrupt. This event doesn't carry any extra information.],

            [ ...], [...], [...], [...], [...], [...], [...],

            [  80], [IPCINT_31], [IPCINT], [2], [32], [IPC Interrupt], [*IPC Interrupt 31*: \ Generic IPC interrupt. This event doesn't carry any extra information.],

            // DALIGN module
            [  81], [MISD], [DALIGN], [0], [Program order], [Fault], [*Misaligned Data*: \ Triggered when the hart accesses unaligned data. This event doesn't carry any extra information.],

            // USER module
            [  82], [PFLT], [USER], [0], [Program order], [Fault], [*Page Fault*: \ Triggered when the addressed page could not be found in memory. The MED register must be populated with the faulting address.],

            [  83], [ILLA], [USER], [0], [Program order], [Fault], [*Illegal Address*: \ Triggered when the user accesses "illegal" address, that is, an address that is not accessible in user mode. The MED register must be populated with the faulting address.],

            [  84], [SYSC], [USER], [0], [Program order], [Fault], [*System Call*: \ Triggered by the system call instruction explicitly. (see section 7 for more information).],

            [  85], [TQE ], [USER], [1], [0], [IPC Interrupt], [*Time quantum expired*: \ Triggered by the internal watchdog timer. This event doesn't carry any extra information.],

            [  86], [-],   [-],   [-],   [-],   [-],   [Reserved for future uses.],
            [ ...], [...], [...], [...], [...], [...], [...],
            [  97], [-],   [-],   [-],   [-],   [-],   [Reserved for future uses.],

            // EXC module
            [  98], [COVRE], [EXC], [3], [Program order], [Exception], [*Carry Over Exception*: \ This event is triggered by the COVRn flag, where  \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

            [  99], [CUNDE], [EXC], [3], [Program order], [Exception], [*Carry Under Exception*: \ This event is triggered by the CUND flag. This event doesn't carry any extra information.],

            [ 100], [OVFLE], [EXC], [3], [Program order], [Exception], [*Overflow Exception*: \ This event is triggered by the OVFLn flag, where \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

            [ 101], [UNFLE], [EXC], [3], [Program order], [Exception], [*Underflow Exception*: \ This event is triggered by the UNFLn flag, where \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

            [ 102], [DIV0E], [EXC], [3], [Program order], [Exception], [*Division by Zero Exception*: \ This event is triggered by the DIV0 flag. This event doesn't carry any extra information.],

            [ 103], [-], [EXC], [3], [Program order], [Exception], [Reserved for future uses.],
            [ ...], [...], [...], [...], [...], [...], [...],
            [ 113], [-], [EXC], [3], [Program order], [Exception], [Reserved for future uses.],

            // HLPR module
            [ 114], [RDT], [HLPR], [3], [See subsection 6.3], [Exception], [*Read Trigger*: \ Event for mode 1 and 6 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 115], [WRT], [HLPR], [3], [See subsection 6.3], [Exception], [*Write Trigger*: \ Event for mode 2 and 7 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 116], [EXT], [HLPR], [3], [See subsection 6.3], [Exception], [*Execute Trigger*: \ Event for mode 3 and 8 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 117], [RWT], [HLPR], [3], [See subsection 6.3], [Exception], [*Read-Write Trigger*: \ Event for mode 4 and 9 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 118], [RWET], [HLPR], [3], [See subsection 6.3], [Exception], [*Read-Write-Execute Trigger*: \ Event for mode 5 and 10 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 119], [COVR1T], [HLPR], [3], [See subsection 6.3], [Exception], [*Carry Over 1 Trigger*: \ Event for mode 11 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 120], [COVR2T], [HLPR], [3], [See subsection 6.3], [Exception], [*Carry Over 2 Trigger*: \ Event for mode 12 of the helper registers. The causing instruction and the address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 121], [COVR4T], [HLPR], [3], [See subsection 6.3], [Exception], [*Carry Over 4 Trigger*: \ Event for mode 13 of the helper registers. The causing instruction and the address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 122], [COVR8T], [HLPR], [3], [See subsection 6.3], [Exception], [*Carry Over 8 Trigger*: \ Event for mode 14 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 123], [CUNDT], [HLPR], [3], [See subsection 6.3], [Exception], [*Carry Under Trigger*: \ Event for mode 15 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 124], [OVFL1T], [HLPR], [3], [See subsection 6.3], [Exception], [*Overflow 1 Trigger*: \ Event for mode 16 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 125], [OVFL2T], [HLPR], [3], [See subsection 6.3], [Exception], [*Overflow 2 Trigger*: \ Event for mode 17 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 126], [OVFL4T], [HLPR], [3], [See subsection 6.3], [Exception], [*Overflow 4 Trigger*: \ Event for mode 18 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 127], [OVFL8T], [HLPR], [3], [See subsection 6.3], [Exception], [*Overflow 8 Trigger*: \ Event for mode 19 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 128], [UNFL1T], [HLPR], [3], [See subsection 6.3], [Exception], [*Underflow 1 Trigger*: \ Event for mode 20 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 129], [UNFL2T], [HLPR], [3], [See subsection 6.3], [Exception], [*Underflow 2 Trigger*: \ Event for mode 21 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 130], [UNFL4T], [HLPR], [3], [See subsection 6.3], [Exception], [*Underflow 4 Trigger*: \ Event for mode 22 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 131], [UNFL8T], [HLPR], [3], [See subsection 6.3], [Exception], [*Underflow 8 Trigger*: \ Event for mode 23 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 132], [DIV0T], [HLPR], [3], [See subsection 6.3], [Exception], [*Division by Zero Trigger*: \ Event for mode 24 of the helper registers. The address of the causing register must be written into the MEC / UEC special purpose register as additional information.],

            [ 133], [-], [HLPR], [3], [See subsection 6.3], [Exception], [Reserved for future uses.],
            [ ...], [...], [...], [...], [...], [...], [...],
            [ 369], [-], [HLPR], [3], [See subsection 6.3], [Exception], [Reserved for future uses.],

            [ 370], [-], [-], [-], [-], [-], [Left as implementation specific.],
            [ ...], [...], [...], [...], [...], [...], [...],
            [ 512], [-], [-], [-], [-], [-], [Left as implementation specific.]
        ))),

        [When the hart is trapped by an event, the handling procedure must be performed in order to successfully process the event. Such procedure is left to the programmer to define, however, the steps needed to reach the code must be implemented in hardware. Depending if the event is promoting or not, as well as the currently active privilege, the appropriate "launching sequence" must be performed.],

        [The following ordered steps define the "privileged" launching sequence and must be executed in a single cycle:],

        enum(tight: false,

            [_Cancel all in-flight instructions._],
            [_Write the current value of the PC into the MEPC special purpose register._],
            [_Write the current value of the SR into the MESR special purpose register._],

            [_Set the following bits of the SR to the following values ignoring privilege restrictions:_

                #list(tight: false,

                    [_GEE to 0 if present._],
                    [_HLPRE to 0 if present._],
                    [_PERFCE to 0 if present._],
                    [_PMOD to 1._],
                    [_WDTE to 0._],
                    [_IM to 3 if present._]
                )
            ],

            [_Write the event identifier and extra information, depending on the specific event, into the MEC special purpose register._],
            [_Write the event data into the MED special purpose register if needed._],
            [_Write the current value of the MEHP special purpose register into the PC._]
        ),

        [The following ordered steps define the "unprivileged" launching sequence and must be executed in a single cycle:],

        enum(tight: false,

            [_Cancel all in-flight instructions._],
            [_Write the current value of the PC into the UEPC special purpose register._],
            [_Write the current value of the SR into the UESR special purpose register._],

            [_Set the following bits of the SR to the following values:_

                #list(tight: false,

                    [_GEE to 0 if present._],
                    [_HLPRE to 0 if present._],
                    [_PERFCE to 0 if present._]
                )
            ],

            [_Write the event identifier and extra information, depending on the specific event, into the UEC special purpose register._],
            [_Write the event data into the UED special purpose register if needed._],
            [_Write the current value of the UEHP special purpose register into the PC._]
        ),

        [After reaching the handling procedure, it's extremely important to save to memory the all the "critical" state that was temporarily copied into the MEPC and MESR for machine level events, or UEPC and UESR for user level events. This is because in order to support the nesting of events, it must be possible to restore the critical state of the previous handler. If the hart is re-trapped, for any reason, before the critical state is saved to memory, loss of information will occur and it won't be possible to restore it. This catastrophic failure must be detected and the hart must be immediately halted with code 2 in the HLT section of the Status Register. It is important to note that trapping a hart with a promoting event while in user mode, is always possible and will never result in the "double event" situation since the target event registers will be different.],

        [Returning from an event handler requires executing the appropriate dedicated return instruction: ERET, UERET or URET (see section 7 for  more information). Such instructions will undo the associated sequences described above by performing the same step in reverse order.],

        [The following ordered steps define the "privileged" returning sequence initiated by the ERET instruction which must be executed in a single cycle:],

        enum(tight: false,

            [_Write the value of the MESR special purpose register into the SR._],
            [_Write the value of the MEPC special purpose register into the PC._]
        ),

        [The following ordered steps define the "unprivileged" returning sequence initiated by the UERET instruction which must be executed in a single cycle:],

        enum(tight: false,

            [_Write the value of the UESR special purpose register into the SR. Any changes to any privileged bit must be ignored._],
            [_Write the value of the UEPC special purpose register into the PC._]
        ),

        [The following ordered steps define the "user" returning sequence initiated by the URET instruction. This special case performs a "demotion" of the hart, that is, the privilege is changed from machine to user. Similarly to all other sequences, this must be executed in a single cycle as well:],

        enum(tight: false,

            [_Write the value of the UESR special purpose register into the SR._],

            [_Set the following bits of the SR to the following values:_

                #list(tight: false,

                    [_PMOD to 0._],
                    [_WDTE to 1._],
                )
            ],

            [_Write the value of the UEPC special purpose register into the PC._]
        ),

        [During event handling, other events might be received by the hart. This situation was already mentioned in the previous paragraphs and a queuing system is needed in order to avoid loss of information. Queues have finite length so it's important to handle the events more rapidly than they come, however if the events are too frequent the queues will eventually fill. Any IO and IPC interrupt that is received while the queues are full, must be discarded and the interrupting device must be notified.],
        // TODO: other event queues might fill up too...

        [When any event is received and the hart is in a transactional state, then all executing memory transactions must immediately fail with the abort code EABT.],

        [Software interrupts can be easily implemented by injecting the appropriate values into the critical registers and then performing the appropriate returning sequence. This will cause the hart to return from a handler with the event id not at zero, thus triggering again the launching sequence. A hart with an event id of zero in its cause register is not considered as trapped.],

        comment([

            Events are a very powerful way to react to different things "on the fly", which is very useful for event-driven programming, managing external devices at low latency and are essential for privileged architectures.

            The division in different categories might seem a bit strange at first, but the two broad classes are the usual ones: synchronous and asynchronous events, that is, deterministic and non-deterministic ones. The different types of events within each class are roughly based on "severity" (which is basically the global priority metric), as well as a local priority which can depend on different things.

            Exceptions are the lowest severity among all other events and the program order defines the order in which they must be handled. The only complication to this rule is for helper register exceptions, which have a higher intrinsic priority and the handling order depends on which particular helper register fired. These exceptions might also clash with the previously mentioned regular arithmetic ones but, since the helper ones have a higher innate priority, they all take over and override. This behavior stems from the fact that HLPR registers allow for fine control, while the GEE bit allows exceptions to be enabled or disabled globally. In both instances, it's possible to distinguish if the exception was caused by a HLPR register or not. 

            Faults are also synchronous just like exceptions, but their severity is the highest among any other event and they often signify that something bad happened, such as an access to an illegal address. Because they are synchronous, they must be handled in program order.

            IO Interrupts are the lowest global priority asynchronous event and they are used to handle external device requests. They have a progressive local priority that defines the order in which they must be handled when received.

            IPC Interrupts are a higher priority version of the IO Interrupt. IPC Interrupts are used by harts to send signals to each other, which may also be used for quickly starting and stopping other harts. Just like the IO variant, they have a progressive local priority that defines the order in which they must be handled when received.

            In some situations it may be necessary to queue an event in order to handle it after another and to avoid loss of information. If the queue is full, the events must be discarded and, whoever generated the event, must be notified. This includes IO devices or other harts that generated an IPC interrupt, in this last case, by making their IPC interrupt generating instruction fail.
        ])
    ),

    ///.
    subSection(

        [Configuration segment],

        [In previous sections, this document introduced several different configuration constants, which describe the features, that any system must have in order to be considered compliant to the FabRISC architecture. These parameters must be stored in a dedicated static, read-only memory-like region that is byte addressable. Some of these parameters are global for all harts, while others are private. The parameters are all unprivileged and are listed in the following table:],

        align(center, table(

            columns: (auto, auto, auto, auto, auto),
            inset: 8pt,
            align: (x, y) => (right + horizon, right + horizon, left + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Start*])], [#align(center, [*End*])], [#align(center, [*Parameter*])], [#align(center, [*Visibility*])], [#align(center, [*Description*])],

            [   0], [   1], [HID     ], [Private], [Unique identifier of the current hart.],
            [   2], [   9], [ISAMOD  ], [Private], [See section 2 for more information.],
            [  10], [  11], [ISAVER  ], [Private], [See section 2 for more information.],
            [  12], [  12], [WLEN    ], [Private], [See section 6 for more information.],
            [  13], [  13], [MXVL    ], [Private], [See section 6 for more information.],
            [  14], [  14], [CLEN    ], [Private], [See section 6 for more information.],
            [  15], [  15], [SRFS    ], [Private], [See section 6 for more information.],
            [  16], [  16], [VRFS    ], [Private], [See section 6 for more information.],
            [  17], [  17], [HRFS    ], [Private], [See section 6 for more information.],
            [  18], [  18], [CRFS    ], [Private], [See section 6 for more information.],
            [  19], [  19], [LLSCS   ], [Private], [See section 4 for more information.],

            [  20], [  27], [CPUID   ], [Global ], [Unique CPU identifier.],
            [  28], [  35], [CPUVID  ], [Global ], [Unique CPU vendor identifier.],
            [  36], [ 163], [CPUNAME ], [Global ], [CPU name.],
            [ 164], [ 165], [NCORES  ], [Global ], [Number of physical CPU cores.],
            [ 166], [ 167], [NTHREADS], [Global ], [Number of logical CPU cores per physical core (hardware threads or harts).],
            [ 168], [ 168], [IOS     ], [Global ], [See section 5 for more information.],
            [ 169], [ 169], [DMAMOD  ], [Global ], [See section 5 for more information.],
            [ 170], [ 170], [DMAS    ], [Global ], [See section 5 for more information.],

            [ 171], [ 255], [-], [-], [Reserved for future uses.],
            [ 256], [1023], [-], [-], [Left as implementation specific.],
        )),

        comment([

            These read-only parameters describe the hardware configuration and capabilities. Some have already been explained in earlier sections, while others are new. Global parameters are the same for all harts in the system, while private parameters depends on which hart is targeted.

            The majority of this region is left as implementation specific since it can be used to write information about the specific microarchitecture, such as cache and TLB organizations.
        ])
    ),

    ///.
    subSection(

        [Instruction formats],

        [FabRISC organizes the instructions in 14 different formats with lengths of 2, 4 and 6 bytes and opcode lengths ranging from 4 to 20 bits. Formats that specify the "md" field are also subdivided into "classes" at the instruction level. This is because the _md_ field acts as an extra modifier, such as, extra immediate bits, data type selector  and more.],

        [The following is the complete list of all the formats:],

        page(flipped: true, text(size: 10pt,

            [#align(center, tablex(

                columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),

                align: center + horizon,
                fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

                [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],

                [2RI-B], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(11)[op \ 14...4], colspanx(5)[im \ 18...16], colspanx(2)[md \ 1...0], colspanx(16)[im \ 15...0],

                [3RI-A], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(11)[op \ 14...4], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0], colspanx(16)[im \ 15...0],

                [4R-B], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(6)[op \ 9...4], colspanx(5)[rd \ 4...0], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0], colspanx(2)[vm \ 1...0], colspanx(10)[op \ 19...10], colspanx(4)[vm \ 5...2],

                [3RI-B], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(11)[op \ 14...4], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0], colspanx(2)[vm \ 1...0], colspanx(14)[im \ 13...0]
            ))

            #align(center, tablex(

                columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
                align: center + horizon,
                fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

                [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],

                [2R-A], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(16)[op \ 19...4], colspanx(2)[md \ 1...0],

                [3R-A], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(11)[op \ 14...4], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0],

                [4R-A], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(6)[op \ 9...4], colspanx(5)[rd \ 4...0], colspanx(5)[rc \ 4...0], colspanx(2)[md \ 1...0],

                [I-A], colspanx(4)[op \ 3...0], colspanx(5)[im \ 23...19], colspanx(5)[ra \ 15...11], colspanx(4)[op \ 7...4], colspanx(1)[im \ 18], colspanx(11)[im \ 10...0], colspanx(2)[im \ 17...16],

                [RI-A], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[ra \ 15...11], colspanx(5)[op \ 8...4], colspanx(11)[im \ 10...0], colspanx(2)[md \ 1...0],

                [2RI-A], colspanx(4)[op \ 3...0], colspanx(5)[ra \ 4...0], colspanx(5)[rb \ 4...0], colspanx(4)[op \ 7...4], colspanx(12)[im \ 11...0], colspanx(2)[md \ 1...0]
            ))
        ])),

        page(flipped: true, text(size: 10pt, [

            #align(center, tablex(

                columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),
                align: center + horizon,
                fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

                [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],

                [2R-B], colspanx(4)[op \ 3...0], colspanx(2)[md \ 1...0], colspanx(3)[ra \ 2...0], colspanx(2)[op \ 5...4], colspanx(3)[rb \ 2...0], colspanx(2)[op \ 7...6],

                [I-B], colspanx(4)[op \ 3...0], colspanx(2)[im \ 3...2], colspanx(3)[im \ 9...7], colspanx(2)[op \ 5...4], colspanx(3)[im \ 6...4], colspanx(2)[im \ 1...0],

                [RI-B], colspanx(4)[op \ 3...0], colspanx(2)[im \ 3...2], colspanx(3)[ra \ 2...0], colspanx(1)[op \ 4], colspanx(1)[im \ 7], colspanx(3)[im \ 6...4], colspanx(2)[im \ 1...0],

                [2RI-C], colspanx(4)[op \ 3...0], colspanx(2)[im \ 3...2], colspanx(3)[ra \ 2...0], colspanx(2)[im \ 5...4], colspanx(3)[rb \ 2...0], colspanx(2)[im \ 1...0]
            ))
        ])),

        [Formats that include the "md" field can be, depending on the specific instruction, one of the following classes. Instructions are allowed to only utilize some modes of the chosen class if desired.],

        align(center, table(

            columns: (1fr, 3fr, 3fr),
            inset: 8pt,
            align: (x, y) => (left + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Class*])], [#align(center, [*Labels*])], [#align(center, [*Description*])],

            [-], [-], [Nothing. The _md_ field is ignored.],

            [Class A], [.U, .S, \ .UI, .SI], [Four combinations of: unsigned, signed, unsigned with inverted output, signed with inverted output.],

            [Class B], [.L1, .L2, \ .L4, .L8], [Data type size in bytes.],
            [Class C], [.SGPRB, \ .VGPRB, \ .HLPRB, \ .PERFCB], [Register file selector.],
            [Class D], [-], [Extra immediate bits (always most significant).],
            [Class E], [-, .MSK, \ .IMSK, -], [Vector mask modes: unmasked, maksed, inverted mask.],
            [Class F], [.LD, .ST, \ .LS, .F], [Fence types: loads, stores, loads & stores, fetch.],
            [Class G], [.B0, .B1, \ .B2, .B3], [Register bank specifier (only for compressed formats).],

            [Class H], [.MA, .NMA, \ .MS, .NMS], [Multiply-Accumulate modes: multiply-add, negative multiply-add, multiply-subtract, negative multiply-subtract.],
        )),

        [Vector instruction formats: 4R-B, 3RI-B include an additional modifier:],

        align(center, table(

            columns: (1fr, 3fr, 3fr),
            inset: 8pt,
            align: (x, y) => (left + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,
            fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") },

            [#align(center, [*Modifier*])], [#align(center, [*Labels*])], [#align(center, [*Description*])],

            [vm(6)], [VV, VS, MVV, \ MVS, IMVV, IMVS], [Vector modes and masking combinations: vector-vector, vector-scalar, masked vector-vector, masked vector-scalar, inverted mask vector-vector, inverted mask vector-scalar],

            [vm(2)], [-, .MSK, \ .IMSK, -], [Same effect as the Class E modifier.],
        )),

        comment([

            FabRISC is provides 14 different variable length instruction formats of 2, 4 and 6 bytes in length. I chose this path because variable length encoding, if done right, can increase the code density by more than 25%, which can mean an effective increase in instruction cache capacity by that amount. The downside of this is the more complex hardware required to fetch and decode the instructions since they can now span across multiple cache lines and multiple OS pages.

            I felt that three sizes would be sweet spot: 4 byte as the "standard" length, 2 byte as the compressed variant of the standard and the 6 byte as an extended, more niche length for larger and more complex formats. Anything else would either feel like something was missing or there was too much. With this configuration the ISA can enjoy the code density gains, while also being relatively easy to fetch and decode compared to other solutions like x86.

            To increase the expressivity and flexibility of the formats, without introducing too many of them, i included a "format class" system. Formats that have the "md" (modifier) field can be considered "polymorphic" and can be adapted to many different classes of instructions. This also helps in condensing similar instructions together by parametrizing them, thus simplifying the specification and potentially the underlying hardware.
        ])
    )
)

#pagebreak()

///
