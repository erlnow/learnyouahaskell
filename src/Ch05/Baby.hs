-- |
-- Module      : Ch05.Baby
-- Description : Chapter 5
-- Copyright   : (c) 2020-2030 Eduardo Ramón Lestau
-- License     : BSD3
-- Stability   : experimental
-- Portability : POSIX
--
-- Recursion

module Ch05.Baby where

-- * Recursion
--
-- ** Hello Recursion
--
-- $recursion
--
-- Recursion is a way of defining functions in which the function is applied
-- inside its own definition.
--
-- Definitions in mathematics are often given recursively. For instance, the
-- Fibonacci sequence is defined recursively. First, we defined the first two
-- Fibonacci numbers non-recursively. We say \(F(0) = 0\) and \(F(1) = 1\),
-- meaning that the 0th an 1st Fibonacci 0 and 1, respectively. Then we say
-- than for any other natural number, that Fibonacci number is the sum of the
-- previous two Fibonacci number. So \(F(n) = F(n-1) + F(n-2)\). That way
-- \(F(3)\) is \(F(2) + F(1)\), which is is \((F(1) + F(0)) + F(1)\). Because
-- we've now come down to only non-recursively defined Fibonacci numbers, we
-- can safely say that /(F(3) = 2/) /(F(0)\) and \(F(1)\) definitions that are
-- non-recursive are also called __edge condition__ and is important if you
-- want your recursive function to terminate.
--
-- Recursion is important in Haskell because you do computation by declaring
-- what something /is/ instead of declaring /how/ you get it. That's why there
-- are no while loops or for loops in Haskell and instead we many times have to
-- use recursion to declare what something is.

-- ** Maximum awesome
--
-- $maximum
--
-- The 'maximum' function takes a list of things that can be ordered (instances
-- of the 'Ord' typeclass) and returns the biggest of them. In imperative
-- language, we probably set up a variable to hold the maximum value so far and
-- then we'd loop through the elements of a list an if an element is bigger
-- than current maximum value, we'd replace it with that element. The maximum
-- value that remains at the end is the result.
--
-- Recursively we set up an edge condition and say that maximum of a singleton
-- list is equal to the element in it. Then we can say that maximum of a bigger
-- list is the head if the head of tail of the list. If the maximum of the tail
-- is bigger, then it's the maximum of the tail.

-- | Our own version of 'maximum'
--
maximum' :: (Ord a) => [a] -> a
maximum' [] = error "maximum of a empty list"
maximum' [x] = x
maximum' (x:xs)
  | x > maxTail = x
  | otherwise = maxTail
  where maxTail = maximum' xs

-- $m1
--
-- ![maximum example](images/maxs.png)

-- ** A few more recursive functions
--
-- $afew
--
-- 'replicate' takes an 'Int' and some element and return a list that has
-- several repetitions of the same element. For instance, @replicate 3 5@
-- returns @[5,5,5]@. Let's think about the edge condition. My guess is 
-- that the edge condition is 0 or less. If we try replicate something 
-- zero times, it should return an empty list. Also for negative numbers,
-- because it doesn't really make sense.

-- | Our owns version of 'replicate'
--
-- prop> replicate n x == replicate' n x
--
-- >>> replicate 3 5
-- [5,5,5]
replicate' :: (Num i, Ord i) => i -> a -> [a]
-- Note: 'Num' is not a subclass of 'Ord'
replicate' n x
  | n <= 0    = []
  | otherwise = x : replicate' (n-1) x

-- $a1 
--
-- 'take' takes a certain number of elements from a list. For instance, @take 3
-- [5,4,3,2,1]@ will return @[5,4,3]@. If we try to take 0 or less elements
-- from a list, we get an empty list. Also if we try to take anything from an
-- empty list, we get an empty list. Notice that those are two edge conditions
-- right there

-- | Our own version of 'take'
--
-- prop> take n xs == take' n xs
--
-- >>> take 3 [5,4,3,2,1]
-- [5,4,3]
take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
  | n <= 0     = []
take' _ []     = []
take' n (x:xs) = x : take' (n-1) xs

-- $a2
--
-- 'reverse' simply reverse a list. Think about the edge condition. An empty
-- list reverse equals the empty list itself.

-- | Our own version of 'reverse'
--
-- prop> reverse xs == reverse' xs
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

-- $a3
--
-- Because Haskell supports infinite lists, our recursion doesn't really have
-- to have an edge condition. 

-- | Our own version of 'repeat'
--
-- prop> take n (repeat x) == take n (repeat' x)
repeat' :: a -> [a]
repeat' x = x : repeat' x

-- $a4
--
-- 'zip' takes two lists and zips them together. @zip [1,2,3] [2,3]@ returns
-- [(1,2),(2,3)], because it truncates the longer list to match the length of
-- the shorter one. How about if we zip something with an empty list? Well, we
-- get an empty list back then. So there's our edge condition. However, @zip@,
-- takes two list as parameters, so there are actually two edge conditions.

-- | Our own version 'zip'
--
-- prop> zip xs ys == zip' xs ys
--
-- >>> zip' [1,2,3] ['a','b']
-- [(1,'a'),(2,'b')]
zip' :: [a] -> [b] -> [(a,b)]
zip' _ []          = []
zip' [] _          = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys

-- $a5
--
-- 'elem' takes an element and a list and sees if the element is in the list.
-- The edge condition, as is most of the times with list, is the empty list.

-- | True if element is in the list
--
-- prop> elem a xs == elem' a xs
elem' :: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' a (x:xs)
  | a == x    = True
  | otherwise = a `elem'` xs

-- ** Quick, sort!
--
-- $qs
--
-- We have a list of items that can be sorted. Their type is an instance of the
-- 'Ord' typeclass. /Quick sort/ is an algorithm to sort a list.  The type 
-- signatures is @quicksort :: (Ord a) -> [a] -> [a]@
--
-- The edge condition is the empty list, as is expected. A sorted list is a
-- list that has all the values smaller than (or equal to) the head of the
-- list in front (and those values are sorted), then comes the head of the 
-- list in the middle and then come all the values that are bigger than the
-- head (they're also sorted).

-- | sort a list using /Quick Sort/ algorithm.
--
-- >>> quicksort [10,2,5,3,1,6,7,4,2,3,4,8,9]
-- [1,2,2,3,3,4,4,5,6,7,8,9,10]
-- >>> quicksort "the quick brown fox jumps over the lazy dog"
-- "        abcdeeefghhijklmnoooopqrrsttuuvwxyz"
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
  let smallerSorted = quicksort [a | a <- xs, a <= x]
      biggerSorted  = quicksort [a | a <- xs, a > x]
   in smallerSorted ++ [x] ++ biggerSorted

-- $qs1
--
-- ![quicksort](images/quicksort.png)
