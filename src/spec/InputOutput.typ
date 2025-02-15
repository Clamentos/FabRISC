///
#import "Macros.typ": *

///
#section(

    [Input-Output],

    [This section is dedicated to the specification that FabRISC uses for communicating with external devices and controllers as well as other harts if present.],

    ///.
    subSection(

        [Memory Mapped IO],

        [FabRISC reserves a portion of the high memory address space to memory mapped IO. This region, which size depends on the `IOS` parameter of the system, is not cached (not considered part of memory space) and byte addressable in little-endian order. If a hart wants to transfer data to an IO device it can simply execute memory operations to this region. The IO devices must map all of its IO related registers and state to this region in order to be accessible. The area starts at address `0xFFF`...`F` and grows upwards based on the `IOS` parameter.],

        [FabRISC provides the *Input Output size* (`IOS`) 4 bit ISA parameter, to indicate the size of the memory mapped IO region in bytes. The possible values are listed in the table below:],

        tableWrapper([Memory Mapped IO sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + top).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [ 0], [$2^3$ bytes for 8 bit systems ($"WLEN" = 0$).],
            [...], [...],
            [ 3], [$2^6$ bytes for 8 bit systems ($"WLEN" = 0$).],

            [ 4], [$2^10$ bytes for 16 bit systems ($"WLEN" = 1$).],
            [...], [...],
            [ 7], [$2^13$ bytes for 16 bit systems ($"WLEN" = 1$).],

            [ 8], [$2^15$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],
            [...], [...],
            [11], [$2^24$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],

            [12], [$2^32$ bytes for 64 bit systems ($"WLEN" = 3$).],
            [...], [...],
            [15], [$2^40$ bytes for 64 bit systems ($"WLEN" = 3$).],
        )),

        pagebreak(),
        comment([

            I decided to go with memory mapped IO because of its flexibility and simplicity compared to port based solutions. The IO region can be considered plain memory by the processor internally, which allows for advanced and fancy operations that use locks, barriers, fences and transactions to be done by multiple threads to the same device. The IO space should not be cached since it's considered separate from the actual memory one. 

            The idea here is to provide general purpose IO system that can be easily implemented on pretty much any microarchitecture. The MMIO proposed is basically as simple as it gets and it should be a good enough framework. Its flexibility makes possible to map internal CPU resources, such as configuration of any external controller, as well as the actual IO devices themselves.

            The hardware designers can choose from a variety of different sizes for the MMIO space, ranging from the minuscule 8 bytes suitable for tiny toy-like 8 bit implementations, all the way to 1 terabytes (definitely overkill) suitable for more advanced machines that also implement a full blown operating system.

            Memory mapped IO, along with port-based IO, is a "CPU centric" IO implementation, that is, the running code is what instructs the CPU to what and how to talk to the external world. This means that large and / or frequent transfers may significantly slowdown the CPU from completing its own tasks. In these cases, a more "passive" approach such as DMA would be better suited.
        ])
    ),

    ///.
    subSection(

        [Direct Memory Access],

        [FabRISC provides the ability for IO devices to access regions of the main system memory without interfering with the CPU. A dedicated centralized controller serving as the main interface may be utilized to achieve this, but the hardware designers are free to choose any another alternative considered appropriate. If this method of communication is chosen to be used, coherence must be ensured between the processor and the IO devices too. Some possible options can be:],

        list(tight: false,

            [*Non cacheable memory region:* _With this configuration coherence is guaranteed because no caching is performed by the CPU and the IO device in question. The region is fixed and must reside above the MMIO address space but within the regular memory space. All DMA accesses must be made to that region otherwise they are considered undefined behavior._],

            [*Software IO coherence:* _With this configuration the CPU and the device are required to flush or invalidate the cache explicitly with no extra hardware complexity. This option requires the exposure of the underlying organization to the programmer thus shifting a low level concern upwards._],

            [*Hardware IO coherence:* _With this configuration coherence is handled automatically by the hardware. In this case, there is no further partitioning of the address space._]
        ),

        [FabRISC provides the *DMA Mode* (`DMAMOD`) 2 bit ISA parameter, to indicate which solution the hardware exposes for DMA. If the system doesn't support any DMA capability, then this parameter must be set to zero for convention. The possible values are listed in following table:],

        tableWrapper([DMA modes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + top).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [0], [No DMA capabilities present.],
            [1], [Non cacheable memory region.],
            [2], [Software IO coherence.],
            [3], [Hardware IO coherence.],
        )),

        [FabRISC provides the *DMA Size* (`DMAS`) 4 bit ISA parameter, to indicate the size of the DMA region. If the `DMAMOD` parameter is not equal to one, then this parameter has no meaning and must be set to zero for convention. The possible values are listed in the following table:],

        tableWrapper([DMA Sizes.], table(

            columns: (auto, auto),
            align: (x, y) => (center, left + top).at(x),

            [#middle([*Code*])], [#middle([*Value*])],

            [ 0], [$2^3$ bytes for 8 bit systems ($"WLEN" = 0$).],
            [...], [...],
            [ 3], [$2^6$ bytes for 8 bit systems ($"WLEN" = 0$).],

            [ 4], [$2^10$ bytes for 16 bit systems ($"WLEN" = 1$).],
            [...], [...],
            [ 7], [$2^13$ bytes for 16 bit systems ($"WLEN" = 1$).],

            [ 8], [$2^15$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],
            [...], [...],
            [11], [$2^24$ bytes for 32 and 64 bit systems ($"WLEN" = 2, 3$).],

            [12], [$2^32$ bytes for 64 bit systems ($"WLEN" = 3$).],
            [...], [...],
            [15], [$2^40$ bytes for 64 bit systems ($"WLEN" = 3$).],
        )),

        [The final layout of the address space might resemble the graphic below. The "DMA Region" is part of the "Memory Region" more or less strictly depending on which DMA Mode is chosen.],

        align(center, grid(

            columns: (90pt, 150pt),
            rows: (150pt, 100pt, 80pt),
            gutter: 0pt,

            grid.cell(rowspan: 1, [`0x000000...0`]),
            rect(width: 100%, height: 100%, inset: 8pt)[#align(left, [*Memory Region*])],
            grid.cell(rowspan: 2, [#align(bottom, [`0xFFFFFF...F`])]),
            rect(width:100%, height: 100%, inset: 8pt, fill: rgb("#eaeaea"), stroke: 1pt)[#align(left, [*DMA Region* \ `DMAS` bytes, only when `DMAMOD = 1`.])],
            rect(width:100%, height: 100%, inset: 8pt, fill: rgb("#dadada"), stroke: 1pt)[#align(left, [*MMIO Region* \ `IOS` bytes. Outside of main system memory.])]
        )),

        comment([

            For more bandwidth demanding devices, such as external accelerators, DMA can be used to transfer data at very high speeds without interfering with the CPU. This scheme however, is more complex than plain MMIO because of the often required special arbiter that handles and grants the requests.

            FabRISC gives various high level options in how to implement DMA. The best choice for high-performance systems would be to have one or more DMA controllers embedded in the CPU that actively participate in cache coherence. This way, the full memory address space is available and coherent all under the same interface exposed by the CPU.
        ])
    )
)

#pagebreak()

///
