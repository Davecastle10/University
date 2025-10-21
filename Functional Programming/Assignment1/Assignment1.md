## Assignment 1

To solve this assignment, please copy the file [Assignment1-Template.hs](Assignment1-Template.hs) to a new file `Assignment1.hs` in the same folder, and work on this copy. Don't modify the template, and obey  the intructions in that file.

### Preliminaries

Consider the following type that represents a 2-D grid of values of some type `a` which we wrapped with a `newtype` to be able to derive a handy `Show` instance.

```haskell

newtype Grid a = Grid { grid :: [[a]] } deriving (Eq, Functor)

instance (Show a) => Show (Grid a) where
  show (Grid g)
    | null g = ""
    | otherwise = unlines (map showRow g)
    where
      strGrid = map (map show) g
      colWidths = [maximum (map visibleLength col) | col <- transpose strGrid]
      showRow row = unwords [padRight w s | (w, s) <- zip colWidths (map show row)]
      padRight n s = s ++ replicate (n - visibleLength s) ' '

```

You will find all the helper functions such as `visibleLength` in the template.


With this in hand we can construct a grid as follows and see it being printed in the terminal. **Note that througout we will assume that the dimensions of all the lists in a grid agree**

<img src="img/GridPrettyPrinting.png"></img>


We can then supplement such a grid with a *pointer*, again with a `newtype` wrapper to help with printing.

```haskell

newtype GridWithAPointer a = GridWithAPointer (Grid a, [a], a, [a], Grid a)
```

The *pointer* points to a particular element of the grid, that is given by the middle element of the tuple. The remaining elements represent the context of that element:

  * All elements to the left (**in reverse order**),

  * all elements to the right, and

  * the grids above and below respectively.

We will also say that the *focus* of the grid is at this middle element.

---

#### Task 1

Implement the `Show a => Show (GridWithAPointer a)` instance such that it highlights the *focused* element. To show a highlighted element, say `13`, you can use ` "\ESC[44m" ++ show 13 ++ "\ESC[0m", where the escape sequence `"\ESC[44m"` makes the background blue, and the escape sequence goes back to normal `"\ESC[0m"`. Your output should look like this:

<img src="./img/GridWithAPointerPrettyPrinting.png"></img>

Note that the element in the middle of the tuple is the focus and and note how the list on the left of it is reversed (as opposed to the list on the right). Also note that you can wrap the code in `ghci` in `:{ ... :}` to insert line breaks.

We can perform various operations on a grid with a pointer.
The ones that are of a particular interest to us are moving the pointer around the grid and replacing the element under the focus.

---

#### Task 2

Implement the following functions on a grid with a pointer.

#### `put`

```haskell
put :: a -> GridWithAPointer a -> GridWithAPointer a
```

Which puts a given value under the pointer, without changing anything else.

<img src="./img/Put.png"> </img>

#### `moveLeft, moveRight, moveUp, moveDown`

```haskell
moveLeft :: GridWithAPointer a -> GridWithAPointer a

moveRight :: GridWithAPointer a -> GridWithAPointer a

moveUp :: GridWithAPointer a -> GridWithAPointer a

moveDown :: GridWithAPointer a -> GridWithAPointer a
```

The above four functions should modify the position of the focus accordingly:

<img src="./img/MovingAround.png"></img>

Note that in the module we have not yet seen any error handling machinery provided by Haskell, so as of now it is safe to just let the function crash if the pointer can not be moved any further.

```haskell

error : String -> a

```

For example,

<img src="./img/Error.png"></img>

---

Now we have all the ingredients to solve the following problem.
We will call a block of size 2x1 that can be placed either horizontally or vertically onto a grid a *tatami* (which is a sort of mat). We will represent a grid with no tatamis at all by a grid of all zeroes and each tatami will be defined by a non-zero natural number.

#### Task 3

Implement the following functions:

```haskell
putTatamiUp :: Integer -> GridWithAPointer Integer ->  GridWithAPointer Integer

putTatamiDown :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer

putTatamiRight :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer

putTatamiLeft :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer

```

that put a tatami in a given direction and restore the pointer:

<img src="./img/Tatami.png"></img>


#### Task 4

Now suppose you are given an empty grid (that is, a grid filled by zeros only) of an arbitrary dimension with a pointer in the **left top** corner.
Determine whether it is possible to cover the entire grid with 2x1 tatamis such that **no 4 tatamis share a corner** and if it is, provide such a coverage. Throw an error otherwise.

For example, this is a valid coverage

```
1122
3446
3556
7788
```

and this is not

```
1134
2234
5677
5688
```
as in the latter the tatamis 2,3,6,7 share a corner.
Please use distinct natural numbers for different tatamis, e.g. use `(1,1)` for the first one, `(2,2)` for the second one and so on.

```haskell
cover :: GridWithAPointer Integer -> GridWithAPointer Integer
```
