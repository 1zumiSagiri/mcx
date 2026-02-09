// preamble.typ
#let preamble(
  name: "mcx",
  author: "1zumiSagiri",
  version: "0.1.1",
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

  block(width: 100%, height: 80%)[
    #set align(center + horizon)
    #text(size: 2.5em, weight: "bold")[#name] \
    #v(1em)
    #text(size: 1.2em)[#description]
    #v(2em)
    *Author:* #author \
    *Version:* #version
  ]
  
  pagebreak()

  body
}