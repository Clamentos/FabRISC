///
#import "Macros.typ": *

///
#section(

    [Introduction],

    [This is the official specification document for the FabRISC instruction set architecture, intended to introduce and explain concepts, features and capabilities of the specification.],

    [FabRISC is a feature rich, register-register, load-store architecture with variable length encodings of 2, 4 and 6 bytes. The specification is designed to be highly modular allowing the realization of various different microarchitectures ranging from simple 8 and 16 bit widths, all the way to advanced 32 and 64 bit high performance multithreaded systems. The ISA includes scalar, vector, floating-point, compressed and atomic memory instructions, as well as, privileges, system related instructions, interrupts, exceptions, faults and more, helping with the implementation of various kinds of operating systems with or without memory management needs. The ISA can be further expanded and enriched by allocating unused encoding space to custom application specific instructions, increasing both performance and code density in such areas.],

    [FabRISC is free and open-source, available to anyone interested in the project via the official GitHub page: #monospace(link("https://github.com/Clamentos/FabRISC")) (license details can be found at the very end of this writing as well as in the linked repository). The document is divided into multiple sections each explaining a particular aspect of the architecture in detail with the help of tables, figures and suggestions in order to aid the hardware designers in creating an efficient implementation of the FabRISC ISA.],

    comment([

        Commentary in this document is formatted in this way and communication is more colloquial. If the reader is only interested in the specification, these sections can be skipped without hindering the understanding too much.

        This project tries to be more of a hobby learning experience rather than a new super serious industry standard, besides, the architecture borrows many existing concepts from the most popular and iconic ISAs like: x86, RISC-V, MIPS, ARM and OpenRISC. Don't expect this project to be as good or polished as the commercial ones, however, i wanted to design something that goes beyond simple toy architectures used for teaching and demonstrations. I chose to target FPGAs as the primary platform for two main reasons: firstly is that ASICs are infeasible for the vast majority of people because of cost, time and required expertise. Secondly is that using discrete components, all though fun and interesting, makes little sense from a sanity, practicality and scalability points of view given the complexity of this project. Software simulators, such as Logisim-evolution #monospace(link("https://github.com/logisim-evolution/logisim-evolution")) or Digital #monospace(link("https://github.com/hneemann/Digital")), or even emulators, can be good alternative platforms for simpler implementations without having to spend a dime.

        The core ideas of this architecture are the use of variable length encodings of 4 and 6 byte along with shorter "compressed" ones to increase code density. The goal is to use the long 6 byte format for instructions containing larger immediate values or for less common operations, while the 2 and 4 byte formats for the more common instructions with smaller constants or registers only. The trade off is increased ISA capabilities and code density at the expense of misalignment which can complicate hardware implementations.

        Initially i only wanted to have the 2 and 4 byte sizes but i decided to add the 6 byte one to ease the "pressure", because i couldn't fit all of the features i wanted in the encodings. After several iterations i concluded that this setup is the sweet spot for this architecture: not too many lengths and enough complexity to fit everything.

        This ISA, all though not a "pure" RISC design with simple fixed length instructions and few addressing modes, resembles that philosophy for the most part skewing away from it in some areas where performance can benefit from higher complexity.

        I chose the name "FabRISC" because i wanted to encapsulate the main characteristics and target device of this instruction set. The pronunciation should vaguely remind of the word "fabric" which is a reference on the fact that the main component of an FPGA is the "LUT fabric", that is, a network of many interconnected logic cells.
    ]),

    ///.
    subSection(

        [Terminology],

        [The FabRISC architecture uses the following terminology throughout the document in order to more accurately define technical concepts and vocabulary:],

        tableWrapper([Technical term list.], table(

            columns: (auto, auto),
            align: (x, y) => (left + top, left + top).at(x),

            [#middle([*Term*])], [#middle([*Description*])],

            [Abort \ Transaction Abort \ Transaction Rollback \ Rollback], [Are used to refer to the act of abruptly stopping an ongoing memory transaction as well as invalidating, rolling back or undoing all of its changes.],

            [Architecture], [Is used to refer to the set of abstractions and contracts that the hardware exposes to the software.],
            [Atomic], [Is used to refer to any operation that must, either be completely executed, or not at all.],

            [Architectural State], [Is used to refer to the state of the processor, a single core or hardware thread that can be directly observed by the programmer.],

            [Coherence], [Is used to refer to the ability of a system to be coherent, that is, ensuring the uniformity of shared resources across the entire system. In particular, it ensures that the order of accesses to a single memory location is observed by all of the participating actors.],

            [Consistency], [Is used to refer to the ability of a system to be consistent, that is, ensuring a particular order of operations across all memory locations that is observed by all of the participating actors.],

            [Consistency Model], [Is used to refer to a particular consistency model or protocol implemented by a system.],

            [Core], [Is used to refer to a fully functional and complete sub-processor within a bigger entity. Advanced processors often aggregate multiple copies of themselves, in order to be able to schedule different instruction streams each working on it's own stream of data.],

            [Demotion], [Is used to refer to the transition from a higher privilege mode to a lower privilege one.],

            [Event], [Is used to generically refer to any extraordinary situation that needs to be taken care of as soon as possible, potentially interrupting and redirecting the current flow of execution.],

            [Exception], [Is used to refer to any non severe internal synchronous event.],
            [Fault], [Is used to refer to any severe internal synchronous event.],

            [Fence], [Is used to refer to a particular instruction that has the ability to affect the execution order of other  instructions.],

            [Hardware Thread \ Hart \ Logical Core], [Are used to refer to a particular physical instance of an instruction stream.],

            [Instruction Set Architecture \ ISA], [Are used to refer to the architecture that a particular processor exposes to the software under the form of instructions, registers and other resources and features.],

            [Instruction \ Macro Operation \ Macro-Op], [Are used to refer to an idiomatic assembly machine command that a particular ISA defines.],

            [Interrupt], [Is used to refer to any external asynchronous event.],

            [Micro Operation \ Micro-Op], [Are used to refer to a partially or fully decoded instruction.],

            [Microarchitectural State], [Is used to refer to the complete state of the processor, a single core or hardware thread, that might not be visible by the programmer in its entirety. The microarchitectural state can be seen as a superset of the architectural state.],

            [Microarchitecture], [Is used to refer to a particular physical implementation or realization of a given architecture.],
            [Page], [Is used to refer to a logical partition of the main system memory.],
            [Promotion], [Is used to refer to the transition from a lower privilege mode to a higher privilege one.],

            [Privileged \ Privilege Level], [Is used to refer to a protected system resource that needs "elevated" permissions in order to be accessed.],

            [Transaction \ Memory Transaction], [Are used to refer to a particular series of operations that behave atomically within the system.],

            [Transparent], [Is used to refer to something that is, mostly, invisible to the programmer and handled automatically by the underlying hardware.],

            [Trap], [Is used to refer to the transition from a state of normal execution to the launch of an event handler after receiving an event.],

            [Unaligned \ Misaligned], [Are used to refer to any memory item that is not naturally aligned, that is, the address of the item modulo its size, is not equal to zero.]
        ))
    )
)

#pagebreak()

///
