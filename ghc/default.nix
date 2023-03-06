{ ghcid ? true
, hls ? "ormolu"
}:

# https://gitlab.haskell.org/ghc/ghc/-/wikis/building/hadrian
# 1. ./boot
# 2. ./configure
# 3. ./hadrian/build -j --flavour=validate+werror

# make sure _build is empty if compiler versions are changed.

# git submodule update --init --recursive

let
  ghcVers = "ghc944";
  lib = import ../lib.nix;

  pkgs = lib.getPkgs ghcVers;
  compiler = pkgs.haskell.packages.${ghcVers};

  # https://gitlab.haskell.org/ghc/ghc/-/wikis/building/preparation/tools
  hsDeps = [
    compiler.alex
    compiler.ghc
    compiler.happy
  ];

  otherDeps = [
    pkgs.autoreconfHook
    pkgs.automake
    pkgs.cabal-install
    pkgs.gmp
    pkgs.gnumake
    pkgs.libffi
    pkgs.ncurses
    pkgs.perl
    pkgs.python3
    pkgs.sphinx
  ];

  cabalPlan = false;
in
pkgs.mkShell {
  buildInputs = hsDeps ++ otherDeps ++ (lib.mkDev compiler pkgs cabalPlan ghcid hls);

  shellHook = ''
    ghc_clean () {
      rm -rf _build
    }

    ghc_build () {
      ./hadrian/build -j --flavour=validate+werror
    }

    ghc_fbuild () {
      set -e

      ghc_clean

      ./boot

      ./configure

      ghc_build
    }
  '';
}
