{ dev ? true
}:

# https://gitlab.haskell.org/ghc/ghc/-/wikis/building/hadrian
# 1. ./boot
# 2. ./configure
# 3. ./hadrian/build -j --flavour=validate+werror

# make sure _build is empty if compiler versions are changed.

# git submodule update --init --recursive

let
  ghcVers = "ghc944";
  pkgs = (import ../lib.nix).getPkgs ghcVers;
  compiler = pkgs.haskell.packages.${ghcVers};

  # https://gitlab.haskell.org/ghc/ghc/-/wikis/building/preparation/tools
  hsDeps = with compiler; [
    alex
    ghc
    happy
  ];

  otherDeps = with pkgs; [
    autoreconfHook
    automake
    cabal-install
    gmp
    gnumake
    libffi
    ncurses
    perl
    python3
    sphinx
  ];

  devTools =
    if dev then [
      compiler.ghcid
      compiler.haskell-language-server
    ] else [ ];
in
pkgs.mkShell {
  buildInputs = hsDeps ++ otherDeps ++ devTools;
}
