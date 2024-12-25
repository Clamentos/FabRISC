///
#import "Macros.typ": *
#import "@preview/tablex:0.0.9": tablex, colspanx, rowspanx

///
#section(

    [Events],

    [In this subsection, all the possible events are defined. In general, the term "event" is used to refer to any extraordinary situation that may happen at any time and should be handled as soon as possible. Events can be "promoting" or "non promoting", that is, elevate the trapped hart to a higher privilege level or not. If the `USER` module is not implemented, then this distinction is not needed since the system always runs at the highest possible privilege level: machine mode. Events also have _global priority_ and _local priority_ which together define a deterministic handling order (lower numbers signify higher priority). Global priority dictates the priority for classes of events, while local priority defines the level for each event within each group and, for some groups of events, local priority is not defined since they should be handled in program order. The following is the event taxonomy:],

    list(tight: false,

        [*Synchronous: * _Synchronous events are deterministic and can be triggered by an instruction, for example a division by zero, or by other sources such as helper registers. This category is further subdivided in two subcategories:_
        
            #list(tight: false, marker: [--],

                [*Exceptions:* _Exceptions are low severity events and are non-promoting._],
                [*Faults:* _Faults are high severity events and are promoting._]
            )
        ],

        [*Asynchronous:* _Asynchronous events are non-deterministic and can be triggered by other harts or any external IO device. This category is further divided into two subcategories, both promoting:_

            #list(tight: false, marker: [--],

                [*IO-Interrupts:* _These events are triggered by external IO devices._],
                [*IPC-Interrupts:* _These events are triggered by other harts and are sometimes referred as "notifications"._]
            )
        ]
    ),

    [The following is a list of all events that are supported by the specification:],

    page(flipped: true, tableWrapper([Event list.], table(

        columns: (auto, auto, auto, auto, auto, auto, auto),
        align: (x, y) => (right + horizon, left + horizon, left + horizon, center + horizon, left + horizon, left + horizon, left + horizon).at(x),

        [#middle([*Code*])], [#middle([*Short*])], [#middle([*Module*])], [#middle([*GP*])], [#middle([*LP*])], [#middle([*Type*])], [#middle([*Description*])],

        // Mandatory
        [   1], [`MISI`], [Mandatory], [0], [Program order], [Fault], [*Misaligned Instruction*: \ Triggered when the hart tries to fetch a misaligned instruction. This event doesn't carry any extra information.],

        [   2], [`INCI`], [Mandatory], [0], [Program order], [Fault], [*Incompatible Instruction*: \ Triggered when the hart fetches a non supported instruction. Even if a particular opcode is supported, not all operands might be legal. This event doesn't carry any extra information.],

        [   3], [`ILLI`], [Mandatory], [0], [Program order], [Fault], [*Illegal Instruction*: \ Triggered when the hart tries fetch an instruction that is all zeros, all ones or otherwise deemed as illegal. This event doesn't carry any extra information.],

        [   4], [-],   [-], [-],   [-],   [-], [Reserved for future uses.],
        [ ...], [...], [...], [...], [...], [...], [...],
        [  16], [-],   [-],   [-],   [-],   [-], [Reserved for future uses.],

        // IOINT module
        [  17], [`IOINT_0`], [`IOINT`], [1], [0], [IO-Interrupt], [*IO-Interrupt 0*: \ Generic IO interrupt. This event doesn't carry any extra information.],

        [ ...], [...], [...], [...], [...], [...], [...],

        [  48], [`IOINT_31`], [`IOINT`], [1], [31], [IO-Interrupt], [*IO-Interrupt 31*: \ Generic IO interrupt. This event doesn't carry any extra information.],

        // IPCINT module
        [  49], [`AWAKE`], [`IPCINT`], [2], [0], [IPC-Interrupt], [*Awake*: \ Causes the receiving hart to resume execution regardless of the halting state. This event cannot be masked and doesn't carry any extra information.],

        [  50], [`IPCINT_0`], [`IPCINT`], [2], [1], [IPC-Interrupt], [*IPC-Interrupt 0*: \ Generic IPC interrupt. This event doesn't carry any extra information.],

        [ ...], [...], [...], [...], [...], [...], [...],

        [  81], [`IPCINT_31`], [`IPCINT`], [2], [32], [IPC-Interrupt], [*IPC-Interrupt 31*: \ Generic IPC interrupt. This event doesn't carry any extra information.],

        // DALIGN module
        [  82], [`MISD`], [`DALIGN`], [0], [Program order], [Fault], [*Misaligned Data*: \ Triggered when the hart accesses unaligned data. This event doesn't carry any extra information.],

        // USER module
        [  83], [`PFLT`], [`USER`], [0], [Program order], [Fault], [*Page Fault*: \ Triggered when the addressed page could not be found in memory. The `MED` register must be populated with the faulting address.],

        [  84], [`ILLA`], [`USER`], [0], [Program order], [Fault], [*Illegal Address*: \ Triggered when the user accesses "illegal" address, that is, an address that is not accessible in user mode. The `MED` register must be populated with the faulting address.],

        [  85], [`SYSC`], [`USER`], [0], [Program order], [Fault], [*System Call*: \ Triggered by the system call instruction explicitly.],

        [  86], [`TQE` ], [`USER`], [1], [0], [IPC-Interrupt], [*Time Quantum Expired*: \ Triggered by the internal watchdog timer. This event doesn't carry any extra information.],

        [  87], [-],   [-],   [-],   [-],   [-],   [Reserved for future uses.],
        [ ...], [...], [...], [...], [...], [...], [...],
        [  98], [-],   [-],   [-],   [-],   [-],   [Reserved for future uses.],

        // EXC module
        [  99], [`COVRE`], [`EXC`], [3], [Program order], [Exception], [*Carry Over Exception*: \ This event is triggered by the `COVRn` flag, where  \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

        [ 100], [`CUNDE`], [`EXC`], [3], [Program order], [Exception], [*Carry Under Exception*: \ This event is triggered by the `CUND` flag. This event doesn't carry any extra information.],

        [ 101], [`OVFLE`], [`EXC`], [3], [Program order], [Exception], [*Overflow Exception*: \ This event is triggered by the `OVFLn` flag, where \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

        [ 102], [`UNFLE`], [`EXC`], [3], [Program order], [Exception], [*Underflow Exception*: \ This event is triggered by the `UNFLn` flag, where \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

        [ 103], [`DIV0E`], [`EXC`], [3], [Program order], [Exception], [*Division By Zero Exception*: \ This event is triggered by the `DIV0` flag. This event doesn't carry any extra information.],

        [ 104], [`INVOPE`], [`EXC`], [3], [Program order], [Exception], [*Invalid Operation Exception*: \ This event is triggered by the `INVOP` flag. This event doesn't carry any extra information.],

        [ 105], [-], [`EXC`], [3], [Program order], [Exception], [Reserved for future uses.],
        [ ...], [...], [...], [...], [...], [...], [...],
        [ 114], [-], [`EXC`], [3], [Program order], [Exception], [Reserved for future uses.],

        // HLPR module
        [ 115], [`RDT`], [`HLPR`], [3], [See section 6.3], [Exception], [*Read Trigger*: \ Event for mode 1 and 6 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 116], [`WRT`], [`HLPR`], [3], [See section 6.3], [Exception], [*Write Trigger*: \ Event for mode 2 and 7 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 117], [`EXT`], [`HLPR`], [3], [See section 6.3], [Exception], [*Execute Trigger*: \ Event for mode 3 and 8 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 118], [`RWT`], [`HLPR`], [3], [See section 6.3], [Exception], [*Read-Write Trigger*: \ Event for mode 4 and 9 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 119], [`RWET`], [`HLPR`], [3], [See section 6.3], [Exception], [*Read-Write-Execute Trigger*: \ Event for mode 5 and 10 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 120], [`COVR1T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Carry Over 1 Trigger*: \ Event for mode 11 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 121], [`COVR2T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Carry Over 2 Trigger*: \ Event for mode 12 of the helper registers. The causing instruction and the address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 122], [`COVR4T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Carry Over 4 Trigger*: \ Event for mode 13 of the helper registers. The causing instruction and the address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 123], [`COVR8T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Carry Over 8 Trigger*: \ Event for mode 14 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 124], [`CUNDT`], [`HLPR`], [3], [See section 6.3], [Exception], [*Carry Under Trigger*: \ Event for mode 15 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 125], [`OVFL1T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Overflow 1 Trigger*: \ Event for mode 16 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 126], [`OVFL2T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Overflow 2 Trigger*: \ Event for mode 17 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 127], [`OVFL4T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Overflow 4 Trigger*: \ Event for mode 18 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 128], [`OVFL8T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Overflow 8 Trigger*: \ Event for mode 19 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 129], [`UNFL1T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Underflow 1 Trigger*: \ Event for mode 20 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 130], [`UNFL2T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Underflow 2 Trigger*: \ Event for mode 21 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 131], [`UNFL4T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Underflow 4 Trigger*: \ Event for mode 22 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 132], [`UNFL8T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Underflow 8 Trigger*: \ Event for mode 23 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 133], [`DIV0T`], [`HLPR`], [3], [See section 6.3], [Exception], [*Division by Zero Trigger*: \ Event for mode 24 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 134], [`INVOPT`], [`HLPR`], [3], [See section 6.3], [Exception], [*Invalid Operation Trigger*: \ Event for mode 25 of the helper registers. The address of the causing register must be written into the `MEC` / `UEC` special purpose register as additional information.],

        [ 135], [-], [`HLPR`], [3], [See section 6.3], [Exception], [Reserved for future uses.],
        [ ...], [...], [...], [...], [...], [...], [...],
        [ 370], [-], [`HLPR`], [3], [See section 6.3], [Exception], [Reserved for future uses.],

        [ 371], [-], [-], [-], [-], [-], [Left as implementation specific.],
        [ ...], [...], [...], [...], [...], [...], [...],
        [ 512], [-], [-], [-], [-], [-], [Left as implementation specific.]
    ))),

    [When the hart is trapped by an event, the handling procedure must be performed in order to successfully process the event. Such procedure is left to the programmer to define, however, the steps needed to reach the code must be implemented in hardware. Depending if the event is promoting or not, as well as the currently active privilege, the appropriate "launching sequence" must be performed. The following ordered steps define the "privileged" launching sequence and must be executed in a single cycle:],

    enum(tight: true,

        [_Cancel all in-flight instructions._],
        [_Write the current value of the `PC` into the `MEPC` special purpose register._],
        [_Write the current value of the `SR` into the `MESR` special purpose register._],

        [_Set the following bits of the `SR` to the following values ignoring privilege restrictions:_

            #list(tight: true,

                [_`GEE` to 0 if present._],
                [_`HLPRE` to 0 if present._],
                [_`PERFCE` to 0 if present._],
                [_`PMOD` to 1._],
                [_`WDTE` to 0._],
                [_`IM` to 15 if present._]
            )
        ],

        [_Write the event identifier and extra information, depending on the specific event, into the `MEC` special purpose register._],
        [_Write the event data into the `MED` special purpose register if needed._],
        [_Write the current value of the `MEHP` special purpose register into the `PC`._]
    ),

    [The following ordered steps define the "unprivileged" launching sequence and must be executed in a single cycle:],

    enum(tight: true,

        [_Cancel all in-flight instructions._],
        [_Write the current value of the `PC` into the `UEPC` special purpose register._],
        [_Write the current value of the `SR` into the `UESR` special purpose register._],

        [_Set the following bits of the `SR` to the following values:_

            #list(tight: true,

                [_`GEE` to 0 if present._],
                [_`HLPRE` to 0 if present._],
                [_`PERFCE` to 0 if present._]
            )
        ],

        [_Write the event identifier and extra information, depending on the specific event, into the `UEC` special purpose register._],
        [_Write the event data into the `UED` special purpose register if needed._],
        [_Write the current value of the `UEHP` special purpose register into the `PC`._]
    ),

    [After reaching the handling procedure, it's extremely important to save to memory the all the "critical" state that was temporarily copied into the `MEPC` and `MESR` for machine level events, or `UEPC` and `UESR` for user level events. This is because in order to support the nesting of events, it must be possible to always restore the critical state of the previous handler. If the hart is re-trapped, for any reason, before the critical state is saved to memory, loss of information will occur and it won't be possible to restore it. This catastrophic failure must be detected and the hart must be immediately halted with code 2 in the `HLT` section of the `SR`. It is important to note that trapping a hart with a promoting event while in user mode, is always possible and will never result in the "double event" situation since the target event registers will be different.],

    [Returning from an event handler requires executing the appropriate dedicated return instruction: `ERET`, `UERET` or `URET`. Such instructions will undo the associated sequences described above by performing the same step in reverse order. The following ordered steps define the "privileged" returning sequence initiated by the `ERET` instruction which must be executed in a single cycle:],

    enum(tight: true,

        [_Write the value of the `MESR` special purpose register into the `SR`._],
        [_Write the value of the `MEPC` special purpose register into the `PC`._]
    ),

    [The following ordered steps define the "unprivileged" returning sequence initiated by the `UERET` instruction which must be executed in a single cycle:],

    enum(tight: true,

        [_Write the value of the `UESR` special purpose register into the `SR`. Any changes to any privileged bit must be ignored._],
        [_Write the value of the `UEPC` special purpose register into the `PC`._]
    ),

    [The following ordered steps define the "user" returning sequence initiated by the `URET` instruction. This special case performs a "demotion" of the hart, that is, the privilege is changed from machine to user. Similarly to all other sequences, this must be executed in a single cycle as well:],

    enum(tight: true,

        [_Write the value of the `UESR` special purpose register into the `SR`._],

        [_Set the following bits of the `SR` to the following values:_

            #list(tight: true,

                [_`PMOD` to 0._],
                [_`WDTE` to 1._],
            )
        ],

        [_Write the value of the `UEPC` special purpose register into the `PC`._]
    ),

    [During event handling, other events might be received by the hart. This situation was already mentioned in the previous paragraphs and a queuing system is needed in order to avoid loss of information. Queues have finite length so it's important to handle the events more rapidly than they come, however if the events are too frequent the queues will eventually fill. Any IO-interrupt and IPC-interrupt that is received while the queues are full, must be discarded and the interrupting device must be notified. In case the queues for synchronous events become full, the hart must be immediately halted with code 3 in the `HLT` section of the `SR`.],

    [When any event is received and the hart is in a transactional state, then all executing memory transactions must immediately fail with the abort code `EABT`.],

    [Software interrupts can be easily implemented by injecting the appropriate values into the critical registers and then performing the appropriate returning sequence. This will cause the hart to return from a handler with the event id not at zero, thus triggering again the launching sequence. A hart with an event id of zero in its cause register is not considered as trapped.],

    comment([

        Events are a very powerful way to react to different things "on the fly", which is very useful for event-driven programming, managing external devices at low latency and are essential for privileged architectures.

        The division in different categories might seem a bit strange at first, but the two broad classes are the usual ones: synchronous and asynchronous events, that is, deterministic and non-deterministic ones. The different types of events within each class are roughly based on "severity" (which is basically the global priority metric), as well as a local priority which can depend on different things.

        Exceptions are the lowest severity among all other events and the program order defines the order in which they must be handled. The only complication to this rule is for helper register exceptions, which have a higher intrinsic priority and the handling order depends on which particular helper register fired. These exceptions might also clash with the previously mentioned regular arithmetic ones but, since the helper ones have a higher innate priority, they all take over and override. This behavior stems from the fact that `HLPR` registers allow for fine control, while the `GEE` bit allows exceptions to be enabled or disabled globally. In both instances, it's possible to distinguish if the exception was caused by a `HLPR` register or not.

        Faults are also synchronous just like exceptions, but their severity is the highest among any other event and they often signify that something seriously bad happened, such as an access to an illegal memory address. Because they are synchronous, they must be handled in program order.

        IO-Interrupts are the lowest global priority asynchronous event and they are used to handle external device requests. They have a progressive local priority that defines the order in which they must be handled when received.

        IPC-Interrupts are a higher priority version of the IO-Interrupts. IPC-Interrupts are used by harts to send signals to each other, which may also be used for quickly starting and stopping other harts. Just like the IO variant, they have a progressive local priority that defines the order in which they must be handled when received.

        In some situations it may be necessary to queue an event in order to handle it after another and to avoid loss of information. If the queue is full, the events must be discarded and, whoever generated the event, must be notified. This includes IO devices or other harts that generated an IPC-interrupt, in this last case, by making their IPC-interrupt generating instruction fail. If the synchronous event queues fill, the hart will be halted since firing more events will result in losing them.
    ])
)

#pagebreak()

///
