# Provides package-specific shells as attributes.
#
# E.g.
#
# nix-shell . -A default

let
  cabal_template = import ./nix/cabal_template.nix;
  ghc_map = import ./nix/ghc_map.nix;
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

  help = ghc_map.latest.pkgs.writeShellApplication {
    name = "help";

    text = ''
      echo ""
      echo "nix-hs-shells: provides nix-shells with GHC and related tools."
      echo ""
      echo "Below is a list of all supported GHCs. Stability refers to whether the hash"
      echo "might change in the future."
      echo ""
      echo "See github.com/tbidne/nix-hs-shell#readme for more detail."
      echo ""

      echo -e "\e[34mLegend:\e[0m"
      echo -e "\e[32m- Stable, good caching, and supports all tools\e[0m"
      echo -e "\e[33m- Stable\e[0m"
      echo -e "\e[31m- Unstable\e[0m"
      echo ""

      echo -e "\e[34mCurrent GHCs:\e[0m"
      echo -e "- \e[31m9.14.1\e[0m"
      echo -e "- \e[33m9.12.1\e[0m, \e[32m9.12.2\e[0m, \e[31m9.12.3\e[0m, \e[31m9.12.4\e[0m"
      echo -e "- \e[33m9.10.1\e[0m, \e[33m9.10.2\e[0m, \e[33m9.10.3\e[0m"
      echo ""

      echo -e "\e[34mLegacy GHCs:\e[0m"
      echo -e "- \e[33m9.8.1\e[0m, \e[32m9.8.2\e[0m, \e[33m9.8.3\e[0m, \e[32m9.8.4"
      echo -e "- \e[33m9.6.1\e[0m, \e[32m9.6.2\e[0m, \e[32m9.6.3\e[0m, \e[32m9.6.4\e[0m, \e[32m9.6.5\e[0m, \e[32m9.6.6\e[0m, \e[32m9.6.7\e[0m"
      echo -e "- \e[33m9.4.4\e[0m, \e[32m9.4.5\e[0m, \e[32m9.4.6\e[0m, \e[32m9.4.7\e[0m, \e[32m9.4.8\e[0m"
      echo -e "- \e[32m9.2.5\e[0m, \e[32m9.2.6\e[0m, \e[32m9.2.7\e[0m, \e[32m9.2.8\e[0m"
      echo -e "- \e[32m9.0.2\e[0m"
      echo -e "- \e[32m8.10.7\e[0m"
    '';

    runtimeInputs = [ ];
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
