{ config, pkgs, ... }:

{
  services.flatpak.enable = true;
  environment.etc."flatpak/flatpak.conf".text = ''
    [Flatpak]
    SystemInstallationID=default
    RequireFlatpakSession=true
    DefaultInstallation=user
  '';
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.systemPackages = with pkgs; [
    flatpak
    distrobox
    podman
    boxbuddy
    git
    gnome-menus
    gnomeExtensions.arcmenu
    firefox-esr
    #flatpak store
    /*firejail
    (writeShellScriptBin "flatpak" ''
      if [[ "$1" == "run" ]]; then
        shift
        exec firejail ${pkgs.flatpak}/bin/flatpak run "$@"
      else
        exec ${pkgs.flatpak}/bin/flatpak "$@"
      fi
    '')*/
  ];
  /*# Declaración correcta del wrapper con setuid
  security.wrappers.firejail = {
    source = "${pkgs.firejail}/bin/firejail";
    owner = "root";
    group = "root";
    setuid = true;  # ✅ NO uses "permissions"
  };

  # Asegura que /run/firejail exista
  systemd.tmpfiles.rules = [
    "d /run/firejail 0755 root root"
  ];*/

  programs.firejail.enable = true;
  # Crea un wrapper con setuid y permisos correctos
  security.wrappers.firejail = {
    source = "${pkgs.firejail}/bin/firejail";
    owner = "root";
    group = "root";
    permissions = "u=rwx,g=rx,o=x,u+s"; # Esto asegura que tenga setuid Y ejecución para root
  };

  # Asegura que el directorio /run/firejail exista
  systemd.tmpfiles.rules = [
    "d /run/firejail 0755 root root"
  ];

  programs.firejail.wrappedBinaries = {
    /*firefox = {
      executable = "${pkgs.firefox}/bin/firefox";
      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    };*/
    firefox-esr = {
      executable = "${pkgs.firefox-esr}/bin/firefox-esr";
      profile = "${pkgs.firejail}/etc/firejail/firefox-esr.profile";
    };
  };


  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  users.users.leonardocl.extraGroups = [ "podman" ];
}