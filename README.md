<div align="center">

# nix-hs-shells

[![ci](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/ci.yaml?branch=main&labelColor=2f353c&label=ci)](https://github.com/tbidne/hs-nix-shells/actions/workflows/ci.yaml)
[![libs](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/libs.yaml?branch=main&labelColor=2f353c&label=libs)](https://github.com/tbidne/hs-nix-shells/actions/workflows/libs.yaml)
[![MIT](https://img.shields.io/github/license/tbidne/nix-hs-shells?color=blue)](https://opensource.org/licenses/MIT)

</div>

---

- [Introduction](#introduction)
- [GHC Support Matrix](#ghc-support-matrix)
- [Shells](#shells)
  - [Default](#default)
  - [LiquidHaskell](#liquidhaskell)

# Introduction

This packages provides lightweight nix shells for general haskell development with `cabal`.

# GHC Support Matrix

The below matrix shows how well a particular GHC version is supported. Legend:

- 🌕: Support exists with good caching.
- 🌓: Support exists with poor caching.
- 🌑: Support does not exist.

In particular:

- **Caching:** A 🌕 means that the GHC shell has fast caching for itself. A 🌓 means that the bare GHC shell has poor caching.
- **HLS:** If the **haskell-language-server** is supported.
- **Other Tools:** A 🌕 means that all (non-HLS) tools are supported with good caching. A 🌓 means that at least one tool has poor caching, and 🌑 means that at least one tool is not supported.

GHC versions that support all tools and have fast caching are bolded. Precise information can be found in the source: [nix/ghc_map.nix](./nix/ghc_map.nix). In the interest of brevity, only the latest 3 major versions are listed. Older versions are listed in the collapsed table below.

| GHC        | Caching | HLS | Other Tools |
|:-----------|--------:|----:|------------:|
| 9.4.4      |      🌓 |  🌕 |          🌕 |
| **9.4.5**  |      🌕 |  🌕 |          🌕 |
| **9.4.6**  |      🌕 |  🌕 |          🌕 |
| **9.4.7**  |      🌕 |  🌕 |          🌕 |
| **9.4.8**  |      🌕 |  🌕 |          🌕 |
| 9.6.1      |      🌓 |  🌕 |          🌕 |
| **9.6.2**  |      🌕 |  🌕 |          🌕 |
| **9.6.3**  |      🌕 |  🌕 |          🌕 |
| **9.6.4**  |      🌕 |  🌕 |          🌕 |
| **9.6.5**  |      🌕 |  🌕 |          🌕 |
| 9.8.1      |      🌕 |  🌓 |          🌑 |
| **9.8.2**  |      🌕 |  🌕 |          🌕 |
| 9.10.1     |      🌕 |  🌑 |          🌑 |

<details>
<summary>Click to expand legacy versions</summary>

| GHC        | Caching | HLS | Other Tools |
|:-----------|--------:|----:|------------:|
| **8.10.7** |      🌕 |  🌕 |          🌕 |
| **9.0.2**  |      🌕 |  🌕 |          🌕 |
| **9.2.5**  |      🌕 |  🌕 |          🌕 |
| **9.2.7**  |      🌕 |  🌕 |          🌕 |
| **9.2.8**  |      🌕 |  🌕 |          🌕 |

</details>

# Shells

This section lists the provided shells. For shells with arguments, the default value (if any) is listed in parentheses.

### Common Args

* `applyRefact` (`false`)
* `fourmolu` (`false`)
* `ghcVers`:
  * `ghc8107`
  * `ghc902`
  * `ghc925`, `ghc926`, `ghc927`, `ghc928`
  * `ghc944`, `ghc945`, `ghc946`, `ghc947`, `ghc948`
  * `ghc961`, `ghc962`, `ghc963`, `ghc964`, `ghc965`
  * `ghc981`, `ghc982`
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
* `ghcVers` (`ghc982`)
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

* `ghcVers`
* `hlint`
* `hls`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A liquidhaskell
```
