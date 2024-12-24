///
#import "Macros.typ": *

///
#section(

    [Memory],

    [This section is dedicated to present the memory model used by FabRISC including data alignment, addressing modes, synchronization, consistency, as well as possible cache coherence considerations.],

    ///.
    subSection(

        [Data Alignment],

        [FabRISC, overall, treats the main system memory and the MMIO regions as collections of byte addressable locations in little-endian order with a range of $2^"WLEN"$ addresses in total. The specification leaves to the hardware designers the choice of supporting aligned, unaligned memory accesses or both for data. If aligned is decided to be the only supported scheme, the hart must generate the `MISD` (Misaligned Data) fault every time the constraint is violated. When it comes to instructions, it is mandatory to align the code at the 16 bit boundary which is the greatest common denominator between the instruction lengths. If the hardware detects that the program counter isn't aligned for any reason, the `MISI` (Misaligned Instruction) fault must be generated. Detecting `PC` misalignment simply amounts to checking if the last bit is equal to zero, otherwise the fault is generated. Because instructions are aligned at the 2-byte boundary, the branch offsets can be shifted by one to the left, thus, doubling the range in terms of bytes.],

        [The `DALIGN` module must be implemented if the hardware doesn't support misaligned data accesses. The module provides the architecture with the aforementioned `MISD` fault and it can be implemented in unprivileged microarchitectures as well like any other event. Compatibility between two microarchitectures that differ in data alignment capabilities, can be solved by simulating unaligned memory accesses in software as an event handler for the `MISD` fault. This would render the code interchangeable between the two systems at the cost of performance.],

        comment([

            Alignment issues can arise when the processor wants to read or write an item whose size is greater than the smallest addressable thing. This problem is tricky to design hardware for, especially caches and TLBs, because misaligned items can cross cache line boundaries as well as OS page boundaries. Alignment networks and more advanced caches are needed to natively support this, which increases complexity and may slow down the critical path. For already complex, deeply pipelined multicore out-of-order superscalar machines, however, i believe that supporting unaligned accesses in hardware can be handy.

            FabRISC always provides the option for aligned only systems via emulation thanks to the `MISD` fault, if the other route is not deemed worth pursuing.
        ])
    ),

    ///.
    pagebreak(),
    subSection(

        [Memory Addressing Modes],

        [FabRISC provides several addressing modes for both vector and scalar pipelines, from simple register indirect all the way to vector gather and scatter operations. This helps the code to be more compact increasing the efficiency of instruction caches as well as reducing the overhead of "bookkeeping" instructions for more complex access patterns. The addressing modes are divided into two parts, the first for scalar operations and the second for vector operations:],

        list(tight: false,

            [*Scalar addressing modes:* _These modes can access a single element at a time, which can be any integer or floating point type of 8, 16, 32 or 64 bits:_

                #list(tight: false, marker: [--],

                    [*Immediate displaced:* $"mem"["reg" + "imm"] <-> "reg"$ _The address is composed of the sum between a register acting as the base pointer and a constant. This addressing mode also support two auto-update modes to help with sequential data structures: post-increment and pre-decrement._],

                    [*Immediate indexed*: $"mem"["reg" + "reg" + "imm"] <-> "reg"$ _The address is composed of the sum between two registers, one acting as the base pointer while the other acting as the index and a constant._],

                    [*Immediate scaled:* $"mem"["reg" + ("reg" << "imm")] <-> "reg"$ _The address is composed of the sum between a register acting as the base pointer and a second register acting as the index logically left shifted by a constant._]
                )
            ],

            [*Vector addressing modes:* _These modes can access multiple elements at a time. The number of elements accessed is dictated by the VLEN bits stored in the flag register. The elements are all the same type either integer or floating point of 8, 16, 32 or 64 bits:_

                #list(tight: false, marker: [--],

                    [*Vector immediate displaced:* $"mem"_i ["reg" + "stride"("imm")] <-> "vreg"_i$ _The address is composed of a single scalar register used as the base pointer. The constant specifies the stride of the access, which is simply how many bytes to skip between each element._],

                    [*Vector indexed (gather / scatter):* $"mem"_i ["reg" + "vreg"_i] <-> "vreg"_i$ _The address is composed of the sum between the base pointer register and the $i^"th"$ index of the specified vector register._]
                )
            ]
        ),

        comment([

            Good addressing modes can help improve code density and performance since they can be directly implemented in hardware reducing the overhead. The modes that i decided to support are handy for a variety of data structures, especially sequential ones such as stacks and arrays thanks to the auto-update features. Vector modes include the common strided, as well as gather and scatter which are particularly useful for accessing sparse matrices.

            Thanks to the modular nature of FabRISC, it's not required to implement the complex modes at all, only the immediate displaced can suffice as it's the simplest and, by far, the most commonly used in programs and also the "standard" addressing mode for many RISC-oriented architectures.
        ])
    ),

    ///.
    subSection(

        [Synchronization],

        [FabRISC provides dedicated atomic instructions via the `DAB` and `DAA` instruction modules to achieve proper synchronization in order to protect critical sections and to avoid data races in threads that share memory with each other. The proposed instructions behave atomically and can be used to implement atomic _test-and-set_ and _read-modify-write_ operations for locks, semaphores and barriers. It is important to note that if the system can only ever run one software thread at any given moment, then this section can be skipped since the problem can be solved by the operating system, or by software in general. Below is a description of the atomic instructions, which are divided in two categories:],

        list(tight: false,

            [*Test-and-set* _instructions:_

                #list(tight: false, marker: [--],

                    [*Compare And Swap:* _(`CAS`) is a simple atomic instruction that atomically swaps the memory location `X` with register value `Y` if `X` is equal to the register value `Z`._]
                )
            ],

            [*Read-modify-write instructions:* _These instructions provide several atomic read-modify-write operations on single variables, such as atomic addition that can generally scale better than using CAS-based algorithms when implementing lock-free datastructures (see section 7 for more information)._]
        ),

        [The test-and-set and read-modify-write family of instructions, in order to be atomic, must perform all of their operations in the same memory "request". This ensures that no other hart or device has access to the memory, potentially changing the target variable in the middle of the operation. This may be achieved by directly arbitrating the bus or with the help of the cache coherence protocol or both depending on the underlying microarchitecture.],

        subSubSection(

            [Transactional Memory],

            [FabRISC also provides optional instructions, via the `TM` module, to support basic hardware transactional memory that can be employed instead of the above seen solutions to exploit parallelism in a more "optimistic" manner. Multiple transactions can proceed in parallel as long as no conflict is detected by the hardware. when such situations occur the offended transaction must be aborted, that is, it must discard all the changes and restore the architectural state immediately before the start of the transaction itself. If a transaction detects no conflict it is allowed to commit the changes and the performed operations can be considered atomic. Transactions can be nested inside each other up to a depth of 255, beyond this, further transactions must be all aborted before event starting. For convention and simplicity, if an event that causes the context to be changed or traps the hart, all of its ongoing transactions must be aborted. One important consideration is that FabRISC approach to transactional memory is "liberal", which requires a transaction to fully reach the commit point before resulting in either a positive or negative outcome. In order to fail transactions earlier and to allow for a quicker retry, it's possible to perform a checkpoint on the progress via a dedicated instruction. The following are the proposed transactional memory instructions:],

            pagebreak(),
            tableWrapper([Transactional instructions.], table(

                columns: (auto, auto),
                align: left + horizon,

                [#middle([*Name*])], [#middle([*Description*])],

                [`TBEG`], [*Transaction Begin*: \ Causes the hart that executed this instruction to start monitoring accesses by other harts as well as incrementing the nesting counter by one, thus starting a transaction. If the nesting counter was zero prior to executing this instruction, the hart must enter into transactional mode. This instruction will write the outcome status of its execution in the specified destination register.],

                [`TCOM`], [*Transaction Commit*: \ Causes the hart that executed this instruction to stop monitoring accesses by other harts and commit the changes as well as decrementing the nesting counter by one. If the nesting counter is zero after the execution of this instruction, the hart must exit from transactional mode. This instruction will write the outcome status of its execution in the specified destination register. All of the updates to memory, if any, can be considered atomic and permanent after the successful completion of this instruction.],

                [`TABT`], [*Transaction Abort*: \ Causes the hart that executed this instruction to stop monitoring accesses by other harts, discard all changes, decrement the nesting counter by one and write, to the specified destination register, the value of the `XABT` abort code. This instruction behaves in a similar manner to a failing `TCOM`. It is important to note that this instruction will, naturally, only abort the innermost active transaction.],

                [`TABTA`], [*Transaction Abort All*: \ Causes the hart that executed this instruction to stop monitoring accesses by other harts, discard all changes, reset the nesting counter to zero and write, to the specified destination register, the value of the `XABT` abort code. This instruction behaves in a similar manner to a failing `TCOM`. It is important to note that this instruction will abort all currently active transactions.],

                [`TCHK`], [*Transaction Check*: \ Causes the hart that executed this instruction to check if it's necessary to abort the current transaction. If the check fails, this instruction will behave exactly the same as a failing `TCOM`. If the check passes, this instruction will not affect the architectural state, that is, it will behave like a no-operation.],

                [`TLEV`], [*Transaction Level*: \ Returns the current transaction nesting level count. If no transaction is active a zero is returned.]
            )),

            pagebreak(),
            [The `TM` module, as mentioned earlier, also includes _abort-codes_ that can be used by the programmer to take appropriate actions in case the transaction was aborted. The proposed codes are listed in the following table:],

            tableWrapper([Transaction abort codes.], table(

                columns: (auto, auto, auto),
                align: (x, y) => (right + horizon, left + horizon, left + horizon).at(x),

                [#middle([*Code*])], [#middle([*Mnemonic*])], [#middle([*Description*])],

                [0], [`XABT`], [*Explicit abort*: \ The transaction was explicitly aborted by the `TABT` or `TABTA` instruction.],
                [1], [`EABT`], [*Event abort*: \ The transaction was aborted due to a triggered event: Interrupt, fault or exception.],

                [2], [`CABT`], [*Conflict abort*: \ The transaction was aborted due to a collision with another thread, that is, both wrote to the same memory location but the other thread committed earlier.],

                [3], [`RABT`], [*Replacement abort*: \ The transaction was aborted due to a cache line replacement that held a previously fetched transactional variable.],

                [4], [`UABT`], [*Depth underflow abort*: \ The transaction was aborted because a `TCOM`, `TABT`, `TABTA` or a failing `TCHK` instruction attempted to execute at a depth of 0.],

                [5], [`OABT`], [*Depth Overflow abort*: \ The transaction was aborted due to an exceeded nesting depth.]
            ))
        ),

        comment([

            Memory synchronization is extremely important in order to make shared memory communication even work at all. The problem arises when a pool of data is shared among different processes or threads that compete for resources and concurrent access to this pool might result in erroneous behavior and must, therefore, be arbitrated. This zone is called "critical section" and special atomic primitives can be used to achieve this protection. Many different instruction families can be chosen such as "test-and-set", "read-modify-write" and others. I decided to provide in the ISA the compare-and-swap instruction as it's very popular and is a classic. It has the useful property of guaranteeing that at least one thread will successfully execute the operation. It doesn't obviously protect from deadlocks or livelocks as they are a symptom of erroneous code and also suffers from the "ABA" problem since it detects changes by looking at the data only.

            Another valid option would be to use the `LL` & `SC` pair commonly found in many RISC ISAs. I decided not to go this route since the pair, even though it doesn't suffer from the ABA problem, it doesn't guarantee forward progress unless additional restrictions are placed (see "constrained" / "unconstrained" `LL` & `SC` sequences in RISC-V).

            FabRISC also provides a small set of simple read-modify-write type operations, which can ease the implementation of lock-free datastructures and algorithms allowing for better scaling when thread contention is high.

            Lastly i decided to also provide basic hardware transactional memory support because, in some situations, it can yield great performance compared to "pessimistic" solutions without losing atomicity. This is, naturally, completely optional and up to the hardware designers to implement or not simply because it can complicate the design by a fair bit, especially the caching and coherence subsystem. Transactional memory seems to be promising in improving performance and ease of implementation when it comes to shared memory programs, but debates are still ongoing to decide which exact way of implementing is best. I chose to go with a very liberal approach that aborts only at commit or during a checkpoint, as opposed to aborting as soon as a failure is detected via exceptions or events. This is simpler to implement in both the specification (i tried and there were so many edge cases, i ended up scrapping it) and the hardware and can provide a higher transaction completion percentage at the expense of a higher retry latency.
        ])
    ),

    ///.
    subSection(

        [Coherence],

        [FabRISC leaves to the hardware designers the choice of which coherence protocol to implement. On multicore systems cache coherence must be ensured by choosing a coherence protocol and making sure that all harts agree on the current sequence of accesses to the same memory location. That can be guaranteed by serializing the operations via the use of a shared bus or via a distributed directory system. After this, _write-update_ or _write-invalidate_ protocol can be employed. Software coherence can also be a potential option but it will rely on the programmer to explicitly flush or invalidate the cache of each core separately. Nevertheless, FabRISC provides via the `SYS` instruction module, implementation dependent instructions, such as `CACOP`, that can be sent to the cache subsystem directly to manipulate its state and operation. If the processor makes use of a separate instruction cache, potential complications can arise for self modifying code which can be solved by employing any of the above mentioned options for instruction caches as well.],

        comment([

            Cache coherence is a big topic and is hard to get right because it can greatly hinder performance in both single core and multicore code as well as significantly complicate the design. I decided to give as much freedom as possible to the designer of the system to pick the best solution that they see fit.

            Another aspect that could be important, if the software route is chosen, is the exposure to the underlying microarchitecture implementation to the programmer which can be yield unnecessary complications and confusions. Generally speaking though write-invalidate seems to be the standard approach in many modern designs because of the way it behaves in certain situations, especially when a process is moved to another core by the operating system. A simple shared bus with snooping can be a good choice if the number of cores is small (lots of cores means lots of traffic), otherwise a directory based approach can be used to ensure that all the cores agree on the order of accesses. From this, the actual coherence protocol can be picked. Common ones are: `MSI`, `MESI`, `MOSI` or `MOESI`, the latter being the most complex but most powerful in reducing traffic and maximizing power efficiency. All the harts that map to the same core don't need to worry about coherence between each other since the caches are shared between those harts. This argument holds true for whole cores that share bigger pools of cache, such as L3 and sometimes L2. Virtually accessed caches are sort of an exception because false sharing can be an issue needing extra hardware checks to cover this edge case.

            The concept of coherence goes beyond caching and exists any time where multiple copies of the same data are shared by different actors, including IO devices.
        ])
    ),

    ///.
    subSection(

        [Consistency],

        [FabRISC utilizes a fully relaxed memory consistency model formally known as _release consistency_ that allows all possible orderings in order to give harts the freedom to reorder memory instructions to different addresses in any way they want. For debugging and specific situations the stricter _sequential consistency_ model can be utilized and the hart must be able to switch between the two at any time via the `CMD` bit in the status register. Special instructions, called "fences", are provided by the `FNC` module to let the programmer impose memory ordering restrictions when the relaxed model is in use. If the hart doesn't reorder memory operations this module is not necessary and can be skipped. The proposed fencing instructions are listed in the following table:],

        tableWrapper([Fencing instructions.], table(

            columns: (auto, auto),
            align: left + horizon,

            [#middle([*Name*])], [#middle([*Description*])],

            [`FNCL`], [*Fence Loads*: \ This instruction forbids the hart from reordering any memory load instruction across the fence.],

            [`FNCS`], [*Fence Stores*: \ This instruction forbids the hart from reordering any memory store instruction across the fence.],

            [`FNCLS`], [*Fence Loads and Stores*: \ This instruction forbids the hart from reordering any memory load or store instruction across the fence.],

            [`FNCIOL`], [*Fence IO Loads*: \ This instruction forbids the hart from reordering any IO load instruction across the fence.],

            [`FNCIOS`], [*Fence IO Stores*: \ This instruction forbids the hart from reordering any IO store instruction across the fence.],

            [`FNCIOLS`], [*Fence IO Loads and Stores*: \ This instruction forbids the hart from reordering any IO load or store instruction across the fence.]
        )),

        [The fences can be used on any memory type instruction, including the atomic `CAS` to forbid reordering when acquiring or releasing a lock for critical sections and barriers. Writes to portions of memory where the code is stored can be made effective by issuing a command to the cache subsystem via the dedicated implementation specific `CACOP` instruction as briefly discussed in the previous subsection.],

        comment([

            The memory consistency model i wanted to utilize was a very relaxed one to allow all kinds of performance optimization to take place inside the system. However one has to provide some sort of restrictions, effectively special memory operations, to avoid edge cases that can cause erroneous processing if the hart can execute memory instructions out of order.

            Even with those restrictions debugging could be quite difficult because the program might behave very weirdly, so i decided to include the sequentially consistent model that forbids reordering of any kind of memory instruction.
        ])
    )
)

#pagebreak()

///
