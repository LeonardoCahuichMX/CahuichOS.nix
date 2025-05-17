{ config, pkgs, ... }:

{
  # boot.kernelPackages = pkgs.linuxPackages; # Esto ahora apunta al kernel 6.1
  imports = [
    ../modules/base.nix
    ../modules/users.nix
    ../modules/security.nix
    ../modules/desktop.nix
    ../modules/flatpak.nix
    # ../modules/branding.nix
  ];

  # Archivo personalizado para tu propio uso
  environment.etc."cahuichos-branding".text = ''
    distro = "CahuichOS"
    version = "0.1"
    codename = "19"
    build = "beta"
    author = "Leo"
  '';

  # networking.hostName = "thinkpad";
}
