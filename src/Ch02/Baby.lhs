Chapter 2: Starting out
=======================

> {-|
> Module      : Ch02.Baby
> Description : baby.hs
> Copyright   : (c) 2020-2030 Eduardo Ramón Lestau
> License     : BSD3
> Stability   : experimental
> Portability : POSIX
>
> This is the @baby.hs@ file from Chapter two /Starting Out/ of
> the book online /Learn you a Haskell for Great Good!__/ available
> online on <http://learnyouahaskell.com/chapters>.
>
> -}
>
> module Ch02.Baby where
>
> -- * Starting Out!
> --
> -- $baby
> --
> -- Module with definitions in @baby.hs@ 

Ready, set, go!
---------------

> -- ** Ready, set, go!
> --
> -- $e0

In Haskell we have a [repl][repl] `ghci`. If we are using **cabal** to
manage our source, use `cabal repl`. 

Example of a session with `ghci` or `cabal repl`.

```
➜  learnyouahaskell git:(Ch02) ✗ ghci
GHCi, version 8.8.4: https://www.haskell.org/ghc/  :? for help
Loaded GHCi configuration from /home/erlnow/.ghc/ghci.conf
λ> :l src/Ch02/Baby.lhs
[1 of 1] Compiling Ch02.Baby        ( src/Ch02/Baby.lhs, interpreted )
Ok, one module loaded.
λ> 2 + 15
17
λ> doubleMe 9
18
λ> :q
➜  learnyouahaskell git:(Ch02) ✗
```

```
➜  learnyouahaskell git:(Ch02) ✗ cabal repl Ch02.Baby
Build profile: -w ghc-8.8.4 -O1
In order, the following will be built (use -v for more details):
 - learnyouahaskell-0.2.0.0 (lib) (configuration changed)
Configuring library for learnyouahaskell-0.2.0.0..
Preprocessing library for learnyouahaskell-0.2.0.0..
GHCi, version 8.8.4: https://www.haskell.org/ghc/  :? for help
Loaded GHCi configuration from /home/erlnow/.ghc/ghci.conf
[1 of 3] Compiling Lib              ( src/Lib.hs, interpreted )
[2 of 3] Compiling Paths_learnyouahaskell ( /home/erlnow/learning/haskell/learnyouahaskell/dist-newstyl
e/build/x86_64-linux/ghc-8.8.4/learnyouahaskell-0.2.0.0/build/autogen/Paths_learnyouahaskell.hs, interp
reted )
[3 of 3] Compiling Ch02.Baby        ( src/Ch02/Baby.lhs, interpreted )
Ok, three modules loaded.
λ> 2 + 15
17
λ> doubleMe 9
18
λ> :q
Leaving GHCi.
➜  learnyouahaskell git:(Ch02) ✗
```


[repl]: https://es.wikipedia.org/wiki/REPL

Baby's first functions
----------------------

> -- ** Baby's first functions
> --
> -- $e1
> -- 
> -- first functions in @baby.hs@

> -- | double a number
> --
> -- >>> doubleMe 9
> -- 18
> -- >>> doubleMe 8.3
> -- 16.6
> --
> doubleMe x = x + x

We can use other functions to define our own functions.

> -- | Add the double of two numbers
> --
> -- >>> doubleUs 4 9
> -- 26
> -- >>> doubleUs 2.3 34.2
> -- 73.0
> -- >>> doubleUs 28 88 + doubleMe 123
> -- 478
> --
> -- prop> doubleUs a b == doubleMe (a + b)
> doubleUs x y = doubleMe x + doubleMe y

A function that double a number but only if it is small.

> -- | double a number **only** if it is a small number
> doubleSmallNumber x = if x > 100
> 			   then x
> 			   else x*2

Always there is an `else`. `If` is an _expression_ and an expression have to resolves
to a value, always.

This function can be defined in one line. It's an expression so, I can operate with it.

> -- | double a number **only** if it is a small number
> doubleSmallNumber' x = (if x > 100 then x else x*2)

`'` is a valid character for names:

> -- | ` is a valid character in names 
> conanO'Brien = "It's a-me, Conan O'Brien!"

> -- ** An intro list
> --
> -- $e2
> --
> -- Lists in Haskell

An intro to list
----------------

In Haskell, lists are a **homegenous** data structure. It stores several elements of the
same type. A 'String' is a list of 'Char'. 

We can concatenate lists using the operator `++`.

> -- | a list of lost numbers
> lostNumbers = [4,8,15,16,23,42]
> 
> -- | concatenation of lists
> concatenateLists = [1,2,3,4] ++ [9,10,11,12]
> 
> -- | concatenation of Strings
> concatenateStrings = "hello" ++ " " ++ "world"
>
> -- | another one
> concatenateStrings' = ['w','0'] ++ ['0','t']

To construct list we can use the _cons operator_ `:`, actually `[1,2,3]` is syntactic
sugar to `1:2:3:[]`. `[]` is the empty list.

> -- | appendig a char to the begining of the String
> consStrings = 'A' : " SMALL CAT"
> -- | appending a number to the begining of the list of numbers
> consNumbers = 5:[1,2,3,4,5]

We can get an element out of a list by index, using the `!!` operator. Index start
at 0. We get an error if the index is greater than the length of the list.

> -- | 6th char in "Steve Buscemi"
> indexString = "Steve Buscemi" !! 6

List can also contain lists.

> -- | a list of lists
> listOfLists = [[1,2,3,4],[5,3,3,3],[1,2,2,3,4],[1,2,3]]
> -- | concat lists of lists
> concatLists = listOfLists ++ [[1,1,1,1]]
> -- | cons with lists of lists
> consLists   = [6,6,6] : listOfLists
> -- | index on list of lists
> indexLists  = listOfLists !! 2

List can be compared if its items can be compared. They are compared in
lexicographical order.

> -- | Compare two list of numbers
> compareList = [3,2,1] > [2,1,0]
> -- | other comparation of list
> compareList' = [3,2,1] > [2,10,100]
> -- | The lists can be of different lengths
> compDiff = [3,4,2] > [3,4]
> -- | another comparation
> compDiff' = [3,4,2] > [2,4]
> -- | equality @==@ operator
> compEq = [3,4,2] == [3,4,2]

Basic functions that operate on lists.

```
        head   tail
         |  ----------
aList = [5, 4, 3, 2, 1]
         ----------  |
	   init     last
````

> -- | a list
> aList = [5,4,3,2,1]
> -- | 'head' takes a list and return its first element
> headList = head aList
> -- | 'tail' takes a list and return the all elements but head
> tailList = tail aList
> -- | 'last' takes a list and return the last elemnts
> lastList = last aList
> -- | 'init' takes a list and return everything except its last element
> initList = init aList

This functions will fail with the empty list. This error cannot be caught at
compile time.

```
ghci> head []
*** Exception: Prelude.head: empty list
```

More functions that operate on lists

> -- | `length` returns the length of a list
> lengthList = length aList
> -- | `null` checks if a list is empty
> isNull = null [1,2,3]
> -- | `reverse` reverses a list
> reverseList = reverse aList

`take` takes a number and a list. It extracts that many elements from the
beginning of the list

> -- | `take` extracts elements from the beginning of a list.
> takeFirst3 = take 3 aList
> -- | always return a list
> takeOne = take 1 [3,9,3]
> -- | as much it returns the list
> takeAll = take 5 [1,2]
> -- | at least the empty list
> takeEmpty = take 0 [6,6,6]

`drop` drops the number of elements from the beginning of a list.

> -- | `drop` drops elements from the beginning of a list
> dropFist3 = drop 3 [8,4,2,1,5,6]
> -- | as much it returns the list
> dropZero = drop 0 [1,2,3,4]
> -- | at least it returns empty list
> dropAll = drop 100 [1,2,3,4]

Some functions walks on a list to perfome some operations.

> -- | `maximum` returns the biggest element
> maxList = maximum [1,9,2,3,4]
> -- | `minimum` returns the smallest
> minList = minimum [8,4,2,1,5,6]
> -- | `sum` returns the sum of all elements on a list
> sumList = sum [5,2,1,6,3,2,5,7]
> -- | `product` returns the product of all elements on a list
> productList = product [1,2,5,6,7,9,2,0]

'elem' takes an element and a list and return 'True' if element
is in the list. It's usually called in infix notation.

> -- | `elem` tell us if an element is in the list
> inList = 4 `elem` [3,4,5,6]
> -- | this element is not in the list
> inList' = 10 `elem` [3,4,5,6]

> -- ** Texas ranges
> --
> -- $e3
> --
> -- Ranges are sequences of elements that can be enumerated.

Texas ranges
------------

To write a list of all natural number from 1 to 20, i can write `[1..20]`.

> -- | from 1 to 20
> rangeNumber = [1..20]
> -- | so whith characters
> rangeCharacter = ['a'..'z']
> -- | from \'K\' to \'Z\'
> rangeCharacter' = ['K'..'Z']

We can specify a step, separating the two first element by comma. To make a
decresing list we use a range with a step. range with floating point can yield
some odd results. Also, we can make infinite list if not specify an upper
limit. Because Haskell is lazy doesn't need evaluate inmediately.

> -- | a ranged list with a step
> rangeStep = [2,4..20]
> -- | another ranged list with a step
> rangeStep' = [3,6..20]
> -- | ranged decresing list
> rangeDecresing = [20,19..1]
> -- | a floating point range
> rangeFloat = [0.1, 0.3..1]
> -- | take 20 first element of a range stepped list
> rangeSteppedInfinityTake = take 20 [13,26..]

There are functions that produces infinity list, like: `cycle` and `repeat`.

> -- | `cycle` takes a list an cycles it into an infinite list.
> cycleListTake = take 10 (cycle [1,2,3])
> -- | `repeat` takes an element and produces an infinite list of just that element
> repeatElementTake = take 10 (repeat 5)

This last example is simplest using `replicate`

> -- | `replicate` replicates a number of times an element
> replicateElement = replicate 3 10


I'm a list comprehension
------------------------

> -- ** I'm a list comprehension
> -- 
> -- $s4
> --
> -- List comprehension are similar to set comprehension in Mathematics.

List comprehension are similar to set comprehension in Mathematics:

For example a set that contains the first ten even natural numbers is:

$S = \{ 2 \cdot x \:|\: x \in \mathbb{N},\; x \leq 10 \}$.

Where left part is called the output function $x$ is the variable, $\mathbb{N}$
is the input set and $x\leq10$ is a predicate. That means that the set contains
the doubles of all natural number that satisfy the predicate.

In Haskell, we could use a list comprehension to write something similar.

> -- | a list comprehension 
> comprehensionMultiplesTwo = [ x | x <- [1..10]]

We can use a predicate to filter the list. An element is on the list if
satisfy the predicate.

> -- | with a predicate
> comprehensionMultiplesFilterMultiples = [ x | x <- [1..10], x*2 >= 12]
> -- | all numbers from 50 to 100 whose remainder when divided by 7 is 3
> comprehensionFilterMod = [ x | x <- [50..100], x `mod` 7 == 3 ]

`odd` is a function that returns `True` on an odd number and `False` on an even
number.

> -- | a function that replace each odd number lesser than 10 with "BOOM!"
> -- and greater than 10 with "BANG!"
> --
> -- >>> boomBangs [7..13]
> -- ["BOOM!","BOOM!","BANG!","BANG!"]
> boomBangs xs = [if x<10 then "BOOM!" else "BANG!" | x <- xs, odd x]

We can include several predicates.

> -- | all numbers from 10 to 20 that are not 13, 15 or 19
> comprehensionFilterNot = [ x | x <- [10..20], x /= 13, x /= 15, x /= 19]

We can drawn from several list. In this case, comprehension produces all
combination of the given lists and then join them by the output function we
supply.

> -- | the product of all possible combinations between number in the list
> -- @[2,5,10]@ and @[8,10,11]
> comprehensionDrawMultipleList = [ x*y | x <- [2,5,10], y <- [8,10,11]]
> -- | like above but only those products greater than 50
> comprehensionDrawMultipleListFilter = [ x*y | x <- [2,5,10], y <- [8,10,11], x*y > 50]

How about a list comprehension that combines a list of adjectives and a list of nouns...

> -- | a list of nouns
> nouns = ["hobo", "frog", "pope"]
> -- | a list of adjectives
> adjectives = ["lazy", "grouchy", "scheming"]
> -- | a list comprehension that combines adjectives and nouns
> descriptions = [adjective ++ " " ++ noun | adjective <- adjectives, noun <- nouns]

We can write our own version of `length`. Using  a list comprehension that replace
every element of a list with `1` and then the sum of that list comprehension is the
length of our list. '_' means that we don't care what we'll drawn from the list.

Our own version of `length`:

> -- | Our own version of `length` using a list comprehension and `sum`.
> --
> -- prop> length' xs == length xs
> length' xs = sum [1 | _ <- xs]

Because `Strings` are lists, we can use list comprehension to process and produce strings.

> -- | remove non uppercase from the string
> --
> -- >>> removeNonUppercase "Hahaha! Ahahaha!"
> -- "HA"
> -- >>> removeNonUppercase "IdontLIKEFROGS"
> -- "ILIKEFROGS"
> removeNonUppercase st = [c | c <- st, c `elem` ['A'..'Z']]

Nested list comprehension are supported.

> -- | a list of list
> xss = [[1,3,5,2,3,1,2,4,5],[1,2,3,4,5,6,7,8,9],[1,2,4,2,1,6,3,1,3,2,3,6]]
> -- | only even elements from the previous list
> onlyEven = [[x | x <-xs, even x] | xs <- xss]

Tuples
------

> -- ** Tuples
> -- 
> -- $e5
> --
> -- Tuples are another way of store several values in a single value like lists.

List can be of any size from empty list to an infinite list. All elements in a
list are the same type.  Tuples are used when we know in advance how many
values we want to pack and its types. The elements of a tuple can be of
different types. There isn't tuples of one element.

The size and the types of its elements are part of type of a tuple. So,
`[(1,2), (8,11,5), (4,5)]` give an error because all elements of a list are of
the same type and `(1,2)` are of a type different to the type of `(8,11,5)`. The
type of pair `(1,2)` isn't like the type of `("one", 2)`, so.

Only for *pairs* are function to extracts its elements: the functions `fst` and
`snd`.

> -- | first element of a pair
> first = fst (8, 11)
> -- | second element of a pair
> second = snd (8, 11)

`zip` take two lists and produces a list of pairs with elements of both list,
matching them one by one. The list can be of any type and any size, don't need
to match the size or type of both list

> -- | a zipped list 
> zipList = zip [1,2,3,4,5] (repeat 5)
> -- | another zip list
> zipList' = zip [1..5] ["one", "two", "three", "four", "five"]
> -- | and another
> zipListDifferentLength = zip [5,3,2,6,2,7,2,5,4,6,6] ["i'm", "a", "turtle"]
> -- | and another
> zipListDifferentLength' = zip [1..] ["apple", "orange", "cherry", "mango"]

A problem: which right triangle that has integers for all sides an all sides
equal or smaller than 10 has a perimeter of 24?

First, try to generate all triangles with sides equal or smaller than 10:

> -- | right triangles with integer sides equal o smaller than 10
> triangle = [(a,b,c) | c <- [1..10], b <- [1..10], a <- [1..10]]

In `triangle` we have triangle repeated to prevent it we add the restriction
`c >= b >= a`. We'll add the condition that all have to be a right triangle.

> -- | right triangles with sides equal or smaller than 10.
> rightTriangle = [(a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2]

We add the last restriction, its perimeter must be 24.

> -- | right triangles like last but with its perimeter must be 24
> response = [(a,b,c) |
>               c <- [1..10], b <- [1..c], a <- [1..b],
>               a^2 + b^2 == c^2,
>               a + b + c == 24]
