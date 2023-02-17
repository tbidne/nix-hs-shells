{ dev ? true
}:

# https://gitlab.haskell.org/ghc/ghc/-/wikis/building/hadrian
# 1. ./boot
# 2. ./configure
# 3. ./hadrian/build -j --flavour=validate+werror

# make sure _build is empty if compiler versions are changed.

# git submodule update --init --recursive

let
  pkgs = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/545c7a31e5dedea4a6d372712a18e00ce097d462.tar.gz";
    })
    { };
  compiler = pkgs.haskell.packages.ghc944;

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
