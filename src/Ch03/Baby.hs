-- |
-- Module      : Ch03.Baby
-- Description : Chapter 3
-- Copyright   : (c) 2020-2030 Eduardo Ramón Lestau
-- License     : BSD3
-- Stability   : experimental
-- Portability : POSIX
--
-- Types and Typeclasses annotations with code

module Ch03.Baby where

-- * Type and Typeclasses
--
-- ** Believe the type
-- 
-- $type
--
-- Haskell has a static type system. The type of every expression is known at
-- compiler time, which lead to safer code. Haskell has type inference.  A type
-- is a kind of label that every expression has. In @GHCI@ we can use the
-- command @:t@ followed by a valid expression to know its type.  Types are
-- written in capital case. @::@ is read as \"has type\".
--
-- Functions also have types. It's a good practice to give them a explicit type
-- declaration

-- | Remove all non uppercase from a string.
removeNonUppercase :: [Char] -> [Char]
removeNonUppercase st = [c | c <- st, c `elem` ['A'..'Z']]

-- $parameters
--
-- Note that there's not special distinction between the parameters and the
-- return type. The return type is the last item in the declaration.  Later
-- we'll see why they're separated with @->@ only.

-- | Add three integers
addThree :: Int -> Int -> Int -> Int
addThree x y z = x+y+z

-- 'Int' and 'Integer': the last is not bounded.

-- | factorial of a number
--
-- >>> factorial 50
-- 30414093201713378043612608166064768844377641568960512000000000000
factorial :: Integer -> Integer
factorial n = product [1..n ]

-- 'float'

-- | circumference of a circle of radius @r@
--
-- >>> circumference 4.0
-- 25.132742
circumference :: Float -> Float
circumference r = 2 * pi * r

-- 'Double' a float with double precision

-- | circumference of a circle of radius @r@ with double precision
--
-- >>> circumference' 4.0
-- 25.132741228718345
circumference' :: Double -> Double
circumference' r = 2 * pi * r

-- ** Type variables
--
-- $typesvariables
--
-- What is the type of 'head'? Head take a list of /somethings/ and returns the
-- first element in the list, whatever its type will be. If we check in @GHCI@
-- the type of 'head' it returns something like this: @head :: [a] -> a@
--
-- @a@ is a __type variable__. Functions that have type variables are
-- __polymorphic functions__. 
--

-- ** Typeclasses 101
--
-- $typeclass
--
-- In Haskell typeclasses are like Java interfaces. If a types is part of a
-- typeclass, that means it supports and implements the behavior the typeclass
-- describes.
--
-- If we check the type of the operator @==@ @GHCI@ says its type is @(==) ::
-- (Eq a) => a -> a -> Bool
--
-- Anything before the symbol @=>@ is a __class constraint__. 
--
-- Some typeclasses:
--
-- The 'Eq' typeclass provides an interface for testing equality. All types
-- mentioned so far, except for functions, are part of 'Eq'. Members of this
-- class type implement '==' and '/='.
--
-- >>> 5 == 5
-- True
-- >>> 5 /= 5
-- False
-- >>> 'a' == 'a'
-- True
-- >>> "Ho Ho" == "Ho Ho"
-- True
-- >>> 3.432 == 3.432
-- True
--
-- 'Ord' is for types that have ordering. All types covered so far except
-- functions are part of 'Ord'. 'Ord' covers all the standard comparing
-- functions such as '>', '<', '>=', '<='. The 'compare' function takes two
-- 'Ord' members of the same type and returns an ordering. 'Ordering' is a type
-- that can be 'GT', 'LT' or 'EQ', meaning /greater/, /lesser/ and /equal/,
-- respectively.
--
-- >>> "Abracadabra" < "Zebra"
-- True
-- >>> "Abracadabra" `compare` "Zebra"
-- LT
-- >>> 5 >= 2
-- True
-- >>> 5 `compare` 3
-- GT
--
-- Members of 'Show' can be presented as string. All types covered so far
-- except for functions are part of 'Show'. The most function that deals with
-- the 'Show' typeclass is the 'show'. It takes a value whose type is a member
-- of 'Show' and present it to us as a 'String'.
--
-- >>> show 3
-- "3"
-- >>> show 5.334
-- "5.334"
-- >>> show True
-- "True"
--
-- 'Read' is a sort of the opposite typeclass of 'Show'. The 'read' function
-- takes a string and returns a type which is a member of 'Read'.
--
-- >>> read "True" || False
-- True
-- >>> read "8.2" + 3.8
-- 12.0
-- >>> read "5" - 2
-- 3
-- >>> read "[1,2,3,4]" ++ [3]
-- [1,2,3,4,3]
--
-- Most expressions are such that the compiler can infer what their type is by
-- itself. But sometimes, the compiler doesn't know whether to return a value
-- of type 'Int' or 'Float' for an expression like @read "5"@. In these cases
-- we use __type annotations__. Type annotations are a way of explicitly saying
-- what the type of an expression should be. We do that by adding @::@ at the
-- end of the expression and then specifying a type.
--
-- >>> read "5" :: Int
-- 5
-- >>> read "5" :: Float
-- 5.0
-- >>> (read "5" :: Float) * 4
-- 20.0
-- >>> read "[1,2,3,4]" :: [Int]
-- [1,2,3,4]
-- >>> read "(3, 'a')" :: (Int, Char)
-- (3,'a')
--
-- 'Enum' members are sequentially order types - they can be enumerated. We can
-- use its types in list ranges. `succ` and `pred` functions give the successor
-- and the predecessor. Types in this class: (), 'Bool', 'Char', 'Ordering',
-- 'Int', 'Integer', 'Float' and 'Double'.
--
-- >>> ['a'..'e']
-- "abcde"
-- >>> [LT .. GT]
-- [LT,EQ,GT]
-- >>> [3 .. 5]
-- [3,4,5]
-- >>> succ 'B'
-- 'C'
--
-- 'Bounded' members have an upper and lower bound. 'minBound' and 'maxBound'
-- have a type @(Bounded a) => a@. They are a __polymorphic constants__. All
-- tuples are also part of 'Bounded' if the components are also in it.
--
-- >>> minBound :: Int
-- -9223372036854775808
-- >>> maxBound :: Char
-- '\1114111'
-- >>> maxBound :: Bool
-- True
-- >>> minBound :: Bool
-- False
-- >>> maxBound :: (Bool, Int, Char)
-- (True,9223372036854775807,'\1114111')
--
-- 'Num' is a numeric type class. Its members have the property of being act
-- like numbers. It appears that whole numbers are also polymorphic constants.
-- They can act like any type that's a member of 'Num' typeclass.
--
-- >>> :t 20
-- 20 :: Num p => p
--
-- >>> 20 :: Int
-- 20
-- >>> 20 :: Integer
-- 20
-- >>> 20 :: Float
-- 20.0
-- >>> 20 :: Double
-- 20.0
--
-- If we examine the type of '*', we'll see that it accepts all numbers.
--
-- >>> :t (*)
-- (*) :: Num a => a -> a -> a
--
-- It takes two numbers of the same type and returns a number of the that type.
-- @(5 :: Int) * (6 :: Integer)@ will result in a type error whereas @5 * (6 ::
-- Integer)@ will work just fine and produce an 'Integer' because 5 can act
-- like an 'Integer' or an 'Int'.
--
-- To join 'Num', a type must already be friends with 'Show' and 'Eq'.
--
-- 'Integral' is also a numeric typeclass. 'Num' include all numbers, including
-- real numbers, 'Integral' include only integral (whole) numbers. In this
-- typeclass are 'Int' and 'Integer'.
--
-- 'Floating' includes only floating point numbers, so 'Float' and 'Double'.
--
-- A very useful function for dealing with numbers is 'fromIntegral'. It has a
-- type declaration of @fromIntegral :: (Integral a, Num b) => a -> b@. That's
-- useful when you want integral and floating point types to work together
-- nicely.
