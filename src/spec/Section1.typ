///
#import "Macros.typ": *

///
#section(

    [Introduction],

    [This is the official document for the FabRISC instruction set architecture. This writing is intended to introduce and explain concepts, features and capabilities of the specification.],

    [FabRISC is a feature rich, register-register, classically virtualizable, load-store architecture with variable length encodings of 2, 4 and 6 bytes. This specification is designed to be highly modular allowing the realization of various different microarchitectures ranging from simple 8 and 16-bit widths, all the way to advanced 32 and 64-bit high performance multithreaded systems. The ISA includes scalar, vector, floating-point, compressed as well as atomic memory instructions. The complete specification supports privileged and system related instructions, interrupts, exceptions, faults and more helping with the implementation of various kinds of operating systems with or without memory management needs. The ISA can be further expanded and enriched by allocating unused encoding space to custom application specific instructions, further increasing both performance and code density. FabRISC is completely free, open-source and available to anyone interested in the project via the official GitHub page: *#link("https://github.com/Clamentos/FabRISC")* (license details can be found at the very end of this writing). The document is divided into multiple sections each explaining a particular aspect of the architecture in detail with the help of tables, figures and suggestions in order to aid the hardware and software designers in creating an efficient implementation of the FabRISC ISA.],

    comment([

        Commentary in this document will formatted in this way and communication will be more colloquial. If the reader is only interested in the specification, these sections can be skipped without hindering the understanding much.

        This project tries to be more of a hobby learning experience rather than a new super serious industry standard, plus the architecture borrows many existing concepts from the most popular and iconic ISAs like: x86, RISC-V, MIPS, ARM and OpenRISC. Don't expect this project to be as good or polished as the commercial ones, however, i wanted to design something that goes beyond simple toy architectures used for teaching and demonstrations. I chose to target FPGAs as the primary platform for two main reasons: firstly is that ASICs are completely out of the question for me and most people because of cost, time and required expertise. Secondly is that using discrete components, all though interesting, makes little sense from a sanity and practicality point of view given the complexity of this project. Software simulators, such as Logisim-evolution *#link("https://github.com/logisim-evolution/logisim-evolution")* or Digital *#link("https://github.com/hneemann/Digital")* can be good alternative platforms for simpler implementations without having to spend a dime.

        The core ideas here are the use of variable length encodings of 4 and 6 byte instruction sizes along with shorter "compressed" ones to increase code density. The goal behind these is to use the long 6 byte format for instructions containing larger immediate values, while the 2 and 4 byte formats for instructions with smaller ones or registers only. The trade off of this is increased ISA capabilities and code density (good for caching) at the expense of misalignment and variable length encodings which can complicate the hardware implementation a bit. This ISA, all though not a "pure" RISC design with simple fixed length instructions and few addressing modes, resembles that philosophy for the most part skewing away from it in some areas, such as, being able to load, store, move and swap multiple registers with a single instruction, more complex addressing modes, floating point transcendental operations and variable length encodings.

        I chose the name "FabRISC" because i wanted to encapsulate the main characteristics and target device of this instruction set. The pronunciation should vaguely remind of the word "fabric" which is a reference on the fact that the main component of an FPGA is the "LUT fabric", that is, a network of many interconnected logic cells.
    ]),

    ///.
    subSection(

        [Terminology],

        [The FabRISC architecture uses the following terminology throughout the document in order to more accurately define technical concepts and vocabulary:],

        align(center, table(

            columns: (auto, auto),
            inset: 8pt,
            align: left + horizon,
            stroke: 0.75pt,

            [#align(center, [*Term*])], [#align(center, [*Description*])],

            [Abort, \ Transaction abort], [Are used to refer to the act of abruptly stopping an ongoing memory transaction as well as invalidating, rolling back or undoing all of its memory changes. The first term is also used to signify the act of abruptly terminating an ongoing set of operations.],

            [Architecture], [Is used to refer to the set of abstractions and contracts that the hardware exposes to the software.],

            [Atomic], [Is used to refer to any operation that must, either be completely executed, or not at all.],

            [Architectural state], [Is used to refer to the state of the processor, a single core or hardware thread that can directly be observed by the programmer.],

            [Coherence], [Is used to refer to the ability of a system to be coherent, that is, ensuring the uniformity of shared resources across the entire system. In particular, it ensures that the order of accesses to a single memory location that is observed by all of the actors within the system.],

            [Consistency], [Is used to refer to the ability of a system to be consistent, that is, ensuring a particular order of operations across all memory locations that is observed by all of the actors within the system.],

            [Consistency model], [Is used to refer to a particular model or protocol of consistency implemented by a system.],

            [Core], [Is used to refer to a fully functional and complete sub-processor within a bigger entity. Advanced processors often aggregate multiple similar copies of themselves, in order to be able to schedule different programs each working on it's own stream of data. It is important to note that each core can implement a completely different microarchitecture, as well as instruction set.],

            [Event], [Is used to generically refer to any extra-ordinary situation that needs to be taken care of as soon as possible, potentially interrupting and redirecting the current flow of execution.],

            [Exception], [Is used to refer to any non severe internal, synchronous event.],

            [Fault], [Is used to refer to any severe internal, synchronous event.],

            [Hardware thread, \ Hart, \ Logical core], [Are used to refer to a particular physical instance of a software thread running on the processor.],

            [Instruction set architecture, \ ISA], [Are used to refer to the architecture that a particular processor exposes to the software under the form of instructions, registers and other resources.],

            [Interrupt], [Is used to refer to any external, asynchronous event.],

            [Macro operation, \ Macro-op, \ Instruction], [Are used to refer an idiomatic assembly machine command that a particular ISA defines.],

            [Memory fence, \ Fence], [Are used to refer to particular instructions that have the ability to enforce a specific execution order of memory instructions.],

            [Memory transaction, \ Transaction], [Are used to refer to a particular series of operations that behave atomically within the system.],

            [Micro operation, \ Micro-op], [Are used to refer to a partially or fully decoded instruction.],

            [Microarchitectural state], [Is used to refer to the complete state of the processor, a single core or hardware thread, that might not be visible by the programmer in its entirety. The microarchitectural state is a superset of the architectural state.],

            [Microarchitecture], [Is used to refer to a particular physical implementation of a given architecture.],

            [Page], [Is used to refer to a logical partition of the main system memory.],

            [Transparent], [Is used to refer to something that is, mostly, invisible to the programmer and handled automatically by the underlying hardware.],

            [Trap], [Is used to refer to the transition from a state of normal execution to the launch of an event handler after receiving an event.],

            [Unaligned, \ Misaligned], [Are used to refer to any memory item that is not naturally aligned, that is, the address of the item modulo its size, is not equal to zero.]
        ))
    )
)

#pagebreak()

///
