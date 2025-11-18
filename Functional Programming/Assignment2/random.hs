
import Types
import Data.List
test1 = [[1,2,3],[2,3,4]]

split :: Eq a => [a] -> [a] -> [[a]]
split delim xs = filter (not . null) (splitHelper xs)
  where
    splitHelper [] = [[]] -- if empty list make list of empty list for nice base case
    splitHelper ys@(y:ys') -- make ys into y (the head of ys) and ys' the rest of ys the @ symbol usage is really cool, it makes this sort of stuff way eaier
      | delim `isPrefixOf` ys = [] : splitHelper (drop (length delim) ys) -- if the deliminator is the prefix of ys the drop it and call the function again
      | otherwise = let (h:t) = splitHelper ys' in (y:h) : t -- calls split helper recursively on the tail of ys then recmobines as it backtracks throught the recursive call

testList = [Beep,Silence,Beep,Beep,Beep,Silence,Beep,Silence,Beep,Silence]

data Direction = GoLeft | GoRight deriving (Show, Eq)

-- error "it's dah propaganda you get me"
-- convert a code to a list of directions
ditdahSplit :: [Atom] -> [Direction]
ditdahSplit code = case code of 
    [] -> [] -- emoty code
    code -> case matchCode'' code of -- non empty code
        Just signal -> (if signal == "dit" then GoLeft else GoRight) : ditdahSplit (drop (length (getCode signal)) code) -- if the driection
        Nothing -> ditdahSplit (tail code)


matchCode :: [Atom] -> Maybe String
matchCode code -- this not working
    | code == dit = Just "dit"
    | code == dah = Just "dah"
    | otherwise = Just "Nothing"

{-}
matchCode' :: [Atom] -> Maybe String
matchCode' code@(x:y:z:xs)
    | length code >= 2 = (if [x] ++ [y] == dit then Just "dit" else (if length code >= 3 then (if [x] ++ [y] ++ [z] == dah then Just "dit" else Nothing) else Nothing))
    | otherwise = Nothing
-}

matchCode'' :: [Atom] -> Maybe String
matchCode'' code
    | length code >= 4 && take 4 code == dah = Just "dah"
    | length code >= 2 && take 2 code == dit = Just "dit"
    | otherwise = Nothing


getCode :: String -> [Atom]
getCode str
    | str == "dit" = [Beep, Silence]
    | str == "dah" = [Beep, Beep, Beep, Silence]
    | otherwise = []




stringTest :: String -> Char
stringTest string = last string

-- t6 attempt 1

tree :: String -> Maybe Bracket
tree string = parse string 0

parse :: String -> Int ->  Maybe Bracket
parse [] _ = Nothing
parse (')':_) _ = Nothing
parse ('}':_) _ = Nothing
pare string@(x : xs)
    | x == '(' = Just (helperFuncRound (take (length xs -1) xs))
    | x == '{' = Just (helperFuncCurly (take (length xs -1) xs))
    | otherwise = Nothing

helperFuncRound :: String -> Int -> Bracket
helperFuncRound = undefined

helperFuncCurly :: String -> Int -> Bracket
helperFuncCurly = undefined


-- bad code banished to the random realm

tree :: String -> Maybe Bracket
tree xs = case parse xs 0 of
    Just (bracket, _) -> Just bracket   -- Return the parsed Bracket, ignoring the Int
    Nothing          -> Nothing          -- Return Nothing if parsing fails


-- doesnt work cause it thinks tree "(()" is valid

parse :: String -> Int ->  Maybe (Bracket, Int)
parse [] _ = Nothing
parse (')':_) _ = Nothing
parse ('}':_) _ = Nothing
parse string@(x : xs) depth
    | x == '(' = parseInner xs (depth + 1) [] Round -- parse the inner part of the function wehn staring with round brakcets and increase the depth to show tht another round bracket has been found that needs to be mathced
    | x == '{' = parseInner xs (depth + 1) [] Curly -- above but for the curly fun ones
    | x == ')' && depth > 0 = Just (Round [], 1)  -- case for cloasing losing Round bracket
    | x == '}' && depth > 0 = Just (Curly [], 1)  -- above but for the curly fun ones
    | x == ')' || x == '}' = Nothing  -- Invalibad closing bracket
    | otherwise = Nothing  -- bad  character

{-}
    | x == '(' = Just (helperFuncRound (take (length xs -1) xs))
    | x == '{' = Just (helperFuncCurly (take (length xs -1) xs))
-}

-- Inner parsing loop to gather elements
parseInner :: String -> Int -> [Bracket] -> ([Bracket] -> Bracket) -> Maybe (Bracket, Int)
parseInner [] _ _ _ = Nothing
parseInner xs depth brackets constructor =
    case parse xs depth of
        Nothing -> Just (constructor (reverse brackets), length xs)  -- Construct final bracket -- its this line that isn't rigth, cause of the way it handles nothing
        -- migth need to start from scratch
        Just (b, n) -> parseInner (drop n xs) depth (b : brackets) constructor -- 

