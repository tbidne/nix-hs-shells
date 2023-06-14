# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A ghc

let
  cabal_template = import ./nix/cabal_template.nix;
  lib = import ./nix/lib.nix;

  defGhcLatest =
    { applyRefact ? false
    , fourmolu ? false
    , ghcVers ? "ghc945"
    , hlint ? false
    , hls ? false
    , ormolu ? false
    }:
    cabal_template {
      inherit ghcVers;
      devTools = { inherit applyRefact fourmolu hlint hls ormolu; };
    };
in
{
  default = defGhcLatest;

  ghc = import ./nix/ghc/default.nix;

  liquidhaskell =
    { ghcVers ? "ghc925"
    , hlint ? false
    , hls ? false
    }:
    cabal_template {
      inherit ghcVers;
      # no ormolu or fourmolu since LH is not formatted with either.
      devTools = lib.emptyDevTools // { inherit hlint hls; };
      extraInputs = p: [ p.z3 ];
    };
}
