{ ghc-vers ? "ghc925"
, dev ? true
}:

let
  hash925 = "545c7a31e5dedea4a6d372712a18e00ce097d462";
  ghc-map = {
    ghc925 = { ghc = "ghc925"; hash = hash925; };
  };
  val = ghc-map.${ghc-vers};
  pkgs = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${val.hash}.tar.gz";
    })
    { };
  compiler = pkgs.haskell.packages."${val.ghc}";
  dev-tools = [
    compiler.haskell-language-server
    compiler.ghcid
  ];
in
pkgs.mkShell {
  buildInputs =
    [
      pkgs.cabal-install
      compiler.ghc
    ] ++ (if dev then dev-tools else [ ]);
}
