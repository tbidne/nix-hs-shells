# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A ghc

let
  defGhc944 =
    { ghcVers ? "ghc944"
    , ghcid ? true
    , hls ? "ormolu"
    }:
    import ./cabal_template.nix { inherit ghcVers ghcid hls; };
in
{
  default = defGhc944;

  ghc = import ./ghc/default.nix;

  liquidhaskell = { ghcid ? true, hls ? "ormolu" }:
    import ./cabal_template.nix {
      inherit ghcid hls;
      ghcVers = "ghc925";
      extraInputs = p: [ p.z3 ];
    };
}
