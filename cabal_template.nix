{ dev
, ghcVers
}:

let
  pkgs = (import ./lib.nix).getPkgs ghcVers;
  compiler = pkgs.haskell.packages."${ghcVers}";
  devTools = [
    compiler.haskell-language-server
    compiler.ghcid
  ];
in
pkgs.mkShell {
  buildInputs =
    [
      pkgs.cabal-install
      compiler.ghc
    ] ++ (if dev then devTools else [ ]);
}
