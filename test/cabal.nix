{ use-hash ? true
, with-sha ? false
}:

let
  main = import ../default.nix;
  add-non-nulls = main.inputs.nix-utils.add-non-nulls;

  hash = "b39924fc7764c08ae3b51beef9a3518c414cdb7d";
  flake-path = ./test-flake.lock;
  sha256 = "1yivdc9k1qcr29yxq9pz4qs2i29wgxj5y550kp0lz2wzp45ksi1x";

  pkgs-others = [
    { key = "sha256"; val = if with-sha then sha256 else null; }
  ];

  pkgs-input =
    if use-hash
    then add-non-nulls { inherit hash; } pkgs-others
    else add-non-nulls { inherit flake-path; } pkgs-others;

  cabal-input = { ghc-version = "ghc923"; };

in
main.cabal-shell (cabal-input // pkgs-input)
