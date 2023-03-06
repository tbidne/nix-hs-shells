# Template for a typical cabal+ghc shell.

{ extraInputs ? _: [ ]
, cabalPlan
, ghcid
, ghcVers
, hls
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
    ] ++ (lib.mkDev compiler pkgs cabalPlan ghcid hls)
    ++ (extraInputs pkgs);
}
