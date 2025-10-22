show (GridWithAPointer(Grid gu, l, pointer, r, Grid gl))
          | null l && null r = ""
          | otherwise = show (Grid gu) ++ unwords strGridListLeft ++ " " ++ "\ESC[44m" ++ show pointer ++ "\ESC[0m"  ++ " " ++ unwords strGridListRight ++ "\n" ++ show (Grid gl)
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
              strGridListLeft = ((map show) l)
              strGridListRight = ((map show) r) 
              strGridLower =   replace (unwords ((map show) gl))
              -- show (Grid gu)



-- figure out how this works properly

stripANSI :: String -> String -- strips the non displayed stuff e.g. the blue text highlighting
stripANSI [] = []
stripANSI ('\ESC':'[':xs) = stripANSI (drop 1 (dropWhile (not . isLetter) xs))
stripANSI (x:xs) = x : stripANSI xs

visibleLength :: String -> Int
visibleLength = length . stripANSI

newtype Grid a = Grid { grid :: [[a]] } deriving Eq

instance (Show a) => Show (Grid a) where
  show (Grid g)
    | null g = ""
    | otherwise = unlines (map showRow g) -- take the lists in grid run show row on each list/row then use unlines to print line by line.
    where
      strGrid = map (map show) g -- get the string for the list
      colWidths = [maximum (map visibleLength col) | col <- transpose strGrid] -- transposes the grid so it can run in a lsit of the column rather than row, and then makes a lsit of the width of each column
      showRow row = unwords [padRight w s | (w, s) <- zip colWidths (map show row)] -- creates list of items from row with padding to their right, and then runs unwords on them to create a string
      padRight n s = s ++ replicate (n - visibleLength s) ' ' -- takes the element from the row and pads to the left of it with spaces equal to the colwidth-visible length of the row when printed

transpose :: [[a]] -> [[a]]
transpose [] = []
transpose ([]:_) = []
transpose x = map head x : transpose (map tail x)







replace' :: String -> String
              replace' [] = []
              replace' (x:xs)
                  | x == '[' && not (null xs) && head xs == ',' = '[' : replace' (tail xs)  -- Replace "[," with "["
                  | x == '\\'  = replace' xs  -- Remove '\\' which means remove '\' but need to do '\\'
                  | x == '"'  = replace' xs  -- Remove '"' 
                  -- | x == "[,"  = '[' : replace' xs  -- Remove ','
                  | otherwise = x : replace' xs    -- Keep other characters unchanged