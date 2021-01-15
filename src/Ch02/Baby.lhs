> {-|
> Module      : Baby
> Description : baby.hs
> Copyright   : (c) 2020-2030 Eduardo Ramón Lestau
> License     : BSD3
> Stability   : experimental
> Portability : POSIX
>
> This is the `baby.lhs` file from Chapter two `Starting Out` of
> the book online `Learn you a Haskell for Great Good!` available
> online on http://learnyouahaskell.com/chapters.
>
> -}
>
> module Ch02.Baby where

Baby
====

In this file I define functions functions that I then load in `GHCI`. Once
inside `GHCI`, do `:l baby.hs`.

As it is, this file is not part of the project. Neither `stack` or `cabal` know
about the file. I added the file in `extra-source-files` inside `package.yaml`, 
so the file is added as `README.md` do, for example.

This file is not a module!

Chapter 2: Starting out
-----------------------

> doubleMe x = x + x

We can use other functions to define our own functions.

> doubleUs x y = doubleMe x + doubleMe y

A function that double a number but only if it is small.

> doubleSmallNumber x = if x > 100
> 			   then x
> 			   else x*2

Always there is an `else`. `If` is an _expression_ and an expression have to resolves
to a value, always.

This function can be defined in one line. It's an expression so, I can operate with it.

> doubleSmallNumber' x = (if x > 100 then x else x*2) + 1  -- add 1 to double

`'` is a valid character for names:

> conanO'Brien = "It's a-me, Conan O'Brien!"

> boomBangs xs = [if x<10 then "BOOM!" else "BANG!" | x <- xs, odd x]

Our own version of `length`:

> length' xs = sum [1 | _ <- xs]

> removeNonUppercase st = [c | c <- st, c `elem` ['A'..'Z']]
