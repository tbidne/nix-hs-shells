# Template for a typical cabal+ghc shell.

{ devTools
, extraInputs ? _: [ ]
, extraGhcInputs ? _: [ ]
, ghcVers
, shellHook ? ""
}:

let
  lib = import ./lib.nix;
  pkgs = lib.getPkgs ghcVers;
  compiler = pkgs.haskell.packages."${ghcVers}";
in
pkgs.mkShell {
  inherit shellHook;

  buildInputs =
    [
      compiler.ghc
      pkgs.cabal-install
      pkgs.zlib
    ] ++ (lib.mkDev compiler devTools pkgs)
    ++ (extraInputs pkgs)
    ++ (extraGhcInputs compiler);
}
