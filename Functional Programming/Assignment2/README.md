# Assignment 2

To solve the assignment, please copy the file `Assignment2-Template.hs` to a new file called `Assignment2.hs` and write your solutions in `Assignment2.hs`.

**Don't change the header of this file, _including the module declaration_, and, moreover, _don't_ change the
type signature of any of the given functions for you to complete.**

Run the pre-submit script to check for any (compilation) errors **before** submitting by running in the vLab terminal:
  ```bash
  $ ./presubmit.sh Assignment2
  ```

If this fails, you are not ready to submit, and any submission that doesn't pass the presubmit test on vLab is not eligible for marking.

Submit your file `Assignment2.hs` via Canvas.

## Morse code

International [Morse code](https://en.wikipedia.org/wiki/Morse_code#Representation,_timing,_and_speeds) is composed of five elements:

  * short mark, dot or "dit" (·) -- one unit long;
  * longer mark, dash or "dah" (-) -- three units long;
  * inter-element gap between the dots and dashes within a character -- one unit long;
  * short gap (between letters) -- three units long;
  * medium gap (between words) -- seven units long.

We represent a Morse code unit, called "atom" from now on, as either a beep or silence:
```haskell
data Atom = Beep | Silence deriving (Eq, Show)
```
Then Morse code can be represented by a list of these atoms:
```haskell
type Code = [Atom]
```
Now we can write constants for a short mark "·" (`dit`), a long mark "-" (`dah`), a gap between letters (`shortGap`) and a gap between words (`mediumGap`):
```haskell
dit, dah, shortGap, mediumGap :: Code
dit       = [Beep, Silence]
dah       = [Beep, Beep, Beep, Silence]
shortGap  = replicate (3-1) Silence
mediumGap = replicate (7-1) Silence
```
Note that the length of `shortGap` and `mediumGap` are made so that a
`shortGap` has the correct length 3 if following a `dit` or `dah` and
a `mediumGap` has length 7 if following a `dit` or `dah`. 
This is because `dit` and `dah` each end in a `Silence` by definition. 

We can code symbols as follows
```haskell
morseCode :: Char -> Code
morseCode 'A' = dit ++ dah
morseCode 'B' = dah ++ dit ++ dit ++ dit
morseCode 'C' = dah ++ dit ++ dah ++ dit
morseCode 'D' = dah ++ dit ++ dit
morseCode 'E' = dit
morseCode 'F' = dit ++ dit ++ dah ++ dit
morseCode 'G' = dah ++ dah ++ dit
morseCode 'H' = dit ++ dit ++ dit ++ dit
morseCode 'I' = dit ++ dit
morseCode 'J' = dit ++ dah ++ dah ++ dah
morseCode 'K' = dah ++ dit ++ dah
morseCode 'L' = dit ++ dah ++ dit ++ dit
morseCode 'M' = dah ++ dah
morseCode 'N' = dah ++ dit
morseCode 'O' = dah ++ dah ++ dah
morseCode 'P' = dit ++ dah ++ dah ++ dit
morseCode 'Q' = dah ++ dah ++ dit ++ dah
morseCode 'R' = dit ++ dah ++ dit
morseCode 'S' = dit ++ dit ++ dit
morseCode 'T' = dah
morseCode 'U' = dit ++ dit ++ dah
morseCode 'V' = dit ++ dit ++ dit ++ dah
morseCode 'W' = dit ++ dah ++ dah
morseCode 'X' = dah ++ dit ++ dit ++ dah
morseCode 'Y' = dah ++ dit ++ dah ++ dah
morseCode 'Z' = dah ++ dah ++ dit ++ dit
morseCode '1' = dit ++ dah ++ dah ++ dah ++ dah
morseCode '2' = dit ++ dit ++ dah ++ dah ++ dah
morseCode '3' = dit ++ dit ++ dit ++ dah ++ dah
morseCode '4' = dit ++ dit ++ dit ++ dit ++ dah
morseCode '5' = dit ++ dit ++ dit ++ dit ++ dit
morseCode '6' = dah ++ dit ++ dit ++ dit ++ dit
morseCode '7' = dah ++ dah ++ dit ++ dit ++ dit
morseCode '8' = dah ++ dah ++ dah ++ dit ++ dit
morseCode '9' = dah ++ dah ++ dah ++ dah ++ dit
morseCode '0' = dah ++ dah ++ dah ++ dah ++ dah
morseCode  _  = undefined -- Avoid warnings
```

We can represent the function `morseTable` by the following lookup table:
```haskell
type Table = [(Char, Code)]

morseTable :: Table
morseTable = [ (c , morseCode c) | c <- ['A'..'Z']++['0'..'9'] ]
```

**Remark:** We can get the function `morseCode` from the table using
```hs
lookup :: Eq a => a -> [(a, b)] -> Maybe b
```
from the prelude.

**Remark:** The above datatypes, constants, `morseCode` and `morseTable` are all
available in `Types.hs`. Do **not** change this file.

## Exercises

You may wish to use your own helper functions.

### Exercise 1: Encode using a table (18 marks)

In the following parts of this exercise, the functions should work with any
table, including `morseTable` but not only `morseTable`. You can use `morseTable`
for testing your solution for correctness.

1. Write a function

   ```haskell
   encodeWord :: Table -> String -> Code
   ```

   that, given _any_ table and a string with a **single** word in it, produces
   the code for that word. **The resulting code should have a `shortGap` after
   every character that is not the last**.

   Note that `encodeWord` should work for **any** table, not just
   `morseTable`.

	Examples:
	```hs
	encodeWord morseTable "" = []
	encodeWord morseTable "A" = [Beep,Silence,Beep,Beep,Beep,Silence]
	encodeWord morseTable "0" = [Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence]
    encodeWord morseTable "HELLO" = [Beep,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence]
    encodeWord morseTable "WORLD" = [Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Beep,Silence]
	```

2. Write a function

   ```haskell
   encodeWords :: Table -> [String] -> Code
   ```
   that, given _any_ table and a list of strings, encodes each string of the
   list, puts a `mediumGap` after every word that is not the last, and concatenates the results.

   As above, this function should work for **any** table, not just
   `morseTable`.

   Examples:
   ```hs
   encodeWords morseTable [] = []
   encodeWords morseTable ["007"] = [Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Beep,Silence,Beep,Silence]
   encodeWords morseTable ["HI","THERE"] = [Beep,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Silence,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence]
   ```

3. Write a function

   ```haskell
   encodeText :: Table -> String -> Code
   ```
   that, given _any_ table and some string of words separated by spaces, encodes the text.
   **Spaces should become `mediumGap`s**.

   You may assume that the text consists only of single spaces and `['A'..'Z']++['0'..'9']` otherwise, and that the spaces do not occur at the end.

   Examples:
   ```hs
   encodeText morseTable "WORD" = [Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Beep,Silence]
   encodeText morseTable "HI THERE" = [Beep,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Silence,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence]
   encodeText morseTable "THIS IS A TEST" = [Beep,Beep,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Silence,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Silence,Silence,Silence,Silence,Beep,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Silence,Silence,Silence,Silence,Beep,Beep,Beep,Silence,Silence,Silence,Beep,Silence,Silence,Silence,Beep,Silence,Beep,Silence,Beep,Silence,Silence,Silence,Beep,Beep,Beep,Silence]
   ```

   **HINT**: You may find it useful to define a general function
   ```hs
   split :: Eq a => [a] -> [a] -> [[a]]
   ```
   satisfying the following specification:
   ```hs
   split " " "ABC DEF" = ["ABC","DEF"]
   split shortGap (dit ++ shortGap ++ dah) = [dit,dah]
   ```
   where the first argument of `split` indicates a word separator, which is " "
   in this example.

### Exercise 2: Decode using a table (16 marks)

Write a function
```haskell
decodeText :: Table -> Code -> String
```
such that
```hs
decodeText t (encodeText t s) = s
```
for every `s :: String` and `t :: Table`. We will only test strings with capital letters, digits and spaces.

For instance, we should have:
```hs
decodeText morseTable (encodeText morseTable "THIS IS A TEST") = "THIS IS A TEST"
```

**HINT**: You may find it helpful to use your general function `split` discussed
above.

### Exercise 3: Decode using a tree (16 marks)

We can also store tables as trees where a left branch is a `dit` and a right
branch is a `dah`. For Morse code, we would get the following tree.

![](morse_tree.jpg)

Here is the type of such trees.
```haskell
data Tree = Empty
          | Branch (Maybe Char) Tree Tree
          deriving (Show , Eq)
```

Write a function
```haskell
decodeTextWithTree :: Tree -> Code -> String
```
that decodes using a tree such as the above.

This function should work with **any** such tree, not just the tree pictured above.

For testing purposes, here is the tree above in Haskell:
```hs
let morseTree = Branch Nothing (Branch (Just 'E') (Branch (Just 'I') (Branch (Just 'S') (Branch (Just 'H') (Branch (Just '5') Empty Empty) (Branch (Just '4') Empty Empty)) (Branch (Just 'V') Empty (Branch (Just '3') Empty Empty))) (Branch (Just 'U') (Branch (Just 'F') Empty Empty) (Branch Nothing Empty (Branch (Just '2') Empty Empty)))) (Branch (Just 'A') (Branch (Just 'R') (Branch (Just 'L') Empty Empty) Empty) (Branch (Just 'W') (Branch (Just 'P') Empty Empty) (Branch (Just 'J') Empty (Branch (Just '1') Empty Empty))))) (Branch (Just 'T') (Branch (Just 'N') (Branch (Just 'D') (Branch (Just 'B') (Branch (Just '6') Empty Empty) Empty) (Branch (Just 'X') Empty Empty)) (Branch (Just 'K') (Branch (Just 'C') Empty Empty) (Branch (Just 'Y') Empty Empty))) (Branch (Just 'M') (Branch (Just 'G') (Branch (Just 'Z') (Branch (Just '7') Empty Empty) Empty) (Branch (Just 'Q') Empty Empty)) (Branch (Just 'O') (Branch Nothing (Branch (Just '8') Empty Empty) Empty) (Branch Nothing (Branch (Just '9') Empty Empty) (Branch (Just '0') Empty Empty)))))
```

Your function `decodeTextWithTree` should satisfy for instance:
```hs
decodeTextWithTree morseTree (encodeText morseTable "THIS IS ANOTHER TEST") = "THIS IS ANOTHER TEST"
```

### Exercise 4: Translating a table to a tree (16 marks)

Write a function

```haskell
ramify :: Table -> Tree
```
that translates a given `Table` into a `Tree`. For example `ramify morseTable` should give the tree pictured above, i.e.
```hs
ramify morseTable = Branch Nothing (Branch (Just 'E') (Branch (Just 'I') (Branch (Just 'S') (Branch (Just 'H') (Branch (Just '5') Empty Empty) (Branch (Just '4') Empty Empty)) (Branch (Just 'V') Empty (Branch (Just '3') Empty Empty))) (Branch (Just 'U') (Branch (Just 'F') Empty Empty) (Branch Nothing Empty (Branch (Just '2') Empty Empty)))) (Branch (Just 'A') (Branch (Just 'R') (Branch (Just 'L') Empty Empty) Empty) (Branch (Just 'W') (Branch (Just 'P') Empty Empty) (Branch (Just 'J') Empty (Branch (Just '1') Empty Empty))))) (Branch (Just 'T') (Branch (Just 'N') (Branch (Just 'D') (Branch (Just 'B') (Branch (Just '6') Empty Empty) Empty) (Branch (Just 'X') Empty Empty)) (Branch (Just 'K') (Branch (Just 'C') Empty Empty) (Branch (Just 'Y') Empty Empty))) (Branch (Just 'M') (Branch (Just 'G') (Branch (Just 'Z') (Branch (Just '7') Empty Empty) Empty) (Branch (Just 'Q') Empty Empty)) (Branch (Just 'O') (Branch Nothing (Branch (Just '8') Empty Empty) Empty) (Branch Nothing (Branch (Just '9') Empty Empty) (Branch (Just '0') Empty Empty)))))
```

### Exercise 5: Tabulating a tree (16 marks)

Write a function
```haskell
tabulate :: Tree -> Table
```
that does the opposite. That is, it should satisfy:
```hs
ramify (tabulate t) = t
```
for every `t :: Tree`.

(Note that this establishes `Tree` as a
[retract](https://git.cs.bham.ac.uk/fp/fp-learning-2025/-/blob/main/files/LectureNotes/Sections/Data1.md#type-retracts)
of `Table`. The types are _not_ isomorphic, because, in general, `tabulate
(ramify t)` may be only a _permutation_ of the table `t`.)


### Exercise 6: Well-bracketed strings (hard) (18 marks)

Consider the following type of "bracket trees" with constructors `Round :: [Bracket] -> Bracket` and `Curly :: [Bracket] -> Bracket`:
```haskell
data Bracket = Round [Bracket] | Curly [Bracket] deriving (Show,Eq)
```
The simplest trees we can construct are `Round []` and `Curly []`. Other examples of such trees are
`Round [Curly [] , Round []]` and `Round [Curly [] , Round [] , Curly [ Round [] ]]`.

We can convert bracket trees to strings:
```haskell
brackets :: Bracket -> String
brackets (Round ts) = "(" ++ concat [brackets t | t <- ts] ++ ")"
brackets (Curly ts) = "{" ++ concat [brackets t | t <- ts] ++ "}"
````

Write a partial inverse
```haskell
tree :: String -> Maybe Bracket
```
of the function `brackets` satisfying the following specification.

For any bracket tree `t`, we should have that

   * the equation `tree (brackets t) = Just t` holds,

and we should have that for any string `xs`,

   * the equation `tree xs = Nothing` holds precisely when `xs` is
     *not* well-bracketed.

Well-bracketed strings are defined by the following two generating rules:

  * Any string starting with '(' followed by zero or more well-bracketed strings and ending with ')' is well
    bracketed.

  * Any string starting with '{' followed by zero or more well-bracketed strings and ending with '}' is well
    bracketed.

It is a fact that bracket trees generate only well bracketed strings, using the function `brackets`, and, moreover, every well-bracketed string arises from some bracket tree in this way.

Examples:

  * "()" is well bracketed
  * "{}" is well bracketed
  * "({})" is well bracketed
  * "{()()}" is well bracketed
  * "(()(){()()})" is well bracketed
  * "(((){}){}(()()))" is well bracketed
  * "(()" is not
  * "())" is not
  *  "(()(()()" is not
  *  "(}" is not
  *  "({)}" is not
  * "(cat)" is not
  * "" is not

Then we can use the function `tree` to check whether an expression is well bracketed:
```haskell
isWellBracketed :: String -> Bool
isWellBracketed xs = case tree xs of
                      Nothing -> False
                      Just _  -> True
```
You can use this function for testing. You can also test by creating well-bracketed strings `xs`and checking whether
```hs
   brackets (fromJust (tree xs)) = xs
```
where `fromJust` is in the import `Data.Maybe`.
