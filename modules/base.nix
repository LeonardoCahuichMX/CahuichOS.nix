{ config, pkgs, ... }:

{
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "es_MX.UTF-8";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [ "root" ];
    auto-optimise-store = true;
  };

  environment.systemPackages = [ pkgs.git ];
  nixpkgs.config.allowUnfree = true;

  programs.command-not-found.enable = false;
  environment.pathsToLink = [ "/share/zsh" ];
}