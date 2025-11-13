-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module Assignment2 (encodeWord , encodeWords , encodeText ,
                    decodeText ,
                    decodeTextWithTree ,
                    ramify ,
                    tabulate ,
                    tree) where

import Types
import Data.List
import Types (morseCode, morseTable)

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

{- Question 1 -}
encodeWord :: Table -> String -> Code

encodeWord tableIn xs = take (retCodeLength - 2) retCode
    where
        retCode = concat [case lookup x tableIn of 
                                        Just code -> code ++ [Silence,Silence]
                                        Nothing -> [] | x <- xs] -- i don't like the way this looks but also don't want to add another function will will slow down code
        retCodeLength = length retCode

{-}
encodeWord tableIn xs = take (retCodeLength - 2) retCode
    where
        retCode = [snd (head (filter (\x -> fst x == y) tableIn)) ++ [Silence,Silence] | y <- xs]
        retCodeLength = length retCode
-}

encodeWords :: Table -> [String] -> Code
encodeWords tableIn xs 
    | null xs = []
    -- | otherwise = take (codeListLength - 6) codeList
    | otherwise = codeList
    where
        codeList = concat [encodeWord morseTable x ++ [Silence,Silence,Silence,Silence,Silence,Silence]| x <- xs]
        codeListLength = length codeList

{-}
split :: Eq a => [a] -> [a] -> [[a]]
split delim xs = case break (==delim) xs of 
    (front, []) -> front -- there is no seperatror in the list/string/whatever so just return the front = whole list
    (front, rest) -> front ++ split delim (drop (length delim) rest) -- migth not need the [] around front here if the base case when nothing left sorts it out, but test later.
-}

{-}
splitCharString :: Eq a => a -> [a] -> [[a]]
splitCharString delim xs = case break (==delim) xs of 
    (front, []) -> front -- there is no seperatror in the list/string/whatever so just return the front = whole list
    (front, rest) -> front ++ splitCharString delim (drop 1 rest) -- migth not need the [] around front here if the base case when nothing left sorts it out, but test later.
-}

-- alt take length delim if it is delim, then drop delim

--split :: Eq a => [a] -> [a] -> [[a]]




encodeText :: Table -> String -> Code
encodeText tableIn stringIn = encodeWords tableIn (words stringIn)


{- Question 2 -}
decodeText :: Table -> Code -> String
decodeText = undefined

{- Question 3 -}
decodeTextWithTree :: Tree -> Code-> String
decodeTextWithTree = undefined

{- Question 4 -}
ramify :: Table -> Tree
ramify = undefined

{- Question 5 -}
tabulate :: Tree -> Table
tabulate = undefined

{- Question 6 -}
brackets :: Bracket -> String
brackets (Round ts) = "(" ++ concat [brackets t | t <- ts] ++ ")"
brackets (Curly ts) = "{" ++ concat [brackets t | t <- ts] ++ "}"

tree :: String -> Maybe Bracket
tree = undefined

isWellBracketed :: String -> Bool
isWellBracketed xs = case tree xs of
                      Nothing -> False
                      Just _  -> True
