# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A ghc

let
  cabal_template = import ./cabal_template.nix;
  defGhcLatest =
    { ghcVers ? "ghc961"
    , hls ? false
    }:
    cabal_template {
      inherit ghcVers;
      devTools = { inherit hls; };
    };
in
{
  default = defGhcLatest;

  ghc = import ./ghc/default.nix;

  liquidhaskell =
    { ghcVers ? "ghc925"
    , hls ? false
    }:
    cabal_template {
      inherit ghcVers;
      devTools = { inherit hls; };
      extraInputs = p: [ p.z3 ];
    };
}
