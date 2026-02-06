> [!WARNING]
> Still a work in progress

> [!NOTE]
>
> Todo:
> - Fix metadata for file splitting (currently unable to insert <version_marker>).
> - Documentation.

# mcx.typ

A Typst package for typesetting randomized multiple-choice exams.

`mcx.typ` is an independent implementation for Typst.
It is inspired by the user-facing functionality of the LaTeX package _mcexam_, and is redesigned specifically for Typst’s typesetting and scripting model.

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
See [`tests/example.typ`](tests/example.typ) for a complete example.
