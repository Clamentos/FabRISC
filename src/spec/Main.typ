///
#import "Macros.typ": *

///
// General configuration.

#set page(paper: "a4", margin: (x: 2cm, y: 2cm))
#set text(font: "New Computer Modern", size: 12pt, hyphenate: true)
#set par(justify: true)

#set table(stroke: 0.75pt, inset: 8pt, fill: (_, y) => if(calc.rem(y, 2) == 0) { rgb("#eaeaea") })
#set table.cell(breakable: false)

#set figure.caption(position: top)
#show figure: set block(breakable: true)
#show figure.caption: emph

///
// Front page.

#align(center, image("../resources/LOGO-1.png", height: 25%))
#align(center, text(32pt)[Instruction Set Architecture])
#align(center, text(12pt)[Specification version 1.0])
#align(center, text(12pt)[Document version 1.0.0])

#linebreak()

#align(center, text(16pt)[Enrico Gatto Monticone])
#align(center, text(14pt)[08/02/2025])

#linebreak()

#align(left + bottom, text(12pt)[

    FabRISC is licensed under a
    Creative Commons Attribution-ShareAlike 4.0 International License.

    You should have received a copy of the license along with this
    work. If not, see #monospace(link("https://creativecommons.org/licenses/by-sa/4.0/")).
])

#align(right + bottom, image("../resources/LICENSE.png", height: 3%))
#pagebreak()

///
// Contents.

#outline(indent: true)
#outline(title: [Tables], target: figure.where(kind: table), indent: true)
#pagebreak()

///
#set page(numbering: "1")
#set heading(numbering: "1.")
#set enum(indent: 0.5cm)

///
// Actual content.

#include "Introduction.typ"
#include "IsaCompatibility.typ"
#include "LowLevelDataTypes.typ"
#include "RegisterFileOrganization.typ"
#include "Memory.typ"
#include "InputOutput.typ"
#include "Events.typ"
#include "InstructionFormats.typ"
#include "InstructionList.typ"
#include "License.typ"

///
