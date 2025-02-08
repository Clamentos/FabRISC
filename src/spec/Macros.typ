///
#import "@preview/tablex:0.0.5": tablex, colspanx, rowspanx;
#import "@preview/cetz:0.3.0";

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

///..
// Author: martandrMC (https://github.com/martandrMC)

#let ifmt(name: "", ..fields) = {
    let bits = fields.pos().map(f => f.bits).sum()
    assert(bits <= 48)

    cetz.canvas(length: 95% / 48, {
        import cetz.draw: *
        let count = 0
        let idx = 0
        let total = fields.pos().map(x => x.bits).sum()
        if(name != "") {content((
            0,1), anchor: "east", padding: 0.1,
            text(size: 10pt)[#name]
        )}
        while count < bits {
            let f = fields.pos().at(idx)
            rect(
                (count, 0), (count + f.bits, 2),
                stroke: 0.2mm + black,
                fill: f.at("color", default: white)
            )
            content(
                (count + f.bits/2, 1),
                text(f.at("label", default: "-"))
            )
            content(
                (count + f.bits - 0.5 , 2.50),
                text[#{total - count - f.bits}]
            )
            if f.bits > 1 {content(
                (count + 0.5 , 2.50),
                text[#{total - count - 1}]
            )}

            for i in range(count + 1, count + f.bits) {
                line((i,0), (i,0.2), stroke: 0.2mm + black)
                line((i,1.8), (i,2), stroke: 0.2mm + black)
            }
            idx = idx + 1
            count = count + f.bits
        }
    })
}

///
