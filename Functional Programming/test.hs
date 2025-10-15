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
doubleAndTen 