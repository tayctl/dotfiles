{ ... }: {
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
  # One-off after first boot: sudo smbpasswd -a main
}
