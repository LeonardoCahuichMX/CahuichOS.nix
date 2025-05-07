{ config, pkgs, ... }:

{
  imports = [
    ../modules/base.nix
    ../modules/users.nix
    ../modules/security.nix
    ../modules/desktop.nix
    ../modules/flatpak.nix
  ];

  networking.hostName = "thinkpad";
}