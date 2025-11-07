-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

---------------------------------------------------------------------------------
-------------------------- DO **NOT** MODIFY THIS FILE --------------------------
---------------------------------------------------------------------------------

module Types where

data Atom = Beep | Silence
  deriving (Eq, Show)

type Code = [Atom]

dit, dah, shortGap, mediumGap :: Code
dit       = [Beep, Silence]
dah       = [Beep, Beep, Beep, Silence]
shortGap  = replicate (3-1) Silence
mediumGap = replicate (7-1) Silence

morseCode :: Char -> Code
morseCode 'A' = dit ++ dah
morseCode 'B' = dah ++ dit ++ dit ++ dit
morseCode 'C' = dah ++ dit ++ dah ++ dit
morseCode 'D' = dah ++ dit ++ dit
morseCode 'E' = dit
morseCode 'F' = dit ++ dit ++ dah ++ dit
morseCode 'G' = dah ++ dah ++ dit
morseCode 'H' = dit ++ dit ++ dit ++ dit
morseCode 'I' = dit ++ dit
morseCode 'J' = dit ++ dah ++ dah ++ dah
morseCode 'K' = dah ++ dit ++ dah
morseCode 'L' = dit ++ dah ++ dit ++ dit
morseCode 'M' = dah ++ dah
morseCode 'N' = dah ++ dit
morseCode 'O' = dah ++ dah ++ dah
morseCode 'P' = dit ++ dah ++ dah ++ dit
morseCode 'Q' = dah ++ dah ++ dit ++ dah
morseCode 'R' = dit ++ dah ++ dit
morseCode 'S' = dit ++ dit ++ dit
morseCode 'T' = dah
morseCode 'U' = dit ++ dit ++ dah
morseCode 'V' = dit ++ dit ++ dit ++ dah
morseCode 'W' = dit ++ dah ++ dah
morseCode 'X' = dah ++ dit ++ dit ++ dah
morseCode 'Y' = dah ++ dit ++ dah ++ dah
morseCode 'Z' = dah ++ dah ++ dit ++ dit
morseCode '1' = dit ++ dah ++ dah ++ dah ++ dah
morseCode '2' = dit ++ dit ++ dah ++ dah ++ dah
morseCode '3' = dit ++ dit ++ dit ++ dah ++ dah
morseCode '4' = dit ++ dit ++ dit ++ dit ++ dah
morseCode '5' = dit ++ dit ++ dit ++ dit ++ dit
morseCode '6' = dah ++ dit ++ dit ++ dit ++ dit
morseCode '7' = dah ++ dah ++ dit ++ dit ++ dit
morseCode '8' = dah ++ dah ++ dah ++ dit ++ dit
morseCode '9' = dah ++ dah ++ dah ++ dah ++ dit
morseCode '0' = dah ++ dah ++ dah ++ dah ++ dah
morseCode  _  = undefined -- Avoid warnings

type Table = [(Char, Code)]

morseTable :: Table
morseTable = [ (c , morseCode c) | c <- ['A'..'Z']++['0'..'9'] ]

data Tree = Empty
          | Branch (Maybe Char) Tree Tree
  deriving (Eq, Show)

data Bracket = Round [Bracket] | Curly [Bracket] deriving (Show,Eq)


-- Added for marking purposes
-- A modification of morseCode
markingCode :: Char -> Code
markingCode 'A' = dah ++ dah ++ dit ++ dit
markingCode 'B' = dah ++ dit ++ dah ++ dah
markingCode 'C' = dit ++ dah ++ dah
markingCode 'D' = dit ++ dit ++ dit ++ dah
markingCode 'E' = dit ++ dit ++ dit
markingCode 'F' = dit
markingCode 'G' = dah ++ dah ++ dit
markingCode 'H' = dit ++ dit ++ dit ++ dit
markingCode 'I' = dit ++ dit
markingCode 'J' = dah ++ dit
markingCode 'K' = dah ++ dit ++ dah
markingCode 'L' = dit ++ dah ++ dit ++ dit
markingCode 'M' = dah
markingCode 'N' = dit ++ dah ++ dah ++ dah
markingCode 'O' = dah ++ dah ++ dah
markingCode 'P' = dit ++ dah ++ dit
markingCode 'Q' = dah ++ dah ++ dit ++ dah
markingCode 'R' = dit ++ dah ++ dah ++ dit
markingCode 'S' = dit ++ dit ++ dah ++ dit
markingCode 'T' = dah ++ dah
markingCode 'U' = dit ++ dit ++ dah
markingCode 'V' = dah ++ dit ++ dit
markingCode 'W' = dah ++ dit ++ dah ++ dit
markingCode 'X' = dah ++ dit ++ dit ++ dah
markingCode 'Y' = dah ++ dit ++ dit ++ dit
markingCode 'Z' = dit ++ dah
markingCode '1' = dah ++ dah ++ dah ++ dah ++ dah
markingCode '2' = dah ++ dah ++ dah ++ dah ++ dit
markingCode '3' = dah ++ dah ++ dah ++ dit ++ dit
markingCode '4' = dah ++ dah ++ dit ++ dit ++ dit
markingCode '5' = dah ++ dit ++ dit ++ dit ++ dit
markingCode '6' = dit ++ dit ++ dit ++ dit ++ dit
markingCode '7' = dit ++ dit ++ dit ++ dit ++ dah
markingCode '8' = dit ++ dit ++ dit ++ dah ++ dah
markingCode '9' = dit ++ dit ++ dah ++ dah ++ dah
markingCode '0' = dit ++ dah ++ dah ++ dah ++ dah
markingCode  _  = undefined -- Avoid warnings

markingTable :: Table
markingTable = [ (c , markingCode c) | c <- ['A'..'Z']++['0'..'9'] ]
