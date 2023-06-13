<div align="center">

# nix-hs-shells

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tbidne/nix-hs-shells?include_prereleases&sort=semver)](https://github.com/tbidne/shrun/releases/)
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

This packages provides nix shells for general haskell development with `cabal`.

# Shells

This section lists the provided shells. For shells with arguments, the default value (if any) is listed in parentheses.

### Common Args

* `ghcVers`:
  * `ghc8107`
  * `ghc902`
  * `ghc925`, `ghc926`, `ghc927`, `ghc928`
  * `ghc944`, `ghc945`
  * `ghc961`, `ghc962`
* `hls` (`false`)

## Default

**Attr:** `default`

**Description:** Nix shell for general haskell development. Most packages can use this shell. Includes `cabal` and `GHC`.

**Args:**

* `ghcVers` (`ghc962`)
* `hls`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default

nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default \
  --argstr ghcVers ghc925 \
  --arg hls true
```

## GHC

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