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
newtype Grid a = Grid { grid :: [[a]] } deriving Eq

instance (Show a) => Show (Grid a) where
  show (Grid g)
    | null g = ""
    | otherwise = unlines (map showRow g) -- take the lists in grid run show row on each list/row then use unlines to print line by line.
    where
      strGrid = map (map show) g -- get the string for the list
      colWidths = [maximum (map visibleLength col) | col <- transpose strGrid]
      showRow row = unwords [padRight w s | (w, s) <- zip colWidths (map show row)]
      padRight n s = s ++ replicate (n - visibleLength s) ' '

transpose :: [[a]] -> [[a]]
transpose [] = []
transpose ([]:_) = []
transpose x = map head x : transpose (map tail x)
