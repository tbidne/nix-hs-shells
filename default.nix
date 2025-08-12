# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A default

let
  cabal_template = import ./nix/cabal_template.nix;
  lib = import ./nix/lib.nix;
in
{
  default =
    {
      apply-refact ? false,
      fourmolu ? false,
      ghc-vers ? "ghc9122",
      hlint ? false,
      hls ? false,
      ormolu ? false,
    }:
    cabal_template {
      inherit ghc-vers;
      devTools = {
        inherit
          apply-refact
          fourmolu
          hlint
          hls
          ormolu
          ;
      };
    };

  liquidhaskell =
    {
      ghc-vers ? "ghc9122",
      hlint ? false,
      hls ? false,
    }:
    cabal_template {
      inherit ghc-vers;
      # no ormolu or fourmolu since LH is not formatted with either.
      devTools = lib.emptyDevTools // {
        inherit hlint hls;
      };
      extraInputs = p: [ p.z3 ];
    };
}
