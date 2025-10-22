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
          | null l && null r = ""
          | otherwise = strGridListStr  --unlines (map showRow g)
            where
              --helper function for making list to string
              --strGrid = (map (map show) gu) ++ sting for l ++ string for a ++ string for r ++ (map (map show) gl)
              replace :: String -> String
              replace [] = []
              replace (x:xs) 
                  | x == '['  = replace xs  -- Replace '[' with a space
                  | x == ']'  = replace xs  -- Replace ']' with a space
                  | x == ','  = ' ' : replace xs  -- Replace ',' with a space
                  | otherwise = x : replace xs    -- Keep other characters unchanged
              strGridUpper =  replace  (unwords ((map show) gu))
              strGridUpperD =  show (Grid gu)
              strGridListLeft = ((map show) l)
              strGridListRight = ((map show) r) 
              strGridLower =   replace (unwords ((map show) gl))

              replace' :: String -> String
              replace' [] = []
              replace' (x:xs)
                  | x == '[' && not (null xs) && head xs == ',' = '[' : replace' (tail xs)  -- Replace "[," with "["
                  | x == ',' && (null xs || head xs == ']') = replace' xs  -- Remove trailing commas at the end or before ']'
                  | x == '\\'  = replace' xs  -- Remove backslashes
                  | x == '"'   = replace' xs  -- Remove quotes
                  | otherwise  = x : replace' xs  -- Keep other characters unchanged
              
              replace'' :: String -> String
              replace'' [] = []
              replace'' (x:xs)
                  | x == '[' && not (null xs) && head xs == ',' = '[' : replace' (tail xs)  -- Replace "[," with "["
                  | x == ',' && (null xs || head xs == ']') = replace' xs  -- Remove trailing commas at the end or before ']'
                  | x == '\\'  = replace' xs  -- Remove backslashes
                  | x == '"'   = replace' xs  -- Remove quotes
                  | otherwise  = x : replace' xs  -- Keep other characters unchanged
              
              

              strGrid = strGridUpper ++ unwords strGridListLeft ++ " " ++ "\ESC[44m" ++ show pointer ++ "\ESC[0m"  ++ " " ++ unwords strGridListRight ++ "\n" ++ strGridLower
              middleRow = l ++ [pointer] ++ r
              middleRowListString = [ show x | x <- middleRow]
              strGridList = (((map show) gu)) ++ ["["] ++ middleRowListString ++ ["]"] ++ (((map show) gl))
              strGridListStr = replace' (replace' (show strGridList))

              -- need to get this bit working.
              colWidths = [maximum (map visibleLength col) | col <- transpose strGridListStr]
              showRow row = unwords [padRight w s | (w, s) <- zip colWidths (map show row)]
              padRight n s = s ++ replicate (n - visibleLength s) ' '
              -- show (Grid gu)


-- for testing
g_2 = GridWithAPointer (Grid [[1,2,3,4,5],[6,7,8,9,10]],[12,11],13,[14,15],Grid [[16,17,18,19,20]])
g_3 = Grid [[1,2,3,4,5], [6,7,8,9,10], [11,12,13,14,15]]

g_3fun = map(map show) [[1,2,3,4,5], [6,7,8,9,10], [11,12,13,14,15]]


g_4 = Grid [["1","2"],["3","4"]]

---------------------------------------------------------------------------------
-- TASK 2
---------------------------------------------------------------------------------

put :: a -> GridWithAPointer a -> GridWithAPointer a
put = undefined

moveLeft :: GridWithAPointer a -> GridWithAPointer a
moveLeft = undefined


moveRight :: GridWithAPointer a -> GridWithAPointer a
moveRight = undefined

moveUp :: GridWithAPointer a -> GridWithAPointer a
moveUp = undefined

moveDown :: GridWithAPointer a -> GridWithAPointer a
moveDown = undefined


---------------------------------------------------------------------------------
-- TASK 3
---------------------------------------------------------------------------------

putTatamiUp :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiUp = undefined

putTatamiDown :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiDown = undefined

putTatamiRight :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiRight = undefined

putTatamiLeft :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiLeft = undefined


---------------------------------------------------------------------------------
-- TASK 4
---------------------------------------------------------------------------------

cover :: GridWithAPointer Integer -> GridWithAPointer Integer
cover = undefined
