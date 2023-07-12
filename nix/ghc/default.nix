{ ghcVers ? "ghc962"
, hls ? false
}:

# https://gitlab.haskell.org/ghc/ghc/-/wikis/building/hadrian
# 1. ./boot
# 2. ./configure
# 3. ./hadrian/build -j --flavour=validate+werror

# make sure _build is empty if compiler versions are changed.

# git submodule update --init --recursive

let
  cabal_template = import ../cabal_template.nix;
  lib = import ../lib.nix;

  # https://gitlab.haskell.org/ghc/ghc/-/wikis/building/preparation/tools
  extraGhcInputs = c: [
    c.alex
    c.ghc
    c.happy
  ];

  extraInputs = p: [
    p.autoreconfHook
    p.automake
    p.gmp
    p.gnumake
    p.libffi
    p.ncurses
    p.perl
    p.python3
    p.sphinx
  ];

  devTools = lib.emptyDevTools // { inherit hls; };

  shellHook = ''
    ghc_clean () {
      rm -rf _build
    }

    ghc_build () {
      ./hadrian/build -j
    }

    ghc_fbuild () {
      set -e

      ghc_clean

      ./boot

      ./configure

      ghc_build
    }
  '';
in
cabal_template {
  inherit devTools extraInputs extraGhcInputs ghcVers shellHook;
}
