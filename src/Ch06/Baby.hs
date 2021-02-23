-- |
-- Module      : Ch06.Baby
-- Description : Chapter 6
-- Copyright   : (c) 2020-2030 Eduardo Ramón Lestau
-- License     : BSD3
-- Stability   : experimental
-- Portability : POSIX
--
-- Higher order functions

module Ch06.Baby where

-- * Higher Order functions
--
-- $hof
--
-- Haskell functions can take functions and return functions as return values.
-- A function that does either of those is called a higher order function.
-- They're a really powerful way of solving problems and thinking about
-- programs.

-- ** Curried functions
--
-- $cf
--
-- Every function in Haskell takes one and only one parameter. All functions
-- that accepted /several parameters/ so far have been __curried functions__.
-- For instance: 'max' function. It looks like it take two parameters and
-- returns the one that's bigger. Doing @max 4 5@ first create a function that
-- returns @4@ or that parameter, depending which is bigger. Then, @5@ is
-- applied to that function and that produces our desired result. The following
-- two calls are equivalent:
--
-- >>> max 4 5
-- 5
-- >>> (max 4) 5
-- 5
--
-- Putting a space between two things is simply __function application__. The
-- space is a sort of like an operator an it has the highest precedence. 
--
-- @max :: (Ord a) => a -> a -> a@ could be written as @max :: (Ord a) => a ->
-- (a -> a)@. That could read as: 'max' take an @a@ and returns (that is the
-- @->@) a function that takes an @a@ and returns an @a@. That is why the
-- return type and the parameters of functions are simply separated by arrows.
-- 
-- If we call a function with too few parameters, we get back a __partially
-- applied__ function. Using partially application is a neat way to create
-- functions on the fly so we can pass them to another function or to seed them
-- with some data.

-- | multiplies three numbers
--
-- >>> multTwoWithNine = multThree 9
-- >>> multTwoWithNine 2 3
-- 54
-- >>> multWithEighteen = multTwoWithNine 2
-- >>> multWithEighteen 10
-- 180
multThree :: (Num a) => a -> a -> a -> a
multThree x y z = x*y*z

-- $cf1
--
-- We could define a function, for instance, that compares a number with 100:
--
-- @
-- compareWithHundred :: (Num a, Ord a) => a -> Ordering
-- compareWithHundred x = compare 100 x
-- @
--
-- Notice that the @x@ is on the right hand side on both sides of the equation.
-- @compare 100@ returns a function that take a number and compares it with
-- @100@.  We can rewrite 'compareWithHundred'. The type declaration stays the
-- same, because @compare 100@ returns a function. Compare has a type of @(Ord
-- a) => a -> (a -> Ordering)@ and calling with 100 returns @(Num a, Ord a) =>
-- a -> Ordering. The additional class constraint is because @100@ is part of
-- the 'Num' typeclass.

-- | compare a number with 100
--
-- >>> compareWithHundred 99
-- GT
compareWithHundred :: (Num a, Ord a) => a -> Ordering
compareWithHundred = compare 100

-- $cf2
--
-- Infix functions can also be partially applied by using __sections__. To
-- section an infix function, simply surround it with parentheses and only 
-- supply a parameter on one side.
--
-- In Haskell @(-4)@ is /minus/ four. So, we couldn't use something like 
-- that to create a section. In this cases should be a function like:
-- @subtract 4@.

-- | Divides by 10
--
-- >>> divideByTen 200
-- 20.0
divideByTen :: (Floating a) => a -> a
divideByTen = (/10)

-- | Returns 'True' if the character is a upper letter
isUpperAlphanum :: Char -> Bool
isUpperAlphanum = (`elem` ['A'..'Z'])

-- ** Some higher-orderism is in order
--
-- $ho
--
-- Functions can take functions as parameters an also return functions.
--
-- @->@ is right associative. So far we didn't need parentheses but we
-- want to declare a function as parameter of other is mandatory. So:
-- @(a -> a) -> a -> a@ could be read as take a function that takes an
-- argument of any type and returns something of the same type as first
-- argument and a parameter of any type and returns something of the 
-- same type.

-- | Applies twice the provided function
--
-- >>> applyTwice (+3) 10
-- 16
-- >>> applyTwice (++ " HAHA") "HEY"
-- "HEY HAHA HAHA"
-- >>> applyTwice ("HAHA " ++) "HEY"
-- "HAHA HAHA HEY"
-- >>> applyTwice (multThree 2 2) 9
-- 144
-- >>> applyTwice (3:) [1]
-- [3,3,1]
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

-- $ho1
--
-- As you can see, a single high order function can be used in very versatile
-- ways. Imperative programming usually uses stuff like loops, setting something
-- to a variable, checking its state, etc. to achieve some behavior and then
-- wrap it around an interface like a function. Function programming uses 
-- high order functions to abstract away common patterns, like examining two lists
-- in pairs and doing something with those pairs or getting a set of solutions
-- and eliminating the ones you don't need.

-- | Our own version of 'zipWith'
--
-- >>> zipWith' (+) [4,2,5,6] [2,6,2,3]
-- [6,8,7,9]
-- >>> zipWith' max [6,3,2,1] [7,3,1,5]
-- [7,3,2,5]
-- >>> zipWith' (++) ["foo ", "bar ", "baz "] ["fighters", "hoppers", "aldrin"]
-- ["foo fighters","bar hoppers","baz aldrin"]
-- >>> zipWith' (zipWith' (*)) [[1,2,3],[3,5,6],[2,3,4]] [[3,2,2],[3,4,5],[5,4,3]]
-- [[3,4,6],[9,20,30],[10,12,12]]
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

-- | our own version of 'flip'
--
-- 'flip' is a function that takes a function and returns another that it is
-- like our original function but with two arguments flipped.
--
-- We can implement like:
--
-- @
--   flip' :: (a -> b -> c) -> (b -> a -> c)
--   flip' f = g
--       where g x y = f y x
-- @
--
-- In the final implementation we don't have the @where@ clause neither
-- auxiliary @g@ function and because @->@ is right associative the @b -> a ->
-- c@ don't need parentheses.
--
-- Here, we take advantage of the fact functions are curried. When we call
-- @flip' f@ without @y@ and @x@ parameters, it will return a @f@ that takes
-- those two parameters but calls them flipped.
--
-- >>> flip' zip [1,2,3,4,5] "hello"
-- [('h',1),('e',2),('l',3),('l',4),('o',5)]
-- >>> zipWith (flip' div) [2,2..] [10,8,6,4,2]
-- [5,4,3,2,1]
flip' :: (a -> b -> c) -> b -> a -> c
flip' f x y = f y x 

-- ** Maps and filters
--
-- $mf
--
-- 'map' takes a function and a list and applies that function to every element
-- in the list, producing a new list.

-- | Our own version of 'map'
--
-- >>> map' (+3) [1,5,3,1,6]
-- [4,8,6,4,9]
-- >>> map' (++ "!") ["BIFF", "BANG", "POW"]
-- ["BIFF!","BANG!","POW!"]
-- >>> map' (replicate 3) [3..6]
-- [[3,3,3],[4,4,4],[5,5,5],[6,6,6]]
-- >>> map' (map' (^2)) [[1,2],[3,4,5,6],[7,8]]
-- [[1,4],[9,16,25,36],[49,64]]
-- >>> map' fst [(1,2),(3,5),(6,3),(2,6),(2,5)]
-- [1,3,6,2,2]
map' :: (a->b) -> [a] -> [b]
map' _ []     = []
map' f (x:xs) = f x : map' f xs

-- $mf1
--
-- You've probably noticed that each of these could be achieved with a list
-- comprehension. @map (+3) [1,5,3,1,6]@ is the same as writing
-- @[x+3 | x <- [1,5,3,1,6]]@. 'map' is much more readable for case where
-- you only apply some function to the elements of a list, especially once 
-- you're dealing wit maps of maps and the whole thing with a lot of brackets
-- can get a bit messy.
--
-- 'filter' is a function that takes a predicate (returns a boolean value) and
-- a list and then returns the list of elements that satisfy the predicate.

-- | Our own version of 'filter'
--
-- >>> filter' (>3) [1,5,3,2,1,6,4,3,2,1]
-- [5,6,4]
-- >>> filter' (==3) [1,2,3,4,5]
-- [3]
-- >>> filter' even [1..10]
-- [2,4,6,8,10]
-- >>> let notNull x = not (null x) in filter' notNull [[1,2,3],[],[3,4,5],[2,2],[],[],[]]
-- [[1,2,3],[3,4,5],[2,2]]
-- >>> filter' (`elem` ['a'..'z']) "u LaUgH aT mE BeCaUsE I aM diFfeRent"
-- "uagameasadifeent"
-- >>> filter' (`elem` ['A'..'Z']) "i lauGh At You BecAuse u r aLL the Same"
-- "GAYBALLS"
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ []     = []
filter' p (x:xs)
  | p x       = x : filter p xs
  | otherwise = filter p xs

-- $mf2
--
-- All of this could be achieved with list comprehension by the use of
-- predicates. There's no set rule for when to use 'map' and 'filter'
-- versus using list comprehension.
--
-- Remember 'Ch05.Baby.quicksort'.  We can achieve the same functionality in a more
-- readable way using filter instead of list comprehension.

-- | sort a list using /Quick Sort/ algorithm.
--
-- >>> quicksort [10,2,5,3,1,6,7,4,2,3,4,8,9]
-- [1,2,2,3,3,4,4,5,6,7,8,9,10]
-- >>> quicksort "the quick brown fox jumps over the lazy dog"
-- "        abcdeeefghhijklmnoooopqrrsttuuvwxyz"
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
  let smallerSorted = quicksort (filter (<=x) xs)
      biggerSorted  = quicksort (filter (>x)  xs)
   in smallerSorted ++ [x] ++ biggerSorted

-- $mf3
--
-- Mapping and filtering is the bread and butter of every functional
-- programmer's toolbox. Recall how we solved the problem of finding right
-- triangles with a certain circumference. With imperative programming, we
-- would had solved it by nesting three loops and then testing if current
-- combination satisfies a right triangle and if it has the right perimeter. If
-- that's the case, we would print it out to the screen or something. In
-- functional programming, that pattern is achieved with mapping and filtering.
-- You make a function that takes a values and produces some result. We map
-- that function over a list of values and then we filter the resulting list
-- out for the results that satisfy our search. Thanks to Haskell's laziness,
-- even if you map something over a list several times and filter it several
-- times, it will only pass over the list once.
--
-- Let's __find the largest number under 100.000 that's divisible by 3829__.
-- To do that, we'll just filter a set of possibilities in which we know the
-- solution lies.
--
-- We first make a list of all numbers lower than 100,000, descending. Then we
-- filter it by our predicate and because the numbers are sorted in a
-- descending manner, the largest number than satisfy our predicate is the
-- first element of the filtered list. We don't even need to use a finite list
-- for our starting set because laziness. The evaluation stops when the first
-- adequate solution is found.

-- | Largest number under 100000 that's divisible by 3829
--
-- >>> largestDivisible
-- 99554
largestDivisible :: (Integral a) => a
largestDivisible = head (filter p [100000,99999..])
  where p x = x `mod` 3829 == 0

-- $mf4
--
-- Next up, we are going to find
-- __the sum of all odd squares that are smaller that 10.000__.
-- In our solution we use 'takeWhile' function. It takes a predicate and a list
-- and then goes from the beginning of the list and returns and returns its
-- elements while the predicate holds true. For instance, if we wanted to get
-- the first word of the string @"elephants know how to party"@, we could do
-- @takeWhile (/= ' ') "elephants know how to party"@ and it would return
-- @"elephants"@.
--
-- >>> takeWhile (/= ' ') "elephants know how to party"
-- "elephants"
--
-- The sum of all odd squares that are smaller than 10,000. First we'll begin
-- mapping the @(^2)@ function to the infinite list @[1..]@. Then we filter
-- them to get the odd ones. And then, we'll take element from that list while
-- they are smaller than 10,000. Finally we'll get the sum of that list. We
-- don't need to make a function for that, we can do it in one line in GHCI:
--
-- >>> sum (takeWhile (<10000) (filter odd (map (^2) [1..])))
-- 166650
--
-- We could have also written this using list comprehension:
--
-- >>> sum (takeWhile (<10000) [n^2 | n <- [1..], odd (n^2)])
-- 166650

-- $mf5
--
-- We now consider a [Collatz sequence](https://en.wikipedia.org/wiki/Collatz_conjecture).
-- __For all starting numbers between 1 and 100, how many chains have a length greater than 15?__.
--
-- First we'll write a function that given a number produces the Collatz sequence
-- for that number.

-- | Collatz sequence for a positive integer
--
-- >>> chain 10
-- [10,5,16,8,4,2,1]
-- >>> chain 1
-- [1]
-- >>> chain 30
-- [30,15,46,23,70,35,106,53,160,80,40,20,10,5,16,8,4,2,1]
chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain n
  | even n = n:chain (n `div` 2)
  | odd n  = n:chain (n*3 + 1)

-- $mf6
--
-- and the answer is 
--
-- >>> numLongChains
-- 66

-- | How many /Collatz sequences/ which it length is biggest than 15 for all
-- starting numbers between 1 and 100 
numLongChains :: Int
numLongChains = length (filter isLong (map chain [1..100]))
  where isLong xs = length xs > 15

-- $mf7
--
-- Using 'map', we can also do stuff like @map (*) [0..]@, if not for any
-- reason than to illustrate how currying works an how (partially applied)
-- functions are real values that you can pass around to other functions or put
-- into lists. So far we've only mapped functions that take one parameter over
-- list, like @map (*2) [0..]@ to get a list of type @(Num a) => [a]@, but we
-- can also do @map (*) [0..]@ without a problem. What happens here is that the
-- number in the list is applied to the function @*@, which has a type @(Num a)
-- => a -> a -> a@. Applying only one parameter to a function that takes two
-- parameters returns a function that take one parameter. If we map @*@ over
-- the list [0..], we get back a list of functions that only take one
-- parameter, so @(Num a) => [a -> a]@. @map (*) [0..]@ produces a list like
-- the one we'd get by writing @[(0*),(1*),(2*),(3*),(4*),(5*)..@.
--
-- >>> listOfFuns = map (*) [0..]
-- >>> (listOfFuns !! 4) 5
-- 20

-- ** Lambdas
--
-- $l
--
-- Lambdas are anonymous functions that are used because need some functions
-- only once. For example in 'numLongChains' we used a /where/ binding to make
-- @isLong@ function for the sole purpose of passing it to 'filter'.  We can
-- use a lambda:

-- | like numLongChains but uses a lambda.
--
-- >>> numLongChains'
-- 66
numLongChains' :: Int
numLongChains' = length (filter (\xs -> length xs > 15) (map chain [1..100]))

-- $l1
--
-- Lambda are expressions. The expression @(\xs -> length xs > 15)@ returns a
-- function that tell us whether the length of a list passed to it is greater 
-- than 15.

-- | A list of 'Fractional' values: a sample of lambda with more that one
-- parameters.
--
-- >>> fractionalValues
-- [153.0,61.5,31.0,15.75,6.6]
fractionalValues :: Fractional a => [a]
fractionalValues = zipWith (\a b -> (a*30 + 3) / b) [5,4,3,2,1] [1,2,3,4,5]

-- $l2
-- Like normal functions, lambdas can take any number of parameters. And like
-- normal functions you can pattern matching. The only difference is that you
-- can't define several patterns for one parameter, like making a @[]@ and 
-- @(x:xs)@ pattern for the same parameter and then having values fall through.
-- If a pattern match fails in a lambda, a runtime occurs, so be careful
-- when pattern matching in lambdas!

-- | A list of 'Num' values, given a list of pairs of 'Num' values returns a list of the
-- sums of both terms of each pair. A sample of pattern matching in lambda
--
-- >>> numList
-- [3,8,9,8,7]
numList :: Num a => [a]
numList = map (\(a,b) -> a + b) [(1,2),(3,5),(6,3),(2,6),(2,5)]

-- If we want that lambda extends all to the right, parentheses aren't needed

-- | Another version of 'flip'
flip'' :: (a -> b -> c) -> b -> a -> c
flip'' f = \x y -> f y x        -- more readable?

-- $l3
--
-- In this version of 'flip' we make obvious that this will be used to producing
-- a new function most of the time. The most common use case with 'flip' is 
-- calling it with just the function parameter and then passing the resulting 
-- function on to 'map' or 'filter'. So use lambdas in this way when you want
-- to make it explicit that your function is mainly meant to be partially applied
-- and then passed on to a function as a parameter.

-- ** Only folds and horses
--
-- $of
--
-- A fold are functions that reduces a list to some single value. Normally takes
-- three parameters: a binary function, an initial value and a list. 'foldl' folds
-- the list up from the left side. The function use the initial value and the first
-- element of the list, giving a new value that is used in the next value of the 
-- list and so

-- | like 'sum' more or less. Defined in 'Ch04.Baby' too as recursive function
--
-- >>> sum' [3,5,2,1]
-- 11
sum' :: (Num a) => [a] -> a
-- sum' xs = foldl (\acc x -> acc + x) 0 xs
sum' = foldl (+) 0

-- $of1
--
-- The lambda function @(\acc x -> acc + x)@ is the same as @(x)@. We can omit the
-- @xs@ parameter because calling @foldl (+) 0@ will return a function that takes a 
-- list. Generally, if you have @foo a = bar b a@, you can rewrite it as
-- @foo = bar b@, because of currying.

-- | 'True' if element is in the list
elem' :: (Eq a) => a -> [a] -> Bool
elem' y ys = foldl (\acc x -> if x == y then True else acc) False ys

-- $of2
--
-- The right fold, 'foldr' works in a similar way to the left foldl, only that
-- accumulator eats up the values from the right. Also the binary function has
-- the current value as the first parameter and the accumulator as second.
-- @(\x acc -> ... )@ instead of (\acc x -> ... ).

-- | as 'map' using 'foldr'. We have implemented a recursion version of 'map'
-- in 'map\''.
--
-- >>> map'' (+3) [1,2,3]
-- [4,5,6]
--
-- Note:
-- We could have implemented 'map' with a left fold too. But it would be more
-- expensive
-- @
--   map'' f xs -> fold' (\acc x -> acc ++ [f x]) [] xs
-- @
map'' :: (a -> b) -> [a] -> [b]
map'' f xs = foldr (\x acc -> f x : acc) [] xs

-- $of3
--
-- If you reverse a list, you can do a right fold on it. Sometimes you don't
-- matter. One big difference is that right folders works on infinite list,
-- while left folders doesn't.
--
-- Folds can be used to implement any function where you traverse a list once,
-- element by element, and then return something based on that. Whenever you
-- want to traverse a list to return something, chances are you want fold.
--
-- The 'foldl1' and 'foldr1' functions work much like 'foldl' and 'foldl', only
-- you don't need to provide them with an explicit starting value. They assume
-- the first (or last) element of the list to be the starting value and then
-- start the fold with the element. With than in mind, the @sum@ function can
-- be implemented like so: @sum = foldl1 (+)@. Because they depend on the list
-- they fold up having at least one element, they cause runtime errors if called
-- with empty list. 'foldl' and 'foldr', on the other hand, work fine with empty
-- lists. Several examples showing how powerful folds are:

-- | just like 'maximum' using folders
--
-- prop> reverse xs == reverse' xs
maximum' :: (Ord a) => [a] -> a
maximum' = foldr1 (\x acc -> if x > acc then x else acc)

-- | my own version of reverse
reverse' :: [a] -> [a]
reverse' = foldl (\acc x -> x : acc) []

-- | like 'product'
--
-- prod> product xs == product' xs
product' :: (Num a) => [a] -> a
product' = foldr1 (*)

-- | like 'filter'. I have implemented another version of 'filter' using
-- recursion.
filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p = foldr (\x acc -> if p x then x : acc else acc) []

-- | My own version 'head'
head' :: [a] -> a
head' = foldr1 (\x _ ->x)

-- | My own version of 'last'
last' :: [a] -> a
last' = foldl1 (\_ x -> x)

-- $of4
--
-- 'scanl' and 'scanr' are like 'foldl' and 'foldr', only they report all the
-- intermediate accumulator states. There are also 'scanl1' and 'scanr1'. When
-- using a 'scanl', the final result will be in the last element of the resulting
-- list while 'scanr' will place the result in the head.
--
-- >>> scanl (+) 0 [3,5,2,1]
-- [0,3,8,10,11]
-- >>> scanr (+) 0 [3,5,2,1]
-- [11,8,3,1,0]
-- >>> scanl1 (\acc x -> if x>acc then x else acc) [3,4,5,3,7,9,2,1]
-- [3,4,5,5,7,9,9,9]
-- >>> scanl (flip (:)) [] [3,2,1]
-- [[],[3],[2,3],[1,2,3]]
--
-- Scans are used to monitor the progression of a function that can be
-- implemented as a fold. For example: How many elements does it take for the
-- sum of the roots of all natural numbers to exceed 1000? @map sqrt [1..]@.
-- Now to get the sum, we could do a fold, but because we're interested in how
-- sum in the scan list will be 1, normally. The first sum in the scan list
-- will be 1, normally. The second will be 1 plus the square root of 2. The
-- third will be that plus the square root of 3. If the are X sums under 1000,
-- then it takes X+1 elements for the sum to exceed 1000.

-- | elements that it take for the sum of the roots of all natural numbers to
-- exceed 1000
--
-- >>> sqrtSums
-- 131
-- >>> sum (map sqrt [1..131])
-- 1005.0942035344083
-- >>> sum (map sqrt [1..130])
-- 993.6486803921487
sqrtSums :: Int
sqrtSums = length (takeWhile (<1000) (scanl1 (+) (map sqrt [1..]))) + 1

-- ** Function application with $
--
-- $fa
--
-- @
-- ($) :: (a -> b) -> a -> b
-- f $ x = f x
-- @
--
-- @$@ is called function application. Normally putting a space between two
-- things is function application. It has a really high precedence. Function
-- application with spaces is left-associative, so @f a b c@ is the same as
-- @((f a) b) c)@. Function application @$@ has the lowest precedence and
-- is right-associative.
--
-- Most of the time, it's a convenience function so that we don't have to
-- write so many parentheses. We can rewrite @sum (map sqrt [1..130])@
-- as @sum $ map sqrt [1..130]@. @sqrt (3 + 4 + 9)@, @sqrt $ 3 + 4 + 9@.
--
-- How about @sum (filter (>10) (map (*2) [2..10]))@? Well, about @$@ is 
-- right associative, @f (g (z x))@ is equal @f $ g $ z x@. And so, we can
-- rewrite @sum (filter (>10) (map (*2) [2..10]))@ as 
-- @sum $ filter (>10) $ map (*2) [2..10]@
--
-- But apart from getting rid of parentheses, @$@ means that function
-- application can be treated just like another function. That way, we can, for
-- instance, map function application over a list of functions.
--
-- >>> map ($ 3) [(4+), (10*), (^2), sqrt]
-- [7.0,30.0,9.0,1.7320508075688772]

-- ** Function composition
--
-- $fc
--
-- In mathematics, function composition is defined like this:
-- \((f \circ g)(x) = f(g(x))\), meaning that composing two functions produces
-- a new function that, when called with a parameter, say, \(x\) is the
-- equivalent of calling \(g\) with the parameter \(x\) and then calling the
-- \(f\) with that result.
--
-- In Haskell @.@ function is defined like:
--
-- @
-- (.) :: (b -> c) -> (a -> b) -> a -> c
-- f . g = \x -> f (g x)
-- @
--
-- @f@ must take as its parameter a value that has the same type @g@'s return
-- value. And returns a value of the same type that @f@ returns. The expression
-- @negate . (* 3)@ returns a function that takes a number, multiplies by 3
-- and then negates it.
--
-- Function composition is sometimes clearer that lambdas and could be used to
-- create functions on the fly. The composition function is right-associative.
-- The expression @f (g (z x))@ is equivalent to @(f.g.z) x@ or @f.g.z $ x@.
--
-- >>> map (\x -> negate (abs x)) [5,-3,-6,7,3,2,-19,24]
-- [-5,-3,-6,-7,-3,-2,-19,-24]
-- >>> map (negate . abs) [5,-3,-6,7,3,2,-19,24]
-- [-5,-3,-6,-7,-3,-2,-19,-24]
-- >>> map (\xs -> negate (sum (tail xs))) [[1..5],[3..6],[1..7]]
-- [-14,-15,-27]
-- >>> map (negate.sum.tail) [[1..5],[3..6],[1..7]]
-- [-14,-15,-27]
--
-- But what about functions that take several parameters? For instance,
-- @sum (replicate 5 (max 6.7 8.9))@ can be rewritten as
-- @sum . replicate 5 . max 6.7 $ 8.9@. If you have
-- @replicate 100 (product (map (*3) (zipWith max [1,2,3,4,5] [4,5,6,7,8])))@,
-- you can rewrite it as
-- @replicate 100 . product . map (*3) . zipWidth max [1,2,3,4,5] $ [4,5,6,7,8]@.
-- If the expression ends with three parentheses, chances are that if you translate
-- it into a function composition, it'll have three composition operators.
--
-- Another use of function composition is defining functions in the so-called 
-- point free style (also pointless style).

-- | sum of a list. Pointless style
sum'' :: (Num a) => [a] -> a
-- sum'' xs = foldl (+) 0 xs is the same as
sum'' = foldl (+) 0

-- $fc1
--
-- The @xs@ is in both right sides. Because of currying, we can omit the @xs@ on 
-- both sides.
--
-- How would we write this in point free style?
--
-- >>> fn x = ceiling (negate (tan (cos (max 50 x))))
--
-- We can't just get rid of the @x@ on both sides. @cos (max 50)@ wouldn't make 
-- sense. What we can do is express @fn@ as a composition of functions:
--
-- >>> fn' = ceiling . negate . tan . cos . max 50
--
-- You can use composition as a glue to form more complex functions. However, 
-- many times, writing a function in point free style can be less readable if
-- a function is too complex. The preferred style is use /@let@/ bindings
-- to split the problem into sub-problems and then putting together so that 
-- the function makes sense to someone reading it instead of just making a 
-- huge composition chain.

-- | the sum of odd squares below 10000
-- Note: traditional style
--
-- >>> oddSquareSum
-- 166650
oddSquareSum :: Integer
oddSquareSum = sum  (takeWhile (<10000) (filter odd (map (^2) [1..])))

-- | the sum of odd squares below 10000
-- Note: a long composition chain
--
-- prop> oddSquareSum == oddSquareSum'
oddSquareSum' :: Integer
oddSquareSum' = sum . takeWhile (<10000) . filter odd . map (^2) $ [1..]

-- | the sum of odd squares below 10000
-- Note: using let to do more readable a long chain of composition
-- in free point style
--
-- prop> oddSquareSum == oddSquareSum''
oddSquareSum'' :: Integer
oddSquareSum'' =
  let oddSquares = filter odd $ map (^2) [1..]
      belowLimit = takeWhile (<10000) oddSquares
   in sum belowLimit
