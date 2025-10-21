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