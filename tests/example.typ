#import "@preview/mcx:0.1.0": *

#let output = sys.inputs.at("output", default: "exam")
#let num_vers = int(sys.inputs.at("number-of-versions", default: "4"))
#let ver = int(sys.inputs.at("version", default: "1"))
#let seed = int(sys.inputs.at("seed", default: "5"))

#let qs = (
  mc-question(
    [What is 2 + 2?],
    (
      mc-answer([3]),
      mc-answer([4], mark: "correct"),
      mc-answer([5]),
      mc-answer([22]),
    ),
    instruction: [The following three questions form a block.],
    permute: (type: "fixlastn", n: 1),
    explanation: [2 + 2 = 4.],
    notes: [Note 1.],
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
    follow: true,
    explanation: [2 + 3 = 5.],
    notes: [Note 2.],
  ),
  mc-question(
    [What is 2 + 4?],
    (
      mc-answer([3]),
      mc-answer([4]),
      mc-answer([5]),
      mc-answer([6], mark: "correct"),
    ),
    permute: (type: "fixlastn", n: 2),
    follow: true,
  ),
  mc-question(
    [Pick the prime numbers.],
    (
      mc-answer([2], mark: "correct"),
      mc-answer([4]),
      mc-answer([5], mark: "correct"),
      mc-answer([9]),
    ),
    permute: "permutenone",
  ),
  mc-question(
    [
      What does this OCaml function do?

      ```ocaml
          let rec fact n =
              if n = 0
                  then 1
              else
                  n * fact (n - 1)
      ```
    ],
    (
      mc-answer([It computes the factorial of a number.], mark: "correct"),
      mc-answer([It computes the Fibonacci sequence.]),
      mc-answer([It sorts a list of numbers.]),
      mc-answer(`let x = 1 * 2 * 3 in x`),
      mc-answer([It reverses a string.]),
      mc-answer([It reverses two strings.]),
      mc-answer([It reverses three strings.]),
    ),
    permute: (type: "fixlastn", n: 3),
    explanation: [This function recursively computes the factorial of a given number n.],
  ),
  mc-question(
    [Which of the following is not a recursive function?],
    (
      mc-answer([
        ```ocaml
            let rec fib n =
                if n <= 1
                    then n
                else
                    fib (n - 1) + fib (n - 2)
        ```
      ]),
      mc-answer([
        ```cpp
            int factorial(int n) {
                if (n == 0) {
                    return 1;
                } else {
                    return n * factorial(n - 1);
                }
            }
        ```
      ]),
      mc-answer(
        [
          ```hs
              revList :: [a] -> [a]
              revList [] = []
              revList (x : xs) = revList xs ++ [x]
          ```
        ],
      ),
      mc-answer(
        [
          ```go
              func sum(n int) int {
                  if n == 0 {
                      return 0
                  }
                  return n + sum(n - 1)
              }
          ```
        ],
      ),
      mc-answer(
        [
          ```rs
              fn factorial(n: u32) -> u32 {
                  for i in 1..=n {
                      result *= i;
                  }
                  result
              }
          ```
        ],
        mark: "correct",
      ),
    ),
    permute: "permuteall",
    explanation: [The Rust function uses an iterative approach with a for loop, rather than recursion.],
  ),
  mc-question(
    [
      Given function: $f(x) = x^3 - 2x^2 + 5x - 7$

      Calculate $f'(2)$.

      Hint: $ f'(x) = frac(d, d x)(x^3 - 2x^2 + 5x - 7) $
    ],
    (
      mc-answer([$9$], mark: "correct"),
      mc-answer([$22$]),
      mc-answer([$5$]),
      mc-answer([$-7$]),
    ),
    permute: "ordinal",
    explanation: [
      The derivative is $f'(x) = 3x^2 - 4x + 5$. Evaluating at $x = 2$ gives $f'(2) = 3(2^2) - 4(2) + 5 = 12 - 8 + 5 = 9$.
    ],
  ),
  mc-question(
    [誰が『神奈川沖浪裏』の作者ですか？],
    (
      mc-answer([葛飾北斎], mark: "correct"),
      mc-answer([レオナルド・ダ・ヴィンチ]),
      mc-answer([ピカソ]),
      mc-answer([歌川広重]),
    ),
    permute: ((2, 1, 3, 4), (3, 2, 1, 4)),
    explanation: [『神奈川沖浪裏』は葛飾北斎によって描かれました。],
    notes: [この問題は日本語で書かれています],
  ),
)

#mc-questions(
  qs,
  output: "exam",
  number-of-versions: num_vers,
  version: 1,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "exam",
  number-of-versions: num_vers,
  version: 2,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "exam",
  number-of-versions: num_vers,
  version: 3,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "exam",
  number-of-versions: num_vers,
  version: 4,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "key",
  number-of-versions: num_vers,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "concept",
  number-of-versions: num_vers,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "answers",
  number-of-versions: num_vers,
  version: 1,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "answers",
  number-of-versions: num_vers,
  version: 2,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "answers",
  number-of-versions: num_vers,
  version: 3,
  seed: seed,
)

#pagebreak()
#mc-questions(
  qs,
  output: "answers",
  number-of-versions: num_vers,
  version: 4,
  seed: seed,
)

// Note:
// The above code generates multiple versions of an exam, answer key, concept explanations, and answer lists based on a set of multiple-choice questions.
// The following command is a placeholder for the actual script that would be used to split the generated content into separate files or sections based on the metadata specified in the versions and output types.
#pagebreak()
#mc-gen-split-script(filename: "example.typ")
