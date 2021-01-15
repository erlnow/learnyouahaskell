# learnyouahaskell

Examples and exercises from the [book][book]

> Learn You a Haskell for Great Good!
> by _Miran Lipovaca_

There is a [spanish translation][sp].

[book]: http://learnyouahaskell.com/
[sp]: http://aprendehaskell.es/

## baby.lhs

The book uses a file to define functions and so: `baby.hs` or `baby.lhs` for
a _literate_ version of Haskell code.

In order to play with this code, in Haskell we use a _repl_ and load the 
file inside it, with:

```
main> :l baby.lhs
[1 of 1] Compiling Main             ( baby.lhs, interpreted )
Ok, one module load
main> :t doubleMe
doubleMe :: Num a => a -> a
```

To invoke the _repl_ inside **cabal** we use `cabal repl` or `cabal new-repl`. I don't
know why but although load `baby.lhs` doesn't give any error the definitions 
inside the file are not available. The solution is running `ghci` as:

```
$ cabal exec ghci 
```

## Modules

`baby.lhs` from chapter 2, for example, was moved to `src/Ch02` directory
and converted to module `Ch02.Baby` in order to integrate with `cabal` tools.
