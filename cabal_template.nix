# Template for a typical cabal+ghc shell.

{ devTools
, extraInputs ? _: [ ]
, ghcVers
}:

let
  lib = import ./lib.nix;
  pkgs = lib.getPkgs ghcVers;
  compiler = pkgs.haskell.packages."${ghcVers}";
in
pkgs.mkShell {
  buildInputs =
    [
      compiler.ghc
      pkgs.cabal-install
      pkgs.zlib
    ] ++ (lib.mkDev compiler devTools pkgs)
    ++ (extraInputs pkgs);
}
