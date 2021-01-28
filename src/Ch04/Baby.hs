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

-- $p7
-- We can also pattern match in list comprehension.

-- | a list of integer pairs
xs = [(1,3),(4,3),(2,4),(5,3),(5,6),(3,1)]

-- | Given a list of integer pairs generate a integer list
-- as result of sum each component in a pair for all pair in
-- the given list.
--
-- >>> summed
-- [4,7,6,8,11,4]
summed = [a+b | (a,b) <- xs]

-- $p8
--
-- List themselves can also used in pattern matching. @[]@ matched
-- the empty list. The pattern @x:xs@ will bind the head of the 
-- list with @x@ and the rest of the list with @xs@. If there's
-- only one element @xs == []@.

-- | Our own version of 'head' using pattern matching
--
-- prop> head xs == head' xs
--
-- >>> head' [4,5,6]
-- 4
-- >>> head' "Hello"
-- 'H'
head' :: [a] -> a
head' [] = error "Can't call head' on a empty list, dummy!"
head' (x:_) = x

-- | tell us some of the first elements of the list in (in)convenient
-- English form.
tell :: (Show a) => [a] -> String
tell []      = "The list is empty"
tell (x:[])  = "The list has one element: " ++ show x
tell (x:y:_) = "The list is long. The first two elements are: " ++ show x
             ++ " and " ++ show y

-- | our own version 'length' with pattern matching and a little recursion
--
-- prop> length xs == length' xs
length' :: (Num b) => [a] -> b
length' []     = 0
length' (_:xs) = 1 + length' xs

-- | like 'sum' calculates the sum of a list of numbers.
sum' :: (Num a) => [a] -> a
sum' []     = 0
sum' (x:xs) = x + sum' xs

-- $p9
--
-- There's also a thing called /patterns/. For example, @xs\@(x:y:ys)@:
-- these pattern is the same as @x:y:ys@ but you can easily get the whole
-- list via @xs@.

-- | First letter of a string
capital :: String -> String
capital ""         = "Empty string, whoops!"
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]

-- ** Guards, guards!
--
-- $g1
--
-- Guards are a way of testing some property of a value are true or false.
-- Guards are indicated by pipes and boolean expression following the 
-- function name and its parameters. If the condition is evaluated to 'True',
-- then the corresponding function body is executed. The guards are checked
-- in order, like pattern matches. Many times the last guard is @otherwise@,
-- is the same as 'True'.
--
-- For example: look at the source of `bmiTell`.

-- | a string for every /BMI/ range
bmiTell :: (RealFloat a) => a -> String
bmiTell bmi
  | bmi <= 18.5 = "You're underweight, you emo, you!"
  | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"
  | otherwise   = "You're a whale, congratulations!"

-- | like bmiTell but expects weight and height, as parameters
--
-- >>> bmiTell' 85 1.90
-- "You're supposedly normal. Pffft, I bet you're ugly!"
bmiTell' :: (RealFloat a) => a -> a -> String
bmiTell' weight height
  | weight / height^2 <= 18.5 = "You're underweight, you emo, you!"
  | weight / height^2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
  | weight / height^2 <= 30.0 = "You're fat! Lose some weight, fatty!"
  | otherwise   = "You're a whale, congratulations!"

-- $g2
--
-- Guards can also be written inline, although it is not recommended
--
-- @
-- max' :: (Ord a) => a -> a -> a
-- max a b | a > b = a | otherwise = b
-- @

-- | returns the maximum of two elements 
--
-- prop> max a b == max' a b
max' :: (Ord a) => a -> a -> a
max' a b
  | a > b     = a
  | otherwise = b

-- | compares two elements. It returns a 'Ordering'
--
-- >>> 3 `myCompare` 2
-- GT
--
-- prop> compare a b == myCompare a b
myCompare :: (Ord a) => a -> a -> Ordering
a `myCompare` b
  | a > b     = GT
  | a == b    = EQ
  | otherwise = LT

-- ** Where!?
--
-- $g3
--
-- When we need to declare a name visible for all function body (include guards)
-- we can use the keyword @where@ after the guards and declare the new definitions
-- visible into the function. It must be indent as much as the pipes are indented.
-- The names introduced are aligned at the column.
--
-- We can use __pattern matching__.
--
-- /where/ bindings can be nested.

-- | like bmiTell' but using @where@ for better reading
--
-- >>> bmiTell' 85 1.90
-- "You're supposedly normal. Pffft, I bet you're ugly!"
bmiTell'' :: (RealFloat a) => a -> a -> String
bmiTell'' weight height
  | bmi <= skinny = "You're underweight, you emo, you!"
  | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= fat = "You're fat! Lose some weight, fatty!"
  | otherwise   = "You're a whale, congratulations!"
  where bmi = weight / height^2
        -- skinny = 18.5
        -- normal = 25.0
        -- fat    = 30.0 -- as independent elements or as a tuple
        (skinny,normal,fat) = (18.5,25.0,30.0) -- using pattern matching

-- | gives back the initials of a name given as first name and second name
initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
  where (f:_) = firstname
        (l:_) = lastname

-- also we can define functions in a where block.

-- | calculates /BMI/ for a list of pairs weight-height
calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [bmi w h | (w, h) <- xs]
  where bmi weight height = weight / height^2

-- ** Let it be
--
-- $letitbe
--
-- Very similar to where bindings are let bindings. Where bindings are a
-- /syntactic construct/ that let you bind to variables at the end of a
-- function and the whole function can see them, including all the guards.  Let
-- bindings let you bind to variables anywhere and are /expressions/
-- themselves, but are very local, do they don't span across guards. Let
-- bindings can be used for pattern matching.
--
-- The form is @let <bindings> in <expressions>@. The names that we defined in
-- the /let/ part are accessible to the expression after the /in/ part.

-- | calculates the area of a cylinder given its base radius and its height
cylinder :: (RealFloat a) => a -> a -> a
cylinder r h =
  let sideArea = 2 * pi * r * h
      topArea  = pi * r^2
   in sideArea + 2 * topArea

-- $l1
--
-- let bindings are expressions, can appear where any expression can appear.
-- Just like if statement:
--
-- >>> [if 5 > 3 then "Woo" else "Boo", if 'a' > 'b' then "Foo" else "Bar"]
-- ["Woo","Bar"]
-- >>> 4 * (if 10 > 5 then 10 else 0) + 2
-- 42
--
-- We can do that with let bindings
--
-- >>> 4 * (let a = 9 in 9 + 1) + 2
-- 42
-- >>> [let square x = x * x in (square 5, square 3, square 2)]
-- [(25,9,4)]
-- >>> (let a=100; b=200; c=300 in a*b*c, let foo="Hey "; bar="there!" in foo++bar)
-- (6000000,"Hey there!")
-- >>> (let (a,b,c) = (1,2,3) in a+b+c) * 100
-- 600

-- $l2
--
-- We can use let inside of list comprehension much like we would a predicate.
-- The names defined in let are visible in the output function but not in the
-- generator that is defined first. If omit the @in@ part of the @let@
-- statement the visibility is all predicates and the output function. If we
-- use a @in@ part is only that predicate.
--
-- /let/ bindings cannot be used across guards.

-- | like 'calcBmis' but using let statement. If we 
calcBmis' :: (RealFloat a) => [(a, a)] -> [a]
calcBmis' xs = [bmi | (w, h) <- xs, let bmi=w/h^2, bmi >= 25.0]
  where bmi weight height = weight / height^2

-- ** case expression
--
-- $caseexpression
--
-- case expression in Haskell 
--
-- @
-- case expression of pattern -> result
--                    pattern -> result
--                    pattern -> result
--                    ...
-- @
--
-- __expression__ is matched against the patterns. The /first pattern/ that 
-- matches the expression is used. If it falls through the whole case expression
-- and not suitable pattern is found, a runtime error occurs.
--
-- For example, we defined 'head\'' using patter matching on parameters in function
-- definition. We could had used a case statement

-- | Our own version of 'head' using a case expression. 
--
-- prop> head'' xs == head xs
--
-- >>> head'' [4,5,6]
-- 4
-- >>> head'' "Hello"
-- 'H'
head'' :: [a] -> a
head'' xs = case xs of []    -> error "No head for empty list"
                       (x:_) -> x

-- $cs1
--
-- We can use case expression pretty much anywhere. For instance:

-- | describe a list. It says if it is empty, singleton or more longer.
describeList :: [a] -> String
describeList xs = "The list is " ++ case xs of []  -> "empty."
                                               [x] -> "a singleton list."
                                               xs  -> "a longer list."

-- $cs2
--
-- We could have define it using a where

-- | describe a list. It says if it is empty, singleton or more longer.
describeList' :: [a] -> String
describeList' xs = "The list is " ++ what xs
  where what []  = "empty."
        what [x] = "a singleton list."
        what xs  = "a longer list"
