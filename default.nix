# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A ghc

let
  cabal_template = import ./cabal_template.nix;
  defGhcLatest =
    { cabalPlan ? false
    , ghcid ? false
    , ghcVers ? "ghc944"
    , hls ? false
    }:
    cabal_template {
      inherit ghcVers;
      devTools = { inherit cabalPlan ghcid hls; };
    };
in
{
  default = defGhcLatest;

  ghc = import ./ghc/default.nix;

  liquidhaskell =
    { cabalPlan ? false
    , ghcid ? false
    , hls ? false
    }:
    cabal_template {
      devTools = { inherit cabalPlan ghcid hls; };
      ghcVers = "ghc925";
      extraInputs = p: [ p.z3 ];
    };
}
