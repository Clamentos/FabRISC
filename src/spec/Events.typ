///
#import "Macros.typ": *
#import "@preview/tablex:0.0.9": tablex, colspanx, rowspanx

///
#section(

    [Events],

    [In this subsection, all the possible events are defined and discussed. In general, the term "event" is used to refer to any extraordinary situation that may happen at any time and should be handled as soon as possible. Events can be "promoting" or "non promoting", that is, elevate the trapped hart to a higher privilege level or not. If the `USER` module is not implemented, then this distinction is not needed since the system always runs at the highest possible privilege level: machine mode. Events have a unique priority value which allows the presence of a deterministic handling order, with lower numbers signifying higher priority. The following is the event taxonomy:],

    list(tight: false,

        [*Synchronous: * _Synchronous events are triggered by an instruction, for example a division by zero, or by other sources such as helper registers. This category is further subdivided in two subcategories:_
        
            #list(tight: true, marker: [--],

                [*Exceptions:* _Exceptions are low severity events and are non-promoting._],
                [*Faults:* _Faults are high severity events and are promoting._]
            )
        ],

        [*Asynchronous:* _Asynchronous events are triggered by other harts or any external IO device. This category is further divided into two subcategories, both promoting:_

            #list(tight: true, marker: [--],

                [*IO-Interrupts:* _These events are triggered by external IO devices._],
                [*IPC-Interrupts:* _These events are triggered by other harts._]
            )
        ]
    ),

    [FabRISC allows to relax the requirements of the eventing system for implementations that do not want to support events. This relaxation simply requires halting the system completely when any event is triggered. This, in the end, allows to avoid the implementation of the complex eventing system and its respective handling registers in the special purpose bank, simplifying the hardware. This relaxation is valid for any event, including the mandatory ones such as: `MISI`, `INCI`, `ILLI` mentioned earlier in the document.],

    [For systems that want to actively handle events, the following is the list of all events that are supported by the specification:],

    page(flipped: true, tableWrapper([Event list.], table(

        columns: (6%, auto, auto, auto, auto, auto),
        align: (x, y) => (right + top, left + top, left + top, left + top, right + top, left + top).at(x),

        [#middle([*Code*])], [#middle([*Short*])], [#middle([*Module*])], [#middle([*Type*])], [#middle([*Priority*])], [#middle([*Description*])],

        [   1], [`DUE`], [`USER`], [Fault], [1], [*Double User Event*: \ Triggered when the hart is in user mode and receives an exception while handling another exception before saving the user-level critical state. This event doesn't carry any extra information.],

        [   2], [`MISI`], [`*`], [Fault], [2], [*Misaligned Instruction*: \ Triggered when the hart tries to fetch a misaligned instruction, that is, when the least significant bit of the `PC` is 1. This event doesn't carry any extra information.],

        [   3], [`ILLI`], [`*`], [Fault], [3], [*Illegal Instruction*: \ Triggered when the hart tries to execute an instruction that is all zeros or all ones. This event doesn't carry any extra information.],

        [   4], [`INCI`], [`*`], [Fault], [4], [*Incompatible Instruction*: \ Triggered when the hart tries to execute a non supported instruction. If the `MED` register is 64 bits wide, then it must be populated with the actual faulting instruction. If it's 32 bits, then it must be populated with the faulting instruction only if such is 4 or 2 bytes long, else a zero must be placed.],

        [   5], [`ILLA`], [`USER`], [Fault], [5], [*Illegal Address*: \ Triggered when the hart in user mode tries to accesses an illegal address, that is, an address that is not accessible in user mode. The `MED` register must be populated with the faulting address as extra information.],

        [   6], [`MISD`], [`DALIGN`], [Fault], [6], [*Misaligned Data*: \ Triggered when the hart accesses unaligned data. The `MED` register must be populated with the faulting address as extra information. If the `MEC` is 64 bits wide, then the free bits must be populated with the actual memory instruction, otherwise a zero must be placed.],

        [   7], [`PFLT`], [`USER`], [Fault], [7], [*Page Fault*: \ Triggered when the addressed page could not be found in memory. The `MED` register must be populated with the faulting address as extra information.],

        [   8], [`IOINT`], [`IOINT`], [IO-Int.], [8], [*IO-Interrupt*: \ Generic IO interrupt. The `MED` must be populated with the 32 bit id of the interrupt.],

        [   9], [`IPCINT`], [`IPCINT`], [IPC-Int.], [9], [*IPC-Interrupt*: \ Generic IPC interrupt. The `MED` must be populated with the 32 bit id of the interrupt.],

        [  10], [`TQE`], [`USER`], [IPC-Int.], [10], [*Time Quantum Expiration*: \ Triggered by the internal watchdog timer when it expires. This event doesn't carry any extra information.],

        [  11], [`RDT`], [`HLPR`], [Exception], [11], [*Read Address Trigger*: \ Event for mode 2 and 3 of the helper registers. See section 4 for more information.],

        [  12], [`WRT`], [`HLPR`], [Exception], [12], [*Write Address Trigger*: \ Event for mode 4 and 5 of the helper registers. See section 4 for more information],

        [  13], [`EXT`], [`HLPR`], [Exception], [13], [*Execute Address Trigger*: \ Event for mode 6 and 7 of the helper registers. See section 4 for more information],

        [  14], [`RWT`], [`HLPR`], [Exception], [14], [*Read or Write Address Trigger*: \ Event for mode 8 and 9 of the helper registers. See section 4 for more information],

        [  15], [`RWET`], [`HLPR`], [Exception], [15], [*Read or Write or Execute*: \ Event for mode 10 and 11 of the helper registers. See section 4 for more information],

        [  16], [`COVR1T`], [`HLPR`], [Exception], [16], [*COVR1 Flag Trigger*: \ Event for mode 12 and 13 of the helper registers. See section 4 for more information],

        [  17], [`COVR2T`], [`HLPR`], [Exception], [17], [*COVR2 Flag Trigger*: \ Event for mode 14 and 15 of the helper registers. See section 4 for more information],

        [  18], [`COVR4T`], [`HLPR`], [Exception], [18], [*COVR4 Flag Trigger*: \ Event for mode 16 and 17 of the helper registers. See section 4 for more information],

        [  19], [`COVR8T`], [`HLPR`], [Exception], [19], [*COVR8 Flag Trigger*: \ Event for mode 18 and 19 of the helper registers. See section 4 for more information],

        [  20], [`CUNDT`], [`HLPR`], [Exception], [20], [*CUND Flag Trigger*: \ Event for mode 20 and 21 of the helper registers. See section 4 for more information],

        [  21], [`OVFL1T`], [`HLPR`], [Exception], [21], [*OVFL1 Flag Trigger*: \ Event for mode 22 and 23 of the helper registers. See section 4 for more information],

        [  22], [`OVFL2T`], [`HLPR`], [Exception], [22], [*OVFL2 Flag Trigger*: \ Event for mode 24 and 25 of the helper registers. See section 4 for more information],

        [  23], [`OVFL4T`], [`HLPR`], [Exception], [23], [*OVFL4 Flag Trigger*: \ Event for mode 26 and 27 of the helper registers. See section 4 for more information],

        [  24], [`OVFL8T`], [`HLPR`], [Exception], [24], [*OVFL8 Flag Trigger*: \ Event for mode 28 and 29 of the helper registers. See section 4 for more information],

        [  25], [`UNFL1T`], [`HLPR`], [Exception], [25], [*UNFL1 Flag Trigger*: \ Event for mode 30 and 31 of the helper registers. See section 4 for more information],

        [  26], [`UNFL2T`], [`HLPR`], [Exception], [26], [*UNFL2 Flag Trigger*: \ Event for mode 32 and 33 of the helper registers. See section 4 for more information],

        [  27], [`UNFL4T`], [`HLPR`], [Exception], [27], [*UNFL4 Flag Trigger*: \ Event for mode 34 and 35 of the helper registers. See section 4 for more information],

        [  28], [`UNFL8T`], [`HLPR`], [Exception], [28], [*UNFL8 Flag Trigger*: \ Event for mode 36 and 37 of the helper registers. See section 4 for more information],

        [  29], [`DIV0T`], [`HLPR`], [Exception], [29], [*DIV0 Flag Trigger*: \ Event for mode 38 and 39 of the helper registers. See section 4 for more information],

        [  30], [`INVOPT`], [`HLPR`], [Exception], [30], [*INVOP Flag Trigger*: \ Event for mode 40 and 41 of the helper registers. See section 4 for more information],

        [  31], [`COVRE`], [`EXC`], [Exception], [31], [*Carry Over Exception*: \ This event is triggered by the `COVRn` flag, where  \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

        [  32], [`CUNDE`], [`EXC`], [Exception], [32], [*Carry Under Exception*: \ This event is triggered by the `CUND` flag. This event doesn't carry any extra information.],

        [  33], [`OVFLE`], [`EXC`], [Exception], [33], [*Overflow Exception*: \ This event is triggered by the `OVFLn` flag, where \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

        [  34], [`UNFLE`], [`EXC`], [Exception], [34], [*Underflow Exception*: \ This event is triggered by the `UNFLn` flag, where \ $n = 1/8 dot 2^"WLEN"$. This event doesn't carry any extra information.],

        [  35], [`DIV0E`], [`EXC`], [Exception], [35], [*Division By Zero Exception*: \ This event is triggered by the `DIV0` flag. This event doesn't carry any extra information.],

        [  36], [`INVOPE`], [`EXC`], [Exception], [36], [*Invalid Operation Exception*: \ This event is triggered by the `INVOP` flag. This event doesn't carry any extra information.],

        [ 37], [`SOFT`], [`USER`], [Exception], [37], [*Software Event*: \ This event is a generic software event. The `MED` or `UED` are free space.],

        [  38], [`SYSCL`], [`USER`], [Fault], [38], [*System Call Fault*: \ This event signals a call to the operative system. The `MED` must be populated with the 32 bit call id.],

        [ 39], [-], [-], [-], [], [Reserved for future uses.],
        [...], [...], [...], [...], [...], [],
        [ 63], [-], [-], [-], [], [Reserved for future uses.],

        [ 64], [-], [-], [-], [], [Left as a free slot for implementation specific features.],
        [...], [...], [...], [...], [...], [],
        [ 255], [-], [-], [-], [], [Left as a free slot for implementation specific features.]
    ))),

    [When the hart is trapped by an event, the handling procedure must be performed in order to successfully process the event. Such procedure is left to the programmer to define, however, the steps needed to reach such code must be implemented in hardware. Depending if the event is promoting or not, as well as the currently active privilege, the appropriate "launching sequence" must be performed. The following ordered steps define the "privileged" launching sequence and must be executed in a single cycle:],

    enum(tight: true,

        [_Cancel all in-flight instructions._],
        [_Write the current value of the `PC` into the `MEPC` special purpose register._],
        [_Write the current value of the `SR` into the `MESR` special purpose register._],

        [_Set the following bits of the `SR` to the following values ignoring privilege restrictions:_

            #list(tight: true,

                [_`HLPRE` to 0 if present._],
                [_`PERFCE` to 0 if present._],
                [_`PMOD` to 1._],
                [_`WDTE` to 0._],
                [_`IM` to 15 if present._]
            )
        ],

        [_Write the event identifier and data into the `MEC` special purpose register._],
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

                [_`HLPRE` to 0 if present._],
                [_`PERFCE` to 0 if present._]
            )
        ],

        [_Write the event identifier and data into the `UEC` special purpose register._],
        [_Write the event data into the `UED` special purpose register if needed._],
        [_Write the current value of the `UEHP` special purpose register into the `PC`._]
    ),

    [After reaching the handling procedure, it is important to save to memory the all the "critical" state that was temporarily copied into the `MEPC` and `MESR` for machine level events, or `UEPC` and `UESR` for user level events. This is because in order to support the nesting of events, it must be possible to always restore the critical state of the previous handler. If the hart is re-trapped, for any reason, before the critical state is saved to memory, loss of information regarding control flow will occur and it won't be possible to restore it. Depending on the currently active privilege level, this situation can have different levels of severity:

        #list(tight: true,

            [_User mode: if another user-level event is received before saving the critical state, the hardware must detect this situation and throw the `DUE` fault._],

            [_Machine mode: if any event is received before saving the critical state, the hardware must detect this situation and the affected hart must be halted immediately with code 2 in the `HLT` section of the `SR`._]
        )

        It is important to note that trapping a hart with a promoting event while in user mode, is always possible and will never result in the "double event" situation since the target event registers will be different.
    ],

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

    [The following ordered steps define the "user" returning sequence initiated by the `URET` instruction. This special case performs a "demotion" of the hart, that is, the privilege is changed from machine mode to user mode. Similarly to all other sequences, this must be executed in a single cycle as well:],

    enum(tight: true,

        [_Write the value of the `UESR` special purpose register into the `SR`._],
        [_Write the value of the `UEPC` special purpose register into the `PC`._],

        [_Set the following bits of the `SR` to the following values:_

            #list(tight: true,

                [_`PMOD` to 0._],
                [_`WDTE` to 1._],
            )
        ]
    ),

    [During event handling, interrupts might be received by the hart. A queuing system must be implemented to avoid loss of information. Queues have finite length so it's important to handle the events more rapidly than they come, however if the events are too frequent the queues will eventually fill. Any IO-interrupt and IPC-interrupt that is received while the queues are full, must be discarded and the interrupting device must be notified.],

    [FabRISC provides the *IO Interrupt Queue Size* (`IOIQS`) and the *IPC Interrupt Queue Size* (`IPIQS`) 16 bit ISA parameters, to indicate the size of the queues for IO and IPC interrupts respectively. If no IO or IPC interrupt related capability is implemented, then the corresponding parameter must be set to zero for convention.],

    [FabRISC provides the *IO Interrupt Amount* (`IOIA`) and the *IPC Interrupt Amount* (`IPIA`) 32 bit ISA parameters, to indicate how many distinct IO or IPC interrupts are supported respectively. If no IO or IPC interrupt related capability is implemented, then the corresponding parameter must be set to zero for convention.],

    [When any event is received and the hart is in a transactional state, then all executing memory transactions must immediately be marked as failed with the appropriate abort code depending on the type of event: `EABT`, `FABT`, `IOIABT` or `IPCIABT`.],

    [Software interrupts can be implemented by injecting the appropriate values into the critical registers and then performing the appropriate returning sequence. This will cause the hart to return from a handler with the event id not at zero, thus triggering again the launching sequence. A hart with an event id of zero in its cause register is not considered trapped.],

    comment([

        Events are a very powerful way to react to different things "on the fly", which is very useful for event-driven programming, managing external devices at low latency and are essential for privileged architectures.

        The division in different categories might seem a bit strange at first, but the two broad classes are the usual ones: synchronous and asynchronous events, which roughly align with them being deterministic and non-deterministic respectively. The different types of events within each class are more or less based on "severity".

        Exceptions are the lowest severity among all other events and the program order defines the order in which they must be handled. The only complication to this rule is for helper register exceptions, which have a higher priority. These exceptions might also clash with the previously mentioned regular arithmetic ones but, since the helper ones have a higher priority, they all take over and override them. This behavior stems from the fact that `HLPR` registers allow for finer control, while the `GEE` bit allows exceptions to be enabled or disabled globally. In both instances, it's possible to distinguish if the exception was caused by a `HLPR` register or not. Helper register exceptions are also the only events where a higher priority event doesn't necessarily suppress a lower one, thus having the possibility of handling more than one on the same instruction address in "groups" as mentioned in section 4.

        Faults are also synchronous just like exceptions, but their severity is the highest among any other event and they often signify that something seriously wrong happened, such as an access to an illegal memory address or an invalid / unsupported instruction. Since they are synchronous, they must be handled in program order. The only exception to this is the system call, which has a low priority. This is because faults are the only type of synchronous events that can promote, which is what is needed to invoke the operating system.

        In some situations it may be necessary to queue an interrupt in order to handle it after another, thus avoiding loss of information. If the queue is full, the events must be discarded and, whoever generated the event, must be notified. This includes IO devices or other harts that generated an IPC-interrupt, in this last case, it could be achieved by making the IPC-interrupt generating instruction fail.
    ])
)

#pagebreak()

///
