///
#import "Macros.typ": *

///
#section(

    [Register File Organization],

    [In this section the various register file banks, calling convention (ABI) and the configuration segment of the FabRISC architecture are presented.],

    ///.
    subSection(

        [Register File Banks],

        [Depending on which modules are chosen as well as the ISA parameter values, the register file can be composed of up to five different banks of variable width registers, including special purpose ones mainly used for status and configuration. Some registers are considered privileged and / or hart-private, that is, each hart must hold its own copy of such registers. The banks are briefly described in the following table:],

        tableWrapper([Register file banks.], table(

            columns: (auto, auto),
            align: (x, y) => (left + top, left + top).at(x),

            [#middle([*Name*])], [#middle([*Description*])],

            [`SGPRB`], [*Scalar General Purpose Register Bank*: \ This bank is composed of `SRFS` number of registers which can be used to hold data during program execution. The registers are all `WLEN` bits wide and are used by scalar integer and floating point instructions together. These registers are not privileged, but private for each hart and must always be implemented.],

            [`VGPRB`], [*Vector General Purpose Register Bank*: \ This bank is composed of `VRFS` number of registers which can be used to hold data during program execution. The registers are all `MXVL` bits wide and are used by vector integer and floating point instructions together. These registers are not privileged, but private for each hart and are only needed when the system implements any vector related module.],

            [`HLPRB`], [*Helper Register Bank*: \ This bank is composed of `HRFS` number of registers which can be used for debugging, automatic address boundary checking as well as triggering exceptions in precise occasions. These registers are all $"WLEN" + 8$ bits wide, not privileged, but private for each hart and are only needed when the system implements the `HLPR` module.],

            [`PERFCB`], [*Performance Counters Bank*: \ This bank is composed of `CRFS` number of registers which can be used for performance diagnostic, timers and counters. These registers are all $"CLEN" + 8$ bits wide, not privileged, but private for each hart and are only needed when the system implements the `PERFC` module.],

            [`SPRB`], [*Special Purpose Register Bank*: \ This bank is composed of various special purpose registers used to keep track of the system status and configuration. The number of these registers, as well as their width, can vary depending on which modules are chosen. They are always hart-private, however, privileges are defined for each individual register later in this section.]
        )),

        [FabRISC provides the *Scalar Register File Size* (`SRFS`), *Vector Register File Size* (`VRFS`), *Helper Register File Size* (`HRFS`) and the *Counter Register File Size* (`CRFS`) 2 bit ISA parameters, to indicate the number of registers in the scalar, vector, helper and counter files respectively. Depending on the value of `SRFS`, the calling convention differs slightly. If the system doesn't support the `HLPR` or `PERFC` or any module that necessitates the vector register file, then their corresponding parameter has no meaning and must be set to zero for convention. The possible values are listed in the following table:],

        tableWrapper([Scalar register file sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + top).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [0], [8 entries. ],
            [1], [16 entries.],
            [2], [32 entries.],
            [3], [Reserved for future uses.]
        )),

        [FabRISC provides the *Maximum Vector Length* (`MXVL`) 3 bit ISA parameter, to indicate the maximum vector length in bits. If the system doesn't support any vector capability, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the following table:],

        tableWrapper([Maximum vector length sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + top).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [0], [16 bit wide for 8 bit machines ($"WLEN" = 0$).],
            [1], [32 bit wide for 8 and 16 bit machines ($"WLEN" = 0, 1$).],
            [2], [64 bit wide for 8, 16 and 32 bit machines ($"WLEN" = 0, 1, 2$).],
            [3], [128 bit wide for 8, 16, 32 and 64 bit machines ($"WLEN" = 1, 2, 3$).],
            [4], [256 bit wide for 8, 16, 32 and 64 bit machines ($"WLEN" = 2, 3$).],
            [5], [512 bit wide for 16, 32 and 64 bit machines ($"WLEN" = 3$).],
            [6,7], [Reserved for future uses.],
        )),

        comment([

            Five banks of several registers might seem overkill, but thanks to FabRISC flexibility the hardware designers can choose only what they desire and how much. The `SGPRB` and `VGPRB` are standard across many ISAs and are the classic scalar general purpose and vector files. I decided to not split integer and floating point further into separate files because i wanted to allow easy bit manipulation on floating point data without having to move back and forth between files, as well as for simplicity and lower amount state. This can increase the register pressure in some situations but the ISA provides instructions that allow efficient data packing and unpacking, thus alleviating some of the pressure. Another issue could potentially be a higher number of structural hazards as both integer and floating point instructions will read and write to the same bank in highly parallel systems.

            The `HLPRB` and `PERFCB` are a "nice to have" features for more advanced systems allowing a very granular amount of control over arithmetic edge cases, memory boundary checking, debugging, as well as performance monitoring. Performance counters are a standard feature among modern processors because they are essential in determine what causes stalls and bottlenecks, thus allowing for proper software profiling at the lowest possible level.

            The `SPRB` mainly holds privileged registers and flag bits that dictate the behavior of the system while it's running. This bank also holds several structures that are essential for events and other modules to work.

            This ISA also allows quite large vector widths to accommodate more exotic and special microarchitectures as well as byte-level granularity. The size must be at least twice the `WLEN` up to a maximum of eight times, which is quite large even for vector heavy specialist machines. Vector execution is also possible at low `WLEN` of 8 and 16 bits but it probably won't be the best idea because of the limited word length. I expect an `MXVL` of 128 to 256 bits to be the most used for general purpose microarchitectures such as CPUs because it gives a good boost in performance for data-independent code, without hindering other aspects of the system such as power consumption, frequency or resource usage in FPGAs too much. 512 bits will probably be the practical limit as even real commercial CPUs make tradeoffs between width and frequency. For an out-of-order machine the reservation stations and the reorder buffer would already be quite sizeable at 512 bits, however, it's always possible to decouple the two pipelines in order to minimize power and resource usage if a wide `MXVL` is desired.
        ])
    ),

    ///.
    subSection(

        [Application Binary Interface],

        [FabRISC specifies an ABI for the `SGPRB` and `VGPRB`. It is important to remember that this is a suggestion on how the general purpose registers should be used in order to increase code compatibility. As far as the underlying hardware is concerned, all general purpose registers are equal and behave in the same way. The register convention for `SGPRB` is the following:],

        pagebreak(),
        tableWrapper([`SGPRB` application binary interface.], table(

            columns: (auto, auto),
            align: (x, y) => (left + top, left + top).at(x),

            [#middle([*Marker*])], [#middle([*Description*])],

            [$P_i$], [*Parameter Registers*: \ These registers are used for parameter passing and returning to and from function calls. Parameters are stored in these registers starting from the top-down $P_0 -> P_n$, while returning values are stored starting from the bottom-up $P_n -> P_0$. Functions are allowed to mutate any parameter register that is assigned to them.],

            [$S_i$], [*Persistent Registers*: \ These registers are "persistent", that is, they are registers whose value should be retained across function calls. This implies a callee-save calling convention.],

            [$N_i$], [*Volatile Registers*: \ These registers are "volatile" or simply "non-persistent", that is, they are registers whose value may not be retained across function calls. This implies a caller-save calling convention.],

            [SP], [*Stack Pointer*: \ This register is used as a pointer to the current top of the call-stack. The calling convention for this register is callee-save.],

            [FP], [*Frame Pointer*: \ This register is used as a pointer to the base of the currently active call-stack frame. The calling convention for this register is callee-save.],

            [GP], [*Global Pointer*: \ This register is used to point to the global variable area and is always accessible across calls. There is no calling convention for this register since it should be a static value for the most part. If modifying is absolutely necessary the responsibility is on the callee to save and restore the old value.],

            [RA], [*Return Address*: \ This register is used to hold the return address for the currently executing function. The calling convention for this register is caller-save.]
        )),

        [Depending on the `SRFS` parameter, the layout of the `SGPRB` is different. In order to maintain compatibility across different `SRFS` values, the registers are placed at strategic points. This way, the smaller ABI is a subset of the bigger one:],

        pagebreak(),
        tableWrapper([`SGPRB` ABI sizes.], table(

            columns: (auto, auto, auto),
            align: center + top,

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

        [Some compressed instructions are limited in the number of registers that they can address due to their reduced size. The specifiers are 3 or 4 bits long allowing the top eight or sixteen registers to be addressed only. The proposed ABI already accounts for this by placing the most important registers at the top of the bank.],

        [Vector registers are all considered volatile, which means that the caller-save scheme must be utilized since it's assumed that their value won't be retained across function calls. Special instructions are also provided to move these registers, or part of them, between the `VGPRB` and `SGPRB` to ease data transfer.],

        comment([

            FabRISC is a flexible ISA that offers different amounts of entries in the scalar and vector general purpose register banks, however, this necessitates of an ABI for each possible size of the bank. Compressed instructions can only address eight or sixteen registers due to their shorter size. The ABI for the 16-entry variant is a superset of the 8-entry one and the 32-entry ABI is a superset of all. This allows for complete forwards compatibility between processors with a different `SRFS` number, as well as making compressed instructions work seamlessly.

            The parameter registers are peculiar in that they share both function parameters and return values, allowing to return multiple results from a single function.

            Lastly, i didn't include the zero-register because i felt that it didn't provide much value to the architecture since the ISA is big and complex enough to not need it.
        ])
    ),

    ///.
    subSection(

        [Helper Register Bank],

        [This bank houses the helper registers which, as mentioned earlier, can be used for debugging, address range checks and triggering exceptions. These registers are all `WLEN` bits wide and their operating mode can be programmed via an additional 8 bits attached to each one. The `HLPR` module requires the implementation of this bank, special instructions to manipulate its state, all exception events listed in the `EXC` module plus additional ones listed below. The operating modes are the following:],

        pagebreak(),
        tableWrapper([Helper register modes.], table(

            columns: (auto, auto),
            align: (x, y) => (right + top, left + top).at(x),

            [#middle([*Code*])], [#middle([*Description*])],

            [  0], [*Disabled*: \ This mode doesn't do anything. Helper registers that are in this mode can still be red and written and utilized at any moment with a caller-save scheme, which simply means, that they are considered volatile.],

            [  1], [*Range end*: \ This mode simply signifies that the corresponding register value is the end of an address range started by the previous register. If the previous register does not specify a range mode, then this one behaves in the same way as `Disabled`.],

            [  2], [*Trigger on read address*: \ This mode causes the corresponding helper register to generate the `RDT` exception as soon as the hart tries to read data from the specified address.],

            [  4], [*Trigger on write address*: \ This mode causes the corresponding helper register to generate the `WRT` exception as soon as the hart tries to write data to the specified address.],

            [  6], [*Trigger on execute address*: \ This mode causes the corresponding helper register to generate the `EXT` exception as soon as the hart tries to execute the instruction at the specified address.],

            [  8], [*Trigger on read or write address*: \ This mode causes the corresponding helper register to generate the `RWT` exception as soon as the hart tries to read or write data at the specified address.],

            [ 10], [*Trigger on read or write or execute address*: \ This mode causes the corresponding helper register to generate the `RWET` exception as soon as the hart tries to read, write data or execute the instruction at the specified address.],

            [ 12], [*Trigger on COVR1 flag*: \ This mode causes the corresponding helper register to generate the `COVR1T` exception as soon as the `COVR1` flag is raised at the instruction address held in the current register.],

            [ 14], [*Trigger on COVR2 flag*: \ This mode causes the corresponding helper register to generate the `COVR2T` exception as soon as the `COVR2` flag is raised at the instruction address held in the current register.],

            [ 16], [*Trigger on COVR4 flag*: \ This mode causes the corresponding helper register to generate the `COVR4T` exception as soon as the `COVR4` flag is raised at the instruction address held in the current register.],

            [ 18], [*Trigger on COVR8 flag*: \ This mode causes the corresponding helper register to generate the `COVR8T` exception as soon as the `COVR8` flag is raised at the instruction address held in the current register.],

            [ 20], [*Trigger on CUND flag*: \ This mode causes the corresponding helper register to generate the `CUNDT` exception as soon as the `CUND` flag is raised at the instruction address held in the current register.],

            [ 22], [*Trigger on OVFL1 flag*: \ This mode causes the corresponding helper register to generate the `OVFL1T` exception as soon as the `OVFL1` flag is raised at the instruction address held in the current register.],

            [ 24], [*Trigger on OVFL2 flag*: \ This mode causes the corresponding helper register to generate the `OVFL2T` exception as soon as the `OVFL2` flag is raised at the instruction address held in the current register.],

            [ 26], [*Trigger on OVFL4 flag*: \ This mode causes the corresponding helper register to generate the `OVFL4T` exception as soon as the `OVFL4` flag is raised at the instruction address held in the current register.],

            [ 28], [*Trigger on OVFL8 flag*: \ This mode causes the corresponding helper register to generate the `OVFL8T` exception as soon as the `OVFL8` flag is raised at the instruction address held in the current register.],

            [ 30], [*Trigger on UNFL1 flag*: \ This mode causes the corresponding helper register to generate the `UNFL1T` exception as soon as the `UNFL1` flag is raised at the instruction address held in the current register.],

            [ 32], [*Trigger on UNFL2 flag*: \ This mode causes the corresponding helper register to generate the `UNFL2T` exception as soon as the `UNFL2` flag is raised at the instruction address held in the current register.],

            [ 34], [*Trigger on UNFL4 flag*: \ This mode causes the corresponding helper register to generate the `UNFL4T` exception as soon as the `UNFL4` flag is raised at the instruction address held in the current register.],

            [ 36], [*Trigger on UNFL8 flag*: \ This mode causes the corresponding helper register to generate the `UNFL8T` exception as soon as the `UNFL8` flag is raised at the instruction address held in the current register.],

            [ 38], [*Trigger on DIV0 flag*: \ This mode causes the corresponding helper register to generate the `DIV0T` exception as soon as the `DIV0` flag is raised at the instruction address held in the current register.],

            [ 40], [*Trigger on INVOP flag*: \ This mode causes the corresponding helper register to generate the `INVOPT` exception as soon as the `INVOP` flag is raised at the instruction address held in the current register.],

            [ 42], [Reserved for future uses.],
            [...], [...],
            [ 63], [Reserved for future uses.],

            [ 64], [Left as a free slot for implementation specific features.],
            [...], [...],
            [127], [Left as a free slot for implementation specific features.]
        )),

        [Helper registers can be configured to work as pairs, allowing the creation a range of addresses by setting the least significant bit of each mode to one. When a helper register has a mode that specifies a range, the next one is set to mode 1 automatically to mark the end. If multiple ranges for the same trigger are present, then they must be OR-ed together in order to allow proper boundary checking.],

        [Modes 3, 5, 7, 9 and 11, which all specify a range, must write into the `MED` or `UED` registers, depending on the currently active privilege, the actual triggering address. These modes are the only ones that carry additional event information.],

        [If multiple identical events are triggered on the same instruction address, then they must be merged into a single event. This situation can also occur when different events that "include" each other trigger, for example, mode 1 and 3. In this case the more specific one, mode 2 in this example, must suppress the more generic one.],

        [If multiple distinct events are triggered on the same instruction address, then their ids can be placed into `MEC` or `UEC`, depending on the privilege, ordered from the higher priority one to the left to the lesser priority one to the right forming a "group". If they are too many to fit, the remaining ones must discarded. The `MED` or `UED` should be populated, if necessary, with the additional data of the higher priority event of the group only.],

        [The `COVRnT`, `CUNDT`, `OVFLnT` and `UNFLnT` events must override the `COVRE`, `CUNDE`, `OVFLE`, `UNFLE` and `DIV0E` arithmetic exceptions of the `EXC` module if present, where $n = 1/8 dot 2^"WLEN"$. This means that the listed events take precedence and suppress the standard arithmetic exceptions when both are triggered for the same instruction address.],

        pagebreak(),
        comment([

            This bank can be used to aid the programmer in a variety of situations. A big one is memory safety: by specifying address ranges on instruction fetch, loads and stores, the system can automatically throw the appropriate exception when the constraint is violated without explicitly checking with a branch each time. This is helpful to avoid unintentionally overwriting portions of memory, thus reducing chances of exploits and increase memory safety with no performance hit. The triggered events can be caught in order to execute handling code without needing to invoke the operating system.

            Another situation is debugging: by placing the desired breakpoints in the desired spots of the program, exceptions can be triggered and handled to perform things like memory / state dumping, or any other action that might help the programmer understand what is going on in the system. All of this can be achieved with near zero interference with the actual code.

            Another application can be in handling unavoidable arithmetic edge cases without performance penalties, enabling safer arithmetic as well as aiding arbitrary precision data types.

            Finally, these registers can also be used as an extra `SGPRB` as an additional container for register spills before going to memory. In this case, they are treated as simple volatile registers.

            This bank is one of the more unique features of FabRISC. I initially wanted to provide a simpler mechanism to trap on arithmetic edge cases, in a more traditional way by adding a bit to each instruction that enables or suppresses exceptions. This, however, reduced the encoding and operand space in the instructions forcing me to create more formats to ease the pressure. Another alternative would have been to provide additional state in the registers themselves or in the `SR`, however, in the end i decided to scrap those solutions in favor of the helper registers with the main reason being flexibility and options.
        ])
    ),

    ///.
    subSection(

        [Performance Counters Bank],

        [This bank houses the performance counters which, as mentioned earlier, can be used for performance diagnostic, timers and counters. These registers are all `CLEN` bits wide and their operating mode can be programmed via an extra 8 bits attached to each of them. The `PERFC` module requires the implementation of this bank and special instructions to manipulate its state. It is important to note that counters silently wrap around when they reach their maximum value. The operating modes are the following:],

        pagebreak(),
        tableWrapper([Performance counter modes.], table(

            columns: (auto, auto),
            align: (x, y) => (right + top, left + top).at(x),

            [#middle([*Code*])], [#middle([*Description*])],

            [  0], [*Disabled*: \ This mode doesn't do anything. Performance counters that are in this mode can still be red and written and utilized at any moment with a caller-save scheme, which simply means, that they are considered volatile.],

            [  1], [*Instruction counter*: \ This mode is a simple instruction counter that increments with each executed instruction.],

            [  2], [*Memory load counter*: \ This mode is a simple instruction counter that increments with each executed memory load instruction.],

            [  3], [*Memory store counter*: \ This mode is a simple instruction counter that increments with each executed memory store instruction.],

            [  4], [*Taken branch counter*: \ This mode, is a simple instruction counter that increments with each taken conditional branch.],

            [  5], [*Non taken branch counter*: \ This mode is a simple instruction counter that increments with each non-taken conditional branch.],

            [  6], [*Time counter seconds*: \ This mode is a simple timer that counts thread-time seconds.],

            [  7], [*Time counter millis*: \ This mode is a simple timer that counts thread-time milliseconds. The `ILLI` fault must be thrown if the system is not capable of ticking counters with speeds of 1KHz.],

            [  8], [*Time counter micros*: \ This mode is a simple timer that counts thread-time microseconds. The `ILLI` fault must be thrown if the system is not capable of ticking counters with speeds of 1MHz.],

            [  9], [*Time counter nanos*: \ This mode is a simple timer that counts thread-time nanoseconds. The `ILLI` fault must be thrown if the system is not capable of ticking counters with speeds of 1GHz.],

            [ 10], [*Clock counter*: \ This mode is a simple clock cycle counter. Sixteen codes are reserved and each subsequent code divides the frequency of the previous mode by two before advancing the counter.],

            [ 27], [Reserved for future uses.],
            [...], [...],
            [127], [Reserved for future uses.],

            [128], [Left as a free slot for implementation specific features.],
            [...], [...],
            [255], [Left as a free slot for implementation specific features.]
        )),

        [FabRISC provides the *Counters Length* (`CLEN`) 2 bit ISA parameter, indicates the bit width of the performance counters in bits. If the system doesn't support the `PERFC` module, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the following table:],

        tableWrapper([`PERFCB` sizes.], table(

            columns: (10%, 25%),
            align: (x, y) => (center, left + top).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [0], [8 bits. ],
            [1], [16 bits.],
            [2], [32 bits.],
            [3], [64 bits.]
        )),

        comment([

            This bank is a very powerful tool when it comes to performance diagnostics and monitoring. Once configured, the counters keep track of the desired metrics throughout the lifetime of the program. Common statistics, beyond the basic ones mentioned in the table, are often cache hits / misses, TLB hits / misses, BTB hits / misses, branch misspredictions, stalls and many others.

            I wanted to leave as much freedom to the hardware designers as possible here as it can depend a lot on how the microarchitecture is implemented, which is why there are few predefined modes.

            Additionally, i designed these counters to be unprivileged and private for each hart. This means that on context switches the counters are halted, which is useful for isolating the behavior of the program from other things like the operating system.
        ])
    ),

    ///.
    subSection(

        [Special Purpose Bank],

        [In this subsection the special purpose registers are discussed. Some of these registers are unprivileged, that is, accessible to any thread of any process at any time regardless of the privilege, while others are machine mode only and the `ILLI` fault must be triggered if an access is performed in user mode to such resources. The only register that is not included in this bank is the program counter (`PC`), which is considered a separate resource. The special purpose registers are the following:],

        tableWrapper([`SPRB` layout.], table(

            columns: (auto, auto, auto),
            align: (x, y) => (left + top, left + top, left + top).at(x),

            [#middle([*Short*])], [#middle([*Size*])], [#middle([*Description*])],

            [`SR`], [32 bits], [*Status Register*: \ This register holds several flags that keep track of the current hart status. `SR` is semi-privileged and is always mandatory. Depending on which modules are implemented, only certain bits must be present while the others can be ignored and set to zero as a default. The precise bit layout and privileges is discussed in the next subsection.],

            [`VSH`], [8 bits], [*Vector Shape*: \ This register specifies the current vector configuration and is divided into two parts: the most significant two bits specify the size of the singular element: 8, 16, 32 or `WLEN` bit, while the remaining least significant bits specify the number of active elements. Illegal configurations must generate the `ILLI` fault. `VSH` is not privileged and is only needed when the system implements the `VC` module, otherwise the default vector shape must always dictate the maximum number of `WLEN` sized elements.],

            [`MEPC`], [`WLEN`], [*Machine Event PC*: \ This register holds the program counter of the last instruction before the machine event handler, which can then be used to return back from it. `MEPC` is privileged and is only needed when the system implements any combination of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MESR`], [32 bits], [*Machine Event SR*: \ This register holds the latest `SR` before the machine event handler, which can then be used to restore the `SR` when returning from it. `MESR` is privileged and is only needed when the system implements any combination of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MEC`], [32 bits if \ `WLEN = 0`...`2` \ else 64 bits], [*Machine Event Cause*: \ This register holds the id of which event caused the current hart to trap in the least significant byte and the size of the instruction pointed by the `PC` in the next one. Additional information can be placed in the remaining space, depending on the situation. `MEC` is privileged and is only needed when the system implements any combination of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MED`], [32 bits if \ `WLEN = 0`...`2` \ else 64 bits], [*Machine Event Data*: \ This register holds any optional event data based on the specific event. `MED` is privileged and is only needed when the system implements any combination of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MEHP`], [`WLEN`], [*Machine Event Handler Pointer*: \ This register holds the address to the machine event handler. `MEHP` is privileged and is only needed when the system implements any combination of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MET0`], [`WLEN`], [*Machine Event Temporary 0*: \ This register can be used as a temporary register during event handling, often for saving and restoring the various banks. `MET0` is privileged and is only needed when the system implements any combination of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`MET1`], [`WLEN`], [*Machine Event Temporary 1*: \ This register can be used as a temporary register during event handling, often for saving and restoring the various banks. `MET1` is privileged and is only needed when the system implements any combination of the following modules: `EXC`, `IOINT`, `IPCINT`, `USER`.],

            [`UEPC`], [`WLEN`], [*User Event PC*: \ This register holds the program counter of the last instruction before the user event handler, which can then be used to return back from it. `UEPC` is not privileged and is needed if the system implements the `USER` module.],

            [`UESR`], [32 bits], [*User Event Status Register*: \ This register holds the latest `SR` just before the user event handler, which can then be used to restore the `SR` when returning from it. `UESR` has the same privilege as the `SR` and is only needed when the system implements the `USER` module.],

            [`UEC`], [32 bits if \ `WLEN = 0`...`2` \ else 64 bits], [*User Event Cause*: \ This register holds the id of which event caused the current hart to trap in the least significant byte and the size of the instruction pointed by the `PC` in the next one. Additional information can be placed in the remaining space, depending on the situation. `UEC` is not privileged and is only needed when the system implements the `USER` module.],

            [`UED`], [32 bits if \ `WLEN = 0`...`2` \ else 64 bits], [*User Event Data*: \ This register holds any optional event data based on the specific event. `UED` is not privileged and is only needed when the system implements the `USER` module.],

            [`UEHP`], [`WLEN`], [*User Event Handler Pointer*: \ This register holds the address to the user event handler. `UEHP` is not privileged and is only needed when the system implements the `USER` module.],

            [`UET0`], [`WLEN`], [*User Event Temporary 0*: \ This register can be used as a temporary general purpose register during event handling, often for saving and restoring the various banks. `UET0` is not privileged and is only needed when the system implements the `USER` module.],

            [`UET1`], [`WLEN`], [*User Event Temporary 1*: \ This register can be used as a temporary general purpose register during event handling, often for saving and restoring the various banks. `UET1` is not privileged and is only needed when the system implements the `USER` module.],

            [`PFPA`], [`WLEN`], [*Page Fault Physical Address*: \ This register holds the page table physical address of the currently running process. `PFPA` is privileged and is only needed when the system implements the `USER` module.],

            [`PID`], [32 bit], [*Process ID*: \ This register holds the id of the currently running process. `PID` is privileged and is only needed when the system implements the `USER` module.],

            [`TID`], [32 bit], [*Thread ID*: \ This register holds the id of the currently running process thread. `TID` is privileged and is only needed when the system implements the `USER` module.],

            [`TPTR`], [`WLEN`], [*Thread Pointer*: \ This register holds the pointer to the currently running software thread. `TPTR` is privileged and is only needed when the system implements the `USER` module.],

            [`WDT`], [32 bit], [*Watchdog Timer*: \ This register is a counter that triggers the `TQE` event every $n$ microseconds depending on its value. When the event is triggered `WDT` is automatically halted by setting $"WDTE" = 1$ in the `SR`. `WDT` is privileged and is only needed when the system implements the `USER` module.]
        )),

        comment([

            This bank houses a variety of registers used to track and change the behavior of the system while it operates. Many of the modules require the presence of some special purpose registers in order to function such as vector instructions, helper registers, performance counters, eventing and others.

            The registers prefixed with "User Event" or "Machine Event" hold the so called "critical state" of the hart, that is, state that is particularly delicate for event handling in privileged and non privileged implementations.

            Access to privileged resources in user mode is forbidden and must be blocked in order to protect the operating system from exploits. I decided to decouple user-level events from machine-level events in order to void calling the OS on every exception, as well as for a cleaner separation of the two environments.
        ])
    ),

    ///.
    subSection(

        [Status Register Bit Layout],

        [In this section the Status Register bit layout is discussed. The `SR` contains several flags and status bits of different privilege levels. The status that the system must implement depends on which modules are chosen and any write to bits of non implemented modules must throw the `ILLI` fault. The `SR` bit layout is explained in the following table:],

        pagebreak(),
        tableWrapper([`SR` bit layout.], table(

            columns: (auto, auto, auto),
            align: (x, y) => (left + top, left + top, left + top).at(x),

            [#middle([*Short*])], [#middle([*Size*])], [#middle([*Description*])],

            [`GEE`], [2 bit], [*Global Arithmetic Exceptions Enable*: \ Enables or disables immediate traps on arithmetic exceptions.  The arithmetic flags must always be generated if the `HLPR` module is implemented, regardless of the value of these bits. `GEE` is not privileged and is only needed when the `EXC` module is implemented, otherwise the default value must always be zero. The enable modes are:

                #enum(tight: true, start: 0,

                    [_All disabled._],
                    [_Enable integer arithmetic exceptions._],
                    [_Enable FP arithmetic exceptions._],
                    [_Enable integer and FP arithmetic exceptions._]
                )
            ],

            [`CMD`], [1 bit], [*Consistency Mode*: \ Dictates the current memory consistency model: zero for sequential and one for relaxed. `CMD` is not privileged and is only needed when the system implements the `FNC` module, otherwise the default must always be zero.],

            [`RMD`], [3 bits], [*FP Rounding Mode*: \ Dictates the current floating point rounding mode. `RMD` is not privileged, is only needed when the system implements the `FRMD` module and, if not present, the default mode must always be zero. The possible modes are IEEE-754 compliant and are the following:

                #enum(tight: true, start: 0,

                    [_Round to nearest even._],
                    [_Round to nearest away from zero._],
                    [_Round towards zero._],
                    [_Round towards negative infinity._],
                    [_Round towards positive infinity._],
                    [_Remaining combinations are reserved for future use._]
                )
            ],

            [-], [2 bits], [Reserved for future use.],

            [`IM`], [4 bits], [*Interrupt Mask*: \ Masks the interrupts: the first two bits mask IO-interrupts and the last two bits mask IPC-interrupts, where each bit masks chunks of sixteen interrupts at a time. `IM` is privileged and only needed when the system implements the `IOINT`, `IPCINT` or both, otherwise the default value must always be zero.],

            [`HLPRE`], [4 bits], [*HLPR Enable*: \ Enables or disables portions the `HLPRB` in chunks of eight registers at a time. `HLPRE` is not privileged and only needed when the system implements the `HLPR` module, otherwise the default value must always be zero.],

            [`PERFCE`], [1 bit], [*PERFC Enable*: \ Enables or disables the `PERFCB`. `PERFCE` is not privileged and only needed when the system implements the `PERFC` module, otherwise the default value must always be zero.],

            [`PMOD`], [2 bits], [*Privilege Mode*: \ Dictates the current hart privilege level. `PMOD` is privileged and only needed when the system implements the `USER` module, otherwise the default value must always be zero. The possible modes are:

                #enum(tight: true, start: 0,

                    [_Machine mode._],
                    [_User mode._],
                    [_Remaining combinations are reserved for future use._]
                )
            ],

            [`WDTE`], [1 bit], [*Watchdog Timer Enable*: \ Enables or disables the `WDT` register. `WDTE` is privileged and only needed when the system implements the `USER` module, otherwise the default value must always be zero.],

            [`PWRS`], [4 bit], [*Power State*: \ Holds the current hart power state. Values range from `0` to `15`, with `0` being the lowest and `15` being the highest available. `PWRS` is privileged and only needed when the system implements the `PWR` module, otherwise the default value must always be `0`. The actual meaning of each mode is left as implementation specific details. The rationale is to provide an increasing range of performance settings that can be changed at any time.],

            [`HLTS`], [3 bit], [*Halt State*: \ Holds the current hart halting state. `HLTS` is privileged, always mandatory and can only be changed via the `HLT`, `WINT` instructions or via interrupts. The possible states are:

                #enum(tight: true, start: 0,

                    [_Not halted._],
                    [_Explicit halt: the halt was caused by the HLT instruction._],
                    [_Waiting for interrupt._],
                    [_Double event halt: the halt was caused by the "double event" situation (see section 7)._],
                    [_Remaining combinations are reserved for future use._]
                )
            ],

            [-], [5 bits], [Reserved for future use.],
        )),

        pagebreak(),
        comment([

            The `SR` holds many different configuration bits, and because of this, it is the only resource that has distinct privileges: the first 8 bits are user level, while the remaining are machine level.

            Some configuration bits are placed here since they would not fit in the instruction encodings, such as the rounding modes and the exception enable bit. Some sections have to be stateful since they are critical for event handling such as the interrupt mask, the privilege mode, watchdog timer enable and the halting state.

            Other sections are more "novelty" but still need to be stored and, since often small, i decided to unify them into a single resource.
        ])
    ),

    ///.
    subSection(

        [Configuration Segment],

        [This document has introduced, and will introduce, several different configuration constants which describe the features that any system must have in order to be considered compliant to the FabRISC architecture. These parameters must be stored in a dedicated static, read-only memory-like region that is byte addressable. Some of these parameters are global for all harts, while others are private. The parameters are all unprivileged and are listed in the following table:],

        tableWrapper([Configuration segment.], table(

            columns: (auto, auto, auto, auto, auto),
            align: (x, y) => (right + top, right + top, left + top, left + top, left + top).at(x),

            [#middle([*Start*])], [#middle([*End*])], [#middle([*Param.*])], [#middle([*Visibility*])], [#middle([*Description*])],

            [   0], [   1], [`HID`     ], [Private], [*Hart ID*: Unique identifier of the current hart.],
            [   2], [   9], [`ISAMOD`  ], [Private], [*ISA Modules*: See section 2 for more information.],
            [  10], [  11], [`ISAVER`  ], [Private], [*ISA Version*: See section 2 for more information.],
            [  12], [  12], [`WLEN`    ], [Private], [*Word Length*: See section 3 for more information.],
            [  13], [  13], [`MXVL`    ], [Private], [*Maximum Vector Length*: See section 4 for more information.],
            [  14], [  14], [`CLEN`    ], [Private], [*Counters Length*: See section 4 for more information.],
            [  15], [  15], [`SRFS`    ], [Private], [*Scalar Register File Size*: See section 4 for more information.],
            [  16], [  16], [`VRFS`    ], [Private], [*Vector Register File Size*: See section 4 for more information.],
            [  17], [  17], [`HRFS`    ], [Private], [*Helper Register File Size*: See section 4 for more information.],
            [  18], [  18], [`CRFS`    ], [Private], [*Counter Register File Size*: See section 4 for more information.],
            [  19], [  26], [`CPUID`   ], [Global ], [*CPU ID*: Unique CPU identifier.],
            [  27], [  34], [`CPUVID`  ], [Global ], [*CPU Vendor ID*: Unique CPU vendor identifier.],
            [  35], [ 162], [`CPUNAME` ], [Global ], [*CPU Name*: The CPU name.],
            [ 163], [ 164], [`NCORES`  ], [Global ], [*Number of Cores*: Number of physical CPU cores.],

            [ 165], [ 166], [`NTHREADS`], [Global ], [*Number of Hardware Threads*:  Number of logical CPU cores, that is, hardware threads or harts per physical core.],

            [ 167], [ 167], [`COHS`    ], [Global ], [*Coherence Strategy*: See section 5 for more information.],
            [ 168], [ 168], [`IOS`     ], [Global ], [*Input Output size*: See section 6 for more information.],
            [ 169], [ 169], [`DMAMOD`  ], [Global ], [*DMA Mode*: See section 6 for more information.],
            [ 170], [ 170], [`DMAS`    ], [Global ], [*DMA Size*: See section 6 for more information.],
            [ 171], [ 172], [`IOIQS`   ], [Global ], [*IO Interrupt Queue Size*: See section 7 for more information.],
            [ 173], [ 174], [`IPIQS`   ], [Global ], [*IPC Interrupt Queue Size*: See section 7 for more information.],
            [ 175], [ 178], [`IOIA`    ], [Global ], [*IO Interrupt Amount*: See section 7 for more information.],
            [ 179], [ 182], [`IPIA`    ], [Global ], [*IPC Interrupt Amount*: See section 7 for more information.],
            [ 183], [ 255], [-],          [-],       [Reserved for future uses.],
            [ 256], [1023], [-],          [-],       [Left as implementation specific.]
        )),

        pagebreak(),
        comment([

            These read-only parameters describe the hardware configuration and capabilities. Some have already been explained in earlier sections, while others are new and are introduced in the following sections. Global parameters are the same for all harts in the system, while private parameters depends on which hart is targeted.

            The majority of this region is left as implementation specific since it can be used to write information about the specific microarchitecture, such as cache and TLB organizations and other internal structures that the software can probe. FabRISC doesn't define a standard for that, as it would be out of the project scope.

            Presenting this information in a clear way is a very powerful tool that allows to dynamically dispatch specific machine code for the specific target microarchitecture, improving performance and efficiency. I decided to force implementations to specify such things directly in the hardware, in an attempt to reduce the reliance on documentation as much as possible.
        ])
    )
)

#pagebreak()

///
