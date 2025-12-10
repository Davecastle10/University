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

-- think need to use more of the given functions and stuff, could be much better, but think can make work without a full rewrite
roundRobin :: [YieldState s ()] -> State s ()
roundRobin [] = return () -- return when empty list
roundRobin ((Pure x):xs) = roundRobin xs
roundRobin ((Free (FLeft fa)):xs) = do
            g <- fa
            roundRobin (g:xs)
roundRobin ((Free (FRight (Yield g))):xs) = do -- roundRobin (xs:g)
    roundRobin (xs ++ [g])
{-}
roundRobin (x:xs) = do 
    y <- x
    -- result <- unfree x  
    case y of
        Pure val -> roundRobin xs
        Free (FLeft fa) -> do
            g <- fa
            roundRobin (xs ++ [g])
            {-do
            --cState <- get fa -- current state 
            --let (nState, rw) = runState fa cState -- to get the next state
            --returnThings <- putY nState 
            fState <- fa
            roundRobin (xs) -- call roundRobin on rest of list after it has finijhsed executing current stufff
            -}
        Free (FRight (Yield g)) -> roundRobin (xs ++ [g]) -- -> roundRobin (xs ++ [g]) -- put x to reaer of lsit -- should i use the yield function?
-}
-- figure out inputs and stuff
-- figure out how binds and stuff work
-- figure out what inputs should be bound to



charWriter :: Char -> YieldState String ()
charWriter c = do s <- getY
                  if length s > 10 then pure () else
                    do putY (c:s)
                       yield
                       charWriter c

yieldExample :: [YieldState String ()]
yieldExample = [charWriter 'a', charWriter 'b', charWriter 'c']





{- Question 4 -}



-- schedule as re write of round robin
-- need to go through and make it actually obey all the scheduling rules, but it seemed easier to base it off this to start 

schedule :: [SleepState s ()] -> State s ()
schedule [] = return () -- return when empty list
schedule ((Pure _):xs) = schedule xs -- when Pure call schedule on rest of list as this no longer needed
schedule ((Free (FLeft fa)):xs) = do
        g <- fa
        let xs' = map decrementSleep xs
        schedule (g:xs)
schedule ((Free (FRight (Sleep 0 g))):xs) = do -- this is wrong atm, but just wanted a general baseline to get near and then fix
        schedule (g:xs)
        -- schedule (xs ++ [g])  -- need to add some kind of logic allowing for the list to split and other parts to be evaluated?
        -- either that or figeur out a differnt recursive call that maintains list position and keeps correct execution order
schedule xs =
    case nextRunnable xs of
        Nothing -> do schedule (map decrementSleep xs) -- decrement sleeps for everything
        Just (sleepingBefore, runnable, after) ->
            case runnable of
                Free (FLeft fa) -> do
                    g <- fa
                    let others = map decrementSleep (sleepingBefore ++ after)
                    schedule (map decrementSleep sleepingBefore ++ [g] ++ map decrementSleep after)
                Free (FRight (Sleep 0 g)) -> schedule (g : (sleepingBefore ++ after))
                _  -> error "Propaganda, this is Propaganda for THE ORB" -- i really hoep this doesnt actually run, cause errors are annoying
-- need helper function that when encountering sleeping function at star of list goes through list till non sleeping function found
-- executes non sleeping function then returns it's value back up
-- decrements sleep for all things

-- that didn't work beacus need to return state not list of sleep state for helper
-- so instead try splitting list into things sleeping before the next runnable sleepState and the things after
-- then run the runnable sleep state in schedule
-- decrement sleep for all threads  and schedule the things before : ran state : things after 

nextRunnable :: [SleepState s ()] -> Maybe ([SleepState s ()], SleepState s (), [SleepState s ()])
nextRunnable threadsIn = splitThreads [] threadsIn
{-}
    where
        splitThreads sleepingBefore [] = Nothing  -- no runnable thread found
        splitThreads sleepingBefore (Pure _ :xs) = splitThreads sleepingBefore xs -- remove pure stuff as the thread has finished its comppute and call again
        splitThreads sleepingBefore (x@(Free (FLeft fa)):xs) = Just (sleepingBefore, x, xs) -- pass back this val in middle so it gets run next
        splitThreads sleepingBefore (x@(Free (FRight (Sleep 0 g))):xs) = Just (sleepingBefore, x, xs) -- pass back this val so it is taken out of sleep nd run next
        splitThreads sleepingBefore (x@(Free (FRight (Sleep n g))):xs) =  splitThreads (sleepingBefore ++ [x]) xs -- call again on next part of list
-}

-- I could proabbly just replace nexr runnable by calling split threads directly or even just rename split threads to next Runnable?
-- nah, this makes it slighly easier to deal with the inial empty list to the right
-- can't decide if i prefer it split like this or as a sub helper function thingy

splitThreads :: [SleepState s ()] -> [SleepState s ()] -> Maybe ([SleepState s ()], SleepState s (), [SleepState s ()])
splitThreads sleepingBefore [] = Nothing  -- no runnable thread found
splitThreads sleepingBefore (Pure _ :xs) = splitThreads sleepingBefore xs -- remove pure stuff as the thread has finished its comppute and call again
splitThreads sleepingBefore (x@(Free (FLeft fa)):xs) = Just (sleepingBefore, x, xs) -- pass back this val in middle so it gets run next
splitThreads sleepingBefore (x@(Free (FRight (Sleep 0 g))):xs) = Just (sleepingBefore, x, xs) -- pass back this val so it is taken out of sleep nd run next
splitThreads sleepingBefore (x@(Free (FRight (Sleep n g))):xs) =  splitThreads (sleepingBefore ++ [x]) xs -- call again on next part of list

decrementSleep :: SleepState s () -> SleepState s ()
decrementSleep (Free (FRight (Sleep m h))) = Free (FRight (Sleep (max 0 (m-1)) h)) -- sleepy so make less sleepy
decrementSleep x = x -- not sleepy so just return as is

-- prints out "aacabbc"
-- when execState (schedule sleepExample) "" is run
-- but should print "aacbbac"
-- now prints out "aacbbac" as it should do.


