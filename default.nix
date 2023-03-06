# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A ghc

let
  defGhcLatest =
    { cabalPlan ? false
    , ghcid ? true
    , ghcVers ? "ghc944"
    , hls ? "ormolu"
    }:
    import ./cabal_template.nix {
      inherit ghcVers;
      devTools = { inherit cabalPlan ghcid hls; };
    };
in
{
  default = defGhcLatest;

  ghc = import ./ghc/default.nix;

  liquidhaskell = { cabalPlan ? false, ghcid ? true, hls ? "ormolu" }:
    import ./cabal_template.nix {
      devTools = { inherit cabalPlan ghcid hls; };
      ghcVers = "ghc925";
      extraInputs = p: [ p.z3 ];
    };
}
