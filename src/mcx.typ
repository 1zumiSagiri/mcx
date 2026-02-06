// mcx.typ — A Typst package for typesetting multiple-choice exams. It is a Typst implementation inspired by the LaTeX package *mcexam*, redesigned for Typst's capabilities.
//
// Core features implemented:
// - Define multiple-choice questions with answers, correctness/points, explanations, notes.
// - Generate multiple deterministic versions via seed.
// - Randomize question blocks (respecting `follow`) and answer order (permute types).
//   - permute types: permuteall, fixlast, fixlastn, ordinal, permutenone, user-defined permutations.
// - Render different outputs: concept, exam, answers, key.
// - Render permutation tables and answer key tables.
//
// Minimum Typst version: 0.14 (required by suiji package).

#import "@preview/suiji:0.5.1": gen-rng-f, shuffle-f

// -------------------------
// Public data constructors
// -------------------------

/// Create an answer.
/// - `body`: content of the answer.
/// - `mark`: "correct" or a number (points). Use none for 0.
#let mc-answer(body, mark: none) = (
  body: body,
  mark: mark,
)

/// Create a question.
/// - `body`: content of the question.
/// - `answers`: array of answers made with `mc-answer`.
/// - `follow`: if true, this question stays in the same block as previous.
///             useful for reading comprehension sets where multiple questions
///             refer to the same text
/// - `permute`: controls the shuffling logic for choices.
///             | "permuteall" | "fixlast" | (type: "fixlastn", n: 2) | "ordinal"
///             | "permutenone" | (array of permutations).
///             A user permutation is an array of answer indices, e.g. (1,3,2,4).
///             Multiple permutations: ((1,2,3,4), (2,1,3,4), ...)
/// - `instruction`: optional content that appears *before* this question.
/// - `explanation`: optional explanation content that appears *in the concept* output.
/// - `notes`: optional notes content that appears *in the concept* output.
#let mc-question(
  body,
  answers,
  follow: false,
  permute: "permuteall",
  instruction: none,
  explanation: none,
  notes: none,
) = (
  body: body,
  answers: answers,
  follow: follow,
  permute: permute,
  instruction: instruction,
  explanation: explanation,
  notes: notes,
)

// -------------------------
// Defaults / configuration
// -------------------------

// Default configuration per output type
#let _defaults_by_output = (
  concept: (
    show_per_version: false,
    show_q_perm_table: true,
    show_q_list: true,
    show_correct: true,
    show_points: true,
    show_explanation: true,
    show_a_perm_table: true,
    show_notes: true,
    show_key_table: false,
    show_r_snippet: false,
  ),
  exam: (
    show_per_version: true,
    show_q_perm_table: false,
    show_q_list: true,
    show_correct: false,
    show_points: false,
    show_explanation: false,
    show_a_perm_table: false,
    show_notes: false,
    show_key_table: false,
    show_r_snippet: false,
  ),
  answers: (
    show_per_version: true,
    show_q_perm_table: false,
    show_q_list: true,
    show_correct: true,
    show_points: true,
    show_explanation: true,
    show_a_perm_table: false,
    show_notes: false,
    show_key_table: false,
    show_r_snippet: false,
  ),
  key: (
    show_per_version: false,
    show_q_perm_table: false,
    show_q_list: false,
    show_correct: false,
    show_points: false,
    show_explanation: false,
    show_a_perm_table: false,
    show_notes: false,
    show_key_table: true,
    show_r_snippet: false,
  ),
)

#let _cfg(output, config) = {
  // Configuration selector
  // Merges defaults with user config
  let base = _defaults_by_output.at(output)
  if config == none { base } else { base + config }
}

// -------------------------
// RNG helpers (deterministic)
// -------------------------

#let _rng_for(seed, version, salt) = {
  // Mix seed/version/salt into one integer seed.
  // Deterministic across compilations.
  let s = (seed * 1000003 + version * 10007 + salt * 97)
  gen-rng-f(s)
}

#let _shuffle(seed_rng, arr) = {
  // Returns (rng, shuffled-array)
  shuffle-f(seed_rng, arr)
}

// -------------------------
// Permutation computation
// -------------------------

#let _question_blocks(questions) = {
  // Respects `follow` flags, grouping questions into blocks so that
  // blocks can be shuffled as units.
  // Return blocks as array of arrays of original question indices (1-based).
  questions
    .enumerate()
    .fold((), (blocks, (i, q)) => {
      let q_idx = i + 1
      if blocks.len() > 0 and q.follow {
        // Append to last block
        let last = blocks.last()
        blocks.slice(0, -1) + (last + (q_idx,),)
      } else {
        // New block
        blocks + ((q_idx,),)
      }
    })
}

#let _permute_questions(questions, versions, seed, randomize) = {
  // Shuffle question blocks to produce per-version question orderings.
  let blocks = _question_blocks(questions)

  range(1, versions + 1).map(v => {
    if not randomize {
      // No randomization: return original order
      blocks.flatten()
    } else {
      // Generate RNG and shuffle blocks
      let rng = _rng_for(seed, v, 50)
      _shuffle(rng, blocks).at(1).flatten()
    }
  })
}

#let _normalize_user_perms(perms) = {
  // Ensure perms is array of arrays
  if perms.len() == 0 { perms } else if type(perms.at(0)) == array { perms } else { (perms,) }
}

#let _is_fixlastn(q) = {
  let p = q.permute
  (type(p) == str and p == "fixlast") or (type(p) == dictionary and p.at("type", default: "") == "fixlastn")
}

#let _permute_answers_for_question(q, versions, seed, randomize, display_index) = {
  // Handle the various permute types for a single question.
  let n = q.answers.len()
  let base = range(1, n + 1)

  // Helper: produce a per-version mapping display_pos -> original answer index.
  if not randomize { return range(1, versions + 1).map(_ => base) }

  let perm = q.permute

  let is_fix = _is_fixlastn(q)

  // fixlastn, fixlast (= fixlastn with n=1)
  if is_fix {
    // Determine n, clamped to [1, n]
    let num_fix = 1
    if type(perm) == dictionary {
      let user_n = perm.at("n", default: 1)
      num_fix = calc.clamp(int(user_n), 1, n)
    }

    return range(1, versions + 1).map(v => {
      if n <= num_fix { base } else {
        let rng = _rng_for(seed, v, 200 + display_index)
        // Shuffle only the first n - num_fix answers
        let front_indices = range(1, n - num_fix + 1)
        let (_, shuffled_front) = _shuffle(rng, front_indices)
        // Append the fixed last num_fix answers
        let fixed_back = range(n - num_fix + 1, n + 1)
        (..shuffled_front, ..fixed_back)
      }
    })
  }

  // permuteall
  if perm == none or perm == "permuteall" {
    return range(1, versions + 1).map(v => {
      let rng = _rng_for(seed, v, 100 + display_index)
      let (_, shuffled) = _shuffle(rng, base)
      shuffled
    })
  }

  // permutenone
  if perm == "permutenone" {
    return range(1, versions + 1).map(_ => base)
  }

  // ordinal: half of versions keep, half reverse, assignment shuffled
  if perm == "ordinal" {
    let tags = range(1, versions + 1).map(v => if calc.rem(v, 2) == 1 { "keep" } else { "rev" })
    let rng = _rng_for(seed, 1, 300 + display_index)
    let (_, tags2) = _shuffle(rng, tags)
    return range(1, versions + 1).map(v => {
      if tags2.at(v - 1) == "keep" { base } else { base.rev() }
    })
  }

  // user-defined permutations: array of arrays
  let perms = _normalize_user_perms(perm)
  let rng = _rng_for(seed, 1, 400 + display_index)
  let (_, perms2) = _shuffle(rng, perms)

  let p_len = perms2.len()
  if p_len == 0 { return range(1, versions + 1).map(_ => base) }
  return range(1, versions + 1).map(v => {
    let p = perms2.at(calc.rem(v - 1, p_len))
    let missing = base.filter(x => not p.contains(x))
    (..p, ..missing)
  })
}

#let _permute_answers(questions, versions, seed, randomize) = {
  // Shuffle answers per question to produce per-version answer orderings.
  // Returns answers_perm[v][q_original] = array display->original
  let q_count = questions.len()
  range(versions).map(v_idx => {
    let v = v_idx + 1
    range(q_count).map(q_idx => {
      _permute_answers_for_question(questions.at(q_idx), versions, seed, randomize, q_idx + 1).at(v_idx)
    })
  })
}

#let _build_maps(q_order_by_v) = {
  // For each version, map original question -> displayed number.
  q_order_by_v.map(order => {
    let pairs = order
      .enumerate()
      .map(((idx, orig_id)) => {
        (str(orig_id), idx + 1)
      })

    dictionary(pairs)
  })
}

// -------------------------
// Label helpers
// -------------------------

#let _roman(n) = numbering("I", n)
#let _qnum(n) = numbering("1", n)
#let _anum(n) = numbering("a", n)

#let _answer_label(n) = [ (#_anum(n)) ]
#let _answer_label_paren(n) = [ #text("(")#_anum(n)#text(")") ]

// -------------------------
// Conditional output helper
// -------------------------

#let mc-if(output, version, outputs: (), versions: none, body) = {
  // outputs: array of strings
  if outputs.contains(output) {
    if versions == none {
      return body
    } else if versions.contains(version) {
      return body
    } else {
      return none
    }
  } else {
    return none
  }
}

// -------------------------
// Rendering helpers
// -------------------------

#let _heading_for(output, version, cfg) = {
  // Version heading based on output type.
  if not cfg.show_per_version { return none }

  // Titles per output type
  let titles = (
    exam: "Version",
    answers: "Answers — Version",
    concept: "Concept version",
    key: "Answer Key — Version",
  )

  // Render heading based on output type
  let title_text = titles.at(output, default: "Version")
  heading(level: 1)[#title_text #_roman(version)]
}

#let _question_perm_table(questions, versions, q_order_by_v, cfg) = {
  // Question permutation table across versions.
  // If `show_q_perm_table` in config is false, returns none.
  if not cfg.show_q_perm_table { return none }

  // Build table
  // Columns: Question | → | Version I | Version II | ...
  let cols = 2 + versions
  let header = (
    [Question],
    [$arrow.r$],
    ..range(1, versions + 1).map(v => [#_roman(v)]),
  )

  let has_follow = questions.any(q => q.follow)

  let rows = range(1, questions.len() + 1).map(q_idx => {
    // Each row: original question number | → | displayed number in each version
    let q = questions.at(q_idx - 1)

    // Add `*` if question follows previous
    let star = if q.follow { "*" } else { "" }

    // Return one row as array
    (
      // Original question number
      [#star#numbering("1", q_idx)],
      [$arrow.r$],
      ..range(versions).map(v_idx => {
        let order = q_order_by_v.at(v_idx)
        // Find displayed position of original question q
        let disp = order.position(x => x == q_idx) + 1
        [#numbering("1", disp)]
      }),
    )
  })

  // Render table
  block[
    #set text(size: 9pt)
    *Question permutation table*
    #table(
      columns: cols,
      align: (left, center, ..range(versions).map(_ => center)),
      inset: 3pt,
      stroke: luma(170),
      ..header,
      ..rows.flatten(),
    )
  ]

  // Render follow note if needed
  if has_follow {
    text(size: 0.8em)[*:* Question follows previous]
  }
}

#let _answer_perm_table(questions, versions, answers_perm_by_v, q_id, cfg) = {
  if not cfg.show_a_perm_table { return none }
  let q = questions.at(q_id - 1)
  let n = q.answers.len()
  if n == 0 { return none }

  let is_fix = _is_fixlastn(q)

  let num_fix = if type(q.permute) == dictionary {
    q.permute.at("n", default: 1)
  } else { 1 }

  let desc_map = (
    permuteall: [*(All answers permuted)*],
    fixlastn: [*(All answers permuted, except last #num_fix #if num_fix > 1 [answers] else [answer])*],
    ordinal: [*(Order of answers permuted)*],
    permutenone: [*(No answers permuted)*],
  )

  let p_type = if q.permute == none { "permuteall" } else if is_fix { "fixlastn" } else if type(q.permute) == str {
    q.permute
  } else { "user" }
  let desc = desc_map.at(p_type, default: [*(Answers permuted by user)*])

  let rows = range(1, n + 1).map(a => (
    _answer_label_paren(a),
    [$arrow.r$],
    ..range(versions).map(v_idx => {
      let map = answers_perm_by_v.at(v_idx).at(q_id - 1)
      _answer_label_paren(map.at(a - 1))
    }),
  ))

  block[
    *Answer permutations:* #desc
    #table(
      columns: 2 + versions,
      align: (left, center, ..range(versions).map(_ => center)),
      inset: 3pt,
      stroke: luma(180),
      ..([Answer], [$arrow.r$], ..range(1, versions + 1).map(v => [#_roman(v)])),
      ..rows.flatten(),
    )
  ]
}



#let _key_table(questions, versions, q_order_by_v, answers_perm_by_v, cfg) = {
  if not cfg.show_key_table { return none }

  // Determine whether we have points or correctness
  let has_correct = questions.any(q => q.answers.any(a => a.mark == "correct"))
  let has_points = questions.any(q => q.answers.any(a => a.mark != none and a.mark != "correct"))
  if not has_correct and not has_points { return none }


  // Iterate over versions, building the answer key table
  // based on the projected display order and answer permutations.
  let header = ([Question], ..range(1, versions + 1).map(v => [#_roman(v)]))

  let data_cells = range(questions.len()).map(row_idx => {
    // First cell: question label
    let q_label = [#numbering("1", row_idx + 1)]

    // Generate the subsequent version columns for this row
    let v_columns = range(versions).map(v_idx => {
      let qid = q_order_by_v.at(v_idx).at(row_idx)
      let q = questions.at(qid - 1)
      let amap = answers_perm_by_v.at(v_idx).at(qid - 1)

      // Process correct answer labels
      let disp_labels = if has_correct {
        q
          .answers
          .enumerate()
          .filter(((i, a)) => a.mark == "correct")
          .map(((i, a)) => {
            let pos = amap.position(x => x == i + 1) + 1
            _answer_label_paren(pos)
          })
          .join(", ")
      } else { "" }

      // Process points information
      let points_info = if has_points {
        let pts = amap
          .enumerate()
          .map(((disp_pos, orig_idx)) => {
            let mark = q.answers.at(int(orig_idx) - 1).mark
            if mark != none and mark != "correct" {
              [#_answer_label_paren(disp_pos + 1): #mark#text(size: 0.6em)[pt]]
            }
          })
          .filter(it => it != none)

        if pts.len() > 0 { text(size: 0.8em, fill: gray)[#pts.join(", ")] } else { "" }
      } else { "" }

      // Combine into one cell
      let cell = (disp_labels, points_info).filter(it => it != "").join([\ ])
      if cell == "" { [—] } else { cell }
    })

    (q_label, ..v_columns)
  })

  block(breakable: false)[
    *Answer Key*
    #table(
      columns: 1 + versions,
      inset: 5pt,
      align: center,
      stroke: luma(200),
      fill: (x, y) => if y == 0 { luma(240) } else { white },
      ..header,
      ..data_cells.flatten(),
    )
  ]
}

#let _question_list(questions, version, versions, q_order_by_v, answers_perm_by_v, cfg, output) = {
  if not cfg.show_q_list { return none }

  // 1. Displayed order for this version
  let q_order = if cfg.show_per_version { q_order_by_v.at(version - 1) } else { range(1, questions.len() + 1) }

  // Build enum items and render a single question list.
  let items = q_order
    .enumerate()
    .map(((disp_idx_0, qid)) => {
      let disp_idx = disp_idx_0 + 1
      let q = questions.at(qid - 1)
      let amap = answers_perm_by_v.at(version - 1).at(qid - 1)

      let answer_enum = enum(
        numbering: n => _answer_label_paren(n),
        tight: true,
        ..amap.map(orig => block[#q.answers.at(int(orig) - 1).body]),
      )

      let info_items = ()

      if cfg.show_correct {
        let correct = q.answers.enumerate().filter(((i, a)) => a.mark == "correct").map(((i, a)) => i + 1)
        if correct.len() > 0 {
          let disp = correct.map(orig => amap.position(x => x == orig) + 1)
          info_items.push([*Correct answer(s):* #disp.map(d => _answer_label_paren(d)).join([, ])])
        }
      }

      // Points details
      if cfg.show_points and q.answers.any(a => a.mark != none) {
        let parts = amap
          .enumerate()
          .map(((d_idx, o_idx)) => {
            let m = q.answers.at(int(o_idx) - 1).mark
            let pts = if m == none { 0 } else if m == "correct" { 1 } else { m }
            [#_answer_label_paren(d_idx + 1) = #pts]
          })
        info_items.push([*Answer points:* #parts.join([, ])])
      }

      // Explanation, permutation table, notes
      if cfg.show_explanation and q.explanation != none { info_items.push([*Explanation:* #q.explanation]) }
      if cfg.show_a_perm_table { info_items.push(_answer_perm_table(questions, versions, answers_perm_by_v, qid, cfg)) }
      if cfg.show_notes and q.notes != none { info_items.push([*Notes:* #q.notes]) }

      let info_block = if info_items.len() > 0 {
        block(width: 100%, inset: (left: 0.5em), stroke: (left: 0.5pt + luma(200)))[
          #set text(size: 9pt)
          #set par(leading: 0.65em)
          #info_items.join([\ ])
        ]
      }

      // Assemble the final question item
      enum.item(disp_idx)[
        #{ if q.instruction != none { block(text(style: "italic", q.instruction)) } }
        #block(width: 100%)[#q.body]
        #block(inset: (left: 0.5em))[#answer_enum]
        #info_block
      ]
    })

  // Render one enumeration.
  enum(numbering: "1.", spacing: 1.5em, ..items)
}

// -------------------------
// Public entry point
// -------------------------

/// Render multiple-choice questions.
/// Parameters:
/// - `questions`: array of questions created with `mc-question`.
/// - `output`: "concept" | "exam" | "answers" | "key".
/// - `number_of_versions`: total number of versions.
/// - `version`: selected version (used when output wants per-version output).
/// - `seed`: positive integer controlling deterministic randomization.
/// - `randomize_questions`: shuffle question blocks.
/// - `randomize_answers`: shuffle answers according to `permute`.
/// - `config`: dictionary overriding defaults (any of the cfg keys).
#let mc-questions(
  questions,
  output: "exam",
  number_of_versions: 4,
  version: 1,
  seed: 1,
  randomize_questions: true,
  randomize_answers: true,
  config: none,
) = {
  let cfg = _cfg(output, config)

  // Clamp version
  let v = calc.clamp(version, 1, number_of_versions)

  // Compute permutations
  let q_order_by_v = _permute_questions(questions, number_of_versions, seed, randomize_questions)
  let answers_perm_by_v = _permute_answers(questions, number_of_versions, seed, randomize_answers)

  // Render
  let parts = ()

  // Version heading (if enabled)
  parts = (..parts, _heading_for(output, v, cfg))

  // Question permutation table
  parts = (..parts, _question_perm_table(questions, number_of_versions, q_order_by_v, cfg))

  // Question list and embedded per-question details
  // In non-per-version outputs (such as concept), we render version 1 ordering by default.
  let use_v = if cfg.show_per_version { v } else { 1 }
  parts = (
    ..parts,
    _question_list(
      questions,
      use_v,
      number_of_versions,
      q_order_by_v,
      answers_perm_by_v,
      cfg,
      output,
    ),
  )

  // Key table
  parts = (..parts, _key_table(questions, number_of_versions, q_order_by_v, answers_perm_by_v, cfg))

  parts.filter(it => it != none).join()
}

