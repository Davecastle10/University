# Assignment 3

To solve the assignment, please copy the file `Assignment3-Template.hs` to a new file called `Assignment3.hs` and write your solutions in `Assignment3.hs`.

**Don't change the header of this file, _including the module declaration_, and, moreover, _don't_ change the
type signature of any of the given functions for you to complete.**

Run the pre-submit script to check for any (compilation) errors **before** submitting by running in the vLab terminal:
  ```bash
  $ ./presubmit.sh Assignment3
  ```

If this fails, you are not ready to submit, and any submission that doesn't pass the presubmit test on vLab is not eligible for marking.

Submit your file `Assignment3.hs` via Canvas.

# The Free Monad 

The *free monad* is a construction which produces a monad out of an
arbitrary functor `f`.

```hs 
data Free f a = Pure a
              | Free (f (Free f a)) 
			  
instance Functor f => Monad (Free f) where
  (Pure x) >>= f = f x
  (Free ffa) >>= f = Free $ fmap (>>= f) ffa
```

**Note**. Information about the `Functor` type class can be 
found in the lecture note on [Monads](../../LectureNotes/Sections/monads.md) as 
well as in [Problem Sheet 9](../../ProblemSheets/ProblemSheet-Week9.md).

This construction comes with a canonical way of lifting a value of type `f a` to one of 
type `Free f a`: 

```hs 
liftF :: Functor f => f a -> Free f a
liftF fa = Free (fmap Pure fa)
```

If we apply the `Free` construction to a type constructor `m` which is *already* a `Monad`, then we additionally have a map in the other direction:

```hs
unfree :: Monad m => Free m a -> m a
unfree (Pure x) = pure x
unfree (Free mfm) = mfm >>= unfree 
```

The `unfree` construction provides us with a bit of intuition about what the `Free` construction is useful for.  We see that every instance of the `Pure` constructor is mapped to an actual call to the `pure` function of `m`, and every instance of the `Free` constructor is mapped to a call to the `>>=` operator.

So while an element of type `m a` can be thought of as a computation running in the monad `m`, an element of type `Free m a` is rather **data** which records the *steps taken* by such a computation. To actually *run* this computation, we turn the data describing the computation back into calls to the actual computation using the `unfree` function.

One reason for doing this is that when we have the data, or syntax, describing a computation, we can then run that computation in *different way* by interpreting it differently.  We'll now explore this idea in the second Exercise below.

# Rose Trees as an Example of Free 

As a first example, consider the following type of finitely branching trees with data stored at the leaves:

```hs
data Rose a = Lf a
            | Br [ Rose a ] 
```

### Task 1 

Show that this type is "isomorphic" to `Free [] a` by writing functions

```hs
toRose :: Free [] a -> Rose a 
toRose = undefined 
```

and 

```hs
fromRose :: Rose a -> Free [] a
fromRose = undefined 
```

Your functions should have the propery that:

1. For all `Rose` trees `r`, we have `toRose (fromRose r) == r`
1. For all elements `f` of type `Free [] a` we have `fromRose (toRose f) == f` 

# Tracing a Stateful Computation

Let's consider what happens when we look at the `Free` construction applied to the `State` monad:

```hs
type FreeState s a = Free (State s) a
```

Using the `liftF` function we wrote above, we can turn the usual `get` and `put` operations 
of the `State` monad into identical operations of the `FreeState` monad:

```hs
getF :: FreeState s s
getF = liftF get

putF :: s -> FreeState s ()
putF = liftF . put
```

Here, for example, is the efficient implementation of the [Fibonacci function](../../LectureNotes/LiveCoding/monads2.hs), lifted to the `FreeState` monad:

```hs
fibF :: Int -> FreeState (Int,Int) ()
fibF 0 = return ()
fibF n = do fibF (n-1) 
            (x,y) <- getF
            putF (y,x+y)
            return ()
```

### Task 2

Implement a function 

```hs
trace :: FreeState s a -> State ([s],s) a
trace = undefined
```

which, in addition to running the original output, also *records all the intermediate states* which occur during the computation.

For example, the original Fibonacci computation produces the last two Fibonacci numbers as a final state when run:

```
λ> execState (fibS 5) (0,1)
(5,8)
```

But the new version, when traced, shows all the immediate states which arise during this computation:

```
λ> execState (trace $ fibF 5) ([],(0,1))
([(5,8),(3,5),(3,5),(2,3),(2,3),(1,2),(1,2),(1,1),(1,1),(0,1)],(5,8))
```

Note, each state occurs twice (except the initial one) because there are *two* steps in each recursive call to `fibF`: the `get`, which does not modify the state, and the `put` which does.  In other words, we record the state after every occurence of the `>>=` operator (which corresponds to a line of `do` notation) whether or not that line modifies the state itself.

# Round-Robin Scheduling of Stateful Computations 

Since the `Free` monad turns monadic computations into data, if we have a list of such computations, we can run them in any order we choose, possibly interleaving their actions.  This leads to the idea of using the `Free` monad to implement a *scheduler* for light-weight threads.

To implement this idea, let's start with the following simple data type:

```hs
data Yield a = Yield a
  deriving Functor
```

By applying the `Free` construction to the **sum** of this datatype (see [Problem Sheet 9](../../Problemheets/ProblemSheet-Week9.md))  with the `State` monad, we obtain a monad which can take steps consisting 
of **either** a stateful computation **or** a yield command.

```hs
type YieldState s a = Free (FSum (State s) Yield) a 
                       
getY :: YieldState s s
getY = liftF $ FLeft get

putY :: s -> YieldState s ()
putY s = liftF $ FLeft (put s)

yield :: YieldState s ()
yield = liftF $ FRight (Yield ())
```

Here is an example of what such a computation looks like:

```hs
yieldEx :: YieldState Int ()
yieldEx = do
  i <- getY
  yield
  putY $ i + 1
  pure ()
```

### Task 3

Write a function 

```hs
roundRobin :: [YieldState s ()] -> State s ()
roundRobin = undefined 
```

which takes a list of these possibly yielding stateful computations, and schedules them in a round-robin fashion.  That is:

1. When the list is empty, we return 
1. When a compution finishes with a `Pure` that process is removed from the list.
1. The first computation on the list runs until it encounters a `yield`, at which point it is moved to 
   the back and computation continues with the next process in the list.

For an example, consider the following "thread":

```hs
charWriter :: Char -> YieldState String ()
charWriter c = do s <- getY
                  if (length s > 10) then pure () else
                    do putY (c:s)
                       yield
                       charWriter c 
```

Each time the thread wakes up, it reads the current state, and if the length of the string is greater than `10`, exits.  Otherwise, it writes its own specified character to the front of the current string, yields, and then starts over again.

If we create a list of these, each with a different character as so:

```hs
yieldExample :: [YieldState String ()]
yieldExample = [charWriter 'a', charWriter 'b', charWriter 'c'] 
```

We should get the following:

```
ghci> execState (roundRobin yieldExample) "" 
"bacbacbacba"
```

# Stateful Computations which can Sleep 

Let's now make this more interesting by allowing our computations to go to sleep for a fixed number of steps:

```hs
data Sleep a = Sleep Int a
  deriving Functor
```

In a computation `Sleep n`, the `n` is interpreted as a number of scheduler steps to wait (not a real time interval) before the task becomes runnable again.  See below.

We have similar setup to before:

```hs
type SleepState s a = Free (FSum (State s) Sleep) a 
                       
getZ :: SleepState s s
getZ = liftF $ FLeft get

putZ :: s -> SleepState s ()
putZ s = liftF $ FLeft (put s)

sleep :: Int -> SleepState s ()
sleep tm = liftF $ FRight (Sleep tm ())
```


### Task 4

Implement a function 

```hs
schedule :: [SleepState s ()] -> State s ()
schedule = undefined
```

which allows stateful computations to sleep for a fixed number of steps.  This function should 
obey the following rules

1. Each of the provided threads will keep a "sleep counter"
1. When all programs are sleeping, the scheduler advances time by one step, decrementing the sleep counters of all the threads
1. Otherwise, the scheduler should select the first thread in the list whose sleep counter is at 0 and run this thread.  (**Note** This means that the threads should be kept in a fixed order, unlike the Round-Robin scheduler, and the first thread in the list has the highest priority).
1. The thread the continues running, decrementing the *other* threads' sleep counters with each step, until the thread itself sleeps or exits.
1. When the active thread sleeps its sleep counter is set to the specified value (which you may assume is always a positive integer), we recalculate the next thread to run as above
1. Threads which exit are removed from the list 
1. When the list of running threads is empty, the computation returns
1. Note that each instruction in the `State` monad counts as a single step, but `Sleep` instructions themselves do not.

For example, consider the following three "threads" (these are available in the `Type.hs` file) 

```hs
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
```

Running your scheduler should produce the following:

```
ghci> execState (schedule sleepExample) ""
"aacbbac"
```
