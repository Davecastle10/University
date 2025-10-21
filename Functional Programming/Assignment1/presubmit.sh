#!/bin/sh

if [ "$1" = "" ]
then
    echo "You forgot to add the assignment name: 'Assignment1'."
    echo "Please run the script again with the right argument."
    exit 1
fi

if ! [ -f "$1.hs" ]
then
    echo "File '$1.hs' not found."
    echo "Are you in the correct directory?"
    exit 1
fi

echo "Trying to compile your submission..."

# Create temporary directory
temp_dir=$(mktemp -d)

ghc $1.hs -odir $temp_dir -hidir $temp_dir

if [ $? -ne 0 ]
then
    echo ""
    echo "Your file '$1.hs' did not compile."
    echo "Please fix it before submitting."
    exit 1
fi

if ! [ -f "$temp_dir/$1.o" ]
then
    echo ""
    echo "The module name in '$1.hs' does match not the filename '$1'."
    echo "Please make sure you that"
    echo -e "\t(i) your file is called 'Assignment1.hs'"
    echo -e "\t(ii) you did not change the top of the template"
    echo "and try again."
    exit 1
fi

ghc -XSafe -XNoGeneralizedNewtypeDeriving $1.hs -odir $temp_dir -hidir $temp_dir

if [ $? -ne 0 ]
then
    echo ""
    echo "Your file did not compile with '-XSafe.'"
    echo "Did you remove '{-# LANGUAGE Safe #-}' from the template?"
    exit 1
fi

# Create file for ensuring type signatures have not been modified

cat >> $temp_dir/Signatures.hs << 'END'
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}
module Signatures where

import Assignment1


---------------------------------------------------------------------------------
-- TASK 1
---------------------------------------------------------------------------------

instanceCheck = let g = GridWithAPointer (Grid [[1,2]], [2], 8, [], Grid [[2,2]]) in
                            show g

---------------------------------------------------------------------------------
-- TASK 2
---------------------------------------------------------------------------------


put :: a -> GridWithAPointer a -> GridWithAPointer a
put = Assignment1.put

moveLeft :: GridWithAPointer a -> GridWithAPointer a
moveLeft = Assignment1.moveLeft


moveRight :: GridWithAPointer a -> GridWithAPointer a
moveRight = Assignment1.moveRight

moveUp :: GridWithAPointer a -> GridWithAPointer a
moveUp = Assignment1.moveUp

moveDown :: GridWithAPointer a -> GridWithAPointer a
moveDown = Assignment1.moveDown


---------------------------------------------------------------------------------
-- TASK 3
---------------------------------------------------------------------------------

putTatamiUp :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiUp = Assignment1.putTatamiUp

putTatamiDown :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiDown = Assignment1.putTatamiDown

putTatamiRight :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiRight = Assignment1.putTatamiRight

putTatamiLeft :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiLeft = Assignment1.putTatamiLeft


---------------------------------------------------------------------------------
-- TASK 4
---------------------------------------------------------------------------------

cover :: GridWithAPointer Integer -> GridWithAPointer Integer
cover = Assignment1.cover

END

ghc -XSafe -XNoGeneralizedNewtypeDeriving $temp_dir/Signatures.hs -odir $temp_dir -hidir $temp_dir

if [ $? -ne 0 ]
then
    echo ""
    echo "Your file did not compile with the correct type signatures."
    echo "Did you modify the type signatures or header from the template?"
    exit 1
fi

echo ""
echo "All checks passed."
echo "You are ready to submit!"

# Cleanup temporary directory
rm -r $temp_dir
