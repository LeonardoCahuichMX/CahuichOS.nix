{
  description = "Sistema NixOS inmutable para ThinkPad L15";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hardware-configuration/thinkpad-hw.nix
            ./hosts/thinkpad.nix
          ];
        };

        packages.default = pkgs.writeShellScriptBin "deploy-thinkpad" ''
          nix flake lock
          sudo nixos-rebuild switch --flake .#thinkpad
        '';
      });
}