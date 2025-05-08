{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leonardocl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    description = "Leonardo Cahuich López";
    packages = with pkgs; [
    #  thunderbird
    ];
  };
}