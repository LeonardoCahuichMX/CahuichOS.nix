{
  description = "Sistema NixOS inmutable para ThinkPad L15";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    #impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          #impermanence.nixosModules.impermanence
          ./hardware-configuration/thinkpad-hw.nix
          ./hosts/thinkpad.nix
        ];
      };

      # Este paquete es opcional, útil para ejecutarlo como `nix run`
      packages.x86_64-linux.deploy-thinkpad = 
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        in
        pkgs.writeShellScriptBin "deploy-thinkpad" ''
          echo "⚙️ Ejecutando despliegue para ThinkPad..."
          nix flake lock
          sudo nixos-rebuild switch --flake .#thinkpad
        '';
    };
}