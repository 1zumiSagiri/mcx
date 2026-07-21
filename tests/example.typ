#import "@preview/mcx:0.4.0": *

#let output = sys.inputs.at("output", default: "exam")
#let num_vers = int(sys.inputs.at("number-of-versions", default: "4"))
#let ver = int(sys.inputs.at("version", default: "1"))
#let seed = int(sys.inputs.at("seed", default: "5"))

#let style = (
  font-size: 11pt,
  v-numbering: "1",
  line-spacing: 0.65em,
  margin: (top: 1in, bottom: 1in, left: 1in, right: 1in),
)

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
      mc-answer([`let x = 1 * 2 * 3 in x`]),
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
  mc-question(
    [
      Hrothgar, king of the Danes, or Scyldings, builds a great mead-hall, or palace, in which he hopes to feast his liegemen and to give them presents. The joy of king and retainers is, however, of short duration. Grendel, the monster, is seized with hateful jealousy. He cannot brook the sounds of joyance that reach him down in his fen-dwelling near the hall. Oft and anon he goes to the joyous building, bent on direful mischief. Thane after thane is ruthlessly carried off and devoured, while no one is found strong enough and bold enough to cope with the monster. For twelve years he persecutes Hrothgar and his vassals.

      Over sea, a day's voyage off, Beowulf, of the Geats, nephew of Higelac, king of the Geats, hears of Grendel's doings and of Hrothgar's misery. He resolves to crush the fell monster and relieve the aged king. With fourteen chosen companions, he sets sail for Dane-land. Reaching that country, he soon persuades Hrothgar of his ability to help him. The hours that elapse before night are spent in beer-drinking and conversation. When Hrothgar's bedtime comes he leaves the hall in charge of Beowulf, telling him that never before has he given to another the absolute wardship of his palace. All retire to rest, Beowulf, as it were, sleeping upon his arms.

      Grendel comes, the great march-stepper, bearing God's anger. He seizes and kills one of the sleeping warriors. Then he advances towards Beowulf. A fierce and desperate hand-to-hand struggle ensues. No arms are used, both combatants trusting to strength and hand-grip. Beowulf tears Grendel's shoulder from its socket, and the monster retreats to his den, howling and yelling with agony and fury. The wound is fatal.

      The next morning, at early dawn, warriors in numbers flock to the hall Heorot, to hear the news. Joy is boundless. Glee runs high. Hrothgar and his retainers are lavish of gratitude and of gifts.

      Grendel's mother, however, comes the next night to avenge his death. She is furious and raging. While Beowulf is sleeping in a room somewhat apart from the quarters of the other warriors, she seizes one of Hrothgar's favorite counsellors, and carries him off and devours him. Beowulf is called. Determined to leave Heorot entirely purified, he arms himself, and goes down to look for the female monster. After traveling through the waters many hours, he meets her near the sea-bottom. She drags him to her den. There he sees Grendel lying dead. After a desperate and almost fatal struggle with the woman, he slays her, and swims upward in triumph, taking with him Grendel's head.
      Joy is renewed at Heorot. Congratulations crowd upon the victor. Hrothgar literally pours treasures into the lap of Beowulf; and it is agreed among the vassals of the king that Beowulf will be their next liegelord.

      Beowulf leaves Dane-land. Hrothgar weeps and laments at his departure.

      When the hero arrives in his own land, Higelac treats him as a distinguished guest. He is the hero of the hour.

      Beowulf subsequently becomes king of his own people, the Geats. After he has been ruling for fifty years, his own neighborhood is wofully harried by a fire-spewing dragon. Beowulf determines to kill him. In the ensuing struggle both Beowulf and the dragon are slain. The grief of the Geats is inexpressible. They determine, however, to leave nothing undone to honor the memory of their lord. A great funeral-pyre is built, and his body is burnt. Then a memorial-barrow is made, visible from a great distance, that sailors afar may be constantly reminded of the prowess of the national hero of Geatland.

      The poem closes with a glowing tribute to his bravery, his gentleness, his goodness of heart, and his generosity.

      Question: Who is the hero of the poem?
    ],
    (
      mc-answer([Beowulf], mark: "correct"),
      mc-answer([Hrothgar]),
      mc-answer([Grendel]),
      mc-answer([Grendel's mother]),
    ),
    q-breakable: true,
  ),
)

#mc-questions(
  qs,
  output: "exam",
  number-of-versions: num_vers,
  version: 1,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "exam",
  number-of-versions: num_vers,
  version: 2,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "exam",
  number-of-versions: num_vers,
  version: 3,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "exam",
  number-of-versions: num_vers,
  version: 4,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "key",
  number-of-versions: num_vers,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "concept",
  number-of-versions: num_vers,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "answers",
  number-of-versions: num_vers,
  version: 1,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "answers",
  number-of-versions: num_vers,
  version: 2,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "answers",
  number-of-versions: num_vers,
  version: 3,
  seed: seed,
  style: style,
)

#pagebreak()
#mc-questions(
  qs,
  output: "answers",
  number-of-versions: num_vers,
  version: 4,
  seed: seed,
  style: style,
)

// Note:
// The above code generates multiple versions of an exam, answer key, concept explanations, and answer lists based on a set of multiple-choice questions.
// The following command is a placeholder for the actual script that would be used to split the generated content into separate files or sections based on the metadata specified in the versions and output types.
#pagebreak()
#mc-gen-split-script(filename: "example.typ")
