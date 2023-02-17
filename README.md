<div align="center">

# hs-nix-shells

## Provides nix shells for some haskell repositories.

[![GHC](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/ghc.yaml?branch=main&label=GHC)](https://github.com/tbidne/hs-nix-shells/actions/workflows/ghc.yaml)
[![liquidhaskell](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/liquidhaskell.yaml?branch=main&label=LiquidHaskell)](https://github.com/tbidne/hs-nix-shells/actions/workflows/liquidhaskell.yaml)

</div>

# Usage

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/master.tar.gz -A liquidhaskell

nix-shell http://github.com/tbidne/hs-nix-shells/archive/master.tar.gz -A liquidhaskell --argstr ghc-vers "ghc925" --arg dev false
```