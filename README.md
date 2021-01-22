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

## Testing

I tried to configure [DocTest][doctest] with [QuickCheck][quickcheck] in
`cabal` without success. In order to run `DocTest` run:

```
$ doctest src/Ch02/Baby.lhs 
Examples: 3  Tried: 3  Errors: 0  Failures: 0
```

**NOTE**: In version 3.0.1 has added support for [DoctTest][doctest] in
`package.yaml`. It's work but I must add the module to `app/Main.hs` as
import and the output is in a log file deep in `dist-newstyle/' directory.
I prefer run `doctest` manually, still.

For now, I will not try [HSpec][HSpec].

[doctest]: https://github.com/sol/doctest#readme
[quickcheck]: http://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html
[HSpec]: https://hspec.github.io/

## Literate Haskell

Haskell provides native features to support [literate programming][lhs]. In haskell,
a literate program is one with the suffix `.lhs`. `GHC` supports [markdown][md] as
annotation language through [markdown-unlit][md-ulint].

[nvim][vim] support `.hs` and `.lhs` files. To preview the markdown result we can
use a *plugin*. There are several of these plugins, currently, I use [iamcco/markdown-preview.vim][md-plug]. In order to works with `.lhs` files, I added this extension to
`g:mkdp_filetypes`. The output is not very well-looked. [pandoc][pandoc] supports
*literate haskell* with markdown, through [pandoc literate Haskell support][lhs-pandoc]:

```
$ pandoc -f markdown+lhs -t html src/Ch02/Baby.lhs > src/Ch02/Baby.html
$ xdg-open src/Ch02/Baby.html
```

[lhs]: https://wiki.haskell.org/Literate_programming
[md]: https://daringfireball.net/projects/markdown/syntax
[vim]: https://neovim.io
[pandoc]: https://pandoc.org/
[lhs-pandoc]: https://pandoc.org/MANUAL.html#literate-haskell-support
[md-unlit]: https://github.com/sol/markdown-unlit#read
