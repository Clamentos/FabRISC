///
// General configuration

#set page(paper: "a4", margin: (x: 2cm, y: 2cm))
#set text(font: "New Computer Modern", size: 12pt, hyphenate: true)
#set par(justify: true)

///
#linebreak()
#linebreak()
#align(center, image("../resources/LOGO-1.png", height: 25%))
#align(center, text(32pt)[Instruction Set Architecture])
#align(center, text(16pt)[Unprivileged specification])
#align(center, text(12pt)[Version 1.0])
#linebreak()
#align(center, text(16pt)[Enrico Gatto Monticone])
#align(center, text(12pt)[15/10/2023])
#align(right + bottom, image("../resources/LICENSE.png", height: 3%))
#pagebreak()

///
#outline(indent: true)
#pagebreak()

///
#set page(numbering: "1")
#set heading(numbering: "1.")
#set enum(indent: 0.5cm)

///
#include "Section1.typ"
#include "Section2.typ"
#include "Section3.typ"
#include "Section4.typ"
#include "Section5.typ"
#include "Section6.typ"
#include "Section7.typ"

///