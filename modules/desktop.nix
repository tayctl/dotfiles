{ ... }: {
  services.displayManager.ly.enable = true;

  programs.hyprland.enable = true; # registers the session such that ly lists it
  security.polkit.enable = true;

  hardware.graphics.enable = true;

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

  environment.systemPackages = with pkgs; [ system-config-printer ];
}
