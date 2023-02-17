# Template for a typical cabal+ghc shell.

{ dev
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
      pkgs.cabal-install
      compiler.ghc
    ] ++ (lib.devTools dev compiler pkgs);
}
