# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A ghc

let
  defGhcLatest =
    { ghcVers ? "ghc944"
    , cabalPlan ? false
    , ghcid ? true
    , hls ? "ormolu"
    }:
    import ./cabal_template.nix { inherit ghcVers cabalPlan ghcid hls; };
in
{
  default = defGhcLatest;

  ghc = import ./ghc/default.nix;

  liquidhaskell = { cabalPlan ? false, ghcid ? true, hls ? "ormolu" }:
    import ./cabal_template.nix {
      inherit cabalPlan ghcid hls;
      ghcVers = "ghc925";
      extraInputs = p: [ p.z3 ];
    };
}
