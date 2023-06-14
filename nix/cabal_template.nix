# Template for a typical cabal+ghc shell.

{ devTools
, extraInputs ? _: [ ]
, extraGhcInputs ? _: [ ]
, ghcVers
, shellHook ? ""
}:

let
  lib = import ./lib.nix;
  ghcSet = lib.getGhcSet ghcVers;
  pkgs = ghcSet.pkgs;
  compiler = ghcSet.compiler;
in
pkgs.mkShell {
  inherit shellHook;

  buildInputs =
    [
      compiler.ghc
      pkgs.cabal-install
      pkgs.zlib
    ] ++ (lib.mkDev devTools ghcSet)
    ++ (extraInputs pkgs)
    ++ (extraGhcInputs compiler);
}
