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
fromRose (Lf x) = Pure x -- recursive base cases
fromRose (Br []) = Free []
fromRose (Br (Lf x:xs)) = Free (Pure x : [fromRose y| y <- xs]) -- apparently don't need the (Lf x):xs accorrding to vs code syntax thats fun
fromRose (Br (Br x:xs)) = Free (map fromRose (Br x:xs))

-- for testing
exampleRose :: Rose Int
exampleRose = Br [Lf 1, Br [Lf 2, Lf 3], Lf 4]

{- Question 2 -}


trace :: FreeState s a -> State ([s],s) a
trace (Pure val) = return val -- recursive base case
trace (Free fs) = do
    (states, cState) <- get -- get states
    let (nFree, nState) =  runState fs cState -- run the state stuff so cando next bit with the next Free monad and the next State
    put (nState : states, nState) -- collect the states into the otuput list of step staets putting th next state at the front (i tried with current state but then you get tqo (0,1) and no (5,8) in the list) and the final/next state like saveState form attempt 1 but better as the second part of the tuple

    case nFree of
        Pure val -> return val -- I hate the silly auto fill (is it auto fill or auto complete, not sure what the diffenrce is but its anoying) thingy always changes values like x to xargs, now i remeber why i used val last nigth so it doesnt mess around liek this
        Free ifs -> do -- where we actually do the funky recursion bit
            trace $ Free ifs

-- it was worth spending like 3 hours thsi morning going over thoses lecture notes agin.


-- bannish this code to the shadow realm
{-}
    where
        ufs = unfree fs -- unfree FreeState to get just the state but s is alread a name for this so a using ufs -- kinda sounds like one of thos tv figth show names
        ufsTraced = do
            cState <- getF    -- current state
            saveState cState -- save the current state with staveState helper func 

            case ufs of
                Pure val -> return val -- if the resulting value of the unwrapped FreeState is a Pure value return it
                Free stuff -> do -- need to do more stuff to handle when it is a Free thing , moands are confusing
                                 -- might end up changin pproach later as this is not fun to get working.

        -- helpies are great
        saveState state = do -- function to save the state to a list like needed
            modify (\(states, current) -> (state : states, current)) -- save the state to a list, feel like i should also say that it puts it in the structure of the return type in the function declaration cause otherwise i will forget by the morning and then have to spend ages undersradning what 3am me did again.
-}


{- Question 3 -}

-- data FSum f g a = FLeft (f a) | FRight (g a)
-- type YieldState s a = Free (FSum (State s) Yield) a 
{-}
getY :: YieldState s s
getY = liftF $ FLeft get

putY :: s -> YieldState s ()
putY s = liftF $ FLeft (put s)

yield :: YieldState s ()
yield = liftF $ FRight (Yield ())

yieldEx :: YieldState Int ()
yieldEx = do
  i <- getY
  yield
  putY $ i + 1
  pure ()
-}

-- think need to use more of the given functions and stuff, could be much better, but think can make work without a full rewrite
roundRobin :: [YieldState s ()] -> State s ()
roundRobin [] = return () -- return when empty list
roundRobin (x:xs) = do 
    y <- getY x
    -- result <- unfree x  
    case y of
        Pure val -> roundRobin xs
        Free (FLeft fa) -> do
            cState <- get
            (a, nState) <- runState fa cState
            put nState 
            roundRobin (xs:x) -- put x to reaer of lsit
        Free (FRight (Yield _)) -> roundRobin (xs:x) -- put x to reaer of lsit -- should i use the yield function?

-- is probably going to return an incorrect type aswell, but just want to be able to return something would be nice

{- Question 4 -}

schedule :: [SleepState s ()] -> State s ()
schedule = undefined
