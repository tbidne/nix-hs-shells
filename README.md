<div align="center">

# nix-hs-shells

[![ci](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/ci.yaml?branch=main&labelColor=2f353c)](https://github.com/tbidne/hs-nix-shells/actions/workflows/ci.yaml)
[![MIT](https://img.shields.io/github/license/tbidne/nix-hs-shells?color=blue)](https://opensource.org/licenses/MIT)

</div>

---

- [Introduction](#introduction)
- [Shells](#shells)
  - [Default](#default)
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
  * `ghc944`, `ghc945`, `ghc946`, `ghc947`
  * `ghc961`, `ghc962`, `ghc963`
  * `ghc981`
* `ormolu` (`false`)
* `hlint` (`false`)
* `hls` (`false`)

## Default

**Attr:** `default`

**Description:** Nix shell for general haskell development. Most packages can use this shell. Includes `cabal` and `ghc`. Note that there is no guarantee every dev tool will work with every `ghcVers`. In particular, there will often be a lag time before the latest GHCs are fully supported.

The default ghc is the latest version that works with every tool and has decent nix caching.

**Args:**

* `applyRefact`
* `fourmolu`
* `ghcVers` (`ghc963`)
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

## LiquidHaskell

**Attr:** `liquidhaskell`

**Description:** Nix shell for [`LiquidHaskell`](https://github.com/ucsd-progsys/liquidhaskell/). Includes `cabal`, `ghc`, and the `z3` smt solver.

**Args:**

* `ghcVers` (`ghc947`)
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