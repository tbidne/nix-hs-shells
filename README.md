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

GHC shells that are stable (i.e. the hash is not expected to change) are bolded. In the interest of brevity, only the latest 3 major versions are listed. Older versions are listed in the collapsed table below.

| GHC        | Caching | apply-refact | fourmolu | hlint | hls | ormolu |
|:-----------|--------:|-------------:|---------:|------:|----:|-------:|
| 9.14.1     |      🌕 |           🌑 |       🌑 |    🌑 |  🌑 |     🌑 |
| 9.12.3     |      🌕 |           🌑 |       🌑 |    🌑 |  🌑 |     🌑 |
| **9.12.2** |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.12.1** |      🌕 |           🌑 |       🌑 |    🌑 |  🌑 |     🌑 |
| **9.10.3** |      🌕 |           🌑 |       🌕 |    🌑 |  🌕 |     🌕 |
| **9.10.2** |      🌕 |           🌑 |       🌓 |    🌑 |  🌓 |     🌓 |
| **9.10.1** |      🌕 |           🌑 |       🌕 |    🌑 |  🌕 |     🌕 |

<details>
<summary>Click to expand legacy versions</summary>

| GHC        | Caching | apply-refact | fourmolu | hlint | hls | ormolu |
|:-----------|--------:|-------------:|---------:|------:|----:|-------:|
| **9.8.4**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.8.3**  |      🌕 |           🌓 |       🌓 |    🌓 |  🌓 |     🌓 |
| **9.8.2**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.8.1**  |      🌕 |           🌑 |       🌓 |    🌓 |  🌓 |     🌓 |
| **9.6.7**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.6.6**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.6.5**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.6.4**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.6.3**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.6.2**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.6.1**  |      🌓 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.4.8**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.4.7**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.4.6**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.4.5**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.4.4**  |      🌓 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.2.8**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.2.7**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.2.5**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **9.0.2**  |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |
| **8.10.7** |      🌕 |           🌕 |       🌕 |    🌕 |  🌕 |     🌕 |

</details>

We also provide less granular aliases e.g. `ghc9`, `ghc912`, which point to the latest compiler in that series that has fast caching with as many tools as possible.

# Shells

This section lists the provided shells. For shells with arguments, the default value (if any) is listed in parentheses.

### Common Args

* `apply-refact` (`false`)
* `fourmolu` (`false`)
* `ghc-vers`
* `ormolu` (`false`)
* `hlint` (`false`)
* `hls` (`false`)

## Default

**Attr:** `default`

**Description:** Nix shell for general haskell development. Most packages can use this shell. Includes `cabal` and `ghc`. Note that there is no guarantee every dev tool will work with every `ghc-vers`. In particular, there will often be a lag time before the latest GHCs are fully supported.

The default ghc is the latest version that works with every tool and has decent nix caching.

**Args:**

* `apply-refact`
* `fourmolu`
* `ghc-vers`
* `hlint`
* `hls`
* `ormolu`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default

nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A default \
  --argstr ghc-vers ghc925 \
  --arg hls true
```

## LiquidHaskell

**Attr:** `liquidhaskell`

**Description:** Nix shell for [`LiquidHaskell`](https://github.com/ucsd-progsys/liquidhaskell/). Includes `cabal`, `ghc`, and the `z3` smt solver.

**Args:**

* `ghc-vers`
* `hlint`
* `hls`

**Usage:**

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/main.tar.gz -A liquidhaskell
```
