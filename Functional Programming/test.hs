import Data.Char

double :: Int -> Int
double x = x + x

orB :: Bool -> Bool -> Bool
orB a b | a == True = True
        | b == True = True
        | otherwise = False

swap :: (a,b) -> (b,a)
swap (x, y) = (y, x)

unwrap' :: [a] -> [a]
unwrap' [] = []
unwrap' xs = reverse(tail(reverse(tail xs)))

reverseLength :: Int -> [a] -> [a]
reverseLength x ys = if length(ys) > x then reverse(ys) else ys

doubleAndTen :: [Int] -> [Int]
doubleAndTen (x:xs) = [ x*2 | x <- xs , x*2 > 10]

reverseUpper :: String -> String
reverseUpper  = (map toUpper) . reverse


indexPair :: [a] -> [(a,Int)]
indexPair xs = [ (x,i) | (x, i) <- zip xs [0..]]

greatIsh :: Int -> Int -> Bool
greatIsh a b    | b < a && a < 2*b = True
                | otherwise = False

--third :: [a] -> a
--third [] = 
--third (x:xs) = third xs -- this will repeat but need to make it so that we only get the third element.