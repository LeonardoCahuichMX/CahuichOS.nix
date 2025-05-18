{
  description = "Sistema NixOS inmutable para ThinkPad L15";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware-configuration/thinkpad-hw.nix
          ./hosts/thinkpad.nix
        ];
        specialArgs = { inherit self; };
        # 👇 Importar los overlays desde el archivo
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = import ./overlays; # <- Aquí se importa la lista
          config.allowUnfree = true;
        };
      };

      packages.x86_64-linux.deploy-thinkpad =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = import ./overlays;
          };
        in
        pkgs.writeShellScriptBin "deploy-thinkpad" ''
          echo "⚙️ Ejecutando despliegue para ThinkPad..."
          nix flake lock
          sudo nixos-rebuild switch --flake .#thinkpad
        '';
    };
}