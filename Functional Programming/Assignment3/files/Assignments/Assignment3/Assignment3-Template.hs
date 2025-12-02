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
toRose = undefined

fromRose :: Rose a -> Free [] a
fromRose = undefined

{- Question 2 -}

trace :: FreeState s a -> State ([s],s) a
trace = undefined

{- Question 3 -}

roundRobin :: [YieldState s ()] -> State s ()
roundRobin = undefined

{- Question 4 -}

schedule :: [SleepState s ()] -> State s ()
schedule = undefined
