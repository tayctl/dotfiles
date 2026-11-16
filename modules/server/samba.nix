{ config, pkgs, ... }: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings.media = {
      path = "/home/main/media";
      browseable = "yes";
      writable = "yes";
      "valid users" = "main";
    };
  };
  # Samba keeps its own password db, so sync it from the sops secret on activation.
  system.activationScripts.smbpasswd-main = {
    deps = [ "users" ];
    text = ''
      pw=$(cat ${config.sops.secrets.samba-main.path})
      printf '%s\n%s\n' "$pw" "$pw" | ${pkgs.samba}/bin/smbpasswd -s -a main
    '';
  };
}
