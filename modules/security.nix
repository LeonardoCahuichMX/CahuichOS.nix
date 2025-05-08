{ config, ... }:

{
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
  services.openssh.enable = false;

  # nix.settings.trusted-users = [ "root" ];
}