{ config, pkgs, ... }:

{
  users.users.leo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
}