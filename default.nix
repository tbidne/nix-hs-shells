# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A ghc

let
  defGhc925 =
    { dev ? true
    , ghcVers ? "ghc925"
    }:
    import ./cabal_template.nix { inherit dev ghcVers; };
in
{
  ghc = import ./ghc/default.nix;

  # default gives us a "default" haskell shell:
  #
  # * cabal
  # * ghc (defaulting to 9.2.5, overriden by ghcVers)
  # * hls
  # * ghcid
  #
  # Hls and ghcid can be omitted with dev = false
  default = defGhc925;

  liquidhaskell = { dev ? true }:
    import ./cabal_template.nix { inherit dev; ghcVers = "ghc925"; };

  # it is merely an impl detail that these happen to both work with the
  # default shell for now.
  safe-exceptions = defGhc925;
}
