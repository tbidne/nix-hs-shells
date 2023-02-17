<div align="center">

# hs-nix-shells

## Provides nix shells for some haskell repositories.

[![GHC](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/ghc.yaml?branch=main&label=GHC)](https://github.com/tbidne/hs-nix-shells/actions/workflows/ghc.yaml)
[![liquidhaskell](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/liquidhaskell.yaml?branch=main&label=LiquidHaskell)](https://github.com/tbidne/hs-nix-shells/actions/workflows/liquidhaskell.yaml)
[![safe-exceptions](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/safe-exceptions.yaml?branch=main&label=safe-exceptions)](https://github.com/tbidne/hs-nix-shells/actions/workflows/safe-exceptions.yaml)
[![style](http://img.shields.io/github/actions/workflow/status/tbidne/hs-nix-shells/style.yaml?branch=main&label=style&logoColor=white&labelColor=2f353c)](https://github.com/tbidne/hs-nix-shells/actions/workflows/style.yaml)

</div>

# Usage

```
nix-shell http://github.com/tbidne/hs-nix-shells/archive/master.tar.gz -A liquidhaskell

nix-shell http://github.com/tbidne/hs-nix-shells/archive/master.tar.gz -A liquidhaskell --argstr ghcVers "ghc925" --arg dev false
```