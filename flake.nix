{
  description = "Sistema NixOS inmutable para ThinkPad L15";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";
      overlays = import ./overlays;
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      # 👇 Importamos el script cve-scan como paquete
      cveScanApp = pkgs.callPackage ./modules/scan-cves.nix { };
    in
    {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration/thinkpad-hw.nix
          ./hosts/thinkpad.nix

          # 👇 Añadimos el servicio systemd para escaneo de vulnerabilidades
          ({ pkgs, ... }: {
            systemd.services.cve-scan = {
              description = "Escaneo de CVEs con base de datos pública";
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                ExecStart = "${cveScanApp}/bin/cve-scan";
                Type = "oneshot";
              };
              startAt = "weekly"; # puedes usar daily/hourly si prefieres
            };
          })
        ];
        specialArgs = { inherit self; };
        pkgs = pkgs;
      };

      # 👇 Script de despliegue automático
      packages.${system} = {
        deploy-thinkpad = pkgs.writeShellScriptBin "deploy-thinkpad" ''
          echo "⚙️ Ejecutando despliegue para ThinkPad..."
          nix flake lock
          sudo nixos-rebuild switch --flake .#thinkpad
        '';

        # 👇 Exponemos el escáner como ejecutable desde el flake
        cve-scan = cveScanApp;
      };

      # 👇 También como app invocable desde `nix run`
      apps.${system}.cve-scan = {
        type = "app";
        program = "${cveScanApp}/bin/cve-scan";
      };
    };
}
