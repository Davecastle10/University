import Data.List

test1 = [[1,2,3],[2,3,4]]

split :: Eq a => [a] -> [a] -> [[a]]
split delim xs = filter (not . null) (splitHelper xs)
  where
    splitHelper [] = [[]] -- if empty list make list of empty list for nice base case
    splitHelper ys@(y:ys') -- make ys into y (the head of ys) and ys' the rest of ys the @ symbol usage is really cool, it makes this sort of stuff way eaier
      | delim `isPrefixOf` ys = [] : splitHelper (drop (length delim) ys) -- if the deliminator is the prefix of ys the drop it and call the function again
      | otherwise = let (h:t) = splitHelper ys' in (y:h) : t -- calls split helper recursively on the tail of ys then recmobines as it backtracks throught the recursive call
