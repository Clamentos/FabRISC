///
#import "Macros.typ": *

///
#section(

    [Input Output],

    [This section is dedicated to the specification that FabRISC uses for communicating with external devices as well as other cores and hardware threads if present. The architecture defines IO mappings, potential DMA behavior and, in the next sections, OS support and inter-process communication schemes will be discussed.],

    ///.
    subSection(

        [Memory mapped IO],

        [FabRISC reserves a portion of the high memory address space to _memory mapped IO_. This region, which size depends on the IOLEN parameter of the system, is not cached and byte addressable in little-endian order. If a hart wants to transfer data to an IO device it can simply execute a memory operation to this region without further complications. The IO devices must map all of their IO related registers and state to this region in order to be accessible. Multiple channels or buses can potentially be employed to reduce the latency in case another transfers are already taking place as well as increasing the bandwidth. The area starts at address 0xFFF...F and grows upwards based on the IOLEN parameter.],

        [FabRISC provides a 4-bit ISA parameter called *Input Output size (IOS)* to indicate the size of the memory mapped IO region in bytes. The possible values are listed in the table below:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [0000], [$2^3$ bytes for 8-bit systems ($"WLEN" = 0$).],
            [0001], [$2^4$ bytes for 8-bit systems ($"WLEN" = 0$).],
            [0010], [$2^5$ bytes for 8-bit systems ($"WLEN" = 0$).],
            [0011], [$2^6$ bytes for 8-bit systems ($"WLEN" = 0$).],

            [0100], [$2^10$ bytes for 16-bit systems ($"WLEN" = 1$).],
            [0101], [$2^11$ bytes for 16-bit systems ($"WLEN" = 1$).],
            [0110], [$2^12$ bytes for 16-bit systems ($"WLEN" = 1$).],
            [0111], [$2^13$ bytes for 16-bit systems ($"WLEN" = 1$).],

            [1000], [$2^15$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
            [1001], [$2^16$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
            [1010], [$2^20$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
            [1011], [$2^24$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],

            [1100], [$2^32$ bytes for 64-bit systems ($"WLEN" = 3$).],
            [1101], [$2^34$ bytes for 64-bit systems ($"WLEN" = 3$).],
            [1110], [$2^36$ bytes for 64-bit systems ($"WLEN" = 3$).],
            [1111], [$2^40$ bytes for 64-bit systems ($"WLEN" = 3$).],
        )),

        comment([

            I decided to go with memory mapped IO because of its flexibility and simplicity compared to port based solutions. The IO region can be considered plain memory by the processor internally, which allows for advanced and fancy operations that use locks, barriers, fences and transactions to be done by multiple threads to the same device. Caching this region is not recommended because it can yield potential inconsistencies and unnecessary complexities with cache coherence. The idea here is to provide general purpose IO system that can be easily realized on any microarchitecture. The MMIO proposed is almost as easy as it gets and it should be good enough for most low to mid-speed transfers.

            The hardware designers can choose from a variety of different sizes for the MMIO space, ranging from the minuscule 8B suitable for a tiny 8-bit implementation, all the way to 1TB suitable for more advanced machines that also implement a full blown operative system.
        ])
    ),

    ///.
    subSection(

        [Direct memory access],

        [FabRISC provides the ability for IO devices to access any region of the main system memory directly without passing through the processor. A dedicated centralized controller serving as arbiter can be utilized to achieve this, but the hardware designers are free to choose any another alternative if considered appropriate. If this method of communication is chosen to be used, cache coherence must be ensured between the processor and the IO devices too. Some possible options can be, as discussed earlier:],

        list(tight: false,

            [*Non cacheable memory region:* _with this configuration coherence isn't a problem because no caching is performed by the CPU and the IO device in question. The region is fixed and resides outside of the MMIO address space but within the regular memory space. All DMA accesses must be made to that region._],

            [*Software IO coherence:* _with this configuration the CPU and the device are required to flush or invalidate the cache explicitly with no extra hardware complexity, however, this option requires the exposure of the underlying organization to the programmer._],

            [*Hardware IO coherence:* _with this configuration, both the CPU and the IO device, will monitor each other's accesses via a common bus or a directory system while proper actions are automatically taken according to a coherence protocol which can be the already existent one in the processor._]
        ),

        [The DMA protocol or scheme implemented by the hardware designer must also take consistency into account since memory operations to different addresses are allowed to be done out-of-order. This means that fencing instructions must retain their effect from the point of view of the hart and IO devices, in short, IO devices must provide similar fencing features as well.],

        [FabRISC provides a 2-bit ISA parameter called *DMA Mode (DMAMOD)* to indicate which solution the hardware exposes for DMA. If the system doesn't support any DMA capability, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in following table:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [00], [No DMA capabilities present.],
            [01], [Non cacheable memory region.],
            [10], [Software IO coherence.],
            [11], [Hardware IO coherence.],
        )),

        [FabRISC provides a 4-bit ISA parameter called *DMA Size (DMAS)* to indicate the size of the DMA region. If the DMAMOD parameter is not equal to one, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the following table:],

        align(center, table(

            columns: (10fr, 90fr),
            inset: 8pt,
            align: (x, y) => (center, left + horizon).at(x),
            stroke: 0.75pt,

            [#align(center, [*Code*])], [#align(center, [*Value*])],

            [0000], [$2^3$ bytes for 8-bit systems ($"WLEN" = 0$).],
            [0001], [$2^4$ bytes for 8-bit systems ($"WLEN" = 0$).],
            [0010], [$2^5$ bytes for 8-bit systems ($"WLEN" = 0$).],
            [0011], [$2^6$ bytes for 8-bit systems ($"WLEN" = 0$).],

            [0100], [$2^10$ bytes for 16-bit systems ($"WLEN" = 1$).],
            [0101], [$2^11$ bytes for 16-bit systems ($"WLEN" = 1$).],
            [0110], [$2^12$ bytes for 16-bit systems ($"WLEN" = 1$).],
            [0111], [$2^13$ bytes for 16-bit systems ($"WLEN" = 1$).],

            [1000], [$2^15$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
            [1001], [$2^16$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
            [1010], [$2^20$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],
            [1011], [$2^24$ bytes for 32 and 64-bit systems ($"WLEN" = 2, 3$).],

            [1100], [$2^32$ bytes for 64-bit systems ($"WLEN" = 3$).],
            [1101], [$2^34$ bytes for 64-bit systems ($"WLEN" = 3$).],
            [1110], [$2^36$ bytes for 64-bit systems ($"WLEN" = 3$).],
            [1111], [$2^40$ bytes for 64-bit systems ($"WLEN" = 3$).],
        )),

        comment([

            For more bandwidth demanding devices, DMA can be used to transfer data at very high speeds in the order of several Gb/s without interfering with the CPU (depending on how fast the memory is and if caching is allowed). This scheme however, is more complex than plain MMIO because of the special arbiter that handles and grants the requests. IO coherence, as well as its consistency, are actually the main reasons of this subsection as a remainder that it needs to be considered during the development of the underlying microarchitecture, including the devices themselves via the use of atomic and fencing operations.
        ])
    )
)

#pagebreak()

///
