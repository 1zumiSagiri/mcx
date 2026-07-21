#import "@preview/mcx:0.4.0": *

#let qs = (
  mc-question(
    [
      What does this OCaml function do?

      ```ocaml
          let rec fib n =
              if n <= 1
                  then n
              else
                  fib (n - 1) + fib (n - 2)
      ```
    ],
    (
      mc-answer([Calculates the n-th Fibonacci number.], mark: "correct"),
      mc-answer([Calculates the factorial of n.]),
      mc-answer([Calculates the n-th prime number.]),
      mc-answer([Calculates the sum of the first n natural numbers.]),
    ),
    permute: "permuteall",
  ),
  mc-question(
    [
      Given function: $f(x) = x^3 - 2x^2 + 5x - 7$

      Calculate $f'(2)$.
    ],
    (
      mc-answer([$9$], mark: "correct"),
      mc-answer([$22$]),
      mc-answer([$5$]),
      mc-answer([$-7$]),
    ),
    permute: (type: "fixlastn", n: 2),
  )
)

#mc-questions(qs, output: "exam", number-of-versions: 2, version: 1, seed: 6)

#mc-questions(qs, output: "exam", number-of-versions: 2, version: 2, seed: 6)

#pagebreak()
#mc-questions(qs, output: "key", number-of-versions: 2, seed: 6)

#mc-questions(qs, output: "concept", number-of-versions: 2, seed: 6)