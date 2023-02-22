<div align="center">

# nix-hs-shells

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tbidne/nix-hs-shells?include_prereleases&sort=semver)](https://github.com/tbidne/shrun/releases/)
![haskell](https://img.shields.io/static/v1?label=&message=9.4&logo=haskell&logoColor=655889&labelColor=2f353e&color=655889)
[![MIT](https://img.shields.io/github/license/tbidne/nix-hs-shells?color=blue)](https://opensource.org/licenses/MIT)

[![default](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/default.yaml?branch=main&label=default&labelColor=2f353c)](https://github.com/tbidne/hs-nix-shells/actions/workflows/default.yaml)
[![GHC](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/ghc.yaml?branch=main&label=GHC&labelColor=2f353c)](https://github.com/tbidne/hs-nix-shells/actions/workflows/ghc.yaml)
[![LiquidHaskell](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/liquidhaskell.yaml?branch=main&label=LiquidHaskell&labelColor=2f353c)](https://github.com/tbidne/hs-nix-shells/actions/workflows/liquidhaskell.yaml)
[![style](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/style.yaml?branch=main&label=style&labelColor=2f353c)](https://github.com/tbidne/hs-nix-shells/actions/workflows/style.yaml)

</div>

---

# Introduction

This packages provides nix shells for general haskell development with `cabal`.

# Shells

This section lists the provided shells. For shells with arguments, the default value (if any) is listed in parentheses.

### Common Args

* `ghcid` (`true`)
* `hls` (`"ormolu"`). Can be:
  * `"none"`
  * `"ormolu"` (only formatter is `ormolu`)
  * `"full"` (all plugins)

## Default

**Attr:** `default`

**Description:** Nix shell for general haskell development. Most packages can use this shell. Includes `cabal` and `GHC`.

**Args:**

* `ghcid`
* `ghcVers` (`ghc944`): Can be `ghc8107`, `ghc902`, `ghc925`, `ghc944`.
* `hls`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default

nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default \
  --argstr ghcVers ghc925 \
  --argstr hls full \
  --arg ghcid false
```

## GHC

**Attr:** `ghc`

**Description:** Nix shell for [`GHC`](https://gitlab.haskell.org/ghc/ghc/) development. Includes `cabal`, `GHC 9.4.4`, and
other needed dependencies.

**Args:**

* `ghcid`
* `hls`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A ghc
```

## LiquidHaskell

**Attr:** `liquidhaskell`

**Description:** Nix shell for [`LiquidHaskell`](https://github.com/ucsd-progsys/liquidhaskell/). Includes `cabal`, `GHC 9.2.5`, and the `z3` smt solver.

**Args:**

* `ghcid`
* `hls`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A liquidhaskell
```