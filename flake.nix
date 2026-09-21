{
  description = "A theme for KDE Plasma";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      overlays.default = final: prev: {
        vinyl-theme = prev.callPackage ./package.nix { };
      };

      nixosModules.nixpkgs-overlay = inputs: {
        nixpkgs.overlays = [
          self.overlays.default
        ];
      };
    }
    // (inputs.utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        rec {
          packages = rec {
            default = vinyl-theme;
            vinyl-theme = pkgs.callPackage ./package.nix { };
          };

          devShells.default = pkgs.mkShell {
            inputsFrom = [ packages.default ];
          };
        }
      )
    );
}
