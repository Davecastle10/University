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
import Types (morseTable)

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

unMaybe :: Maybe a -> a
unMaybe (Just a) = a
unMaybe Nothing = error "Maybe propaganda"

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
    | otherwise = take (codeListLength - 6) codeList
    -- | otherwise = codeList
    where
        codeList = concat [encodeWord morseTable x ++ [Silence,Silence,Silence,Silence,Silence,Silence]| x <- xs]
        codeListLength = length codeList

{-}
split :: Eq a => [a] -> [a] -> [[a]]
split delim xs = case break (==delim) xs of 
    (front, []) -> front -- there is no seperatror in the list/string/whatever so just return the front = whole list
    (front, rest) -> front ++ split delim (drop (length delim) rest) -- migth not need the [] around front here if the base case when nothing left sorts it out, but test later.
-}


splitComma :: [Char] -> [[Char]] 
splitComma xs = case break (==',') xs of 
    (front, []) -> [front] -- there is no seperatror in the list/string/whatever so just return the front = whole list
    (front, rest) -> [front] ++ splitComma (drop 1 rest) -- migth not need the [] around front here if the base case when nothing left sorts it out, but test later.


stringToAtom :: String -> Atom
stringToAtom stringIn
    | stringIn == "Beep" = Beep
    | stringIn == "Silence" = Silence -- could proabbly just have this by the otherwise case but that just seems wrong
    | otherwise = error "Beep Beep propagande Beep" -- I dont think this will ever occur but it seemed funny 

{-}
split :: Eq a => [a] -> [a] -> [[a]]
split delim xs = case break (==delim) xs of 
    (front, []) -> front -- there is no seperatror in the list/string/whatever so just return the front = whole list
    (front, rest) -> front ++ split delim (drop (length delim) rest) -- migth not need the [] around front here if the base case when nothing left sorts it out, but test later.
-}
-- alt take length delim if it is delim, then drop delim

split :: Eq a => [a] -> [a] -> [[a]]
split delim xs = filter (not . null) (splitHelper xs)
  where
    splitHelper [] = [[]] -- if empty list make list of empty list for nice base case
    splitHelper ys@(y:ys') -- make ys into y (the head of ys) and ys' the rest of ys the @ symbol usage is really cool, it makes this sort of stuff way eaier
      | delim `isPrefixOf` ys = [] : splitHelper (drop (length delim) ys) -- if the deliminator is the prefix of ys the drop it and call the function again
      | otherwise = let (h:t) = splitHelper ys' in (y:h) : t -- calls split helper recursively on the tail of ys then recmobines as it backtracks throught the recursive call

splitGap :: Eq a => [a] -> [a] -> [[a]]
splitGap delim xs = filter (not . null) (splitHelper xs)
  where
    splitHelper [] = [[]] -- if empty list make list of empty list for nice base case
    splitHelper ys@(y:ys') -- make ys into y (the head of ys) and ys' the rest of ys the @ symbol usage is really cool, it makes this sort of stuff way eaier
      | delim `isPrefixOf` ys = [y] : splitHelper (drop (length delim - 1) ys') -- changed so hopefully the leading silence of the medium gap will stay
      | otherwise = let (h:t) = splitHelper ys' in (y:h) : t -- calls split helper recursively on the tail of ys then recmobines as it backtracks throught the recursive call

-- something wrong with the above not splitting properly and 


encodeText :: Table -> String -> Code
encodeText tableIn stringIn = encodeWords tableIn (words stringIn)


{- Question 2 -}
decodeText :: Table -> Code -> String
decodeText morseTable codeIn = retString
    where
        -- words = [ x ++ [Silence]| x <- split (mediumGap ++ [Silence]) codeIn] -- ws going to remove all seven silences and then add backe to end of each word but think can get round this
        words = [ x | x <- splitGap (mediumGap ++ [Silence]) codeIn] 
        -- letterWords = map split (shortGap ++ [Silence]) words
        letterWords = [ splitGap (shortGap ++ [Silence]) x | x <- words]
        decodedLetterWords = [ [ unMaybe (reverseLookup x morseTable) | x <- xs] | xs <- letterWords]
        retString = intercalate " " decodedLetterWords
        -- now just need to go through and connect the list of list of char into list of char ++ space ++ list of char etc to make a decode string


reverseLookup :: Eq b => b -> [(a, b)] -> Maybe a
reverseLookup codeIn tableIn
    | null tableIn = Nothing
    | not (null (filter (\(_, b) -> b == codeIn) tableIn)) = Just (fst (head (filter (\(a, b) -> b == codeIn) tableIn)))
    | otherwise = Nothing



-- head (filter (\x -> snd x == codeIn) tableIn)))


{- Question 3 -}
decodeTextWithTree :: Tree -> Code -> String
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
