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
      show gu l a r gl | null a = ""
            | otherwise = undefined
            where
--            helper function for making list to string
--            strGrid = (map (map show) gu) ++ sting for l ++ string for a ++ string for r ++ (map (map show) gl)
              strGrid = (map (map show) gu) ++ (map (map show) gu) ++ show a ++ (map (map show) gu) ++ (map (map show) gl)


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
