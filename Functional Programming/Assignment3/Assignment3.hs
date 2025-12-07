-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module Assignment3 (toRose, fromRose, trace, roundRobin, schedule) where

import Types
import Control.Monad.State
import Data.Functor.Identity
import Data.List 

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

{- Question 1 -}

toRose :: Free [] a -> Rose a 
toRose (Pure x) = Lf x
toRose (Free f) = Br (map toRose f)

fromRose :: Rose a -> Free [] a
fromRose (Lf x) = Pure x
fromRose (Br []) = Free []
fromRose (Br (Lf x:xs)) = Free (Pure x : [fromRose y| y <- xs]) -- apparently don't need the (Lf x):xs accorrding to vs code syntax thats fun
fromRose (Br (Br x:xs)) = Free (map fromRose (Br x:xs))

-- for testing
exampleRose :: Rose Int
exampleRose = Br [Lf 1, Br [Lf 2, Lf 3], Lf 4]

{- Question 2 -}

trace :: FreeState s a -> State ([s],s) a
trace fs = undefined
    where 
        ufs = unfree fs -- unfree FreeState to get just the state but s is alread a name for this so a using ufs -- kinda sounds like one of thos tv figth show names

{- Question 3 -}

roundRobin :: [YieldState s ()] -> State s ()
roundRobin = undefined

{- Question 4 -}

schedule :: [SleepState s ()] -> State s ()
schedule = undefined
