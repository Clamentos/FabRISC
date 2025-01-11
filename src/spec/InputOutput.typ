///
#import "Macros.typ": *

///
#section(

    [Input-Output],

    [This section is dedicated to the specification that FabRISC uses for communicating with external devices as well as other cores and hardware threads if present. The architecture defines IO mappings, potential DMA behavior and, in the next sections, OS support and basic inter-process communication schemes will be discussed.],

    ///.
    subSection(

        [Memory Mapped IO],

        [FabRISC reserves a portion of the high memory address space to _Memory Mapped IO_. This region, which size depends on the `IOS` parameter of the system, is not cached (not considered part of memory space) and byte addressable in little-endian order. If a hart wants to transfer data to an IO device it can simply execute a memory operation to this region without further complications. The IO devices must map all of its IO related registers and state to this region in order to be accessible. Multiple channels or buses can potentially be employed to reduce the latency in case other transfers are already taking place as well as increasing the bandwidth. The area starts at address `0xFFF`...`F` and grows upwards based on the `IOS` parameter.],

        [FabRISC provides the *Input Output size* (`IOS`) 4 bit ISA parameter, to indicate the size of the memory mapped IO region in bytes. The possible values are listed in the table below:],

        tableWrapper([Memory Mapped IO sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [0000], [$2^3$ bytes for 8 bit systems ($"WLEN" = 0$).],
            [0001], [$2^4$ bytes for 8 bit systems ($"WLEN" = 0$).],
            [0010], [$2^5$ bytes for 8 bit systems ($"WLEN" = 0$).],
            [0011], [$2^6$ bytes for 8 bit systems ($"WLEN" = 0$).],

            [0100], [$2^10$ bytes for 16 bit systems ($"WLEN" = 1$).],
            [0101], [$2^11$ bytes for 16 bit systems ($"WLEN" = 1$).],
            [0110], [$2^12$ bytes for 16 bit systems ($"WLEN" = 1$).],
            [0111], [$2^13$ bytes for 16 bit systems ($"WLEN" = 1$).],

            [1000], [$2^15$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],
            [1001], [$2^16$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],
            [1010], [$2^20$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],
            [1011], [$2^24$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],

            [1100], [$2^32$ bytes for 64 bit systems ($"WLEN" = 3$).],
            [1101], [$2^34$ bytes for 64 bit systems ($"WLEN" = 3$).],
            [1110], [$2^36$ bytes for 64 bit systems ($"WLEN" = 3$).],
            [1111], [$2^40$ bytes for 64 bit systems ($"WLEN" = 3$).],
        )),

        comment([

            I decided to go with memory mapped IO because of its flexibility and simplicity compared to port based solutions. The IO region can be considered plain memory by the processor internally, which allows for advanced and fancy operations that use locks, barriers, fences and transactions to be done by multiple threads to the same device. The IO space should not be cached since it is considered a separate address space from the memory one. 

            The idea here is to provide general purpose IO system that can be easily implemented on pretty much any microarchitecture. The MMIO proposed is basically as simple as it gets and it should be good enough for most low to mid-speed transfers.

            The hardware designers can choose from a variety of different sizes for the MMIO space, ranging from the minuscule 8 bytes suitable for tiny toy-like 8 bit implementations, all the way to 1 terabytes suitable for more advanced machines that also implement a full blown operating system.
        ])
    ),

    ///.
    subSection(

        [Direct Memory Access],

        [FabRISC provides the ability for IO devices to access any region of the main system memory directly without passing through the CPU. A dedicated centralized controller serving as arbiter may be utilized to achieve this, but the hardware designers are free to choose any another alternative considered appropriate. If this method of communication is chosen to be used, cache coherence must be ensured between the processor and the IO devices too. Some possible options can be, as discussed earlier:],

        list(tight: false,

            [*Non cacheable memory region:* _With this configuration coherence isn't a problem because no caching is performed by the CPU and the IO device in question. The region is fixed and must reside above the MMIO address space but within the regular memory space. All DMA accesses must be made to that region otherwise they are considered undefined behavior._],

            [*Software IO coherence:* _With this configuration the CPU and the device are required to flush or invalidate the cache explicitly with no extra hardware complexity. This option requires the exposure of the underlying organization to the programmer thus shifting a low level concern upwards._],

            [*Hardware IO coherence:* _With this configuration, both the CPU and the IO device, will monitor each other's accesses via a common bus or a directory system while proper actions are automatically taken according to a common coherence protocol which can be the already existing one in the CPU, or an "ad-hoc" one._]
        ),

        [The DMA protocol or scheme implemented by the hardware designer must also take consistency into account since regular memory operations to different addresses are allowed to be done out-of-order. This means that fencing instructions must retain their effect from the point of view of the hart and IO devices. The IO devices must ultimately provide similar fencing features as well and behave as if they were any other hart.],

        [FabRISC provides the *DMA Mode* (`DMAMOD`) 2 bit ISA parameter, to indicate which solution the hardware exposes for DMA. If the system doesn't support any DMA capability, then this parameter must be set to zero for convention. The possible values are listed in following table:],

        tableWrapper([DMA modes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [00], [No DMA capabilities present.],
            [01], [Non cacheable memory region.],
            [10], [Software IO coherence.],
            [11], [Hardware IO coherence.],
        )),

        [FabRISC provides the *DMA Size* (`DMAS`) 4 bit ISA parameter, to indicate the size of the DMA region. If the `DMAMOD` parameter is not equal to one, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the following table:],

        tableWrapper([DMA Sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + horizon).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [0000], [$2^3$ bytes for 8 bit systems ($"WLEN" = 0$).],
            [0001], [$2^4$ bytes for 8 bit systems ($"WLEN" = 0$).],
            [0010], [$2^5$ bytes for 8 bit systems ($"WLEN" = 0$).],
            [0011], [$2^6$ bytes for 8 bit systems ($"WLEN" = 0$).],

            [0100], [$2^10$ bytes for 16 bit systems ($"WLEN" = 1$).],
            [0101], [$2^11$ bytes for 16 bit systems ($"WLEN" = 1$).],
            [0110], [$2^12$ bytes for 16 bit systems ($"WLEN" = 1$).],
            [0111], [$2^13$ bytes for 16 bit systems ($"WLEN" = 1$).],

            [1000], [$2^15$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],
            [1001], [$2^16$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],
            [1010], [$2^20$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],
            [1011], [$2^24$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],

            [1100], [$2^32$ bytes for 64 bit systems ($"WLEN" = 3$).],
            [1101], [$2^34$ bytes for 64 bit systems ($"WLEN" = 3$).],
            [1110], [$2^36$ bytes for 64 bit systems ($"WLEN" = 3$).],
            [1111], [$2^40$ bytes for 64 bit systems ($"WLEN" = 3$).],
        )),

        [The final layout of the address space might resemble the graphic below. The "DMA Region" is part of the "Memory Region" more or less strictly depending on which DMA Mode is chosen.],

        align(center, grid(

            columns: (90pt, 150pt),
            rows: (150pt, 100pt, 80pt),
            gutter: 0pt,

            grid.cell(rowspan: 1, [`0x000000...0`]),
            rect(width: 100%, height: 100%, inset: 8pt)[#align(left, [Memory Region.])],
            grid.cell(rowspan: 2, [#align(bottom, [`0xFFFFFF...F`])]),
            rect(width:100%, height: 100%, inset: 8pt, fill: rgb("#eaeaea"), stroke: 1pt)[#align(left, [DMA Region (`DMAS`) bytes, only when `DMAMOD = 1`. Not cacheable.])],
            rect(width:100%, height: 100%, inset: 8pt, fill: rgb("#dadada"), stroke: 1pt)[#align(left, [MMIO Region (`IOS`) bytes. Outside of main system memory.])]
        )),

        comment([

            For more bandwidth demanding devices, such as external accelerators, DMA can be used to transfer data at very high speeds in the order of several Gb/s without interfering with the CPU. This scheme however, is more complex than plain MMIO because of the often required special arbiter that handles and grants the requests.

            IO coherence, as well as its consistency, are actually the main reasons of this subsection as a remainder that it needs to be considered during the development of the underlying microarchitecture, including the devices themselves via the use of atomic and fencing operations. In essence the external IO devices can be considered as "CPU cores" from the point of view of coherence and consistency.
        ])
    )
)

#pagebreak()

///
