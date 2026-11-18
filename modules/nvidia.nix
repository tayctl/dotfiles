{ config, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true; # required for Wayland
    open = true; # Turing (RTX 20xx / GTX 16xx) or newer; set false for older cards
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true; # fixes corruption after suspend
  };

  # No LIBVA_DRIVER_NAME / __GLX_VENDOR_LIBRARY_NAME here: on a PRIME laptop
  # they would push every app onto the Nvidia GPU (work-desktop sets them).
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
