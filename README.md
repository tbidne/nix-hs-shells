<div align="center">

# nix-hs-shells

[![ci](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/ci.yaml?branch=main&labelColor=2f353c)](https://github.com/tbidne/hs-nix-shells/actions/workflows/ci.yaml)
[![MIT](https://img.shields.io/github/license/tbidne/nix-hs-shells?color=blue)](https://opensource.org/licenses/MIT)

</div>

---

- [Introduction](#introduction)
- [Shells](#shells)
  - [Default](#default)
  - [GHC](#ghc)
  - [LiquidHaskell](#liquidhaskell)
- [Development](#development)

# Introduction

This packages provides lightweight nix shells for general haskell development with `cabal`.

# Shells

This section lists the provided shells. For shells with arguments, the default value (if any) is listed in parentheses.

### Common Args

* `applyRefact` (`false`)
* `fourmolu` (`false`)
* `ghcVers`:
  * `ghc8107`
  * `ghc902`
  * `ghc925`, `ghc926`, `ghc927`, `ghc928`
  * `ghc944`, `ghc945`, `ghc946`
  * `ghc961`, `ghc962`
* `ormolu` (`false`)
* `hlint` (`false`)
* `hls` (`false`)

## Default

**Attr:** `default`

**Description:** Nix shell for general haskell development. Most packages can use this shell. Includes `cabal` and `GHC`. Note that there is no guarantee every dev tool will work with every `ghcVers`. In particular, there will often be a lag time before the latest GHCs are fully supported.

The default ghc is the latest version that works with every tool and has decent nix caching.

**Args:**

* `applyRefact`
* `fourmolu`
* `ghcVers` (`ghc946`)
* `hlint`
* `hls`
* `ormolu`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default

nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default \
  --argstr ghcVers ghc925 \
  --arg hls true
```

## GHC

> **Warning**
> The GHC shell is deprecated in favor of [ghc.nix](https://www.github.com/alpmestan/ghc.nix). The latter is better maintained and behaves more predictably (e.g. this shell will fail the validate flavour due to unexpected cpp warnings).

**Attr:** `ghc`

**Description:** Nix shell for [`GHC`](https://gitlab.haskell.org/ghc/ghc/) development. Includes `cabal`, `ghc`, and other needed dependencies.

**Args:**

* `ghcVers` (`ghc962`)
* `hls`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A ghc
```

## LiquidHaskell

**Attr:** `liquidhaskell`

**Description:** Nix shell for [`LiquidHaskell`](https://github.com/ucsd-progsys/liquidhaskell/). Includes `cabal`, `ghc`, and the `z3` smt solver.

**Args:**

* `ghcVers` (`ghc925`)
* `hlint`
* `hls`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A liquidhaskell
```

# Development

A formatter is provided via [./ci/flake.nix](./ci/flake.nix):

```
nix run ./ci#format
```