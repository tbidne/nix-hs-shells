# Template for a typical cabal+ghc shell.

{
  devTools,
  extraInputs ? _: [ ],
  extraGhcInputs ? _: [ ],
  ghc-vers,
  shellHook ? "",
  wrapper ? _: x: x,
}:

let
  lib = import ./lib.nix;
  ghcSet = lib.getGhcSet ghc-vers;
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
