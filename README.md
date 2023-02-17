<div align="center">

# hs-nix-shells

## Nix shells for Haskell development

[![GHC](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/ghc.yaml?branch=main&label=GHC)](https://github.com/tbidne/hs-nix-shells/actions/workflows/ghc.yaml)
[![LiquidHaskell](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/liquidhaskell.yaml?branch=main&label=LiquidHaskell)](https://github.com/tbidne/hs-nix-shells/actions/workflows/liquidhaskell.yaml)
[![style](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/style.yaml?branch=main&label=style&logoColor=white&labelColor=2f353c)](https://github.com/tbidne/hs-nix-shells/actions/workflows/style.yaml)

</div>

---

# Introduction

This packages provides nix shells for general haskell development with `cabal`.

# Shells

## Default

**Attr:** `default`

**Description:** Nix shell for general haskell development. Includes `cabal` and `GHC`.

**Args:**

* `dev` (default `true`): Includes `ghcid` and `haskell-language-server`.
* `ghcVers` (default `ghc944`): Can be `ghc8107`, `ghc902`, `ghc925`, `ghc944`.

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default

nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default --argstr ghcVers ghc925 --arg dev false
```

## GHC

**Attr:** `ghc`

**Description:** Nix shell for `GHC` development. Includes `cabal`, `GHC 9.4.4`, and
other needed dependencies.

**Args:**

* `dev` (default `true`): Includes `ghcid` and `haskell-language-server`.

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A ghc

nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A ghc --arg dev false
```

## LiquidHaskell

**Attr:** `liquidhaskell`

**Description:** Nix shell for `liquidhaskell`. Includes `cabal` and `GHC 9.2.5`.

**Args:**

* `dev` (default `true`): Includes `ghcid` and `haskell-language-server`.

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A liquidhaskell

nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A liquidhaskell --arg dev false
```