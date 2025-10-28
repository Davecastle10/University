-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module Assignment1 ( put,
                     moveLeft,
                     moveRight,
                     moveUp,
                     moveDown,
                     Grid(..),
                     GridWithAPointer(..),
                     putTatamiDown,
                     putTatamiUp,
                     putTatamiLeft,
                     putTatamiRight,
                     cover
             ) where

import Data.Char (isLetter)
import Control.Monad (when)

-- these two function are to correctly measure the width of an entry of a grid, 
-- i.e. so that the width of "\ESC[44m55\ESC[0m" ignored the escape sequences
stripANSI :: String -> String
stripANSI [] = []
stripANSI ('\ESC':'[':xs) = stripANSI (drop 1 (dropWhile (not . isLetter) xs))
stripANSI (x:xs) = x : stripANSI xs

visibleLength :: String -> Int
visibleLength = length . stripANSI

newtype Grid a = Grid { grid :: [[a]] } deriving Eq

instance (Show a) => Show (Grid a) where
  show (Grid g)
    | null g = ""
    | otherwise = unlines (map showRow g)
    where
      strGrid = map (map show) g
      colWidths = [maximum (map visibleLength col) | col <- transpose strGrid]
      showRow row = unwords [padRight w s | (w, s) <- zip colWidths (map show row)]
      padRight n s = s ++ replicate (n - visibleLength s) ' '

transpose :: [[a]] -> [[a]]
transpose [] = []
transpose ([]:_) = []
transpose x = map head x : transpose (map tail x)


newtype GridWithAPointer a = GridWithAPointer (Grid a, [a], a, [a], Grid a)
  deriving Eq


---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- TASK 1
---------------------------------------------------------------------------------

instance (Show a) => Show (GridWithAPointer a) where
     --show gu l a r gl = undefined

     -- this is a mess at the moment trying to add the padding functionaliity from Grid and it's not working, 
     -- the owrking replacement can be found in random.hs
      show (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
          | null l && null r = "" -- fix this as doesnt work with 1 wide by 4 tall or 1 wide by x tall grids and la nd r are empty but ther is still stuff to display.
          | otherwise = outStr  --unlines (map showRow g)
            where
              strGridUpper =  undefined --replace  (unwords ((map show) gu))
              strGridUpperD =  show (Grid gu)
              strGridListLeft = ((map show) l)
              strGridListRight = ((map show) r) 
              strGridLower =   undefined --replace (unwords ((map show) gl))

            
              strGrid = map (map show) (gu ++ [(reverse l) ++ [pointer] ++ r] ++ gl) 

              -- need to get this bit working.
              colWidths = [maximum (map visibleLength col) | col <- transpose strGrid] -- feed this the top grid and the middle row an dbottom grid
              showRow row = unwords [padRight w s | (w, s) <- zip colWidths (map show row)]-- feed top and bootm grids to this and a slightly alter middle row.
              showStrRow row = unwords [padRight w s | (w, s) <- zip colWidths (row)]
              padRight n s = s ++ replicate (n - visibleLength s) ' '
              -- show (Grid gu)

              middleRow = map show (reverse l) ++ ["\ESC[44m" ++ show pointer ++ "\ESC[0m"] ++ map show r
              outStr = unlines (map showRow gu) ++ showStrRow middleRow ++ "\n" ++ unlines (map showRow gl)





-- for testing
g_2 = GridWithAPointer (Grid [[1,2,3,4,5],[6,7,8,9,10]],[12,11],13,[14,15],Grid [[16,17,18,19,20]])
g_20 = GridWithAPointer (Grid [[1,2,3,4,5],[6,7,0,9,10]],[12,11],13,[0,15],Grid [[16,17,0,19,20]])
g_5 = GridWithAPointer (Grid [[1],[6]],[],13,[],Grid [[16]])
g_3 = Grid [[1,2,3,4,5], [6,7,8,9,10], [11,12,13,14,15]]

g_3fun = map(map show) [[1,2,3,4,5], [6,7,8,9,10], [11,12,13,14,15]]

g_200 = GridWithAPointer (Grid [],[],0,[0,0,0],Grid [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]])


g_4 = Grid [["1","2"],["3","4"]]

---------------------------------------------------------------------------------
-- TASK 2
---------------------------------------------------------------------------------

put :: a -> GridWithAPointer a -> GridWithAPointer a
put a (GridWithAPointer(Grid gu, l, pointer, r, Grid gl)) = GridWithAPointer(Grid gu, l, a, r, Grid gl)

moveLeft :: GridWithAPointer a -> GridWithAPointer a
moveLeft (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | length l == 0 = error "Can not move any further"
  | otherwise = GridWithAPointer(Grid gu, newl, newPointer, newr, Grid gl)
    where
      newPointer = head l
      newl = tail l
      newr = pointer : r


moveRight :: GridWithAPointer a -> GridWithAPointer a
moveRight (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | length r == 0 = error "Can not move any further"
  | otherwise = GridWithAPointer(Grid gu, newl, newPointer, newr, Grid gl)
    where
      newPointer = head r
      newr = tail r
      newl = pointer : l

moveUp :: GridWithAPointer a -> GridWithAPointer a
moveUp (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | null gu = error "Can not move any further"
  | otherwise = GridWithAPointer(Grid newGu, newl, newPointer, newr, Grid newGl)
    where
      pointerIndex = length l
      newRow = last gu
      newl = take pointerIndex newRow
      newPointer = head (drop pointerIndex newRow)
      newr = drop (pointerIndex + 1) newRow
      oldRow = l ++ [pointer] ++ r
      newGl = ([oldRow] ++ gl)
      newGu = init gu


moveDown :: GridWithAPointer a -> GridWithAPointer a
moveDown (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | null gl = error "Can not move any further"
  | otherwise = (GridWithAPointer(Grid newGu, newl, newPointer, newr, Grid newGl))
    where
      
      pointerIndex = length l
      newRow = head gl
      newl = take pointerIndex newRow
      newPointer = head (drop pointerIndex newRow)
      newr = drop (pointerIndex + 1) newRow
      oldRow = l ++ [pointer] ++ r
      newGl = drop 1 gl
      newGu = gu ++ [oldRow]


---------------------------------------------------------------------------------
-- TASK 3
---------------------------------------------------------------------------------

putTatamiUp :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiUp a inputGrid = moveDown (put a (moveUp (put a inputGrid)))

putTatamiDown :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiDown a inputGrid = moveUp (put a (moveDown (put a inputGrid)))

putTatamiRight :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiRight a inputGrid = moveLeft (put a (moveRight (put a inputGrid)))

putTatamiLeft :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiLeft a inputGrid = moveRight (put a (moveLeft (put a inputGrid)))


---------------------------------------------------------------------------------
-- TASK 4
---------------------------------------------------------------------------------

-- need to deal with the undefined return values used error cases instead like above in task 2

getRight :: GridWithAPointer Integer -> Integer
getRight (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | r == [] = error "Item outside of grid, nothing to the right available"
  | otherwise = head r

getLeft :: GridWithAPointer Integer -> Integer
getLeft (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | l == [] = error "Item outside of grid, nothing to the left available"
  | otherwise = head l

getUpper :: GridWithAPointer Integer -> Integer
getUpper (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | gu == [[]] = error "Item outside of grid, nothing above available"
  | otherwise = upperPointer
  where
    upperRow = last gu
    pointerIndex = length l
    upperPointer = head (drop pointerIndex upperRow)

getLower :: GridWithAPointer Integer -> Integer
getLower (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | gl == [[]] = error "Item outside of grid, nothing below available"
  | otherwise = lowerPointer
  where
    lowerRow = head gl
    pointerIndex = length l
    lowerPointer = head (drop pointerIndex lowerRow)

getPointer :: GridWithAPointer Integer -> Integer
getPointer (GridWithAPointer(_, _, pointer, _, _)) = pointer

checkCornerNW :: GridWithAPointer Integer -> Bool -- return true if at least 2 items in a 2x2 grid are the same and thus is a valid part of the grid.
checkCornerNW grid = returnBool
  where 
    left = getLeft grid
    above = getUpper grid
    corner = getUpper (moveLeft grid)
    pointer = getPointer grid
    returnBool = (left == above) || (left == corner) || (left == pointer) || (above == corner) || (above == pointer) || (corner == pointer)

checkCornerNE :: GridWithAPointer Integer -> Bool -- return true if at least 2 items in a 2x2 grid are the same and thus is a valid part of the grid.
checkCornerNE grid = returnBool
  where 
    right = getRight grid
    above = getUpper grid
    corner = getUpper (moveRight grid)
    pointer = getPointer grid
    returnBool = (right == above) || (right == corner) || (right == pointer) || (above == corner) || (above == pointer) || (corner == pointer)

checkCornerSW :: GridWithAPointer Integer -> Bool -- return true if at least 2 items in a 2x2 grid are the same and thus is a valid part of the grid.
checkCornerSW grid = returnBool
  where 
    left = getLeft grid
    below = getLower grid
    corner = getLower (moveLeft grid)
    pointer = getPointer grid
    returnBool = (left == below) || (left == corner) || (left == pointer) || (below == corner) || (below == pointer) || (corner == pointer)

checkCornerSE :: GridWithAPointer Integer -> Bool -- return true if at least 2 items in a 2x2 grid are the same and thus is a valid part of the grid.
checkCornerSE grid = returnBool
  where 
    right = getRight grid
    below = getLower grid
    corner = getLower (moveRight grid)
    pointer = getPointer grid
    returnBool = (right == below) || (right == corner) || (right == pointer) || (below == corner) || (below == pointer) || (corner == pointer)


getGridWithAPointerSize :: GridWithAPointer Integer -> (Int,Int) -- returns a tuple containing the integer length and width of a GridWithAPointer
getGridWithAPointerSize (GridWithAPointer(Grid gu, l, pointer, r, Grid gl)) = (gridLength, gridWidth)
  where
    gridWidth = length (l ++ [pointer] ++ r)
    gridLength = length gu + length  gl + 1

getGridSize :: Grid Integer -> (Int,Int)
getGridSize (Grid grid) = (gridLength, gridWidth)
  where
    gridLength = length grid
    gridWidth = length (head grid)

validGridWithAPointerSize :: GridWithAPointer Integer -> Bool -- returnd tru if the grid is a valid size e.g. not odd length and width
validGridWithAPointerSize (GridWithAPointer(Grid gu, l, pointer, r, Grid gl)) = h == 0
  where
    gridWidth = length (l ++ [pointer] ++ r)
    gridLength = length gu + length  gl + 1
    h = (gridWidth * gridLength) `mod` 2 

getPointerHorizontalPos :: GridWithAPointer Integer -> Int
getPointerHorizontalPos (GridWithAPointer(_, l, _, _, _)) = length l

getPointerVerticalPos :: GridWithAPointer Integer -> Int
getPointerVerticalPos (GridWithAPointer(Grid gu, _, _, _, _)) = length gu

-- might need to add another guard for if tyou are at the final item in the grid
getNextEmptyPos :: GridWithAPointer Integer -> GridWithAPointer Integer -- works other than the undefined case
getNextEmptyPos (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | null r && null gl = undefined -- the case for bottom rightmost item in grid what do i do here? hope for the best and pray
  | null r = getNextEmptyPos (GridWithAPointer(Grid newGu, newl, newPointer, newr, Grid newGl))
  | pointer == 0 = GridWithAPointer(Grid gu, l, pointer, r, Grid gl)
  | otherwise = getNextEmptyPos (moveRight (GridWithAPointer(Grid gu, l, pointer, r, Grid gl)))
  where
    newRow = head gl
    newl = []
    newPointer = head newRow
    newr = tail newRow
    oldRow = l ++ [pointer] ++ r
    newGl = drop 1 gl
    newGu = gu ++ [oldRow] 
    -- move rigth until find 0
    -- if edge go down to next level
    -- when the pointer is 0 return the current grid
    -- if made it to the end without encountering 0 grid is covered
    -- not in this function but at that point would check if grid follows rules.

checkCornerSE0:: GridWithAPointer Integer -> Bool -- return true if at least 2 items in a 2x2 grid are the same and thus is a valid part of the grid.
checkCornerSE0 grid = returnBool
  where 
    right = getRight grid
    below = getLower grid
    corner = getLower (moveRight grid)
    pointer = getPointer grid
    returnBool = (right == 0) || (0 == corner) || (0 == pointer) || (below == 0)

moveDownRow :: GridWithAPointer Integer -> GridWithAPointer Integer
moveDownRow (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | null gl = GridWithAPointer(Grid gu, l, pointer, r, Grid gl)
  | otherwise = GridWithAPointer(Grid newGu, newl, newPointer, newr, Grid newGl)
  where
    newRow = head gl
    newl = []
    newPointer = head newRow
    newr = tail newRow
    oldRow = l ++ [pointer] ++ r
    newGl = drop 1 gl
    newGu = gu ++ [oldRow] 


checkGridValidCovering :: GridWithAPointer Integer -> Bool -- not sure if this actually works
checkGridValidCovering (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
  | not (checkCornerSE0 grid) && length r == 1 && not (null gl) = checkCornerSE grid && checkGridValidCovering cont -- no 0 in grid and there is stuff to right and below check the corner and recursively call again
  | otherwise = False -- ? shouldnt get to this i hope?
  where
    grid = GridWithAPointer(Grid gu, l, pointer, r, Grid gl)
    cont 
      | null r && not (null gl) =  moveDownRow grid -- no space to right and there is space below move to start of row below
      | otherwise = moveRight grid -- space to right move right, wouldnt have been called if bothe right and below are null
    


cover' :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer -- recursive func to cover grid
cover' x g@(GridWithAPointer(Grid gu, l, pointer, r, Grid gl)) 
  | null r && null gl = g -- last elemnt in the list hope this works oh well if it doesnt.
  | (length r >= 1) && not (null gl) = cover' (x+1) (putTatamiRight x g)
  | otherwise = cover' (x+1) (putTatamiRight x g)
  where 
    


cover :: GridWithAPointer Integer -> GridWithAPointer Integer
cover grid 
  | not (validGridWithAPointerSize grid) = error "Grid not valid" -- if the gird is odd dimension in btoh dimensions e.g 5x7 then instantly discard as no covergae availabe 
  | otherwise = cover' 1 grid -- have it return a vaild GridWithAPointer with a valid covergae
  --where 
