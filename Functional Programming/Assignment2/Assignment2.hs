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
        words = splitGap (mediumGap ++ [Silence]) codeIn
        -- letterWords = map split (shortGap ++ [Silence]) words
        letterWords = [ splitGap (shortGap ++ [Silence]) x | x <- words]
        decodedLetterWords = [ [ unMaybe (reverseLookup x morseTable) | x <- xs] | xs <- letterWords]
        retString = unwords decodedLetterWords
        -- now just need to go through and connect the list of list of char into list of char ++ space ++ list of char etc to make a decode string




reverseLookup :: Eq b => b -> [(a, b)] -> Maybe a
reverseLookup codeIn tableIn
    | null tableIn = Nothing
    | not (not (any (\(_, b) -> b == codeIn) tableIn)) = Just (fst (head (filter (\(a, b) -> b == codeIn) tableIn)))
    | otherwise = Nothing



-- head (filter (\x -> snd x == codeIn) tableIn)))


{- Question 3 -}

morseTree = Branch Nothing (Branch (Just 'E') (Branch (Just 'I') (Branch (Just 'S') (Branch (Just 'H') (Branch (Just '5') Empty Empty) (Branch (Just '4') Empty Empty)) (Branch (Just 'V') Empty (Branch (Just '3') Empty Empty))) (Branch (Just 'U') (Branch (Just 'F') Empty Empty) (Branch Nothing Empty (Branch (Just '2') Empty Empty)))) (Branch (Just 'A') (Branch (Just 'R') (Branch (Just 'L') Empty Empty) Empty) (Branch (Just 'W') (Branch (Just 'P') Empty Empty) (Branch (Just 'J') Empty (Branch (Just '1') Empty Empty))))) (Branch (Just 'T') (Branch (Just 'N') (Branch (Just 'D') (Branch (Just 'B') (Branch (Just '6') Empty Empty) Empty) (Branch (Just 'X') Empty Empty)) (Branch (Just 'K') (Branch (Just 'C') Empty Empty) (Branch (Just 'Y') Empty Empty))) (Branch (Just 'M') (Branch (Just 'G') (Branch (Just 'Z') (Branch (Just '7') Empty Empty) Empty) (Branch (Just 'Q') Empty Empty)) (Branch (Just 'O') (Branch Nothing (Branch (Just '8') Empty Empty) Empty) (Branch Nothing (Branch (Just '9') Empty Empty) (Branch (Just '0') Empty Empty)))))


decodeTextWithTree :: Tree -> Code -> String
decodeTextWithTree treeIn codeIn = retString
    where
        words = splitGap (mediumGap ++ [Silence]) codeIn
        letterWords = [splitGap (shortGap ++ [Silence]) x | x <- words]
        directionList = codeToDirections codeIn -- of from [[[GoLeft,GoRight], [GoRight]], [[GoLeft], [GoRight]]]
        maybeLetters = [[unMaybe (traverseTree morseTree x) | x <- xs] | xs <- directionList]
        retString = unwords maybeLetters


-- need to go left with dit and rigth with dah, then you will be at the node wit the encode value once you have done all the dit/dah's for the letter.

traverseTree :: Tree -> [Direction] -> Maybe Char
traverseTree Empty _ = Nothing
traverseTree (Branch value left right) [] = value
traverseTree (Branch _ left right) (GoLeft:xs) = traverseTree left xs
traverseTree (Branch _ left right) (GoRight:xs) = traverseTree right xs

codeToDirections :: Code -> [[[Direction]]]
codeToDirections code = retDirections
    where
        words = splitGap (mediumGap ++ [Silence]) code
        letterWords = [ splitGap (shortGap ++ [Silence]) x | x <- words]

        retDirections = [[ditdahSplit x | x <- xs] | xs <- letterWords]
        -- now just need to go through and connect the list of list of char into list of char ++ space ++ list of char etc to make a decode string



data Direction = GoLeft | GoRight deriving (Show, Eq)
-- convert a code to a list of directions
ditdahSplit :: [Atom] -> [Direction]
ditdahSplit code = case code of
    [] -> [] -- emoty code
    code -> case matchCode'' code of -- non empty code
        Just signal -> (if signal == "dit" then GoLeft else GoRight) : ditdahSplit (drop (length (getCode signal)) code) -- if the driection
        Nothing -> ditdahSplit (tail code)


matchCode'' :: [Atom] -> Maybe String -- check if the first part of a code is s dit or a dah
matchCode'' code
    | length code >= 4 && take 4 code == dah = Just "dah"
    | length code >= 2 && take 2 code == dit = Just "dit"
    | otherwise = Nothing


getCode :: String -> [Atom]
getCode str
    | str == "dit" = [Beep, Silence]
    | str == "dah" = [Beep, Beep, Beep, Silence]
    | otherwise = []


{- Question 4 -}
ramify :: Table -> Tree
ramify table = updateTree retTree table
    where
        retTree = Branch Nothing Empty Empty

updateTree :: Tree -> Table -> Tree
updateTree tree table = foldl update tree (directionsTable table)
    where
        update treee (character, directions) = traverseTableTree treee directions (character)


directionsTable :: Table -> [(Maybe Char, [Direction])] -- make a version of the table that is list of pairs pf value and the direction to it's node
directionsTable table = [ (Just c , ditdahSplit b) | (c, b) <-  table]

-- use code to directions to take the code for each char in the table to get the directions to it's position as a node
-- traverse the tree if a node in your path doesnt exist make it woth Nothing as its value
-- when you get to your final position crate a node with your Value or if it alread exists update the value

-- traverse the tree for a specific value in the table
traverseTableTree :: Tree -> [Direction] -> Maybe Char -> Tree
traverseTableTree Empty [] val = Branch val Empty Empty
traverseTableTree Empty (GoLeft:xs) val = Branch Nothing (traverseTableTree (Branch Nothing Empty Empty) xs val) Empty
traverseTableTree Empty (GoRight:xs) val = Branch Nothing Empty (traverseTableTree (Branch Nothing Empty Empty) xs val) 
traverseTableTree (Branch value left right) [] val = (Branch val left right)
traverseTableTree (Branch value left right) (GoLeft:xs) val = Branch value (traverseTableTree left xs val) right
traverseTableTree (Branch value left right) (GoRight:xs) val = Branch value left (traverseTableTree right xs val)

{- Question 5 -}
tabulate :: Tree -> Table
tabulate treeIn = getTable (traverseTreeTable treeIn startPath retTable)
    where
        retTable :: Table
        retTable = []
        startPath :: Path Char
        startPath = EmptyPath

--data Path a = EmptyPath | Path [(Direction, a)] deriving (Show, Eq)
data Path a = EmptyPath | Path [(Direction, Maybe a)] deriving (Show, Eq)


traverseTreeTable :: Tree -> Path Char -> Table -> (Tree, Path Char, Table)
traverseTreeTable Empty path table  = (Empty, path, table)
traverseTreeTable (Branch (Just char) Empty Empty) path table = (Empty, Path (tail (pathGetDirs path)), (char, pathToCode path) : table)


traverseTreeTable (Branch Nothing Empty Empty) path table = (Empty, path, table)
traverseTreeTable (Branch Nothing left Empty) path table = (Empty, Path (tail (pathGetDirs path)), table ++ getTable(traverseTreeTable left (Path ((GoLeft, Nothing) : pathGetDirs path)) table))
traverseTreeTable (Branch Nothing Empty right) path table = (Empty, Path (tail (pathGetDirs path)), table ++ getTable(traverseTreeTable right (Path ((GoRight, Nothing) : pathGetDirs path)) table))
traverseTreeTable (Branch Nothing left right) path table = (Branch Nothing Empty right, Path (tail (pathGetDirs path)), table ++ getTable(traverseTreeTable left (Path ((GoLeft, Nothing) : pathGetDirs path)) table) ++ getTable(traverseTreeTable right (Path ((GoRight, Nothing) : pathGetDirs path)) table))

{-}
traverseTreeTable (Branch Nothing Empty Empty) path table = (Empty, path, table)
traverseTreeTable (Branch Nothing left Empty) path table = traverseTreeTable left path table
traverseTreeTable (Branch Nothing Empty right) path table = traverseTreeTable right path table
traverseTreeTable (Branch Nothing left right) path table = traverseTreeTable left path table
-}

{-}
-- most recent
traverseTreeTable (Branch (Just char) left Empty) path table = (Empty, Path (tail (pathGetDirs path)), table ++ getTable(traverseTreeTable left (Path ((GoLeft, Just char) : pathGetDirs path)) table))
traverseTreeTable (Branch (Just char) Empty right) path table = (Empty, Path (tail (pathGetDirs path)), table ++ getTable(traverseTreeTable right (Path ((GoRight, Just char) : pathGetDirs path)) table))
traverseTreeTable (Branch (Just char) left right) path table = (Branch (Just char) Empty right, Path (tail (pathGetDirs path)), table ++ getTable(traverseTreeTable left (Path ((GoLeft, Just char) : pathGetDirs path)) table))
-}

traverseTreeTable (Branch (Just char) left Empty) path table = (Empty, path, (char, pathToCode path) : table ++ getTable(traverseTreeTable left (Path ((GoLeft, Just char) : pathGetDirs path)) table))
traverseTreeTable (Branch (Just char) Empty right) path table = (Empty, path, (char, pathToCode path) : table ++ getTable(traverseTreeTable right (Path ((GoRight, Just char) : pathGetDirs path)) table))
traverseTreeTable (Branch (Just char) left right) path table = (Empty, path, (char, pathToCode path) : table ++ getTable(traverseTreeTable left (Path ((GoLeft, Just char) : pathGetDirs path)) table) ++ getTable(traverseTreeTable right (Path ((GoRight, Just char) : pathGetDirs path)) table))

-- 36 36
{-}
traverseTreeTable (Branch value left right) [] val = (Branch val left right)
traverseTreeTable (Branch value left right) (GoLeft:xs) val = Branch value (traverseTreeTable left xs val) right
traverseTreeTable (Branch value left right) (GoRight:xs) val = Branch value left (traverseTreeTable right xs val)
-}

getTable :: (Tree, Path a, Table) -> Table
getTable (x, y, z) = z

pathGetDirs :: Path a -> [(Direction, Maybe a)]
pathGetDirs EmptyPath = []
pathGetDirs (Path dirs) = dirs
-- pathGetDirs Path _ = []

pathToDirections :: Path a -> [Direction]
pathToDirections EmptyPath = []
pathToDirections (Path dirs) = [dir | (dir, _) <- dirs]

-- Branch Nothing Empty (traverseTreeTable (Branch Nothing Empty Empty) xs val) 

directionsToCode :: [Direction] -> [Atom] -- puts the direction in reverse order because that is how htye are represented in the Path
directionsToCode dirs = case dirs of
    [] -> []
    dirs -> case head dirs of
        GoLeft -> directionsToCode (tail dirs) ++ dit
        GoRight -> directionsToCode (tail dirs) ++ dah

pathToCode :: Path a -> Code
pathToCode path = directionsToCode (pathToDirections path)


-- go throught every node in the tree noting its directions
-- when you get to a leaf add its value and the code corresponding to its directions to the table
-- remove the leaf 
-- repeat until the tree is empty

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
