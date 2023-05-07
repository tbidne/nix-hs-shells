{
  description = "CI shell";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs@{ flake-parts
    , nixpkgs
    , self
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { pkgs, ... }:
        let
          devTools = [
            pkgs.nixpkgs-fmt
          ];
        in
        {
          apps.format =
            let
              name = "nixpkgs-fmt";
              drv = pkgs.writeShellApplication {
                inherit name;
                text = "nixpkgs-fmt .";
                runtimeInputs = [
                  pkgs.nixpkgs-fmt
                ];
              };
            in
            {
              type = "app";
              program = "${drv}/bin/${name}";
            };

          devShells.default = pkgs.mkShell {
            buildInputs = devTools;
          };
        };
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
