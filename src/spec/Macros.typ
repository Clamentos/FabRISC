///
#import "@preview/tablex:0.0.5": tablex, colspanx, rowspanx

///
#let comment(body) = {

    linebreak()
    line(length: 100%, stroke: 0.5pt)
    emph(body)
    line(length: 100%, stroke: 0.5pt)
    linebreak()
}

///..
#let section(title, ..body) = {

    text(18pt)[#heading(level: 1, title)]
    linebreak()

    for text in body.pos() {
        
        par(text)
    }
}

///..
#let subSection(title, ..body) = {

    text(16pt)[#heading(level: 2, title)]
    linebreak()

    for text in body.pos() {
        
        par(text)
    }
}

///..
#let subSubSection(title, ..body) = {

    text(14pt)[#heading(level: 3, title)]
    linebreak()

    for text in body.pos() {
        
        par(text)
    }
}

///
