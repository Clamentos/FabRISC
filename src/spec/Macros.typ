///
#import "@preview/tablex:0.0.5": tablex, colspanx, rowspanx

///
#let comment(body) = {

    v(10pt)
    line(length: 100%, stroke: 0.5pt)
    emph(body)
    line(length: 100%, stroke: 0.5pt)
    v(10pt)
}

///..
#let section(title, ..body) = {

    text(18pt)[#heading(level: 1, title)]
    v(14pt)

    for text in body.pos() { par(text) }
}

///..
#let subSection(title, ..body) = {

    text(16pt)[#heading(level: 2, title)]
    v(12pt)

    for text in body.pos() { par(text) }
}

///..
#let subSubSection(title, ..body) = {

    text(14pt)[#heading(level: 3, title)]
    v(10pt)

    for text in body.pos() { par(text) }
}

///..
#let tableWrapper(tableCaption, table) = {

    v(10pt)
    align(center, figure(table, caption: tableCaption))
    v(10pt)
}

///..
#let textWrap(..body) = {

    for text in body.pos() { par(text) }
}

///..
#let monospace(text) = {

    $mono(text)$
}

///..
#let middle(text) = {

    align(center, text)
}

///
