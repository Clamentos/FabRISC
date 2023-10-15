///
#import "Macros.typ": *
#import "@preview/tablex:0.0.5": tablex, colspanx, rowspanx

///
#section(

    [ISA specification],

    [In this section the register file organization, vector model, processor modes, events and the instruction formats are presented. Processors that don't support certain modules must generate the INCI fault whenever an unimplemented or incompatible instruction is fetched or attempted to be processed in any other way. Processors must also generate the ILLI fault whenever a combination of all zeros or all ones is fetched in order to increase safety against buffer overflows exploits or accidental accesses of uninitialized memory locations. The full instruction list will be presented separately in the next section as it's quite large.]
)

    ///
    #subSection(

        [Register file],

        [Depending on which modules are chosen as well as the WLEN and MXVL values, the register file can be composed of up to five different banks of variable width along with extra special purpose ones mainly used by the privileged specification. Registers are declared in the following table:],

        align(center, table(

            columns: (16fr, 84fr),
            inset: 8pt,
            align: left + horizon,
            stroke: 0.75pt,

            [#align(center, [*Name*])], [#align(center, [*Description*])],

            [SGPRB], [*Scalar general purpose register bank*: \ This bank is composed of SRFS amount of registers which can be used to hold data during program execution. The registers are all WLEN bits wide and are used by scalar integer and floating point instructions together. These registers are not privileged and private for each hart.],

            [VGPRB], [*Vector general purpose register bank*: \ This bank is composed of VRFS amount of registers which can be used to hold data during program execution. The registers are all MXVL bits wide and are used by vector integer and floating point instructions together. This bank is only necessary if the machine in question supports any vector instructions. These registers are not privileged and private for each hart.],

            [HLPRB], [*Helper register bank*: \ This bank is composed of HRFS amount of registers which can be used for debugging, automatic address boundary checking as well as triggering exceptions in precise occasions. This bank is only necessary if the machine in question supports the HLPR module. These registers are all WLEN bits wide, not privileged and private for each hart.],

            [PERFCB], [*Performance counter bank*: \ This bank is composed of CRFS amount of registers which can be used for performance diagnostic, timers and counters. This bank is only necessary if the machine in question supports the PERFC module. These registers are all CLEN bits wide, not privileged and private for each hart.],

            [SPRB], [*Special purpose register bank*: \ This bank is introduced in this section, however, it will be discussed in greater detail in the privileged specification because only a part of these registers are needed here. Please check that document for more information.]
        )),

        comment([

            Five banks of several registers might seem overkill, but thanks to FabRISC flexibility the hardware designers can choose only what they desire and how much. The SGPRB and VGPRB are standard across many ISAs and are the classic scalar and vector files. I decided not to split integer and floating point further into separate files because i wanted to allow bit fiddling on floating point data without having to move back and forth between files, as well as simplicity. This could increase the register pressure but the ISA provides instructions that allow packing and unpacking data, thus reclaiming some of the pressure. Another issue could potentially be a higher number of structural hazards as both integer and floating point instructions will read and write to the same bank.

            The HLPRB and PERFCB are a "nice to have" features for more advanced systems allowing a very granular amount of control over arithmetic edge cases, debugging, as well as, performance monitoring. Performance counters are a standard pattern among modern high performance processors because they are essential in determine what causes stalls and bottlenecks.

            The SPRB mainly holds bits and flags that dictate the behaviour of the system while it's running. Some can be renamed in out-of-order systems, while for others it makes little sense and flushing the pipe when they are written might be the better option. This bank also holds several registers that are essential for events to work, as well as privileged resources (see privileged specification for more information).
        ])
    )

    ///
    #subSection(

        [Register ABI],

        [FabRISC specifies an ABI (application binary interface) for the SGPRB and VGPRB. It is important to note that this is just a suggestion on how the general purpose registers should be used in order to increase code compatibility. As far as the processor is concerned, all behave in the same way. The register convention for SGPRB is the following:],

        align(center, table(

            columns: (15fr, 85fr),
            inset: 8pt,
            align: (x, y) => (center + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Marker*])], [#align(center, [*Description*])],

            [$P_i$], [*Parameter registers*: \ These registers are used for parameter passing and returning to and from function calls. Parameters are stored in these registers starting from the top-down $P_0 -> P_n$, while returning values are stored starting from the bottom-up $P_0 <- P_n$. Functions must not modify the value of any unused parameter register.],

            [$S_i$], [*Persistent registers*: \ These registers are "persistent", that is, registers whose value should be retained across function calls. This implies a "callee-save" calling convention.],

            [$N_i$], [*Volatile registers*: \ These registers are "volatile" or simply "non-persistent", that is, that is, registers whose value may not be retained across function calls. This implies a "caller-save" calling convention.],

            [SP], [*Stack pointer*: \ This register is used as a pointer to the top of the call-stack. The calling convention for this register is callee-save.],

            [FP], [*Frame pointer*: \ This register is used as a pointer to the base of the currently active call-stack frame. The calling convention for this register is callee-save.],

            [GP], [*Global pointer*: \ This register is used to point to the global variable area and is always accessible across calls. There is no calling convention for this register since it should be static for the most part. If modifying is absolutely necessary the responsibility is on the callee to save and restore the old value.],

            [RA], [*Return address*: \ This register is used to hold the return address for the currently executing function. The calling convention for this register is caller-save.]
        )),

        [Depending on the SRFS parameter, the layout of the SGPRB will be different. In order to maintain compatibility across different SRFS values, the registers are placed at strategic points:],

        align(center, table(

            columns: (auto, auto, auto),
            inset: 8pt,
            align: center + horizon,
            stroke: 0.75pt,

            [#align(center, [*SRFS = 1*])], [#align(center, [*SRFS = 2*])], [#align(center, [*SRFS = 3*])],

            [P0], [P0], [P0],
            [P1], [P1], [P1],
            [P2], [P2], [P2],
            [P3], [P3], [P3],
            [S0], [S0], [S0],
            [S1], [S1], [S1],
            [SP], [SP], [SP],
            [RA], [RA], [RA],
            [-], [P4], [P4],
            [-], [P5], [P5],
            [-], [S2], [S2],
            [-], [S3], [S3],
            [-], [S4], [S4],
            [-], [N0], [N0],
            [-], [N1], [N1],
            [-], [FP], [FP],
            [-], [-], [P6],
            [-], [-], [P7],
            [-], [-], [S5],
            [-], [-], [S6],
            [-], [-], [S7],
            [-], [-], [S8],
            [-], [-], [S9],
            [-], [-], [S10],
            [-], [-], [S11],
            [-], [-], [S12],
            [-], [-], [S13],
            [-], [-], [S14],
            [-], [-], [S15],
            [-], [-], [N2],
            [-], [-], [N3],
            [-], [-], [GP]
        )),

        [Vector registers are all considered volatile, which means that the caller-save scheme must be utilized since it's assumed that their value won't be retained across function calls. Special instructions are also provided to move these registers, or part of them, to and from the SGPRM (see section 7 for more information).],

        [Some compressed instructions are limited in the number of registers that they can address due to their reduced size. The specifiers are 3-bit long allowing the top eight registers to be addressed only. The proposed ABI already accounts for this by placing the most important eight registers at the top of the bank.],

        comment([

            FabRISC is a flexible ISA that offers different amounts of entries in the scalar general purpose register bank. This necessitates of an ABI for each possible size of the bank. The other constraint is the fact that compressed instructions can only address eight registers due to their shorter size. The proposed ABIs have the most important eight registers at the top, in order to make compressed instructions work seamlessly. The ABI for the 16-entry variant is a superset of the 8-entry one and the 32-entry ABI is a superset of all. This allows for complete forwards compatibility between processors with different sizes of the SGPRB.
        ])
    )

    ///
    #subSection(

        [Helper register bank],

        [This bank houses the helper registers which, as mentioned earlier, can be used for debugging, address range checks and triggering exceptions. These registers are all WLEN bits wide and their operating mode can be programmed via an extra 8-bits attached to each of them. The HLPR module requires the implementation of this bank, some special instructions (see section 7 for more information) and some exception events. It is important to note that these registers are "global" and are not scoped, that is visible to anyone at any time regardless of the privilege. The operating modes are the following:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Code*])], [#align(center, [*Description*])],

            [  0], [*Disabled*: \ This mode doesn't do anything. Helper registers that are in this mode can still be red and written and utilized at any moment with a caller-save scheme, which simply means, that they are considered volatile.],

            [  1], [*Trigger on read address*: \ This mode will cause the corresponding helper register to generate the RDT exception as soon as the hart tries to read data from the specified address.],

            [  2], [*Trigger on write address*: \ This mode will cause the corresponding helper register to generate the WRT exception as soon as the hart tries to write data to the specified address.],

            [  3], [*Trigger on execute address*: \ This mode will cause the corresponding helper register to generate the EXT exception as soon as the hart tries to fetch the instruction at the specified address.],

            [  4], [*Trigger on read or write address*: \ This mode will cause the corresponding helper register to generate the RWT exception as soon as the hart tries to read or write data at the specified address.],

            [  5], [*Trigger on read or write or execute address*: \ This mode will cause the corresponding helper register to generate the RWET exception as soon as the hart tries to read, write data or fetch the instruction at the specified address.],

            [  6], [*Trigger on read range*: \ This mode will cause the corresponding helper register to generate the RDT exception as soon as the hart tries to read data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be overwritten.],

            [  7], [*Trigger on write range*: \ This mode will cause the corresponding helper register to generate the WRT exception as soon as the hart tries to write data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be overwritten.],

            [  8], [*Trigger on execute range*: \ This mode will cause the corresponding helper register to generate the EXT exception as soon as the hart tries to fetch an instruction outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be overwritten.],

            [  9], [*Trigger on read or write range*: \ This mode will cause the corresponding helper register to generate the RWT exception as soon as the hart tries to read or write data outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be overwritten.],

            [ 10], [*Trigger on read or write or execute range*: \ This mode will cause the corresponding helper register to generate the RWET exception as soon as the hart tries to read, write data or fetch an instruction outside the specified range. If this mode is selected, the value of the specified register will be considered the starting address of the range. The terminating address of the range will be held in the register immediately after the specified one and its mode will be overwritten.],

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
            [255], [Left as a free slot for implementation specific features.]
        )),

        [If multiple helper registers specify ranges, those ranges must be AND-ed together in order to allow proper automatic boundary checking.],

        [If multiple same events are triggered in the same cycle, then they must be queued to avoid loss of information. In order to avoid any ambiguity when such situations arise, the ordering convention gives the $"HLPR"_0$ the highest priority and $"HLPR"_n$ the lowest.],

        [It is important to note that the COVRnT, CUNDT, OVFLnT and UNFLnT events must overwrite the COVRE, CUNDE, OVFLE, UNFLE and DIV0E arithmetic exceptions (see the subsections below for more information) of the EXC module if present, where $n = 1/8 dot 2^"WLEN"$.],

        comment([

            This bank can be used to aid the programmer in a variety of situations. A big one is memory safety: by specifying address ranges on instruction fetch, loads and stores, the system can automatically throw the appropriate exception when the constraint is violated without checking with a branch each time. This is helpful to avoid accidentally overwriting portions of memory, thus reducing chances of exploits. The triggered exceptions can be caught in order to execute handling / recovery code without invoking the operative system.

            Another situation is debugging: by placing the desired breakpoints in the desired spots of the program, exceptions can be triggered and handled to perform things like memory dumping, or any other action that might help the programmer understand what might be going on. All of this can be achieved with near zero performance penalty and interference with the code.

            One final application can be in handling unavoidable arithmetic edge-cases without performance penalties.
        ])
    )

    ///
    #subSection(

        [Performance counter bank],

        [This bank houses the performance counters which, as mentioned earlier, can be used for performance diagnostic, timers and counters. These registers are all CLEN bits wide and their operating mode can be programmed via an extra 8-bits attached to each of them. The PERFC module requires the implementation of this bank, some special instructions (see section 7 for more information) and some exception events. It is important to note that if a counter reaches its maximum value, it will simply silently overflow. The operating modes are the following:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Code*])], [#align(center, [*Description*])],

            [  0], [*Disabled*: \ This mode doesn't do anything.],
            [  1], [*Clock counter*: \ This mode is a simple clock cycle counter that increments with each passing tick.],
            [  2], [*Instruction counter*: \ This mode is a simple instruction counter that increments with each retired instruction.],

            [  3], [*Memory load counter*: \ This mode is a simple instruction counter that increments with each executed memory load instruction.],

            [  4], [*Memory store counter*: \ This mode is a simple instruction counter that increments with each executed memory store instruction.],

            [  5], [*Taken branch counter*: \ This mode, is a simple instruction counter that increments with each taken conditional branch.],

            [  6], [*Non taken branch counter*: \ This mode is a simple instruction counter that increments with each non-taken conditional branch.],

            [  7], [*Stalled cycles counter*: \ This mode is a simple counter that increments with each clock cycle in which the cpu was stalled.],

            [  8], [*Time counter*: \ This mode is a simple timer that counts the passed units of time (configurable via the CNTU special purpose register).],

            [  9], [Reserved for future uses.],
            [...], [...],
            [127], [Reserved for future uses.],

            [128], [Left as a free slot for implementation specific features.],
            [...], [...],
            [255], [Left as a free slot for implementation specific features.]
        )),
        linebreak(),

        comment([

            This bank is a very powerful tool when it comes to performance diagnostics and monitoring. Once configured, the counters will keep track of the desired metrics throught the lifetime of the program. Common statistics, beyond the basic ones mentioned in the table, are often cache hits / misses, TLB hits / misses, BTB hits / misses, branch misspredictions, stalls and many others. I wanted to leave as much freedom to the hardware designers as possible here as it can depend a lot on how the microarchitecture is implemented.
        ])
    )

    ///
    #subSection(

        // TODO: HLPRE multi bit, so that you can choose to denable / disable specific portions

        [Special purpose bank (introduction)],

        [In this subsection, some of the special purpose registers are quickly discussed. Some of these registers are "unprivileged", that is, accessible to anyone at any time regardless of the privilege, while others are "machine mode only". This distinction is not important in the scope of this document, however, more information and clarification will be available in the privileged document. These registers are also _hart private_, which means that, each hart must hold its own copy of these registers. If the system des not support a specific module which requires a particular special purpose register, that address must be ignored and skipped. Any operation on a non existant register must cause an ILLI fault.],

        linebreak(),
        align(center, table(

            columns: (auto, auto, auto, auto),
            inset: 8pt,
            align: (x, y) => (center + horizon, left + horizon, left + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Address*])], [#align(center, [*Short*])], [#align(center, [*Size*])], [#align(center, [*Description*])],

            [0], [PC], [WLEN], [*Program Counter*: \ This register points to the currently executing instruction. This register is sometimes called IP or simply instruction pointer. Any attempt in writing to this register directly without using the dedicated control-flow instructions must cause an ILLI fault.],

            [1], [RMD], [2-bit], [*FP Rounding Mode*: \ This register specifies the current floating-point rounding mode. The following are the rounding modes: #list(tight: false,

                [00: round to nearest even (RNE).],               // RNE
                [01: round towards zero (RTZ).],                  // RTZ
                [10: round towards negative infinity (RNI).],     // RNI
                [11: round towards positive infinity (RPI).]      // RPI
            )],

            [2], [TND], [8-bit], [*Transaction nesting depth*: \ This register specifies the current transaction nesting depth (see section 4 for more information). A value of 0 will signify that no transaction is currently active. Any attempt in writing to this register directly without using the dedicated transactional instructions must cause an ILLI fault.],

            [3], [CMD], [1-bit], [*Consistency mode*: \ This register specifies the current consistency mode. A value of 0 will specify a release-consistency model, while a value of 1 will specify a sequential-consistency model.],

            [4], [GEE], [1-bit], [*Global exception enable*: \ This register specifies if arithmetic flags generate exception events. This "global exception mode" will cause the system to generate the appropriate arithmetic exception event whenever any arithmetic instruction generates a flag. Note that the flags can still cause exceptions even with GEE at 0, if there are helper registers that check for them.],

            [5], [HLPRE], [1-bit], [*Helper registers enable*: \ This register specifies if the helper registers are active or not. Any attempt in writing to this register directly without using the dedicated helper register instructions must cause an ILLI fault.],

            [6], [PERFCE], [1-bit], [*Performance counters enable*: \ This register specifies if the performance counters are active or not. Any attempt in writing to this register directly without using the dedicated performance counter instructions must cause an ILLI fault.],

            [7], [CNTU], [2-bit], [*Performance counters time unit*: \ This register specifies the time unit of all the performance counters that are in "time counter" mode (8). The units are: 00 for nanoseconds, 01 for microseconds, 10 for milliseconds and 11 for seconds. Any attempt in writing to this register directly without using the dedicated performance counter instructions must cause an ILLI fault.],

            [8], [CNTR], [WLEN], [*Performance counters ratio*: \ This register specifies the clock ratio for all performance counters that are in the "clock counter" mode (1). This register is logically divided into two equal parts: the least significant half will specify the clock division factor, while the most significant half will specify the clock multiplication factor. Illegal ratios, depending on the implementation, might be possible and, in those cases, the ILLI event must be generated. Any attempt in writing to this register directly without using the dedicated performance counter instructions must cause an ILLI fault.],

            [9], [VSH], [$2 + log_2("MXVL" / 8)$], [*Vector shape*: \ This register specifies the current vector configuration. VSH is divided into two parts: the most significant two bits specify the size of the singular element, while the remaining least significant bits, specify the number of active elements. Illegal configurations must generate the ILLI fault.],

            [10], [VM1], [$1/8 "MXVL"$], [*Vector mask 1*: \ This register is the vector mask number 1. Each bit maps to a byte in the vector register bank. Any attempt in writing to this register directly without using the dedicated vector control-flow instructions must cause an ILLI fault.],

            [11], [VM2], [$1/8 "MXVL"$], [*Vector mask 2*: \ This register is the vector mask number 2. Each bit maps to a byte in the vector register bank. Any attempt in writing to this register directly without using the dedicated vector control-flow instructions must cause an ILLI fault.],
            
            [12], [VM3], [$1/8 "MXVL"$], [*Vector mask 3*: \ This register is the vector mask number 3. Each bit maps to a byte in the vector register bank. Any attempt in writing to this register directly without using the dedicated vector control-flow instructions must cause an ILLI fault.],

            [13], [IMK], [2-bit], [*Interrupt mask*: \ This register specifies if interrupts are masked or not. Setting the least significant bit will mask all IO interrupts, while setting the most significant bit will mask all the IPC interrupts.],

            [14], [MEPC], [WLEN], [*Machine event PC*: \ This register will hold the PC of the last instruction before the triggering of an event. This register can then be used to return back from an event handler.],

            [15], [MEIMK], [2-bit], [*Machine event IMK*: \ This register will hold the IMK value before the triggering of an event. This register can then be used to restore the state of the IMK register when returning from the event handler.],

            [16], [MEHLPRE], [1-bit], [*Machine event HLPRE*: \ This register will hold the HLPRE value before the triggering of an event. This register can then be used to restore the state of the HLPRE register when returning from the event handler.],

            [17], [MECS], [32-bit], [*Machine event cause*: \ This register specifies the id of which event caused the current hart to trap in the least significant 9 bits, as well as some extra information in the remaining bits.],

            [18], [EMSG], [32-bit], [*Event message*: \ This register specifies extra information about the triggered event. EMSG can be thought as an extension of the MECS register.],

            [19], [MEHP], [WLEN], [*Machine event handler pointer*: \ This register specifies the address of the event handler. The handler must always be one for all events. A switch statement with the help of the event id can then be used to jump to the specific handler.],

            [20], [METMP], [WLEN], [*Machine event temporary*: \ This register can be used as a temporary register during event handling, often during the saving and restoring of the various banks.],

            [21], [PWRS], [4-bit], [*Power state*: \ This register specifies the current power state that the hart is in. PWRS allows for 16 different implementation specific states which may be changed at any time.],

            [22], [HLT], [2-bit], [*Halt bit*: \ This register specifies if the hart is halted or not. A value of 0 will signal that the hart is running, while the other values are used to indicate different halting reasons:
            
                #list(tight: false,
                
                    [01: explicit halt. The hart executed the halt instruction.],
                    [10: implicit halt. The hart was stopped by the STOP IPC interrupt.],
                    [11: catastrophic halt. The hart was halted due to a "double event" situation.]
                )
            ],

            [23], [CLKR], [WLEN], [*Clock ratio*: \ This register specifies the current clock ratio. This register is logically divided into two equal parts: the least significant half will specify the clock division factor, while the most significant half will specify the clock multiplication factor. Illegal ratios, depending on the implementation, might be possible and, in those cases, the hardware must silently write the closest legal value.]
        )),

        comment([

            This bank houses a variety of registers used to alter and change the behaviour of the system while it operates. Many of the modules will require the presence of some special purpose registers in order to function such as vector extensions, transaction module, helper registers, performance counters and others.
            
            As mentioned at the beginning of this section, this is not an exhaustive list mainly because the privileged architecture will add more especially in regards to event handling for each of the privilege levels.

            Attempting to write some special purpose registers with "not allowed" instructions will result in a fault (for example: changing the PC directly by moving a value to it in order to force a jump), forcing the programmer to use the provided dedicated instructions. This can provide the microarchitecture with "hints", unlocking potential optimizations.
        ])
    )

    ///
    #subSection(

        [Events],

        [In this subsection, all the unprivileged events are defined. In general, the term "event" is used to refer to any extraordinary event that may happen at any time and must be handled as soon as possible.],

        [Events can be "promoting", that is, elevate the hart to a higher privilege, however, because an unprivileged architecture always runs at the highest level, this feature will not be used (see the privileged specification for more information).],

        [Events also have _global priority_ and _local priority_ which together define a deterministic order for handling. Global priority dictates the priority for each module, while local priority defines the level for each event whithin each category. Higher values mean higher priority.],

        [The following is the events taxonomy:],

        list(tight: false,
        
            [*Synchronous: * _Synchronous events are deterministic and can be triggered by an instruction, such as a division by zero, or by other sources such as counters and helper registers. This category is further subdivided into two:_
            
                #list(tight: false, marker: [--],
                
                    [*Exceptions:* _Exceptions are low severity events and do no cause a promotion._],
                    [*Faults:* _Faults are high severity events and do cause a promotion._]
                )
            ],

            [*Asynchronous:* _Asynchronous events are non-deterministic and can be triggered by other harts or any external IO device. This category is further subdivided into two:_

                #list(tight: false, marker: [--],

                    [*IO Interrupts:* _These events are triggered by external IO devices._],
                    [*IPC Interrupts:* _These events are triggered by other harts and are sometimes called "notifications"._]
                )
            ]
        ),

        [The following is a list of all events that can be supported by the unprivileged specification:],

        page(flipped: true, align(center, table(

            columns: (auto, auto, auto, auto, auto, auto, auto),
            inset: 6pt,
            align: (x, y) => (right + horizon, left + horizon, left + horizon, center + horizon, left + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Code*])], [#align(center, [*Short*])], [#align(center, [*Module*])], [#align(center, [*GP*])], [#align(center, [*LP*])], [#align(center, [*Type*])], [#align(center, [*Description*])],

            // IOINT module
            [   1], [IOINT_0],  [IOINT], [3],   [0],   [IO Interrupt], [*IO Interrupt 0*: \ Generic IO interrupt.],
            [ ...], [...],      [...],   [...], [...], [...],          [...],
            [  16], [IOINT_15], [IOINT], [3],   [15],  [IO Interrupt], [*IO Interrupt 15*: \ Generic IO interrupt.],

            // IPCINT module
            [  17], [IPCINT_0],  [IPCINT], [4],   [0],   [IPC Interrupt], [*IPC Interrupt 0*: \ Generic IPC interrupt.],
            [ ...], [...],       [...],    [...], [...], [...],           [...],
            [  32], [IPCINT_15], [IPCINT], [4],   [15],  [IPC Interrupt], [*IPC Interrupt 15*: \ Generic IPC interrupt.],

            // FLT module
            [  33], [-],   [FLT], [6],   [-],   [Fault], [See privileged specification for more information.],
            [ ...], [...], [...], [...], [...], [...],   [...],
            [  48], [-],   [FLT], [6],   [-],   [Fault], [See privileged specification for more information.],

            // DALIGN module
            [  49], [MISA], [DALIGN], [6], [-], [Fault], [*Misaligned Address*: \ Triggered when the hart accesses unaligned data. Systems that don't support misaligned accesses must implement the DALIGN module.],

            // Mandatory
            [  50], [MISI], [Mandatory], [6], [-], [Fault], [*Misaligned Instruction*: \ Triggered when the hart tries to fetch a misaligned instruction.],

            [  51], [INCI], [Mandatory], [6], [-], [Fault], [*Incompatible Instruction*: \ Triggered when the hart fetches a non supported instruction. Even if a particular opcode is supported, not all operands might be legal for example: trying to access the 12th helper register when only 8 are supported.],

            [  52], [ILLI], [Mandatory], [6], [-], [Fault], [*Illegal Instruction*: \ Triggered when the hart tries fetch an instruction that is all zeros or all ones],

            [  53], [CONT], [Mandatory], [5], [0], [IPC Interrupt], [*Continue Execution*: \ Causes the halted receiving hart to become "unhalted" and branch to the exception handler. This event should be used to make the hart resume execution. This event is unmaskable and has no effect on non halted harts.],

            [  54], [START], [Mandatory], [5], [1], [IPC Interrupt], [*Start Execution*: \ Causes the halted receiving hart to become "unhalted" and branch to the exception handler. This event should be used to make the hart start executing again from a new address. This event is unmaskable and has no effect on non halted harts.],

            [  55], [STOP], [Mandatory], [5], [2], [IPC Interrupt], [*Stop Execution*: \ Causes the receiving hart to halt immediately. This event is unmaskablen and has no effect on halted harts.],

            // SUPER / USER
            [  56], [TQE], [SUPER, \ USER], [5], [3], [IPC Interrupt], [*Time quantum expired*: \ See privileged specification for more information.],

            [  57], [-],   [-],   [-],   [-],   [-],   [Reserved for future uses.],
            [ ...], [...], [...], [...], [...], [...], [...],
            [  63], [-],   [-],   [-],   [-],   [-],   [Reserved for future uses.],

            // EXC module
            [  64], [COVRE], [EXC], [0], [Program order], [Exception], [*Carry Over Exception*: \ This event is triggered by the COVRn flag, where  \ $n = 1/8 dot 2^"WLEN"$],

            [  65], [CUNDE], [EXC], [0], [Program order], [Exception], [*Carry Under Exception*: \ This event is triggered by the CUND flag.],

            [  66], [OVFLE], [EXC], [0], [Program order], [Exception], [*Overflow Exception*: \ This event is triggered by the OVFLn flag, where \ $n = 1/8 dot 2^"WLEN"$],

            [  67], [UNFLE], [EXC], [0], [Program order], [Exception], [*Underflow Exception*: \ This event is triggered by the UNFLn flag, where \ $n = 1/8 dot 2^"WLEN"$],

            [  68], [DIV0E], [EXC], [0], [Program order], [Exception], [*Division by Zero Exception*: \ This event is triggered by the DIV0 flag.],

            [  69], [-],   [EXC], [0],   [Program order], [EXC], [Reserved for future uses.],
            [ ...], [...], [...], [...], [...],           [...], [...],
            [ 127], [-],   [EXC], [0],   [Program order], [EXC], [Reserved for future uses.],

            // HLPR module
            [ 128], [RDT], [HLPR], [1], [See subsection 6.3], [Exception], [*Read Trigger*: \ Event for mode 1 and 6 of the helper registers.],
            [ 129], [WRT], [HLPR], [1], [See subsection 6.3], [Exception], [*Write Trigger*: \ Event for mode 2 and 7 of the helper registers.],
            [ 130], [EXT], [HLPR], [1], [See subsection 6.3], [Exception], [*Execute Trigger*: \ Event for mode 3 and 8 of the helper registers.],

            [ 131], [RWT], [HLPR], [1], [See subsection 6.3], [Exception], [*Read-Write Trigger*: \ Event for mode 4 and 9 of the helper registers.],

            [ 132], [RWET], [HLPR], [1], [See subsection 6.3], [Exception], [*Read-Write-Execute Trigger*: \ Event for mode 5 and 10 of the helper registers.],

            [ 133], [COVR1T], [HLPR], [1], [See subsection 6.3], [Exception], [*Carry Over 1 Trigger*: \ Event for mode 11 of the helper registers.],

            [ 134], [COVR2T], [HLPR], [1], [See subsection 6.3], [Exception], [*Carry Over 2 Trigger*: \ Event for mode 12 of the helper registers.],

            [ 135], [COVR4T], [HLPR], [1], [See subsection 6.3], [Exception], [*Carry Over 4 Trigger*: \ Event for mode 13 of the helper registers.],

            [ 135], [COVR8T], [HLPR], [1], [See subsection 6.3], [Exception], [*Carry Over 8 Trigger*: \ Event for mode 14 of the helper registers.],

            [ 136], [CUNDT], [HLPR], [1], [See subsection 6.3], [Exception], [*Carry Under Trigger*: \ Event for mode 15 of the helper registers.],
            [ 137], [OVFL1T], [HLPR], [1], [See subsection 6.3], [Exception], [*Overflow 1 Trigger*: \ Event for mode 16 of the helper registers.],
            [ 138], [OVFL2T], [HLPR], [1], [See subsection 6.3], [Exception], [*Overflow 2 Trigger*: \ Event for mode 17 of the helper registers.],
            [ 139], [OVFL4T], [HLPR], [1], [See subsection 6.3], [Exception], [*Overflow 4 Trigger*: \ Event for mode 18 of the helper registers.],
            [ 140], [OVFL8T], [HLPR], [1], [See subsection 6.3], [Exception], [*Overflow 8 Trigger*: \ Event for mode 19 of the helper registers.],

            [ 141], [UNFL1T], [HLPR], [1], [See subsection 6.3], [Exception], [*Underflow 1 Trigger*: \ Event for mode 20 of the helper registers.],

            [ 142], [UNFL2T], [HLPR], [1], [See subsection 6.3], [Exception], [*Underflow 2 Trigger*: \ Event for mode 21 of the helper registers.],

            [ 143], [UNFL4T], [HLPR], [1], [See subsection 6.3], [Exception], [*Underflow 4 Trigger*: \ Event for mode 22 of the helper registers.],

            [ 144], [UNFL8T], [HLPR], [1], [See subsection 6.3], [Exception], [*Underflow 8 Trigger*: \ Event for mode 23 of the helper registers.],

            [ 145], [DIV0T], [HLPR], [1], [See subsection 6.3], [Exception], [*Division by Zero Trigger*: \ Event for mode 24 of the helper registers.],

            [ 156], [-],   [HLPR], [1],   [-],   [Exception], [Reserved for future uses.],
            [ ...], [...], [...],  [...], [...], [...],       [...],
            [ 255], [-],   [HLPR], [1],   [-],   [Exception], [Reserved for future uses.],
            [ 256], [-],   [HLPR], [1],   [-],   [Exception], [Left as implementation specific.],
            [ ...], [...], [...],  [...], [...], [...],       [...],
            [ 383], [-],   [HLPR], [1],   [-],   [Exception], [Left as implementation specific.]
        ))),

        [When the hart is trapped by an event, a handling procedure must be performed in order to successfully handle the event. Such procedure is left to the programmer to define, however, the steps needed to reach the code of such procedure must be implemented in hardware.],
        
        [The following ordered steps must be performed in a single cycle:],

        enum(tight: false,
        
            [_Write the value of the PC to the MEPC special purpose register._],
            [_Write the current values of the IMK and HLPRE into the MEIMK and MEHLPRE special purpose registers respectively._],
            [_Mask any incoming maskable IO interrupt and IPC interrupt by setting both bits of the IMK special purpose register to one._],
            [_Disable the helper registers by setting the HLPRE special purpose register to one._],
            [_Write the MECS and EMSG special purpose registers with the appropriate value (depends on the event)._],
            [_Write the value of the MEHP special purpose register to the PC._]
        ),

        [After reaching the handling procedure, it's extremely important to save to memory the all the "critical" state that was temporarily copied into the MEPC, MEIMK, MEHLPRE, MECS and EMSG. This is because, in order to support the nesting of events, it must be possible to restore the critical state of the previous handler. If the hart is re-trapped, for any reason, before the critical state is saved to memory, loss of information can occur and it won't be possible to restore it. This catastrophic failure must be detected (by simply checking if all the critical registers have been saved to memory) and, if it happens, the hart must be immediately halted with code 3 in the HLT special purpose register.],

        [Returning from an event handler requires executing the appropriate dedicated return instruction (see section 7 for  more information). Such intruction will undo the above described sequence by performing the following steps in a single cycle:],

        enum(tight: false,
        
            [_Write the value of the MEPC special purpose register to the PC._],
            [_Write the current values of the MEIMK and MEHLPRE special purpose registers back into the IMK and HLPRE respectively._],
            [_Execute the appropriate event handler return instruction (see section 7 and the privileged documentation for more information)._]
        ),

        [During event handling, other events might be received by the hart. This situation was already mentioned in the previous sections and a queuing system is needed in order to avoid loss of information. Queues have finite length so it's important to handle the events more rapidly than they come, however if the events are too frequent the queues will eventually fill. Any IO interrupt that is received while the queues are full, must be discarded and the interrupting device must be notified. A similar argument can be made for IPC interrupts, except for CONT, START, STOP and TQE events which can ignore the queues (see section 7, as well as the privileged specification for more information).],

        comment([

            Events are a very powerfuly way to react to different things "on the fly", which is very useful for event-driven programming, managing external devices at low latency and are essential for privileged architectures.

            The division in different categories might seem a bit strange at first, but the two broad classes are the usual ones: synchronous and asyncronous events. The different types of events within each class are roughly based on "severity" (which is basically the global priority metric), as well as a local priority which can depend on different things.
            
            Exceptions are the lowest severity among all other events and the program order defines the order in which they must be handled. The only complication to this rule is for helper register exceptions, which have a higher intrinsic priority and the handling order depends on which particular helper register fired. These exceptions might also clash with the previously mentioned regular arithmetic ones but, since the helper ones have a higher innate priority, they all take over.

            Faults are also synchronous just like exceptions, but their severity is the highest among any other event and they often signify that something bad happened. Because they are synchronous, they must be handled in program order.

            IO Interrupts are the lowest global priority asynchronous event and they are used to handle external device requests. They have a progressive local priority that defines the order in which they must be handled.

            IPC Interrupts are a higher priority version of the IO Interrupt. IPC Interrupts are used by harts to send signals to each other, which also includes, starting and stopping other harts.

            In some situations it may be necessary to queue an event in order to handle it after another and to avoid loss of information. If the queue is full, the events must be discarded and, whoever generated the event, must simply be notified. This includes IO devices or other harts that generated an IPC interrupt, in this last case, by making their IPC interrupt generating instruction fail.
        ])
    )

    ///
    #subSection(

        [Configuration registers],

        [In previous sections, this document introduced several different configuraion constants, which describe the features, that any system must have in order to be considered compliant to the FabRISC architecture. These parameters must be stored in a dedicated static, read-only memory-like region (byte addressable), that is private for each hart. The following table lists all said parameters:],

        align(center, table(

            columns: (auto, auto, auto, auto),
            inset: 8pt,
            align: (x, y) => (right + horizon, right + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Start*])], [#align(center, [*End*])], [#align(center, [*Parameter*])], [#align(center, [*Description*])],

            [   0], [   7], [ISAMOD],   [See section 2.],
            [   8], [  11], [UISAV],    [See section 2.],
            [  12], [  15], [PISAV],    [See section 2.],
            [  16], [  16], [WLEN],     [See section 2.],
            [  17], [  17], [MXVL],     [See section 2.],
            [  18], [  18], [CLEN],     [See section 2.],
            [  19], [  19], [SRFS],     [See section 2.],
            [  20], [  20], [VRFS],     [See section 2.],
            [  21], [  21], [HRFS],     [See section 2.],
            [  22], [  22], [CRFS],     [See section 2.],
            [  23], [  23], [IOLEN],    [See section 2.],

            [  24], [  31], [CPUID],    [Unique CPU identifier.],
            [  32], [  39], [CPUVID],   [Unique CPU vendor identifier.],
            [  40], [ 295], [CPUNAME],  [CPU name.],
            [ 296], [ 297], [NCORES],   [Number of physical CPU cores.],
            [ 298], [ 298], [NTHREADS], [Number of logical CPU cores per physical core (hardware threads or harts).],
            [ 299], [ 302], [TID],      [Unique identifier of the current hart.],

            [303],  [ 306], [BCLK],     [Current base clock frequency. The values signify units of 1Hz.],

            [307],  [ 308], [TEMP],     [Current temperature. The representation is fixed point and the lower 16-bits indicate the denominator, while the remaining bits indicate the numerator of the fraction.],

            [309],  [ 310], [VOLT],     [Current voltage. The representation is fixed point and the lower 16-bits indicate the denominator, while the remaining bits indicate the numerator of the fraction.],

            [311], [ 508], [-],         [Reserved for future uses.],

            [ 509], [ 510], [CSTMS],    [Custom space size. This parameter specifies how big (in bytes) is the space that is left as implementation specific. If such space is not implemented, a value of 0 must be used.],

            [ 511], [4096], [-],        [Left as implementation specific space.],
        )),

        comment([

            These read-only parameters describe the hardware configuration and capabilities. Some of the parameters have been explained in earlier sections, while others are new. Most of the parameters are global for all harts, while others, such as TID, are specific. The remaining space is left to the hardware designers as a blank canvas on which they can provide more information and details about the microarchitecture. 
        ])
    )

    ///
    #subSection(

        [Instruction formats],

        [FabRISC organizes the instructions in 21 different formats with lengths of 2, 4 and 6 bytes and opcode lengths ranging from 4 to 20 bits. Formats that specify the "md" field are also subdivided into "classes" at the instruction level. This is because the _md_ field acts as an extra modifier, such as, extra immediate bits, data type selector or small shift amounts.],

        [The following is the complete list of formats:],

        page(flipped: true, text(size: 10pt,
        
            [#align(center, tablex(

                columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr),

                align: center + horizon,

                [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],

                [3R-A], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(13)[op \ 4...16],colspanx(5)[rc \ 0...4],colspanx(5)[rb \ 0...4],

                [4R-A], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(8)[op \ 4...11],colspanx(5)[rd \ 0...4],colspanx(5)[rc \ 0...4],colspanx(5)[rb \ 0...4],

                [RI-A], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(7)[op \ 4...10],colspanx(6)[im \ 5...0],colspanx(3)[im \ 8...6],colspanx(2)[im \ 10...9],colspanx(5)[im \ 15...11],

                [2RI-A], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(6)[op \ 4...9],[im \ 11],colspanx(6)[im \ 5...0],colspanx(3)[im \ 8...6],colspanx(2)[im \ 10...9],colspanx(5)[rb \ 0...4],

                [3RI-A], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(5)[op \ 4...8],colspanx(8)[im \ 7...0],colspanx(5)[rc \ 0...4],colspanx(5)[rb \ 0...4],

                [2R-A], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(16)[op \ 4...19],colspanx(2)[md \ 1...0],colspanx(5)[rb \ 0...4],

                [3R-B], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(11)[op \ 4...14],colspanx(2)[md \ 1...0],colspanx(5)[rc \ 0...4],colspanx(5)[rb \ 0...4],

                [4R-B], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(6)[op \ 4...9],colspanx(2)[md \ 1...0],colspanx(5)[rd \ 0...4],colspanx(5)[rc \ 0...4],colspanx(5)[rb \ 0...4],

                [RI-B], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(5)[op \ 4...8],colspanx(2)[im \ 10...9],colspanx(6)[im \ 5...0],colspanx(3)[im \ 8...6],colspanx(2)[md \ 1...0],colspanx(5)[im \ 15...11],

                [2RI-C], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(4)[op \ 4...7],colspanx(3)[im \ 11...9],colspanx(6)[im \ 5...0],colspanx(3)[im \ 8...6],colspanx(2)[md \ 1...0],colspanx(5)[rb \ 0...4],

                [I-A], colspanx(4)[op \ 0...3],colspanx(5)[im \ 23...19],colspanx(4)[op \ 4...7],colspanx(3)[im \ 18...16],colspanx(6)[im \ 5...0],colspanx(3)[im \ 8...6],colspanx(2)[im \ 10...9],colspanx(5)[im \ 15...11],
            ))

            #align(center, tablex(

                columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,auto),

                align: center + horizon,

                [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32...47],

                [2RI-B], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(5)[op \ 4...8],colspanx(8)[im \ 7...0],colspanx(5)[rc \ 0...4],colspanx(5)[rb \ 0...4],[im \ 0...15],

                [3RI-B], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(16)[op \ 4...19],colspanx(2)[md \ 1...0],colspanx(5)[rb \ 0...4],[im \ 0...15]
            ))

            #linebreak()
            #align(center, tablex(

                columns: (auto,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,1fr,),
                align: center + horizon,

                [*Name*],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],

                [R-A], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(7)[op \ 4...10],
                [2R-B], colspanx(4)[op \ 0...3],colspanx(3)[ra \ 0...2],colspanx(2)[rb \ 0...1],colspanx(6)[op \ 4...9],[rb \ 1],
                [2R-C], colspanx(4)[op \ 0...3],colspanx(5)[ra \ 0...4],colspanx(2)[op \ 4...5],colspanx(5)[rb \ 0...4],
                [2R-D], colspanx(4)[op \ 0...3],colspanx(3)[ra \ 0...2],colspanx(2)[md \ 0...1],colspanx(4)[op \ 4...7],colspanx(3)[rb \ 0...2],
                [I-B], colspanx(4)[op \ 0...3],colspanx(3)[im \ 9...7],colspanx(2)[im \ 1...0],colspanx(2)[op \ 4...5],colspanx(5)[im \ 6...2],
                [RI-C], colspanx(4)[op \ 0...3],colspanx(3)[ra \ 0...2],colspanx(2)[im \ 1...0],colspanx(4)[op \ 4...7],colspanx(3)[im \ 4...2],
                [RI-D], colspanx(4)[op \ 0...3],colspanx(3)[ra \ 0...2],colspanx(2)[im \ 1...0],[op \ 4],colspanx(6)[im \ 7...2],
                [2RI-D], colspanx(4)[op \ 0...3],colspanx(3)[ra \ 0...2],colspanx(2)[im \ 1...0],colspanx(3)[im \ 4...2],[im \ 5],colspanx(3)[rb \ 0...2]
            ))
        ])),

        [Formats _2R-A_, _3R-B_, _4R-B_, _RI-B_, _2RI-B_, _3RI-B_, _2RI-C_ and _2R-D_ are affected by the modifier field _md_. The following are the possible classes:],

        align(center, table(

            columns: (1fr, 3fr),
            inset: 8pt,
            align: (x, y) => (left + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Class*])], [#align(center, [*Description*])],

            [], [Nothing. The _md_ field is ignored.],
            [.L1, .L2, \ .L4, .L8], [Data type size.],

            [.RNE, .RTZ, \ .RNI, .RPI], [Explicit rounding mode. This parameter will override the currently specified rounding mode in the special purpose register RMD.],

            [.S0, .S8, \ .S16, .S32], [Shift amount. This value is specified in bits and the direction depends on the individual instruction.],
            [.M0, .M1, \ .M2, .M3], [Vector mask selector. Mask 0 is the "0 mask", that is, a read-only mask that never masks any lane.],
            [.SGPRB, \ .VGPRB, \ .HLPRB, \ .PERFCB], [File selector.],
            [.I00, .I01, \ .I10, .I11], [Extra immediate bits. The specified bits are always the most significant.],
        ))
    )

#pagebreak()

///