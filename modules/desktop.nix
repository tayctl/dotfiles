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
}
