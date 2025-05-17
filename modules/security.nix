{ config, ... }:

{
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;


  # Configuración de logging de sudo
  security.sudo.extraConfig = ''
    Defaults logfile="/var/log/sudo.log"
  '';

  # services.openssh.enable = false;

   services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.firewall.enable = true;

  # Habilitar auditd
  security.audit.enable = true;
  security.auditd.enable = true;

  # Definir las reglas de auditoría
  security.audit.rules = [
    "-w /etc -p wa"   # Vigilar cambios en el directorio /etc
    "-w /var/log -p wa"   # Vigilar cambios en los logs
    "-w /bin -p x"   # Auditar ejecución de binarios
  ];

  /*# Reglas básicas de auditoría
  security.audit.rules = [
    "-w /etc -p rwxa -k etc_changes"                  # Cambios en /etc
    "-w /var/log/syslog -p wa -k syslog_changes"      # Cambios en syslog
    "-a always,exit -F arch=b64 -S execve -k exec_log" # Auditar ejecución
    "-a always,exit -F arch=b32 -S execve -k exec_log"
  ];*/

  /*environment.etc."audit/audit.rules".text = ''
    -w /etc -p rwxa -k etc_changes
    -w /var/log/syslog -p wa -k syslog_changes
    -a always,exit -F arch=b64 -S execve -k exec_log
    -a always,exit -F arch=b32 -S execve -k exec_log
  '';*/

  environment.etc."audit/auditd.conf".text = ''
    log_file = /var/log/audit/audit.log
    log_format = ENRICHED
    flush = INCREMENTAL
    freq = 5
    space_left = 100
    admin_space_left = 50
    disk_full_action = SUSPEND
    disk_error_action = SUSPEND
  '';

  # nix.settings.trusted-users = [ "root" ];
}