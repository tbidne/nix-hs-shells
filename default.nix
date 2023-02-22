# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A ghc

let
  defGhcLatest =
    { ghcVers ? "ghc944"
    , ghcid ? true
    , hls ? "ormolu"
    }:
    import ./cabal_template.nix { inherit ghcVers ghcid hls; };
in
{
  default = defGhcLatest;

  ghc = import ./ghc/default.nix;

  liquidhaskell = { ghcid ? true, hls ? "ormolu" }:
    import ./cabal_template.nix {
      inherit ghcid hls;
      ghcVers = "ghc925";
      extraInputs = p: [ p.z3 ];
    };
}
