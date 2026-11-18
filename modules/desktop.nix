{ pkgs, ... }: {
  services.displayManager.ly.enable = true;

  programs.hyprland.enable = true; # registers the session such that ly lists it
  security.polkit.enable = true;

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true; # blueman-manager in autostart.lua
  services.udisks2.enable = true; # udiskie automounting

  # Thunar (programs.lua fileManager) with what it needs on NixOS
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true; # keeps Thunar's settings
  services.gvfs.enable = true; # trash, mounting, network locations
  services.tumbler.enable = true; # thumbnails

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      brlaser
      brgenml1lpr
      splix
    ];
  };
  
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  
  hardware.printers = {
    ensureDefaultPrinter = null; 
  };
  
  services.printing.browsing = true;

  environment.systemPackages = with pkgs; [
    system-config-printer
    xarchiver # used by thunar-archive-plugin
  ];
}
