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
traverseTreeTable (Branch Nothing left Empty) path table = (Empty, Path (tail (pathGetDirs path)), table ++ getTable (traverseTreeTable left (Path ((GoLeft, Nothing) : pathGetDirs path)) table))
traverseTreeTable (Branch Nothing Empty right) path table = (Empty, Path (tail (pathGetDirs path)), table ++ getTable (traverseTreeTable right (Path ((GoRight, Nothing) : pathGetDirs path)) table))
traverseTreeTable (Branch Nothing left right) path table = (Branch Nothing Empty right, Path (tail (pathGetDirs path)), table ++ getTable (traverseTreeTable left (Path ((GoLeft, Nothing) : pathGetDirs path)) table) ++ getTable (traverseTreeTable right (Path ((GoRight, Nothing) : pathGetDirs path)) table))

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

traverseTreeTable (Branch (Just char) left Empty) path table = (Empty, path, (char, pathToCode path) : table ++ getTable (traverseTreeTable left (Path ((GoLeft, Just char) : pathGetDirs path)) table))
traverseTreeTable (Branch (Just char) Empty right) path table = (Empty, path, (char, pathToCode path) : table ++ getTable (traverseTreeTable right (Path ((GoRight, Just char) : pathGetDirs path)) table))
traverseTreeTable (Branch (Just char) left right) path table = (Empty, path, (char, pathToCode path) : table ++ getTable (traverseTreeTable left (Path ((GoLeft, Just char) : pathGetDirs path)) table) ++ getTable (traverseTreeTable right (Path ((GoRight, Just char) : pathGetDirs path)) table))

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
tree xs
    | not (checkString xs 0 0 0 0) = Nothing
tree xs = case parse xs 0 0 of
    Just (bracket, _) -> Just bracket   -- Return the parsed Bracket, ignoring the Int
    Nothing          -> Nothing          -- Return Nothing if parsing fails


-- doesnt work cause it thinks tree "(()" is valid

parse :: String -> Int -> Int ->  Maybe (Bracket, Int) -- there is an issue with recursion depth more than 3/4 i think
parse [] _ _ = Nothing
parse xs _ _
    | xs == "()" = Just (Round [], 1)
    | xs == "{}" = Just (Curly [], 1)
-- parse (')':_) _ _ = Nothing
-- parse ('}':_) _ _ = Nothing
parse string@(x : xs) depthRound depthCurly
    | x == '(' = parseInner xs (depthRound + 1) depthCurly [] Round -- parse the inner part of the function wehn staring with round brakcets and increase the depth to show tht another round bracket has been found that needs to be mathced
    | x == '{' = parseInner xs depthRound (depthCurly + 1) [] Curly -- above but for the curly fun ones
    -- | x == ')' && depthRound > 0 =  Just (Round [], 1)  -- case for cloasing losing Round bracket   error "test3" --
    -- | x == '}' && depthCurly > 0 = Just (Curly [], 1)  -- above but for the curly fun ones    error "test4" --
    | x == ')' || x == '}' =  Nothing  -- Invalibad closing bracket
    | otherwise = Nothing  -- bad  character

-- Inner parsing loop to gather elements

-- still can't fix the issue with it appending more Brackets [] to the end of a completee tree even with using erros to step throught the code and find where ti fails
-- would require mostly complete reqwrit which don't have time for.
parseInner :: String -> Int -> Int -> [Bracket] -> ([Bracket] -> Bracket) -> Maybe (Bracket, Int)
parseInner [] _ _ _ _ = Nothing -- this line ande the final line are the issues -- think fixed
parseInner xs depthRound depthCurly brackets constructor
    | length xs == 1 = parse xs depthRound depthCurly -- 
    | otherwise =   case parse' xs depthRound depthCurly of -- see if can fix this so doesn'tneed to return nothing whe want to terminate bracket
                        -- Nothing -> Just (constructor (reverse brackets), length xs) -- Nothing -- Construct final bracket 
                        Nothing -> helper xs depthRound depthCurly brackets constructor -- error "test5" --
                        --Just (Round rs, n) ->  Just( fst (unMaybe (parseInner (drop n xs) (depthRound - 1) depthCurly (Round rs : brackets) constructor)), n) -- error "test" --
                        Just (Round rs, n) -> parseInner (drop n xs) (depthRound - 1) depthCurly (Round rs : brackets) constructor -- error "test" --
                        Just (Curly cs, n) -> parseInner (drop n xs) depthRound (depthCurly - 1) (Curly cs : brackets) constructor -- error "test2" --
    where
        helper :: String -> Int -> Int -> [Bracket] -> ([Bracket] -> Bracket) -> Maybe (Bracket, Int) -- this is the issue
        helper [] _ _ _ _  = Nothing
        helper (x:xs) depthRound depthCurly brackets constructor
            | x == ')' || x == '}' =  Just (constructor (reverse brackets), length xs) -- this is the problem can't be nothing but by returning a bracket am adding stuff to the back unnescarily
            | x == ')' && depthRound == 0 =  Nothing
            | x == '}' && depthCurly == 0 =  Nothing
            | otherwise = Nothing


parse' :: String -> Int -> Int ->  Maybe (Bracket, Int)
parse' [] _ _ = Nothing
parse' xs _ _
    | xs == "()" = Just (Round [], 1)
    | xs == "{}" = Just (Curly [], 1)
parse' string@(x : xs) depthRound depthCurly
    | x == '(' = parseInner xs (depthRound + 1) depthCurly [] Round -- parse the inner part of the function wehn staring with round brakcets and increase the depth to show tht another round bracket has been found that needs to be mathced
    | x == '{' = parseInner xs depthRound (depthCurly + 1) [] Curly -- above but for the curly fun ones
    -- | x == ')' && depthRound > 0 =  Just (Round [], 1)  -- case for cloasing losing Round bracket
    -- | x == '}' && depthCurly > 0 = Just (Curly [], 1)  -- above but for the curly fun ones
    | x == ')' || x == '}' =  Nothing  -- Invalibad closing bracket
    | otherwise = Nothing  -- bad  character

-- ({})
-- parseInner "{})" 1 0 [] Round
    -- parse "{})" 1 0 -> parseInner "})" 1 1 [] Curly
        -- parse "})" 1 1 -> Just (Curly [], 1)
    -- parseInner ("})") 1 0 [Curly []] Round
        -- parse "})" 1 0 -> Just (Curly [], 1)
        -- parseInner ")" 1 0 [Curly []] Round
            -- parse ")" 1 0 -> Just (Round [], 1)


checkString :: String -> Int -> Int -> Int -> Int -> Bool
checkString [] numOpenRound numClosedRound numOpenCurly numClosedCurly = numOpenRound == numClosedRound && numOpenCurly == numClosedCurly
checkString string@(x:y:xs) numOpenRound numClosedRound numOpenCurly numClosedCurly
    | length string > 1 && take 2 string == "{)" = False
    | length string > 1 && take 2 string == "(}" = False
checkString string@(x:xs) numOpenRound numClosedRound numOpenCurly numClosedCurly
    | null string && (numOpenRound - numClosedRound == 0) && (numOpenCurly - numClosedCurly == 0) = True
    | null string = False
    | x == '(' = checkString xs (numOpenRound + 1) numClosedRound numOpenCurly numClosedCurly
    | x == ')' = checkString xs numOpenRound (numClosedRound + 1) numOpenCurly numClosedCurly
    | x == '{' = checkString xs numOpenRound numClosedRound (numOpenCurly + 1) numClosedCurly
    | x == '}' = checkString xs numOpenRound numClosedRound numOpenCurly (numClosedCurly + 1)
    | otherwise = False


-- {})
-- parseInner "})" 1 1 [] Round
-- cas parse "})"  1 1 -> Just (Curly [], 1)
    -- parseInner ")" 1 1 [Curly []]

-- not work because run parse, find '('
-- then call parse inner on ')' with depthRound 1
-- then parse inner does parse again which returns Just (Round [], 1)
-- which means it calls parseInner again but drops 1 from xs, so is calling on empty list, so returns Nothing


-- need to iterate through string counting up the brackets and then break into sub trees
--      - need to make a helper function to split up the string into substrings
--            - better if the sub function can be run int he recursive call in the tree function
-- repeat recursivelly over the sub trees - it doesnt have to be binary amoun of sub trees
-- recombine the Brakcet data type recursively

isWellBracketed :: String -> Bool
isWellBracketed xs = case tree xs of
                      Nothing -> False
                      Just _  -> True
