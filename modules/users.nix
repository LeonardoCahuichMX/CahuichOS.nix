{ config, pkgs, ... }:

{
  # Inmutabilida de usuarios
  users.mutableUsers = false;

  users.users.root = {
    /*hashedPassword = "$6$RCffOWbMIwdeiorh$FTtR0QmVH/HrZ8hFQFo0NIv5dJcGjuPQJgiCDy9R1YjypHyCcXCW2gP0XbmqwS4F2mkFFLmbqwRHcQmMlspvD.";  # Generado con `mkpasswd -m sha-512`*/
    hashedPassword = "!";  # o "*", lo que bloquea el inicio de sesión
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    description = "Admin";
    hashedPassword = "$6$RCffOWbMIwdeiorh$FTtR0QmVH/HrZ8hFQFo0NIv5dJcGjuPQJgiCDy9R1YjypHyCcXCW2gP0XbmqwS4F2mkFFLmbqwRHcQmMlspvD.";  # Generado con `mkpasswd -m sha-512`
    /*openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1... tu_clave"
    ];*/
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leonardocl = {
    isNormalUser = true;
    /*extraGroups = [ "wheel" "networkmanager" ];*/
    extraGroups = [ "networkmanager" ];
    description = "Leonardo Cahuich López";
    hashedPassword = "$6$skXr57fXOeVNZv9h$qg.bNJy9MDGbcGkoFosDs4.xveH1.zDfGbET9Qc3sunM7eG5UOztR9dPNHtr0.mWr0IWbuZRwEYYdquHDMOXm/"; # Usa el tuyo
    packages = with pkgs; [
    #  thunderbird
    ];
  };
}