> [!WARNING]
> Still a work in progress

> [!IMPORTANT]
> TODO:
>
> - Enable code blocks inside questions and answers.
> - Generate Python scripts for exam splitting.

# mcx.typ

A Typst package for typesetting multiple-choice exams.

This package is an independent implementation for Typst.
It is inspired by the user-facing functionality of the LaTeX package _mcexam_, and is redesigned specifically for Typst’s typesetting and scripting model.

## Features

- Define multiple-choice questions and answers.
- Generate multiple versions of an exam with randomized question and answer order.
  - Options to control shuffling behavior: 
    - No shuffling.
    - Shuffle all questions and answers.
    - Shuffle only questions.
    - Shuffle only answers.
        - Permute all answers.
        - Permute all but the last `n` answers (e.g., "None of the above").
        - No shuffling.
- Produce answer keys and concept sheets.
- Support for code blocks within questions and answers.
