///
#import "Macros.typ": *

///
#section(

    [Memory],

    [This section is dedicated to present the memory model used by FabRISC including data alignment, addressing modes, synchronization, consistency, as well as possible cache coherence considerations and reminders.]
)

    ///
    #subSection(

        [Data alignment],

        [FabRISC, overall, treats the main memory and the MMIO regions as collections of byte-addressable locations in little-endian order with a range of $2^"WLEN"$ addresses in total. The specification leaves to the hardware designers the choice of supporting aligned or unaligned memory accesses or both for data. If aligned is decided to be the only supported scheme, the hart must generate the MISA fault every time the constraint is violated. When it comes to instructions, it is mandatory to align the code at the 16-bit boundary which is the greatest common denominator between the instruction lengths and the fetch engines must, obviously, be able to provide instructions aligned in this way. If the hardware detects that the program counter isn't aligned for any reason, the MISI fault must be generated. Detecting PC misalignment simply amounts to checking if the last bit is equal to zero, otherwise the fault is generated. Because instructions are aligned at the 2-byte boundary, the branch offsets can be shifted by one to the left, thus, doubling the range in terms of bytes.],

        [The DALIGN module must be implemented if the hardware doesn't support misaligned data accesses. It provides the architecture with the MISA fault and it can be implemented in unprivileged microarchitectures as well like any other event (see the privileged specification for more information).],

        [Compatibility between two microarchitectures that differ in data alignment capabilities, can be easily solved by simulating unaligned memory accesses in software as an event handler for the MISA fault. This would render the code interchangeable between the two systems at a performance hit.],

        comment([
            
            Alignment issues can arise when the processor wants to read or write an item whose size is greater than the smallest addressable thing. This problem is tricky to design hardware for, especially caches, because misaligned items can cross cache line boundaries as well as OS page boundaries. Alignment networks and more advanced caches are needed to support this, which can increase complexity and may slow down the critical path too much for simple designs. For already complex, deeply-pipelined multicore out-of-order superscalar machines, however, i believe that supporting unaligned accesses can be handy so that the software writer can make decisions freely without having to worry about this issue, potentially decreasing the memory footprint in datastructures with many irregular objects.
        ])
    )

    ///
    #subSection(

        [Memory addressing modes],

        [FabRISC provides five addressing modes for both vector and scalar pipelines, from simple register indirect all the way to vector gather and scatter operations. This helps the code to be more compact increasing the efficiency of instruction caches as well as reducing the overhead of "bookkeeping" instructions for more complex access patterns. The addressing modes are divided into two parts, the first for scalar operations and the second for vector operations:],

        list(tight: false,
        
            [*Scalar addressing modes:* _these modes can access a single element at a time. The element can be any integer or floating point type of 8, 16, 32 or 64 bits:_
            
                #list(tight: false, marker: [--],
                
                    [*Immediate displaced:* $"mem"["reg" + "imm"] <-> "reg"$ _The address is composed of the sum between a register acting as a pointer and a constant._],

                    [*Immediate indexed*: $"mem"["reg" + "reg" + "imm"] <-> "reg"$ _The address is composed of the sum between two registers, one acting as a pointer while the other acting as the index, and a constant._],

                    [*Immediate scaled:* $"mem"["reg" + ("reg" dot "imm")] <-> "reg"$ _The address is composed of the sum between a register acting as a pointer and the product of the index with a constant._]
                )
            ],

            [*Vector addressing modes:* _these modes can access multiple elements at a time. The number of elements accessed is dictated by the VLEN bits stored in the flag register. The elements are all the same type either integer or floating point of 8, 16, 32 or 64 bits:_
            
                #list(tight: false, marker: [--],

                    [*Vector immediate displaced:* $"mem"_i ["reg" + "stride"("imm")] <-> "vreg"_i$ _The address is composed of a single scalar register used as a pointer. The constant specifies the stride of the access._],

                    [*Vector indexed (gather / scatter):* $"mem"_i ["reg" + "vreg"_i] <-> "vreg"_i$ _The address is composed of the sum between a base pointer register and the $i^"th"$ index of the specified vector register._]
                )
            ]
        ),

        [All scalar addressing modes support auto-update to help with sequential data structures: _post-increment_ and _pre-decrement_ (See section 7 for more information).],

        comment([

            Good addressing modes can help improve code density, legibility (though low-level assembly isn't red by humans all that often...) as well as performance since they can be directly implemented in hardware with very little overhead. The modes that i decided to support are handy for a variety of data structures, especially sequential ones such as stacks and arrays thanks to the auto-update features. Vector modes include the common strided, as well as gather and scatter which are particularly useful for sparse matrices.

            Thanks to the modular nature of FabRISC, it's not required to implement the complex modes at all, only the immediate displacement as it's the simplest and most commonly used in basic implementations.
        ])
    )

    ///
    #subSection(

        [Synchronization],

        [FabRISC provides dedicated atomic instructions via the AM instruction module to achieve proper synchronization in order to protect critical sections and to avoid data races in threads that share memory with each other. The proposed instructions behave atomically and can be used to implement atomic _read-modify-write_ and _test-and-set_ operations for locks, semaphores and barriers. It is important to note that if the processor can only run one hart at any given moment, then this section can be skipped since the problem can be solved by the operating system (or by software in general). Below is a description of the atomic instructions (see section 7 for more information), which are divided in two categories:],

        list(tight: false,

            [*Read-modify-write* _instructions:_
            
                #list(tight: false, marker: [--],

                    [*Load Linked:* _(LL) is a non atomic memory operation that loads an item from memory into a register and performs a "reservation" of the fetched location. The reservation can simply be storing the address and size of the object into an internal transparent "link" register controlled by the hardware and marking it as valid._],

                    [*Store Conditional:* _(SC) is a non atomic instruction that stores an item from a register to the target memory location if and only if the reservation matches and is marked as valid, that is, the address and size are the same plus the valid bit set. In the case of a mismatch, or an invalidity, SC must not perform the store and must return a zero in its destination register as an indication of the failure. If SC succeeds, the item is written to memory, a one is returned into its register destination and all reservations must therefore be invalidated. From this point in time, the update to the desired variable in memory can be considered atomic._]
                )
            ],

            [*Test-and-set* _instructions:_
            
                #list(tight: false, marker: [--],

                    [*Compare And Swap:* _(CAS) is a simple atomic instruction that conditionally and atomically swaps two values in memory if they are equal._],

                    [*Versioned Compare And Swap:* _(VSCAS) is an atomic instruction that conditionally and atomically swaps two values (including the version counter) in memory if the value and counter are equal to the specified, incrementing its version counter by one. This counter is an 8-byte value physically next to the actual variable._]
                )
            ],

            [*Read-modify-write instructions:* _these instructions provide several atomic read-modify-write operations on single variables, such as addition, subtraction, minimum and maximum (see section 7 for more information)._]
        ),

        [The LL and SC pair, as briefly mentioned above, necessitates of a transparent register that is used to hold the address of the fetched element as well as its size. Once the reservation is completed and marked as valid, accesses performed by other cores must be monitored via the cache coherence protocol. If a memory write request to the matching address is snooped by another hart, then that particular reservation must be immediately invalidated. The hardware designers are free to decide how strict the pair can behave by either storing the logical address and invalidate when the context changes, or when an interrupt or fault is triggered. Alternatively, it's possible to reserve the physical address in order relax this constraint and potentially make the pair work across context switches (see the privileged specification for more information). It is important to note that the LL and SC instructions are not atomic individually, but become atomic when paired thanks to the mentioned link register and the cache coherence protocol.],

        [The test-and-set and read-modify-write family of instructions, in order to be atomic, must perform all of their operations in the same memory request. This ensures that no other hart or device has access to the memory potentially changing the target variable in the middle of the operation. The request should be held just for the necessary amount of time to complete in order to minimize bus contentions and memory traffic.],

        [FabRISC also provides optional instructions, via the TM module, to support basic hardware transactional memory that can be employed instead of the above seen solutions to exploit parallelism in a more "optimistic" manner. Multiple transactions can happen in parallel as long as no conflict is detected by the hardware. when such situations occur the offended transaction must be aborted, that is, it must discard all the changes and restore the architectural state immediately before the start of the transaction itself. If a transaction detects no conflict it is allowed to commit the changes and the performed operations can be considered atomic. Transactions can be nested inside each other up to a depth of 255, beyond this, they must be all aborted. For convention, if an event that causes the context to be changed or traps the hart, all of its ongoing transactions must be aborted (see the privileged specification for more information). One important consideration is that FabRISC approach to transaction is optimistic, which requires a transaction to fully reach the commit point before completing in either a positive or negative outcome (abort). In order to fail transactions earlier and to allow for a quicker retry, it's possible to perform a checkpoint on the progress via a dedicated instruction. The following are the proposed transactional memory instructions (see section 7 for more information):],

        align(center, table(

            columns: (15fr, 85fr),
            inset: 8pt,
            align: left + horizon,
            stroke: 0.75pt,

            [#align(center, [*Name*])], [#align(center, [*Description*])],

            [TBEG], [*Transaction Begin*: \ Causes the hart that executed this instruction to enter into transactional mode and to start monitoring accesses by other harts via the coherence protocol as well as incrementing the nesting counter by one. TBEG will write the outcome status of its execution in the specified destination register. This instruction effectively starts a transaction.],

            [TCOM], [*Transaction Commit*: \ Causes the hart that executed this instruction to stop monitoring accesses by other harts and commit the changes as well as decrementing the nesting counter by one. TCOM will write the outcome status of its execution in the specified destination register. This instruction effectively concludes a transaction and the updates to memory, if any, can be considered atomic and permanent after the completion of TCOM.],

            [TABT], [*Transaction Abort*: \ Causes the hart that executed this instruction to stop monitoring accesses by other harts, discard all changes, decrement the nesting counter by one and write, to the specified destination register, the value of the XABT abort code. This instruction behaves in a similar manner to a failing TCOM. It is important to note that TABT will naturally only abort the innermost transaction.],

            [TABTA], [*Transaction Abort All*: \ Causes the hart that executed this instruction to stop monitoring accesses by other harts, discard all changes, reset the nesting counter to zero and write, to the specified destination register, the value of the XABT abort code. This instruction behaves in a similar manner to a failing TCOM. It is important to note that TABTA will abort all currently ongoing transactions.],

            [TCHK], [*Transaction Check*: \ Causes the hart that executed this instruction to check if it's necessary to abort the current transaction. If the check fails, this instruction will behave exactly the same as TABT. If the check passes, this instruction will not affect the state of the microarchitecture, that is, it will behave like a no-operation.]
        )),

        [The TM module, as mentioned earlier, also includes the presence of _abort codes_ that can be used by the programmer to take appropriate actions in case the transaction was aborted. The proposed codes are:],

        align(center, table(

            columns: (10fr, 20fr, 70fr),
            inset: 8pt,
            align: (x, y) => (center + horizon, left + horizon, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Code*])], [#align(center, [*Mnemonic*])], [#align(center, [*Description*])],

            [0], [XABT], [Explicit abort. The transaction was explicitly aborted by the TABT or TABTA instructions.],
            [1], [EABT], [Event abort. The transaction was aborted due to a triggered event: interrupt, fault or exception.],
            [2], [CABT], [Conflict abort. The transaction was aborted due to a collision with another thread (both wrote to the same location).],

            [3], [RABT], [Replacement abort. The transaction was aborted due to a cache line replacement that held a previously fetched transactional variable.],

            [4], [SABT], [Size abort. The transaction was aborted due to reaching the cache size limit.],

            [5], [UABT], [Depth underflow abort. The transaction was aborted because a TCOM, TABT, TABTA or a failing TCHK instruction attempted to execute at a depth of 0.],

            [6], [OABT], [Depth Overflow abort. The transaction was aborted due to an exceeded nesting depth.]
        )),

        linebreak(),
        comment([

            Memory synchronization is extremely important in order to make shared memory communication even work at all. The problem arises when a pool of data is shared among different processes or threads that compete for resources and concurrent access to this pool might result in erroneous behavior and must, therefore, be arbitrated. This zone is called "critical section" and special atomic primitives can be used to achieve this protection. Many different instruction families can be chosen such as "Compare-and-swap", "Test-and-set", "Read-modify-write" and others. I decided to provide in the ISA the LL and SC pairs, as described above, because of its advantages and popularity among other RISC-like instruction sets. Two important advantages of this pair is that it is pipeline friendly (LL acts as a load and SC acts as a store) compared to others that try to do both. Another advantage is the fact that the pair doesn't suffer from the "ABA" problem. It is important to note, however, that this atomic pair doesn't guarantee forward progress and weaker implementations can reduce this chance even more. The CAS and VSCAS atomic instructions, however, do guarantee forward progress rendering them stricter compared to the previous pair. FabRISC also provides a small set of simple Read-modify-write type operations, which can ease the implementation of lock-free datastructures and algorithms.

            Lastly i decided to also provide basic hardware transactional memory support because, in some situations, it can yield great performance compared to "pessimistic" solutions without losing atomicity. This is completely optional (as all the rest) and up to the hardware designers to implement or not simply because it can complicate the design by a fair bit, especially the caching subsystem. Transactional memory seems to be promising in improving performance and ease of implementation when it comes to shared memory programs, but debates are still ongoing to decide which exact way of implementing is best. I chose to go with a very optimistic approach that aborts only at commit or when checkpointing, as opposed to aborting as soon as a failure is detected. This should be simpler to implement and can provide a higher transaction completion percentage at the expense of a higher retry latency.
        ])
    )

    ///
    #subSection(

        [Coherence],

        [FabRISC leaves to the hardware designer the choice of which coherence protocol to implement. On multicore systems cache coherence must be ensured by choosing a coherence protocol and making sure that all cores agree on the current sequence of accesses to the same memory location. That can be guaranteed by serializing the operations via the use of a shared bus or via a distributed directory and _write-update_ or _write-invalidate_ protocols can be employed without any issues. Software coherence can also be a valid option but it will rely on the programmer to explicitly flush or invalidate the cache of each core separately. Nevertheless, FabRISC provides, via the SB instruction module, implementation-dependent instructions, such as CACOP, that can be sent to the cache controller directly to manipulate its operation (see section 7 for more information). If the processor makes use of a separate instruction cache, potential complications can arise for self modifying code which can be solved by employing one of the above explored options for instruction caches as well.],

        comment([

            Cache coherence is a big topic and is hard to get right because it can hinder performance in both single core and multicore significantly as well as significantly complicate the design. I decided to give as much freedom as possible to the designer of the system to pick the best solution that they see fit. Another aspect that could be important, if the software route is chosen, is the exposure to the underlying microarchitecture implementation to the programmer which can be yield unnecessary complications and confusions. Generally speaking though write-invalidate seems to be the standard approach in many modern designs because of the way it behaves in certain situations, especially when a process is moved to another core by the operating system. Simple shared bus can be a good choice if the number of cores is small (lots of cores means lots of traffic), otherwise a directory based approach can be used to ensure that all the cores agree on the order of accesses. From this, the protocol can be picked: MSI, MESI, MOSI or MOESI, the latter being the most complex but most powerful. All the harts that map to the same core don't need to worry about coherence since the caches are shared between those harts. This argument holds true for whole cores that share bigger pools of cache, such as L3 and sometimes L2. Virtually accessed caches are sort of an exception because false sharing can be an issue needing extra hardware checks to cover this edge case.
        ])
    )

    ///
    #subSection(

        [Consistency],

        [FabRISC utilizes a fully relaxed memory consistency model formally known as _release consistency_ that allows all possible orderings in order to give harts the freedom to reorder memory instructions to different addresses in any way they want. For debugging and specific situations the stricter _sequential consistency_ model can be utilized and the hart must be able to switch between the two at any time via the CMD special purpose register (see section 6 for more information) Special instructions, called "fences", are provided by the FNC module to let the programmer impose an order on memory operations when the relaxed model is in use. If the hart doesn't reorder memory operations this module is not necessary and can be skipped. The proposed fencing instructions are:],

        align(center, table(

            columns: (12fr, 88fr),
            inset: 8pt,
            align: left + horizon,
            stroke: 0.75pt,

            [#align(center, [*Name*])], [#align(center, [*Description*])],

            [FNCL], [*Fence Loads*: \ This instruction forbids the hart to reorder any load instruction across the fence.],
            [FNCS], [*Fence Stores*: \ This instruction forbids the hart to reorder any store instruction across the fence.],
            [FNCLS], [*Fence Loads and Stores*: \ This instruction forbids the hart to reorder any load or store instruction across the fence.],
            [FNCI], [*Fence Instructions*: \ This instruction signals that a modification of the instruction cache happened.]
        )),

        [The fences can be used on any memory type instruction, including the LL and SC pair and CAS to forbid reordering when acquiring or releasing a lock for critical sections and barriers. Writes to portions of memory where the code is stored can be made effective by issuing a command to the cache controller via the dedicated implementation specific CACOP instruction as briefly discussed above. The FNC module also requires the ability for the hart to switch between the release consistency and the more stringent sequential consistency model.],

        comment([

            The memory consistency model i wanted to utilize was a very relaxed one to allow all kinds of performance optimization to take place inside the system. However one has to provide some sort of restrictions, effectively special memory operations, to avoid absurd situations. Even with those restrictions debugging could be quite difficult because the program might behave very weirdly, so i decided to include the sequential model that forbids reordering of any kind of memory instruction.
            
            If a program is considered well synchronized (data race-free and all critical sections are protected) consistency becomes less of an issue because there will be no contention for resources and, therefore, the model can be completely relaxed without any side effects. Achieving this level of code quality is quite the challenge and so these consistency instructions can be employed in making sure that everything works out.
        ])
    )

#pagebreak()

///