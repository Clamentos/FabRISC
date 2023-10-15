///
#import "Macros.typ": *

///
#section(

    [Input Output],

    [This section is dedicated to the specification that FabRISC uses for communicating with external devices as well as other cores and hardware threads if present. The architecture defines IO mappings, potential DMA behavior and, in the next sections, OS support and inter-process communication schemes will be discussed.]
)

    ///
    #subSection(

        [Memory mapped IO],

        [FabRISC reserves a portion of the high memory address space to _memory mapped IO_. This region, which size depends on the IOLEN parameter of the system, is not cached and byte addressable in little-endian order. If a hart wants to transfer data to an IO device it can simply execute a memory operation to this section without further complications. The IO devices must map all of its internal registers and state to this region and multiple channels or buses can potentially be employed to reduce the latency in case another transfers are already taking place as well as increasing the bandwidth. The area starts at address 0xFFF...F and grows upwards like a stack.],

        comment([

            I decided to go with memory mapped IO because of its flexibility and simplicity compared to port based solutions. The IO region can be considered plain memory by the processor internally, which allows for advanced and fancy operations that use locks, barriers, fences and transactions to be done by multiple threads to the same device. I don't recommend caching this region because it can yield potential inconsistencies and unnecessary complexities. The idea here is to provide general purpose IO system that can be easily realized on any microarchitecture. The MMIO i decided to propose is almost as easy as it gets and it should be good for most low to mid-speed transfers.

            The hardware designers can choose from a variety of different sizes for the MMIO space, ranging from the minuscule 8 bytes suitable for a tiny 8-bit implementation, all the way to 1 Tera bytes suitable for more advanced machines that also implement a full blown operative system.
        ])
    )

    ///
    #subSection(

        [Direct memory access],

        [FabRISC provides the ability for IO devices to access the main system memory directly via DMA without passing through the processor. A dedicated centralized controller serving as arbiter can be utilized to achieve this, but the hardware designer is free to choose any another alternative if considered appropriate. If this method of communication is chosen to be used, cache coherence must be ensured between the processor and the IO devices too. Some possible options can be, as discussed earlier:],

        list(tight: false,
        
            [*Non cacheable memory region:* _with this configuration coherence isn't a problem because no caching is performed by the CPU and the IO device in question. The system, however, needs to be able to dynamically declare which portion of memory is cacheable and which isn't. This solution might lead to unnecessary complexities._],

            [*Software IO coherence:* _with this configuration the CPU and the device are required to flush or invalidate the cache explicitly with no extra hardware complexity, however, this option requires the exposure of the underlying organization to the programmer._],

            [*Hardware IO coherence:* _with this configuration, both the CPU and the IO device, will monitor each other's accesses via a common bus or a directory and proper actions are automatically taken according to a coherence protocol which can be the already existent one in the processor._]
        ),

        [The DMA protocol or scheme implemented by the hardware designer must also take consistency into account since memory operations to different addresses are allowed to be done out-of-order. This means that fencing instructions must retain their effect from the point of view of the hart and IO devices, in short, IO devices must provide similar fencing features as well.],

        comment([

            For more bandwidth demanding devices, DMA can be used to transfer data at very high speeds in the order of several Gb/s without interfering with the CPU. This scheme however, is more complex than plain MMIO because of the special arbiter that handles and grants the requests. IO coherence, as well as its consistency, are actually the main reasons of this subsection as a remainder that it needs to be considered during the development of the underlying microarchitecture, including the devices themselves via the use of atomic and fencing operations.
        ])
    )

#pagebreak()

///