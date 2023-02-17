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

  # default gives us a "default" haskell shell: gives us cabal and ghc,
  # and defaults to ghc925 and includes ghcid, haskell-language-server.
  default = defGhc925;

  # it is merely an impl detail that these happen to both work with the
  # default shell for now.
  liquidhaskell = defGhc925;
  safe-exceptions = defGhc925;
}
