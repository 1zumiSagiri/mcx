# mcx.typ

A Typst package for typesetting randomized multiple-choice exams.

`mcx.typ` is an independent implementation for Typst.
It is inspired by the user-facing functionality of the LaTeX package [_mcexam_](https://ctan.org/pkg/mcexam), and is redesigned specifically for Typst’s typesetting and scripting model.

## Features

- Define multiple-choice questions and answers.
- Generate multiple versions of an exam with randomized question and answer order.
  - Options to control shuffling behavior: 
    - No shuffling.
    - Shuffle all questions and answers.
    - Shuffle only questions.
    - Shuffle questions while grouping related questions together.
    - Shuffle only answers.
        - Permute all answers.
        - Permute all but the last `n` answers (e.g., "None of the above").
        - No shuffling.
- Produce answer keys and concept sheets.
- Support for code blocks within questions and answers.
- `mc-gen-split-script()` Provides a Python script to split generated content into separate files or sections.

## Quick Start
Below is an example of how to use `mcx.typ` to create a simple multiple-choice exam with two questions, generate two versions of the exam, and produce an answer key and concept sheet.

<details>
<summary>Show code</summary>

```typst
#import "@preview/mcx:0.1.0": *

#let qs = (
  mc-question(
    [What is 2 + 3?],
    (
      mc-answer([3]),
      mc-answer([4]),
      mc-answer([5], mark: "correct"),
      mc-answer([22]),
    ),
    permute: "permuteall"
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
    permute: "permutenone"
  )
)

#mc-questions(qs, output: "exam", number-of-versions: 2, version: 2, seed: 5)

#mc-questions(qs, output: "exam", number-of-versions: 2, version: 1, seed: 5)

#mc-questions(qs, output: "key", number-of-versions: 2, seed: 5)

#mc-questions(qs, output: "concept", number-of-versions: 2, seed: 5)
```
</details>

See [`tests/example.typ`](https://github.com/1zumiSagiri/mcx/blob/master/tests/example.typ) for a complete example.

## Usage
Import the package using `#import "@preview/mcx:0.1.0": *`.

The full documentation is available in the [manual](https://github.com/1zumiSagiri/mcx/blob/master/docs/manual.pdf).
