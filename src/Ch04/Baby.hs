-- |
-- Module      : Ch04.Baby
-- Description : Chapter 4
-- Copyright   : (c) 2020-2030 Eduardo Ramón Lestau
-- License     : BSD3
-- Stability   : experimental
-- Portability : POSIX
--
-- Syntax in Functions

module Ch04.Baby where

-- * Syntax in Functions
--
-- ** Pattern matching
-- 
-- $patternmatching
--
-- Pattern matching consists of specifying patterns to which some data should
-- conform and then checking to see if it does and deconstructing the data
-- according to those patterns. We can pattern match on any data type.
--
-- When defining functions, we can define separate functions bodies for
-- different patterns.

-- | checks if the number is seven.
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky x = "Sorry, you're out of luck, pal!"

-- $p1
--
-- When you call 'lucky', the patterns will be checked from top to bottom.  The
-- only way to conform with the first pattern is if it is 7. If it's not, it
-- falls to the next pattern, which matches anything and binds it to @x@.

-- | says number from 1 to 5
sayMe :: (Integral a) => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe 4 = "Four!"
sayMe 5 = "Five!"
sayMe x = "Not between 1 and 5"

-- $p2
--
-- We can define the factorial of a number @n@ as @product [1..n]@.  We can
-- also define a factorial function /recursively/, as in mathematics.  We star
-- by saying that the factorial of @0@ is @1@. Then, we state that the
-- factorial of any positive integer is the that integer multiplied by the
-- factorial of its predecessor.

-- | factorial of a positive integer
factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n-1)

-- $p3
--
-- Pattern matching can also fail.

-- | returns a name starting by a letter
--
charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Broseph"
charName 'c' = "Cecil"

-- $p4 
--
-- This function will fail if the input is not expected:
-- 
-- @
-- charName \'a\'
-- \"Albert\"
-- charName \'b\'
-- \"Broseph\"
-- charName \'h\'
-- "*** Exception: src/Ch04/Baby.hs:(66,1)-(68,22): Non-exhaustive patterns in function charName
-- @

-- $p5
--
-- Pattern matching can also be used on tuples.
-- 
-- A function to add two vectors (as tuples) can be defined as:
--
-- @
-- -- | add two vectors
-- addVectors :: (Num a) => (a,a) -> (a,a) -> (a,a)
-- addVectors a b = (fst a + fst b, snd a + snd b)
-- @
--
-- Using a pattern to match a pair can be expressed as @(x,y)@.
-- Version using a pattern matching.

-- | add two vectors as two pairs
addVectors :: (Num a) => (a,a) -> (a,a) -> (a,a)
addVectors (x1,y1) (x2,y2) = (x1 + x2, y1 + y2)

-- $p6
--
-- 'fst' and 'snd' extract the components of pairs. For triplets
-- we can define the functions: 'first', 'second' and 'third'.
--
-- When we don't care about a component we can avoid binding a variable
-- using @_@, as in list comprehension.

-- | first component of a triplet
first :: (a,b,c) -> a
first (x,_,_) = x
-- | second component of a triplet
second :: (a,b,c) -> b
second (_,y,_) = y
-- | third component of a triplet
third :: (a,b,c) -> c
third (_,_,z) = z
