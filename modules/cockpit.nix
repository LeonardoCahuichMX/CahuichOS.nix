{
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = false;
        LoginTitle = "CahuichOS Web Console";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cockpit
    cockpit-podman
    cockpit-networkmanager
  ];
}