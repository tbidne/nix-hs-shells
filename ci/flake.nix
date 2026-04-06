{
  description = "CI shell";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      self,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem =
        { pkgs, ... }:
        let
          devTools = [ pkgs.nixpkgs-fmt ];
        in
        {
          apps.format =
            let
              name = "nixfmt";
              drv = pkgs.writeShellApplication {
                inherit name;
                text = ''
                  fd . . -e nix | xargs nixfmt
                '';
                runtimeInputs = [
                  pkgs.fd
                  pkgs.nixfmt
                ];
              };
            in
            {
              type = "app";
              program = "${drv}/bin/${name}";
            };

          devShells.default = pkgs.mkShell { buildInputs = devTools; };
        };
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
