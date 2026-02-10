// preamble.typ
#let preamble(
  name: "mcx",
  author: "1zumiSagiri",
  description: "A Typst package for typesetting randomized multiple-choice exams.",
  body
) = {
  set document(
    title: [#name User Manual],
    author: (author)
  )

  set page(
    header: context {
      if counter(page).get().first() > 1 [
        #name
      ]
    },
    margin: (top: 3cm, bottom: 2cm, x: 2.5cm)
  )

  set heading(numbering: "1.")
  show link: it => underline(text(fill: blue)[#it])
  show ref: it => text(fill: blue)[#it]

  block(width: 100%, height: 40%)[
    #set align(center)
    #text(size: 2.5em, weight: "bold")[#name] \
    #v(1em)
    #text(size: 1.2em)[#description]
    #v(2em)
    *Author:* #author
  ]

  show outline.entry.where(
    level: 1
  ): set block(above: 1.2em)

  outline()

  pagebreak()

  body
}