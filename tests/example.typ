#import "../src/mcx.typ": *

#let code(lang, code) = raw(
  language: lang,
  block: true,
)[code]

#let qs = (
  mc-question(
    [What is 2 + 2?],
    (
      mc-answer([3]),
      mc-answer([4], mark: "correct"),
      mc-answer([5]),
      mc-answer([22]),
    ),
    permute: (type: "fixlastn", n: 1),
    explanation: [2 + 2 = 4.],
    notes: [Classic warm-up.],
  ),
  mc-question(
    [What is 2 + 3?],
    (
      mc-answer([3]),
      mc-answer([4]),
      mc-answer([5], mark: "correct"),
      mc-answer([22]),
    ),
    permute: "fixlast",
    explanation: [2 + 3 = 5.],
    notes: [Classic warm-up.],
  ),
  mc-question(
    [Pick the prime numbers.],
    (
      mc-answer([2], mark: "correct"),
      mc-answer([4]),
      mc-answer([5], mark: "correct"),
      mc-answer([9]),
    ),
    follow: false,
    permute: "permuteall",
  ),
  mc-question(
    [
      What does this OCaml function do?

      // #code(
      //   "ocaml",
      //   "
      //     let rec fact n =
      //         if n = 0
      //             then 1
      //         else
      //             n * fact (n - 1)
      // ",
      // )
    ],
    (
      mc-answer([It computes the factorial of a number.], mark: "correct"),
      mc-answer([It computes the Fibonacci sequence.]),
      mc-answer([It sorts a list of numbers.]),
      mc-answer([It reverses a string.]),
      mc-answer([It reverses two strings.]),
      mc-answer([It reverses three strings.]),
      //   mc-answer(#ocaml["let x = 1 + 3"]),
    ),
    permute: (type: "fixlastn", n: 2),
    explanation: [This function recursively computes the factorial of a given number n.],
  ),
)

#mc-questions(qs, output: "exam", number_of_versions: 4, version: 4, seed: 41)

#mc-questions(qs, output: "exam", number_of_versions: 4, version: 3, seed: 41)

#mc-questions(qs, output: "exam", number_of_versions: 4, version: 2, seed: 41)

#mc-questions(qs, output: "exam", number_of_versions: 4, version: 1, seed: 41)

#pagebreak()
#mc-questions(qs, output: "key", number_of_versions: 4, seed: 41)

#pagebreak()
#mc-questions(qs, output: "concept", number_of_versions: 4, seed: 41)
