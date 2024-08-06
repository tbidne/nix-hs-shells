# Template for a typical cabal+ghc shell.

{
  devTools,
  extraInputs ? _: [ ],
  extraGhcInputs ? _: [ ],
  ghcVers,
  shellHook ? "",
  wrapper ? _: x: x,
}:

let
  lib = import ./lib.nix;
  ghcSet = lib.getGhcSet ghcVers;
  pkgs = ghcSet.pkgs;
  compiler = ghcSet.compiler;
  shell = pkgs.mkShell {
    inherit shellHook;

    buildInputs = [
      compiler.ghc
      pkgs.cabal-install
      pkgs.zlib
    ] ++ (lib.mkDev devTools ghcSet) ++ (extraInputs pkgs) ++ (extraGhcInputs compiler);
  };
in
(wrapper pkgs) shell
