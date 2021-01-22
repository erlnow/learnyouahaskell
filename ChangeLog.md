# Changelog for learnyouahaskell

## Unreleased changes

## 2021-01-22 - 0.3.0.0

### Added

* src/Ch03/Baby.hs      module `Ch03.Baby` with notes and code
                        from chapter 3

### Changed

* package.yaml
* learnyouahaskell.cabal

## 2021-01-20 - 0.2.0.1

### Changed

* README.md             added a note about literate haskell
* src/Ch02/Baby.lhs     complete code

## 2021-01-15 - 0.2.0.0

Move `baby.lhs` to owns module `Ch02.Baby`

### Added

* src/Ch02/Baby.lhs     module `Baby` from `baby.lhs`

### Changed

* baby.lhs              moved to `src/Ch02`
* README.md             a note about modules
* package.yaml          new version, removed `baby.lhs` from `extra-source-files`
* ChangeLog.md          fix some errors


## 2021-01-13 - 0.1.0.0

Minor fixes

### Changed

* README.md     a note about loading `baby.lhs` in `ghci`.
* .gitignore    added `dist-newstyle/` 

## 2020-10-17 - 0.1.0.0

Chapter 2: Starting Out

### Added

* baby.hs

### Changed

* ChangeLog.md
* learnyouahaskell.cabal
* package.yaml

## 2020-10-17 - 0.1.0.0

Project's Skeleton

### Added
* .gitignore
* ChangeLog.md
* LICENSE
* README.md
* Setup.hs
* TODO
* learnyouahaskell.cabal
* package.yaml
* stack.yaml
* stack.yaml.lock
* app/Main.hs
* src/Lib.hs
* test/Spec.hs
