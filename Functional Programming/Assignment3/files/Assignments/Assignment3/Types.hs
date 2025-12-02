-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

---------------------------------------------------------------------------------
-------------------------- DO **NOT** MODIFY THIS FILE --------------------------
---------------------------------------------------------------------------------

module Types where

import Control.Monad.State
import Data.Functor.Identity


data Free f a = Pure a
              | Free (f (Free f a)) 

instance Functor f => Functor (Free f) where
  fmap f (Pure a) = Pure (f a)
  fmap f (Free ffa) = Free $ fmap (fmap f) ffa

instance Functor f => Applicative (Free f) where
  pure x = Pure x
  (Pure fab) <*> fa = fmap fab fa 
  (Free ffab) <*> fa = Free $ fmap (<*> fa) ffab

instance Functor f => Monad (Free f) where
  (Pure x) >>= f = f x
  (Free ffa) >>= f = Free $ fmap (>>= f) ffa

liftF :: Functor f => f a -> Free f a
liftF fa = Free (fmap Pure fa)

unfree :: Monad m => Free m a -> m a
unfree (Pure x) = pure x
unfree (Free mfm) = mfm >>= unfree 

{- Question 1 -}

data Rose a = Lf a
            | Br [ Rose a ] 


{- Question 2 -}

type FreeState s a = Free (State s) a

getF :: FreeState s s
getF = liftF get

putF :: s -> FreeState s ()
putF = liftF . put

fibS :: Int -> State (Int,Int) ()
fibS 0 = return ()
fibS n = do fibS (n-1) 
            (x,y) <- get
            put (y,x+y)
            return ()

fibF :: Int -> FreeState (Int,Int) ()
fibF 0 = return ()
fibF n = do fibF (n-1) 
            (x,y) <- getF
            putF (y,x+y)
            return ()

{- Question 3 -}

data FSum f g a = FLeft (f a) | FRight (g a)
  deriving Show
  
deriving instance (Functor f, Functor g) => Functor (FSum f g)

data Yield a = Yield a
  deriving Functor

type YieldState s a = Free (FSum (State s) Yield) a 
                       
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


{- Question 4 -}

data Sleep a = Sleep Int a
  deriving Functor

type SleepState s a = Free (FSum (State s) Sleep) a 
                       
getZ :: SleepState s s
getZ = liftF $ FLeft get

putZ :: s -> SleepState s ()
putZ s = liftF $ FLeft (put s)

sleep :: Int -> SleepState s ()
sleep tm = liftF $ FRight (Sleep tm ())

sleepEx :: SleepState Int ()
sleepEx = do
  i <- getZ
  sleep 100 
  putZ $ i + 1
  pure ()

appendChar :: Char -> SleepState String ()
appendChar c = do
  s <- getZ
  putZ (s ++ [c])

sleepThread1 :: SleepState String ()
sleepThread1 = do
  appendChar 'a' -- 2 steps
  appendChar 'a' -- 2 steps
  sleep 4
  appendChar 'a' -- 2 steps

sleepThread2 :: SleepState String ()
sleepThread2 = do
  sleep 2
  appendChar 'b' -- 2 steps
  appendChar 'b' -- 2 steps

sleepThread3 :: SleepState String ()
sleepThread3 = do
  appendChar 'c' -- 2 steps
  sleep 2
  appendChar 'c' -- 2 steps

sleepExample :: [SleepState String ()]
sleepExample = [sleepThread1, sleepThread2, sleepThread3]
