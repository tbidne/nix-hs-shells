# Template for a typical cabal+ghc shell.

{ extraInputs ? _: [ ]
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
    ] ++ (lib.mkDev compiler pkgs ghcid hls)
    ++ (extraInputs pkgs);
}
